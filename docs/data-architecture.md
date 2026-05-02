# Acción — Data Architecture & Scaling Plan

## What We Store and Where

---

### 1. On-Device Only (UserDefaults via `@AppStorage`)

These never leave the phone. No server sees them.

| Key | Value | When written |
|-----|-------|-------------|
| `userName` | First name from onboarding screen | User types it at setup |
| `hasCompletedOnboarding` | true/false | Onboarding final step |

**Privacy note:** The user's name is stored locally only for the greeting ("Good morning, Adrian"). It is never sent to any server.

---

### 2. Supabase — PostgreSQL on AWS us-east-1

All four tables below are in a single Supabase project. Row Level Security (RLS) is enabled on every table — users can only read and write their own rows.

#### `auth.users` (Supabase managed)

Created automatically on first app launch via anonymous sign-in. No email, no password, no name.

| Field | Value |
|-------|-------|
| `id` | Random UUID — stable per device installation |
| `created_at` | First launch timestamp |

The UUID is the user's identity throughout the system. It is not linked to any real-world identifier. If the app is deleted and reinstalled, a new UUID is created and the old one is orphaned (data stays but is permanently inaccessible).

---

#### `location_pings`

The core table. Every GPS coordinate we upload lands here.

| Column | Type | What it is |
|--------|------|-----------|
| `id` | UUID | Auto-generated row ID |
| `user_id` | UUID | Anonymous user ID |
| `latitude` | double | GPS latitude |
| `longitude` | double | GPS longitude |
| `accuracy_m` | double | GPS accuracy in meters |
| `recorded_at` | timestamptz | When the GPS fix was taken |
| `created_at` | timestamptz | When the row was inserted |
| `ping_type` | text | `normal` (background) or `alert` (SOS fired) |

**How often rows are written:**
- Minimum gap: 5 seconds between pings
- Movement threshold: only sends if user moved ≥ 25 meters
- Heartbeat: sends at least once every 60 seconds even if stationary

**Current problem:** Rows accumulate indefinitely. There is no expiration or cleanup. This is the biggest storage cost driver and needs to be fixed before launch (see Scaling section).

---

#### `trusted_contacts`

Written once during onboarding and overwritten whenever contacts change.

| Column | Type | What it is |
|--------|------|-----------|
| `id` | UUID | Auto-generated row ID |
| `user_id` | UUID | Anonymous user ID |
| `name` | text | Contact's display name (from iOS Contacts) |
| `phone_number` | text | Contact's phone number (raw string) |
| `created_at` | timestamptz | When the row was inserted |

**Important:** Phone numbers are stored here so the Edge Function can send SMS during an alert. This is the most sensitive data in the system. The RLS policy ensures only the user's own contacts are readable — no user can access another user's contacts.

---

#### `viewer_tokens`

One token per user. This is the credential that lets trusted contacts view a live location map without logging in.

| Column | Type | What it is |
|--------|------|-----------|
| `id` | UUID | Auto-generated row ID |
| `user_id` | UUID | Anonymous user ID |
| `token` | text | 48-character random hex string |
| `created_at` | timestamptz | When the token was created |

The token is embedded in the shareable URL: `https://accion.app/watch/<token>`. Anyone with this URL can view the user's live location. The user can revoke access by deleting and regenerating their token (not yet built in the UI).

---

### 3. Twilio (Third Party — SMS delivery)

When an SOS alert fires, the Edge Function sends the trusted contacts' phone numbers to Twilio to deliver SMS messages. Twilio logs:

- Outbound phone number (the contact receiving the SMS)
- Message SID
- Delivery status
- Timestamp

Twilio's data retention: 400 days by default. Phone numbers are visible in Twilio's dashboard. This is governed by Twilio's privacy policy, not ours. At scale, consider Telnyx (~$0.004/SMS vs Twilio's ~$0.008/SMS) to cut SMS costs in half.

---

### 4. What We Do NOT Store

- User's phone number (app never asks for it)
- User's email (anonymous auth, no email)
- User's real name on any server (on-device only)
- IP addresses in our tables (Supabase infrastructure may log these, but we don't write them to our schema)
- Contact information beyond name + phone number
- Historical location beyond what we haven't yet cleaned up (see below)

---

## Scaling Plan

### Where the Free Tier Breaks

Supabase free tier limits:

| Resource | Limit | When we hit it |
|----------|-------|----------------|
| Database | 500 MB | ~1,000 DAU with no data TTL, within 3 weeks |
| API requests | 5M/month | ~1,600 DAU pinging every 60s |
| Realtime connections | 200 concurrent | ~200 active viewers simultaneously |
| Edge function calls | 500K/month | ~16K SOS alerts/month |
| Auth MAU | 50,000 | Plenty of runway |

**The math on location pings:**
- 1,000 DAU × 2 hours active × 60 pings/hour = 120,000 pings/day
- Each row ≈ 200 bytes
- 120,000 × 200 bytes × 30 days = **720 MB/month** — hits the limit at 1,000 DAU

### Fix 1: Add Data TTL (do this before launch, costs nothing)

Add a scheduled Postgres job to delete location pings older than 24 hours. Trusted contacts and viewer tokens are small and can be kept indefinitely.

```sql
-- Run once to create the cleanup function
create or replace function public.cleanup_old_pings()
returns void as $$
begin
  delete from public.location_pings
  where created_at < now() - interval '24 hours'
    and ping_type = 'normal';
  -- Keep alert pings for 7 days (audit trail)
  delete from public.location_pings
  where created_at < now() - interval '7 days'
    and ping_type = 'alert';
end;
$$ language plpgsql;

-- Schedule it (requires pg_cron extension, enabled in Supabase dashboard)
select cron.schedule('cleanup-pings', '0 * * * *', 'select public.cleanup_old_pings()');
```

With 24-hour TTL, storage per 1,000 DAU drops from 720 MB/month to ~24 MB total at any moment. This extends free tier runway to ~20,000 DAU.

### Fix 2: Upgrade Path by User Count

| Users (MAU) | Infrastructure | Est. monthly cost |
|-------------|---------------|-------------------|
| 0–5,000 | Supabase Free + TTL job | $0 |
| 5,000–25,000 | Supabase Pro | $25/month |
| 25,000–100,000 | Supabase Pro + larger compute | $100–200/month |
| 100,000+ | Supabase Team or self-hosted Postgres on Fly.io/Railway | $300–500/month |

Supabase Pro ($25/month) gives: 8 GB database, 250 GB bandwidth, 10M API calls, 2M edge function calls. This comfortably handles 25,000 MAU.

### Fix 3: SMS Cost Projection

Every SOS alert sends up to 5 SMS messages (one per trusted contact).

| Monthly alerts | Twilio cost (@$0.008/SMS, 5 contacts) | Telnyx cost (@$0.004/SMS) |
|---------------|--------------------------------------|--------------------------|
| 1,000 | $40 | $20 |
| 10,000 | $400 | $200 |
| 50,000 | $2,000 | $1,000 |

**Recommendation:** Switch from Twilio to Telnyx before reaching 5,000 MAU. Same API surface, half the cost. The Edge Function change is ~10 lines.

### Fix 4: Revenue to Cover Infrastructure

At $3/month per paying user, the break-even points are:

| Infra + SMS cost | Paying users needed |
|-----------------|-------------------|
| $40/month (1K alerts, Supabase free) | 14 paying users |
| $125/month (Supabase Pro + SMS) | 42 paying users |
| $700/month (25K MAU + SMS) | 234 paying users |

Even at 25,000 MAU, you need only 234 paying users (< 1%) to break even. The unit economics are strong.

### Fix 5: What to Build Next for Scale

In priority order:

1. **TTL cleanup job** — implement now, before launch, costs nothing
2. **Ping deduplication** — if GPS doesn't move, skip the insert entirely at the app layer (already partially done with 25m threshold)
3. **Supabase Pro** — flip the switch at 5,000 MAU, $25/month
4. **Switch to Telnyx** — at 5,000 MAU, saves ~$20/month immediately and compounds
5. **Viewer token revocation UI** — users should be able to regenerate their link
6. **Data deletion flow** — users should be able to delete all their data (CCPA requirement, required for App Store in California)
7. **Realtime fanout architecture** — at 100K+ MAU, Supabase Realtime may need to be replaced with a purpose-built fanout (Ably, Pusher, or self-hosted Soketi)

---

## Privacy Summary for Users

What Acción does with your data:

- **Your name:** stays on your phone. No server ever sees it.
- **Your GPS location:** sent to our servers (Supabase/AWS) while the app is open. Deleted after 24 hours unless you triggered an SOS, in which case kept for 7 days.
- **Your trusted contacts:** their names and phone numbers are stored on our servers so we can text them if you need help. Protected by row-level security — only you can access your contacts list.
- **Your account:** anonymous. No email, no password, no name attached to your account. Your only identifier is a random ID generated on first launch.
- **SMS delivery:** when you send an SOS, your contacts' phone numbers are sent to our SMS provider (Twilio/Telnyx) to deliver the alert. Their privacy policy governs that data.

We do not sell, share, or analyze your location data. We do not know who you are.
