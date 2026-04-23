import { createClient } from "@supabase/supabase-js";

// Type definitions
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

interface ViewerToken {
  id: string;
  user_id: string;
  token: string;
  created_at: string;
}

// Initialize Supabase client
const supabaseUrl = Deno.env.get("SUPABASE_URL");
const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

if (!supabaseUrl || !supabaseServiceKey) {
  throw new Error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
}

const supabase = createClient(supabaseUrl, supabaseServiceKey);

// Twilio configuration
const twilioAccountSid = Deno.env.get("TWILIO_ACCOUNT_SID");
const twilioAuthToken = Deno.env.get("TWILIO_AUTH_TOKEN");
const twilioPhoneNumber = Deno.env.get("TWILIO_PHONE_NUMBER");

if (!twilioAccountSid || !twilioAuthToken || !twilioPhoneNumber) {
  throw new Error(
    "Missing TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, or TWILIO_PHONE_NUMBER"
  );
}

// Web viewer base URL (can be configured as environment variable)
const viewerBaseUrl =
  Deno.env.get("VIEWER_BASE_URL") || "https://action-viewer.vercel.app";

/**
 * Send SMS via Twilio
 */
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
      console.error(
        `Twilio SMS send failed: ${response.status} ${errorBody}`
      );
      return false;
    }

    const result = await response.json();
    console.log(`SMS sent successfully: ${result.sid}`);
    return true;
  } catch (error) {
    console.error("Error sending Twilio SMS:", error);
    return false;
  }
}

/**
 * Fetch trusted contacts for the user
 */
async function getTrustedContacts(userId: string): Promise<TrustedContact[]> {
  try {
    const { data, error } = await supabase
      .from("trusted_contacts")
      .select("*")
      .eq("user_id", userId);

    if (error) {
      console.error("Error fetching trusted contacts:", error);
      return [];
    }

    return (data || []) as TrustedContact[];
  } catch (error) {
    console.error("Error in getTrustedContacts:", error);
    return [];
  }
}

/**
 * Fetch viewer token for the user
 */
async function getViewerToken(userId: string): Promise<string | null> {
  try {
    const { data, error } = await supabase
      .from("viewer_tokens")
      .select("token")
      .eq("user_id", userId)
      .single();

    if (error) {
      console.error("Error fetching viewer token:", error);
      return null;
    }

    return data?.token || null;
  } catch (error) {
    console.error("Error in getViewerToken:", error);
    return null;
  }
}

/**
 * Main Edge Function handler
 */
export default async (req: Request): Promise<Response> => {
  try {
    // Parse the webhook payload
    const payload = (await req.json()) as WebhookPayload;

    // Only process INSERT events on location_pings
    if (payload.type !== "INSERT" || payload.table !== "location_pings") {
      return new Response(
        JSON.stringify({ error: "Unsupported event type or table" }),
        { status: 400 }
      );
    }

    const record = payload.record;

    // Only process alert pings
    if (record.ping_type !== "alert") {
      return new Response(
        JSON.stringify({ message: "Not an alert ping, skipping" }),
        { status: 200 }
      );
    }

    const userId = record.user_id;

    console.log(
      `Processing alert ping for user ${userId} at ${record.latitude}, ${record.longitude}`
    );

    // Fetch trusted contacts and viewer token in parallel
    const [contacts, viewerToken] = await Promise.all([
      getTrustedContacts(userId),
      getViewerToken(userId),
    ]);

    if (contacts.length === 0) {
      console.warn(`No trusted contacts found for user ${userId}`);
      return new Response(
        JSON.stringify({
          message: "No trusted contacts to notify",
          sentCount: 0,
        }),
        { status: 200 }
      );
    }

    if (!viewerToken) {
      console.warn(`No viewer token found for user ${userId}`);
      return new Response(
        JSON.stringify({
          message: "No viewer token available",
          sentCount: 0,
        }),
        { status: 200 }
      );
    }

    // Build the viewer link
    const viewerLink = `${viewerBaseUrl}?token=${encodeURIComponent(viewerToken)}`;

    // Send SMS to each contact
    const smsPromises = contacts.map(async (contact) => {
      const message = `${contact.name} activó una alerta de emergencia. Ve su ubicación: ${viewerLink}`;

      console.log(
        `Sending SMS to ${contact.name} (${contact.phone_number})`
      );

      return await sendTwilioSMS(contact.phone_number, message);
    });

    const results = await Promise.all(smsPromises);
    const sentCount = results.filter((success) => success).length;

    console.log(
      `Alert SMS campaign complete: ${sentCount}/${contacts.length} sent`
    );

    return new Response(
      JSON.stringify({
        message: "Alert SMS sent",
        sentCount,
        totalContacts: contacts.length,
      }),
      { status: 200 }
    );
  } catch (error) {
    console.error("Error in send-sos-sms function:", error);
    return new Response(
      JSON.stringify({
        error: "Internal server error",
        details: error instanceof Error ? error.message : String(error),
      }),
      { status: 500 }
    );
  }
};
