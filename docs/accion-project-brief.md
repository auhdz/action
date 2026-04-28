# Acción — Project Brief

Use this document to give Claude (or any collaborator) full context on the project without re-explaining everything.

---

## What It Is

**Acción** is an iPhone-first safety app built for the Hispanic and Latino community in Los Angeles who fear ICE detention. It solves a specific fear: *"If I get stopped or detained, my family won't know where I am or what happened."*

The app gives users:
- Passive live GPS location sharing via a private web link (family opens it in a browser — no app download required)
- An SOS emergency button that texts the web link to trusted family contacts the moment it's triggered
- Anonymous usage — no email, no account, no paper trail

---

## Current Status (as of April 27, 2026)

The MVP is **fully built** and running on iOS Simulator. It has not yet shipped to TestFlight or the App Store. The developer has not enrolled in the $99/yr Apple Developer Program yet.

### What's built
- **3-step onboarding**: Welcome screen → Trusted contacts picker → Location permission
- **Bilingual**: English default, Español toggle (globe dropdown) on every screen
- **SOS button** on main screen: 3-second hold-to-confirm, 60-second cancel window
- **Web viewer**: `accion.app/watch/[token]` — live blue dot (normal) or red pulsing dot (alert state) powered by Supabase Realtime
- **SMS alerts**: Supabase Edge Function + Twilio sends SMS to all trusted contacts on SOS trigger
- **Backend**: Supabase (PostgreSQL + anonymous auth + Realtime + RLS policies)
- **Docs**: `docs/` folder in repo with architecture decision records

### GitHub repo
`https://github.com/auhdz/action` (branch: `main`)

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| App | Swift 5.9 + SwiftUI, iOS 17+, iPhone only |
| Maps | MapKit |
| Location | CoreLocation |
| Backend | Supabase (PostgreSQL, anonymous auth, Realtime) |
| SMS | Twilio via Supabase Edge Function (Deno/TypeScript) |
| Web viewer | HTML + Supabase Realtime JS |
| Distribution | iOS Simulator (now), TestFlight (next), App Store (later) |

---

## Key Decisions Already Made

**Anonymous auth only** — No email or account required. Zero PII stored. A subpoena of the database reveals nothing about who the user is. This is a deliberate privacy protection for the target community.

**Web link for family, not a second app** — Reduces friction at the worst moment. Family taps a link in an SMS and sees the map immediately.

**TestFlight before App Store** — Avoiding the $99/yr Apple Developer Program while iterating. Will enroll when the core SOS flow is validated with ~10 real community testers in LA.

**Spanish + English, not Spanish-only** — Default is English with a one-tap toggle to Español. Serves both monolingual Spanish speakers and bilingual/English-dominant users in LA.

**No incident tracker in v1** — Crowd-sourced ICE sighting map is explicitly v2. Keep v1 focused on personal safety.

---

## Roadmap

### v1 — MVP (current, not yet shipped)
- [x] Onboarding (welcome, contacts, location permission)
- [x] Live location tracking + Supabase sync
- [x] SOS button with 60s cancel window
- [x] Private web viewer with Realtime alerts
- [x] Twilio SMS to trusted contacts on SOS
- [x] Bilingual EN/ES
- [ ] TestFlight distribution
- [ ] App Store submission

### v2 — Community Layer
- Crowd-sourced ICE sighting map (community reports incidents)
- Incident notification radius alerts

### v3 — Scale
- Android
- Push notifications for family (instead of SMS-only)
- Multi-city expansion beyond LA

---

## Business Context (open questions)

- No monetization model decided yet
- No formal legal entity yet
- No community partnerships established yet
- Privacy policy exists (drafted for App Store) but not published
- No funding sought yet

---

## Files Worth Knowing

| File | What it does |
|------|-------------|
| `ios/Action/Action/ActionApp.swift` | App entry point, injects all environment objects |
| `ios/Action/Action/ContentView.swift` | Main screen with map + SOS button |
| `ios/Action/Action/Onboarding/` | All 3 onboarding screens |
| `ios/Action/Action/Services/ContactsService.swift` | Reads device contacts |
| `ios/Action/Action/Services/LocationSyncService.swift` | Uploads GPS pings to Supabase |
| `supabase/migrations/002_accion_mvp.sql` | DB schema for trusted_contacts, viewer_tokens, ping_type |
| `supabase/functions/send-sos-sms/index.ts` | Twilio SMS edge function |
| `web/preview.html` | The family web viewer |
| `docs/decisions/` | Why key decisions were made |
| `CLAUDE.md` | Technical conventions for the codebase |
