# Acción Legal Templates & Reference

## Table of Contents
1. Privacy Policy (Full Template)
2. Terms of Service (Full Template)
3. Supabase Delete Function (SQL)
4. Delete Account Edge Function
5. SwiftUI Implementation Examples
6. Breach Notification Plan

---

> **Before using these templates, read `SKILL.md` for the list of required changes.**
> Key corrections applied in this version vs. the original draft:
> - Table name corrected: `pings` → `location_pings`; `sos_alerts` table removed (does not exist)
> - Twilio retention corrected: 400 days (not 24–72 hours)
> - Location frequency corrected to match actual app behavior
> - "open-source" claim flagged — only include if code is publicly available
> - Supabase region corrected: free tier is US-East only (not EU)
> - Breach notification delivery corrected: in-app (not email — you don't collect email)
> - Auth user deletion added to delete flow for full CCPA/CPRA compliance
> - "View My Data" feature — not yet built; policy uses "contact us" approach until built

---

## 1. Privacy Policy (Full Template)

Publish at `accion.app/privacy`. Link from the app Settings screen and enter the URL in App Store Connect.

```markdown
# Acción Privacy Policy

**Effective Date:** May 2, 2026
**Last Updated:** May 2, 2026

## 1. Overview

Acción is a free iPhone app designed to keep your family informed
during emergencies. We prioritize your privacy above all else.
This policy explains what data we collect, how we use it, and your rights.

[REMOVE IF NOT TRUE: This app is open-source. Source code is available at [GITHUB URL].]

## 2. What Information We Collect

### 2.1 Anonymous User ID
- You do not provide an email, password, or name to use this app
- We generate a unique anonymous ID using Supabase's anonymous
  authentication when you first open the app
- This ID does not identify you personally and is not linked to
  any real-world identifier

### 2.2 Location Data
- When you use Acción, we collect your GPS coordinates (latitude,
  longitude, and accuracy) while the app is open
- Location updates are sent as frequently as every 5 seconds while
  you are actively moving, and at minimum once per 60 seconds while
  stationary (heartbeat)
- Location data is displayed to your trusted contacts on the private
  web viewer

### 2.3 Trusted Contact Information
- You provide names and phone numbers of people you trust
- We store these on our servers (Supabase) to send SMS alerts when
  you press the Emergency button
- We do not access your iOS Contacts without your permission; you
  choose which contacts to add

### 2.4 Timestamps
- We record when location updates were sent and when an Emergency
  alert was triggered

### 2.5 What We Do NOT Collect
- Your name, email address, or phone number
- Your identity (the app uses anonymous authentication)
- Your browsing history
- Your full contacts list (only the contacts you manually select)
- Any data not described in this policy

## 3. How We Use Your Information

- **Location sharing:** To display your location to trusted contacts
  on the private web viewer (accion.app/watch/[your-token])
- **Emergency alerts:** To send SMS messages to your trusted contacts
  when you press the Emergency button
- **Service improvement:** To identify and fix bugs

We do NOT:
- Sell your data to anyone
- Share your data with third parties except as described in Section 5
- Use location data for advertising
- Use location data to profile you

## 4. Data Retention

### 4.1 Location Updates
- Each location update is automatically deleted after **24 hours**
- Emergency alert location records are deleted after **7 days**
- Your location history is never stored long-term

### 4.2 Trusted Contacts
- Phone numbers are stored until you remove them from the app or
  use "Delete All My Data" in Settings
- Removing a contact from the app immediately removes their number
  from our database

### 4.3 Viewer Tokens
- The private web link (token) your contacts use to view your
  location is stored until you delete it
- Deleting the token immediately revokes access for anyone using
  that link

### 4.4 Your Account
- Your anonymous user ID persists until you use "Delete All My Data"
  in Settings, which deletes all records and your account

## 5. Data Processors & Third-Party Services

### 5.1 Supabase (Database)
- Supabase hosts our PostgreSQL database on Amazon Web Services
  (AWS us-east-1, United States)
- Data: anonymous user IDs, location updates, trusted contact
  phone numbers, viewer tokens
- Encryption: At rest and in transit
- Supabase Privacy Policy: https://supabase.com/privacy

### 5.2 Twilio (SMS Delivery)
- Twilio delivers SMS messages to your trusted contacts when you
  press Emergency
- Data shared with Twilio: trusted contact phone numbers (to
  deliver the SMS)
- Twilio retains message delivery logs for up to **400 days**
  by default under their standard data retention policy
- Twilio Privacy Policy: https://www.twilio.com/legal/privacy
- We do not control Twilio's data retention; their policy governs
  their logs

### 5.3 Apple (App Distribution)
- Apple hosts the app on the App Store and may collect usage
  analytics as described in Apple's Privacy Policy

## 6. Your Rights (California Privacy Rights Act — CPRA)

If you are a California resident, you have the following rights:

### 6.1 Right to Know
You can request a copy of the personal data we hold about you.
To request your data, email us at [YOUR EMAIL]. We will respond
within 30 days. [NOTE: Once a "View My Data" screen is built in
the app, update this section to reference it instead.]

### 6.2 Right to Delete
You can delete all your data from within the app:
- Open Settings
- Tap "Delete All My Data"
- Confirm the prompt
- This permanently deletes your anonymous ID, all location records,
  trusted contacts, viewer tokens, and your account
- Deletion is immediate and cannot be undone

### 6.3 Right to Opt-Out of Selling
We do not sell, rent, or share your personal information for
commercial purposes. We never will.

### 6.4 Right to Non-Discrimination
We will not deny you service or treat you differently for
exercising your privacy rights.

## 7. Data Security

We use industry-standard security measures:
- Encryption at rest (managed by Supabase/AWS)
- Encryption in transit (HTTPS/TLS for all connections)
- Row-level security (RLS) — users can only access their own data
- No passwords stored (anonymous auth eliminates credential exposure)
- Automatic data deletion after 24 hours for location records

No security system is 100% secure. We use reasonable and
industry-standard measures to protect your data.

## 8. Data Breach Notification

If we discover that your personal data (phone numbers, location
records) has been exposed in a security breach:

1. We will investigate within 7 days of discovery
2. We will notify affected users within 60 days via **in-app
   notification** (we do not collect your email address)
3. The notification will disclose:
   - What data was exposed
   - When the breach occurred and when we discovered it
   - What steps we are taking to secure it
   - Your rights under applicable law

## 9. Children's Privacy

Acción is not designed for or directed at children under 13.
You must be at least 13 years old to use this app. We do not
knowingly collect data from children under 13. If we become
aware that a user is under 13, we will delete their data.

## 10. International Users

This app is designed for users in the United States. Data is
processed and stored in the United States (AWS us-east-1).
By using this app outside the US, you consent to the transfer
of your data to the United States.

[NOTE: If you plan to accept users in the EU, GDPR applies
and requires additional compliance steps. Consult a lawyer
before launching internationally.]

## 11. Changes to This Policy

We will notify you of material changes via in-app notification.
Your continued use of the app after notification constitutes
acceptance of the updated policy.

## 12. Contact Us

For privacy questions or to request your data:

**Email:** [YOUR EMAIL]
**Mailing Address:** [YOUR ADDRESS — required for CPRA compliance]

We will respond to privacy requests within 30 days.

---
**Effective Date:** May 2, 2026 | **Last Updated:** May 2, 2026
```

---

## 2. Terms of Service (Full Template)

Publish at `accion.app/terms`. Link from the app Settings screen.

```markdown
# Acción Terms of Service

**Effective Date:** May 2, 2026
**Last Updated:** May 2, 2026

## 1. Agreement to Terms

By downloading, installing, and using Acción, you agree to these
Terms of Service. If you do not agree, do not use the app.

## 2. License Grant

We grant you a limited, non-exclusive, non-transferable, revocable
license to use Acción on your iPhone for personal, non-commercial use.

## 3. Emergency Button & SMS Communications

### 3.1 TCPA Consent — Required Before Using the App

**Before you can use Acción, you must check the following box
during onboarding. The box is unchecked by default.**

> ☐ I confirm my trusted contacts have agreed to receive emergency
> SMS alerts from me through this app.

By actively checking this box, you confirm that:

1. You have **personally informed each trusted contact** that you
   will be sending SMS messages via Acción and Twilio in emergencies.

2. Each trusted contact has **explicitly consented** to receive
   these SMS messages.

3. **You are solely responsible** for obtaining this consent.
   Acción and Twilio are not responsible for obtaining consent from
   your contacts or for any claim by a contact that they did not
   consent.

4. **You are solely responsible** for the accuracy of all phone
   numbers you provide.

5. You acknowledge that SMS is governed by the **Telephone Consumer
   Protection Act (TCPA), 47 U.S.C. § 227**, which carries statutory
   damages of **$500–$1,500 per message** for violations. By using
   this feature, **you assume full responsibility for TCPA compliance**.

### 3.2 No Guarantee of SMS Delivery

We cannot guarantee that SMS messages will be delivered or received.
SMS may fail due to network issues, carrier filtering, invalid phone
numbers, or Twilio outages. Acción will not be liable for any damages
arising from failed, delayed, or blocked SMS delivery.

### 3.3 Twilio

SMS is delivered through Twilio. Twilio has its own Terms of Service
and Privacy Policy. Twilio retains message delivery logs for up to
400 days. Acción is not responsible for Twilio's data practices.

## 4. Emergency Button Disclaimer & Limitation of Liability

### 4.1 What the Emergency Button Does

When you press the Emergency button:
1. Your GPS location is shared with your trusted contacts via the
   private web viewer
2. SMS messages are sent to all trusted contacts with the viewer link
3. A 60-second cancel window allows you to stop the alert

### 4.2 What the Emergency Button Does NOT Do

**The Emergency button does NOT:**
- Call 911 or any emergency services
- Prevent detention, arrest, or harm
- Guarantee your safety
- Replace emergency services
- Guarantee that your contacts will receive, see, or respond to
  the message

### 4.3 Emergency Disclaimer

**THIS APP IS NOT A SUBSTITUTE FOR 911 OR EMERGENCY SERVICES.**

**In a genuine emergency, call 911 immediately.**

We cannot guarantee:
- SMS delivery or timing
- Location accuracy
- Real-time location updates
- That your trusted contacts will respond

### 4.4 No Liability for App Failure

Acción will not be liable for any damages arising from:
- Failed, delayed, filtered, or blocked SMS delivery
- Inaccurate, outdated, or missing location data
- Your failure to contact 911 or emergency services
- Your reliance on this app as a primary safety mechanism
- Loss of data, app crashes, or service outages
- Twilio outages or failures
- Any action or inaction by your trusted contacts
- Any damages, claims, injuries, or losses from use of this app

**You use this app entirely at your own risk.**

### 4.5 Limitation of Liability

TO THE FULLEST EXTENT PERMITTED BY LAW, ACCIÓN AND ITS DEVELOPERS
WILL NOT BE LIABLE FOR: INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL,
OR PUNITIVE DAMAGES; LOSS OF DATA, REVENUE, OR PROFITS; PERSONAL
INJURY OR HARM; OR DAMAGES EXCEEDING THE AMOUNT PAID FOR THE APP
(WHICH IS $0). THIS LIMITATION APPLIES EVEN IF ACCIÓN HAS BEEN
ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

## 5. User Responsibilities

You agree to:
- Provide accurate phone numbers of trusted contacts
- Personally inform each contact and obtain their consent before
  adding them to the app
- Keep your device secure and iOS updated
- Report security issues to us at [YOUR EMAIL] immediately
- Not use the app for illegal purposes
- Not use the app to track anyone without their knowledge or consent
- Not share your private viewer link with untrusted parties
- Not spam your contacts with false Emergency alerts

## 6. Privacy

We collect and use your data as described in our Privacy Policy
(accion.app/privacy). By using this app, you consent to that policy.

## 7. Data Retention & Deletion

- Location records are automatically deleted after 24 hours (normal)
  or 7 days (Emergency alerts)
- You can delete all your data at any time using "Delete All My Data"
  in Settings
- Deletion is permanent and cannot be undone

## 8. Prohibited Uses

You agree not to:
- Stalk, harass, or track anyone without their explicit consent
- Provide false contact information
- Attempt to hack, reverse-engineer, or modify the app
- Use the app for commercial purposes
- Send false Emergency alerts

## 9. Immigration-Related Warnings

**IMPORTANT:** This app alerts your family. **It does NOT:**
- Provide legal protection of any kind
- Guarantee safety from any threat
- Prevent detention or arrest
- Replace immigration law advice

If you face immigration enforcement, **contact an immigration
attorney or call a legal hotline immediately.** CHIRLA Hotline:
888-624-4752. This app is not a legal service.

## 10. Disclaimer of Warranties

Acción is provided "AS IS" and "AS AVAILABLE" without warranties
of any kind, express or implied. We do not warrant that the app
will be uninterrupted, error-free, or secure.

## 11. Indemnification

You agree to indemnify and hold harmless Acción and its developers
from any claims, damages, or liability arising from: your use of
the app; your violation of these Terms; your violation of the TCPA
or other applicable laws; or claims from your trusted contacts
related to SMS messages you caused to be sent.

## 12. Termination

We may suspend your access to the app if you violate these Terms.
You may delete your account at any time via "Delete All My Data"
in Settings.

## 13. Third-Party Services

This app uses Supabase (database), Twilio (SMS), Apple (distribution),
and MapKit (maps). These services have their own terms and policies.
We are not responsible for their practices.

## 14. Changes to Terms

We may update these Terms and will notify you of material changes
via in-app notification. Continued use constitutes acceptance.

## 15. Governing Law

These Terms are governed by the laws of the **State of California,
United States**, without regard to its conflict of law principles.
[UPDATE if your entity is incorporated in a different state.]

## 16. Contact Us

**Email:** [YOUR EMAIL]
**Mailing Address:** [YOUR ADDRESS]

---
**Effective Date:** May 2, 2026
```

---

## 3. Supabase Delete Function (SQL)

Save as `supabase/migrations/004_delete_user_data_function.sql` and run in Supabase SQL Editor.

```sql
-- Acción: CCPA/CPRA right-to-delete implementation.
-- Deletes all user data from application tables.
-- Auth user deletion is handled separately by the delete-account Edge Function.

CREATE OR REPLACE FUNCTION public.delete_all_user_data()
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  current_user_id UUID;
  deleted_pings    INT := 0;
  deleted_contacts INT := 0;
  deleted_tokens   INT := 0;
BEGIN
  current_user_id := auth.uid();

  IF current_user_id IS NULL THEN
    RAISE EXCEPTION 'User must be authenticated to delete data';
  END IF;

  -- Delete all location pings (normal, alert, and cancel ping_types)
  DELETE FROM public.location_pings WHERE user_id = current_user_id;
  GET DIAGNOSTICS deleted_pings = ROW_COUNT;

  -- Delete trusted contacts
  DELETE FROM public.trusted_contacts WHERE user_id = current_user_id;
  GET DIAGNOSTICS deleted_contacts = ROW_COUNT;

  -- Delete viewer tokens (revokes all shared links)
  DELETE FROM public.viewer_tokens WHERE user_id = current_user_id;
  GET DIAGNOSTICS deleted_tokens = ROW_COUNT;

  RETURN json_build_object(
    'success',           true,
    'deleted_pings',     deleted_pings,
    'deleted_contacts',  deleted_contacts,
    'deleted_tokens',    deleted_tokens
  );
END;
$$;

-- Authenticated users can call this on themselves; anon cannot
GRANT EXECUTE ON FUNCTION public.delete_all_user_data() TO authenticated;
REVOKE EXECUTE ON FUNCTION public.delete_all_user_data() FROM anon, public;
```

---

## 4. Delete Account Edge Function

Create at `supabase/functions/delete-account/index.ts`. This handles the auth user deletion that the SQL function cannot do (requires service role key, which must never touch the client).

```typescript
import { createClient } from "@supabase/supabase-js";

const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

// Admin client — service role key only, never exposed to client
const adminClient = createClient(supabaseUrl, serviceRoleKey, {
  auth: { autoRefreshToken: false, persistSession: false },
});

export default async (req: Request): Promise<Response> => {
  try {
    // Get the JWT from the Authorization header
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), { status: 401 });
    }

    // Verify the token and get user ID
    const token = authHeader.replace("Bearer ", "");
    const { data: { user }, error: authError } = await adminClient.auth.getUser(token);

    if (authError || !user) {
      return new Response(JSON.stringify({ error: "Invalid token" }), { status: 401 });
    }

    // Delete application data first (via the SQL function)
    const anonClient = createClient(supabaseUrl, Deno.env.get("SUPABASE_ANON_KEY")!, {
      global: { headers: { Authorization: authHeader } },
    });
    await anonClient.rpc("delete_all_user_data");

    // Then delete the auth user (requires service role)
    const { error: deleteError } = await adminClient.auth.admin.deleteUser(user.id);

    if (deleteError) {
      console.error("Auth user deletion failed:", deleteError.message);
      return new Response(JSON.stringify({ error: "Failed to delete account" }), { status: 500 });
    }

    console.log(`Account deleted for user: ${user.id}`);
    return new Response(JSON.stringify({ success: true }), { status: 200 });
  } catch (error) {
    console.error("delete-account error:", error instanceof Error ? error.message : "unknown");
    return new Response(JSON.stringify({ error: "Internal server error" }), { status: 500 });
  }
};
```

---

## 5. SwiftUI Implementation Examples

### 5.1 TCPA Checkbox in ContactPickerView

Add this below the contacts list and above the Continue button in `ContactPickerView.swift`:

```swift
// TCPA consent — required, unchecked by default
@State private var tcpaConsent: Bool = false

// In the view, just above the Continue button:
VStack(alignment: .leading, spacing: 8) {
    Button(action: { tcpaConsent.toggle() }) {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: tcpaConsent ? "checkmark.square.fill" : "square")
                .font(.system(size: 20))
                .foregroundColor(tcpaConsent ? Color.actionRed : .secondary)

            Text(lang.isSpanish
                 ? "Confirmo que mis contactos han aceptado recibir alertas de emergencia por SMS a través de esta app."
                 : "I confirm my trusted contacts have agreed to receive emergency SMS alerts from me through this app.")
                .font(.footnote)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    .buttonStyle(.plain)
}
.padding(12)
.background(Color.black.opacity(0.04))
.cornerRadius(10)
.padding(.horizontal, 24)
.padding(.bottom, 8)

// Block Continue button until checked:
// Change button disabled condition from `isSaving` only to:
.disabled(isSaving || !tcpaConsent)
.opacity((isSaving || !tcpaConsent) ? 0.5 : 1.0)
```

### 5.2 Settings Screen (stub — implement as a sheet or pushed view)

```swift
struct SettingsView: View {
    @State private var showDeleteConfirmation = false
    @State private var isDeleting = false
    @State private var deleteSuccess = false
    @State private var deleteError: String?

    var body: some View {
        List {
            Section("Legal") {
                Link("Privacy Policy", destination: URL(string: "https://accion.app/privacy")!)
                Link("Terms of Service", destination: URL(string: "https://accion.app/terms")!)
            }

            Section("Your Data") {
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Label("Delete All My Data", systemImage: "trash")
                }
            }
        }
        .navigationTitle("Settings")
        .alert("Delete All Data?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete Forever", role: .destructive) {
                Task { await deleteAllData() }
            }
        } message: {
            Text("This permanently deletes your location history, trusted contacts, viewer links, and your account. Cannot be undone.")
        }
        .alert("Data Deleted", isPresented: $deleteSuccess) {
            Button("OK") { }
        } message: {
            Text("All your data and your account have been permanently deleted.")
        }
    }

    private func deleteAllData() async {
        isDeleting = true
        defer { isDeleting = false }

        do {
            // Call the Edge Function which deletes app data + auth user
            let session = try await supabase.auth.session
            let response = try await URLSession.shared.data(from: {
                var req = URLRequest(url: URL(string: "\(AppConfiguration.current.supabaseURL)/functions/v1/delete-account")!)
                req.httpMethod = "POST"
                req.setValue("Bearer \(session.accessToken)", forHTTPHeaderField: "Authorization")
                return req
            }())
            deleteSuccess = true
        } catch {
            deleteError = error.localizedDescription
        }
    }
}
```

### 5.3 SOS Failure State

Add `@State private var sosFailureMessage: String?` to `ContentView`. In `fireSOS()`:

```swift
private func fireSOS() async {
    smsPending = false
    timer?.invalidate()
    timer = nil
    do {
        try await syncService.insertAlertPing()
        // isSosActive = true + smsPending = false → sosSentCard shows
    } catch {
        isSosActive = false
        sosFailureMessage = lang.isSpanish
            ? "No se pudo enviar la alerta. Verifica tu conexión e intenta de nuevo."
            : "Alert failed to send. Check your connection and try again."
    }
}
```

In the body card section, add a failure card above `safetyStatusCard`:

```swift
if let msg = sosFailureMessage {
    sosFailureCard(message: msg)
}
```

---

## 6. Breach Notification Plan

Keep this as an internal document. Update it when infrastructure changes.

```markdown
# Data Breach Response Plan — Acción

## What Counts as a Breach
- Unauthorized access to trusted_contacts (phone numbers) in Supabase
- Unauthorized access to location_pings (GPS data) in Supabase
- Unauthorized access to viewer_tokens (private link credentials)
- Any Supabase security advisory affecting our project

## Detection (Days 1–7)
1. Monitor Supabase Security Advisories and dashboard alerts
2. Watch for unusual query patterns or access logs
3. If a breach is suspected: do NOT shut down. Preserve all logs.
4. Contact Supabase support: support@supabase.com
5. Document: what data, how many users, start/end time of exposure

## Notification (Days 8–60)
California law requires notification within 60 days of discovery.

Who to notify:
- Affected users — via in-app notification (we have no emails)
- California Attorney General if 500+ CA residents affected:
  oag.ca.gov/privacy/databreach/reporting

What to say (template):
---
Security Notice from Acción

On [DATE], we discovered that [DESCRIPTION OF BREACH].
The following data may have been exposed: [phone numbers / location / both].
This affected users who used the app between [DATE] and [DATE].

What we did: [patched vulnerability, rotated credentials, etc.]

What you should do:
- Inform your trusted contacts their phone number may have been exposed
- Consider updating your Acción contacts list
- Use "Delete All My Data" in Settings if you prefer to close your account

Your rights: You can delete all your data via Settings. You can file a
complaint with the California AG at oag.ca.gov.

Contact us: [EMAIL]
---

## Post-Breach (Day 60+)
- Publish a brief public statement on accion.app
- Document everything — required for legal defense if sued
- Schedule a security review with Supabase

## Contacts
- Supabase Support: support@supabase.com
- California AG Privacy: privacy@oag.ca.gov
- Your attorney: [INSERT BEFORE LAUNCH]
```

---

## Quick Reference: What Goes Where

| Document | Location | Required? |
|----------|----------|-----------|
| Privacy Policy | accion.app/privacy | YES — App Store rejects without it |
| Terms of Service | accion.app/terms | YES — Apple requires it |
| Privacy Policy URL | App Store Connect → App Information | YES |
| Privacy Nutrition Labels | App Store Connect → App Privacy | YES — separate from policy URL |
| TCPA Checkbox | In-app onboarding, contacts step | YES — legal defense |
| Delete All My Data | Settings screen | YES — CPRA requirement |
| SOS failure state | ContentView | YES — limits liability |
| Breach Notification Plan | Internal doc | YES — required by CA law |
