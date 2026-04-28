# Supabase Schema Overview

Project URL: `https://gggtcmujowczismmvzis.supabase.co`

## Tables

### `location_pings`
Stores GPS pings from the device. See `supabase/migrations/001_location_pings.sql`.
- `ping_type`: `'normal'` (default) or `'alert'` (SOS triggered)
- RLS: users read/write own rows only

### `trusted_contacts`
Contacts the user selected during onboarding. See `supabase/migrations/002_accion_mvp.sql`.
- Linked to `auth.users` via `user_id`
- Used by Edge Function to send SOS SMS

### `viewer_tokens`
One token per user — the secure ID embedded in the family web viewer URL.
- Token is auto-generated: `encode(gen_random_bytes(24), 'base64url')`
- RLS: public read by token value (no auth required), user writes own row

## Edge Functions

### `send-sos-sms`
- Triggered via DB webhook on INSERT to `location_pings` where `ping_type = 'alert'`
- Fetches trusted contacts + viewer token for the user
- Sends Twilio SMS with the viewer link
- Source: `supabase/functions/send-sos-sms/index.ts`
