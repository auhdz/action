import { createClient } from "@supabase/supabase-js";

// ─── Type Definitions ────────────────────────────────────────────────────────

interface WebhookPayload {
  type: "INSERT" | "UPDATE" | "DELETE";
  table: string;
  schema: string;
  record: {
    id: string;
    user_id: string;
    latitude: number;
    longitude: number;
    accuracy_m: number;
    ping_type: string;
    created_at: string;
  };
  old_record: null | Record<string, unknown>;
}

interface TrustedContact {
  id: string;
  user_id: string;
  name: string;
  phone_number: string;
  created_at: string;
}

// ─── Approved SMS Templates (never reference ICE, immigration, enforcement) ──

const SMS = {
  alert: {
    en: (name: string, link: string) =>
      `${name} needs you. They've shared their live location:\n${link}\n\nOpen the link to see where they are right now.`,
    es: (name: string, link: string) =>
      `${name} necesita tu ayuda. Compartieron su ubicación:\n${link}\n\nAbre el enlace para ver dónde están ahora.`,
  },
  cancel: {
    en: (name: string) =>
      `Update from ${name}: They are safe. No action needed.\nThis was a false alarm. You can ignore the previous message.`,
    es: (name: string) =>
      `Actualización de ${name}: Están bien. No se necesita acción.\nFue una falsa alarma. Puedes ignorar el mensaje anterior.`,
  },
} as const;

// ─── Supabase Client ──────────────────────────────────────────────────────────

const supabaseUrl = Deno.env.get("SUPABASE_URL");
const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

if (!supabaseUrl || !supabaseServiceKey) {
  throw new Error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
}

const supabase = createClient(supabaseUrl, supabaseServiceKey);

// ─── Twilio Configuration ─────────────────────────────────────────────────────

const twilioAccountSid = Deno.env.get("TWILIO_ACCOUNT_SID");
const twilioAuthToken = Deno.env.get("TWILIO_AUTH_TOKEN");
const twilioPhoneNumber = Deno.env.get("TWILIO_PHONE_NUMBER");

if (!twilioAccountSid || !twilioAuthToken || !twilioPhoneNumber) {
  throw new Error(
    "Missing TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, or TWILIO_PHONE_NUMBER"
  );
}

// ─── Viewer URL ───────────────────────────────────────────────────────────────

const viewerBaseUrl = Deno.env.get("VIEWER_BASE_URL") || "https://accion.app";

function buildViewerLink(token: string): string {
  return `${viewerBaseUrl}/watch/${token}`;
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

async function sendTwilioSMS(
  toPhoneNumber: string,
  message: string
): Promise<boolean> {
  try {
    const auth = btoa(`${twilioAccountSid}:${twilioAuthToken}`);

    const response = await fetch(
      `https://api.twilio.com/2010-04-01/Accounts/${twilioAccountSid}/Messages.json`,
      {
        method: "POST",
        headers: {
          Authorization: `Basic ${auth}`,
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: new URLSearchParams({
          From: twilioPhoneNumber,
          To: toPhoneNumber,
          Body: message,
        }).toString(),
      }
    );

    if (!response.ok) {
      const errorBody = await response.text();
      console.error(`Twilio SMS failed: ${response.status}`);
      // Never log errorBody — may contain phone numbers
      return false;
    }

    const result = await response.json();
    console.log(`SMS sent: ${result.sid}`);
    return true;
  } catch (error) {
    console.error("Twilio send error:", error instanceof Error ? error.message : "unknown");
    return false;
  }
}

async function getTrustedContacts(userId: string): Promise<TrustedContact[]> {
  const { data, error } = await supabase
    .from("trusted_contacts")
    .select("*")
    .eq("user_id", userId);

  if (error) {
    console.error("Error fetching contacts:", error.message);
    return [];
  }

  return (data || []) as TrustedContact[];
}

async function getViewerToken(userId: string): Promise<string | null> {
  const { data, error } = await supabase
    .from("viewer_tokens")
    .select("token")
    .eq("user_id", userId)
    .single();

  if (error) {
    console.error("Error fetching viewer token:", error.message);
    return null;
  }

  return data?.token || null;
}

// ─── Main Handler ─────────────────────────────────────────────────────────────

export default async (req: Request): Promise<Response> => {
  try {
    const payload = (await req.json()) as WebhookPayload;

    if (payload.type !== "INSERT" || payload.table !== "location_pings") {
      return new Response(JSON.stringify({ message: "Ignored" }), { status: 200 });
    }

    const { ping_type, user_id: userId } = payload.record;

    if (ping_type !== "alert" && ping_type !== "cancel") {
      return new Response(JSON.stringify({ message: "Not an alert or cancel ping" }), { status: 200 });
    }

    const [contacts, viewerToken] = await Promise.all([
      getTrustedContacts(userId),
      getViewerToken(userId),
    ]);

    if (contacts.length === 0) {
      console.warn(`No trusted contacts for user ${userId}`);
      return new Response(JSON.stringify({ message: "No contacts", sentCount: 0 }), { status: 200 });
    }

    // Default to English. Add preferred_lang field to user profile to enable per-user language.
    const lang: "en" | "es" = "en";

    const smsPromises = contacts.map(async (contact) => {
      let message: string;

      if (ping_type === "cancel") {
        message = SMS.cancel[lang](contact.name);
      } else {
        if (!viewerToken) {
          console.warn(`No viewer token for user ${userId}`);
          return false;
        }
        const link = buildViewerLink(viewerToken);
        message = SMS.alert[lang](contact.name, link);
      }

      // Log contact name only — never log phone numbers or message content
      console.log(`Sending ${ping_type} SMS to contact: ${contact.name}`);
      return sendTwilioSMS(contact.phone_number, message);
    });

    const results = await Promise.all(smsPromises);
    const sentCount = results.filter(Boolean).length;

    console.log(`SMS campaign (${ping_type}): ${sentCount}/${contacts.length} sent`);

    return new Response(
      JSON.stringify({ message: `${ping_type} SMS sent`, sentCount, totalContacts: contacts.length }),
      { status: 200 }
    );
  } catch (error) {
    console.error("Edge function error:", error instanceof Error ? error.message : "unknown");
    return new Response(JSON.stringify({ error: "Internal server error" }), { status: 500 });
  }
};
