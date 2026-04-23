# Action

iPhone-first SwiftUI app: a **compact corner map** on a white, minimal shell, **live location** updates, and **Supabase-backed** location pings you can subscribe to in realtime (for a future trusted viewer or dashboard).

Agent layers, scraping, and watch integrations are **not implemented**; the map exposes a `MapAnnotationProviding` hook for future markers.

## Requirements

- macOS with **Xcode 15+** (iOS 17 SDK)
- A **Supabase** project

## iOS app

1. Open `ios/Action/Action.xcodeproj` in Xcode.
2. Copy `ios/Action/Config/Secrets.example.xcconfig` to `ios/Action/Config/Secrets.xcconfig` and set:
   - `SUPABASE_URL` — Project **Settings → API → Project URL**
   - `SUPABASE_ANON_KEY` — **anon public** key (never commit the service role key)
3. In Xcode, select the **Action** target → **Signing & Capabilities** → choose your **Team** for device runs.
4. Build and run on a simulator or device. Grant **When In Use** location access.

`Shared.xcconfig` includes `Secrets.xcconfig` when present; values flow into `Info.plist` as `$(SUPABASE_URL)` and `$(SUPABASE_ANON_KEY)`.

### Map card

The map is a fixed **180×160** pt rounded card (top-trailing), not full screen. Branding uses a simple system title and a blue accent (see `AccentColor` and `.tint` in `ActionApp`).

### Location pings

`LocationSyncService` throttles uploads (minimum **5 s** between sends, **25 m** movement, or a **60 s** heartbeat). Adjust constants in `LocationSyncService.swift` if needed.

## Supabase backend

1. Create a project at [supabase.com](https://supabase.com).
2. **Authentication → Providers**: enable **Anonymous sign-ins** (used by the app for the first milestone).
3. Run the SQL in [`supabase/migrations/001_location_pings.sql`](supabase/migrations/001_location_pings.sql) in **SQL Editor** (or apply with the Supabase CLI if you use migrations).
4. Confirm **Database → Replication** (or Realtime settings) includes `location_pings` if you rely on realtime broadcasts (the migration runs `alter publication supabase_realtime add table`).

### Realtime smoke test

After a device/simulator has inserted rows, open **Table Editor → `location_pings`** or use the Realtime inspector in the dashboard to confirm new rows appear as the app moves.

To subscribe from another client later, filter by `user_id` equal to the anonymous user’s UUID (see Auth users in the dashboard).

## Privacy

Ship a **Privacy Policy** that matches what you collect (location, backend storage, retention). Update `NSLocationWhenInUseUsageDescription` in `Info.plist` if the product story changes.

## Roadmap (not in repo yet)

- Trusted **viewer** role or shared session for realtime map/dashboard.
- **MapAnnotationProvider** implementations backed by vetted data sources only.
- Android port (separate codebase or shared design system).
