# Task 12: Test End-to-End and Prepare for TestFlight

This document provides the complete checklist and instructions for preparing Acción for TestFlight submission.

## Part 1: Configuration

### Step 1.1: Copy Secrets Configuration
```bash
cp ios/Action/Config/Secrets.example.xcconfig ios/Action/Config/Secrets.xcconfig
```

### Step 1.2: Fill in Supabase Credentials
Edit `ios/Action/Config/Secrets.xcconfig` and add your Supabase project values:

```xcconfig
SUPABASE_URL = https://YOUR_PROJECT_REF.supabase.co
SUPABASE_ANON_KEY = YOUR_SUPABASE_ANON_KEY
```

Find these values at:
- **SUPABASE_URL:** Supabase Dashboard → Settings → API → Project URL
- **SUPABASE_ANON_KEY:** Supabase Dashboard → Settings → API → "anon public" key (never use the service role key)

### Step 1.3: Update Web Preview with Supabase Credentials
Edit `web/preview.html` around lines 279-280:

```javascript
const SUPABASE_URL = "https://YOUR_PROJECT_REF.supabase.co";
const SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";
```

Use the same credentials from Step 1.2.

---

## Part 2: Backend Setup

### Step 2.1: Run Initial Schema Migration
In Supabase SQL Editor, run: `supabase/migrations/001_location_pings.sql`

This creates:
- `location_pings` table with RLS policies
- Realtime publication for live updates

### Step 2.2: Run MVP Migration
In Supabase SQL Editor, run: `supabase/migrations/002_accion_mvp.sql`

This adds:
- `ping_type` column to `location_pings` (values: 'normal', 'alert')
- `trusted_contacts` table with RLS
- `viewer_tokens` table for sharing
- Helper function `is_valid_viewer_token()`
- Viewer token policy for public location access

### Step 2.3: Deploy Edge Function
Deploy the Twilio SMS sender:

```bash
supabase functions deploy send-sos-sms
```

This function:
- Triggers on INSERT of `location_pings` with `ping_type='alert'`
- Fetches trusted contacts for the user
- Generates a shareable viewer link with token
- Sends SMS to each contact with location link

### Step 2.4: Set Environment Variables in Supabase
In Supabase Dashboard → Functions Settings, add:

```
TWILIO_ACCOUNT_SID = your_account_sid
TWILIO_AUTH_TOKEN = your_auth_token
TWILIO_PHONE_NUMBER = +1234567890  (your Twilio number)
VIEWER_BASE_URL = https://your-viewer-domain.com  (optional, defaults to https://action-viewer.vercel.app)
```

Get these from:
- **Twilio Account SID & Auth Token:** Twilio Console → Account Info
- **Twilio Phone Number:** Twilio Console → Phone Numbers → Manage → Active Numbers

### Step 2.5: Enable Anonymous Authentication
In Supabase Dashboard:
1. Go to Authentication → Providers
2. Enable **Anonymous sign-in**
3. (Note: This should already be enabled from Task 3)

---

## Part 3: Build and Test

### Step 3.1: Open Xcode Project
```bash
open ios/Action/Action.xcodeproj
```

### Step 3.2: Configure Signing
1. Select the **Action** target
2. Go to **Signing & Capabilities**
3. Select your **Team** from the dropdown
4. Choose **iPhone Simulator** or a connected device

### Step 3.3: Run the App
Press **Cmd+R** or click **Run** to build and launch on simulator/device (iOS 17+).

### Step 3.4: Verify Onboarding Flow
On first launch, verify:
- [ ] Welcome screen appears
- [ ] Contact picker launches (to add trusted contacts)
- [ ] Location permission prompt displays
- User grants "When In Use" permission

### Step 3.5: Verify Location Tracking
- [ ] Status dot turns **green** (location permissions granted)
- [ ] "Última ubicación" shows current timestamp
- [ ] Updates every few seconds as you move (simulator: drag pin on map)

### Step 3.6: Test Emergency Alert
1. Long-press the **EMERGENCIA** button for 3 seconds
2. Verify:
   - [ ] Visual countdown feedback appears
   - [ ] Button activates after 3 seconds
   - [ ] A ping with `ping_type='alert'` is inserted in Supabase

### Step 3.7: Verify Supabase Data
1. Go to Supabase Dashboard → Table Editor → `location_pings`
2. Confirm:
   - [ ] Alert ping appears with `ping_type='alert'`
   - [ ] `user_id` matches your anonymous session
   - [ ] Coordinates are accurate

### Step 3.8: Verify Edge Function Triggered
1. Go to Supabase Dashboard → Functions
2. Click **send-sos-sms**
3. Check **Function Logs**:
   - [ ] Function invoked after alert ping
   - [ ] Logs show "Processing alert ping for user..."
   - [ ] Logs show "SMS sent successfully" (or contact fetch details)

### Step 3.9: Verify SMS Delivery
1. Go to Twilio Console → Logs → Messages
2. Confirm:
   - [ ] SMS sent to each trusted contact
   - [ ] Message body contains viewer link
   - [ ] Message format: "[Name] activó una alerta de emergencia. Ve su ubicación: https://..."

### Step 3.10: Test Viewer Link
1. Copy the SMS viewer link from Twilio logs
2. Open it in a web browser:
   - [ ] Map loads
   - [ ] User location dot appears
   - [ ] Location updates in real-time

### Step 3.11: Test Cancel Button
1. Activate another alert (long-press EMERGENCIA)
2. Within 60 seconds, tap **Cancelar**
3. Verify:
   - [ ] Most recent ping's `ping_type` resets to 'normal'
   - [ ] SMS is NOT sent (or function logs show cancel detected)

---

## Part 4: Metadata & Documentation

### Step 4.1: Privacy Policy
File created: `PRIVACY_POLICY.md`

This policy covers:
- Information we collect (location, contacts, anonymous ID)
- How we use it (sharing, alerts, service improvement)
- Data retention and security
- User rights (access, delete, revoke)
- Contact information

### Step 4.2: App Store Metadata
File created: `ios/APPSTORE_METADATA.md`

This includes:
- App name: "Acción"
- Subtitle: "Tu ubicación. Tu seguridad. Tus contactos de confianza."
- Full feature description (Spanish)
- Keywords for search (ubicación, seguridad, emergencia, etc.)
- Category: Utilities
- Screenshot guidance
- Release notes template

### Step 4.3: Verify README
Update `README.md` if needed to reflect:
- Latest feature set (emergency button, SMS alerts, trusted contacts)
- New configuration steps (Twilio, Edge Functions)
- Testing instructions

---

## Pre-TestFlight Checklist

- [ ] `Secrets.xcconfig` is filled with your Supabase credentials
- [ ] `web/preview.html` has matching Supabase credentials
- [ ] `001_location_pings.sql` has been run in Supabase
- [ ] `002_accion_mvp.sql` has been run in Supabase
- [ ] `send-sos-sms` Edge Function deployed
- [ ] Twilio environment variables set in Supabase
- [ ] Anonymous auth enabled in Supabase
- [ ] App opens on iOS 17+ simulator
- [ ] Onboarding completes
- [ ] Location permission is granted
- [ ] Green status dot appears
- [ ] Emergency button sends alert ping
- [ ] Alert ping appears in Supabase with `ping_type='alert'`
- [ ] Edge Function triggers and logs show success
- [ ] SMS received in Twilio logs
- [ ] Viewer link loads in browser
- [ ] Cancel button resets ping_type
- [ ] Privacy policy is published and linked
- [ ] App Store metadata is complete

---

## TestFlight Submission Steps (Next)

1. **Archive the app:**
   - Xcode → Product → Archive
   - Select the archive → Distribute App
   - Choose "TestFlight & App Store"

2. **Upload to TestFlight:**
   - Sign in with your Apple Developer account
   - Complete metadata review
   - Add internal testers (or beta testers)

3. **Monitor Test Feedback:**
   - Check for crashes or location issues
   - Verify SMS alerts work on real devices
   - Confirm battery and privacy are acceptable

4. **Prepare for App Store Review:**
   - Complete PRIVACY_POLICY.md in App Store Connect
   - Upload screenshots (use APPSTORE_METADATA.md guidance)
   - Set category as "Utilities"
   - Indicate that the app collects location data
   - Confirm compliance with App Store guidelines

---

## Important Notes

- **Never commit `Secrets.xcconfig`** — it's in `.gitignore` for security
- **Always use the anon public key** — never the service role key
- **Test on a real device** before TestFlight — Twilio SMS may not work in simulator
- **Verify Twilio credentials** — incorrect SID/token will cause edge function failures
- **Monitor Edge Function logs** — they show why SMS delivery fails
- **Keep viewer tokens private** — they grant access to location data

---

## Questions or Issues?

If you encounter issues during testing:
1. Check Supabase Function Logs for edge function errors
2. Check Twilio logs for SMS delivery failures
3. Verify all environment variables in Supabase are set correctly
4. Ensure iOS location permissions are granted in Settings
5. Review the app's Info.plist for location usage descriptions

---

**Last Updated:** April 22, 2026
