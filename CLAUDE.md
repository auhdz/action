# Action

iPhone-first SwiftUI app that displays a compact corner map widget showing the user's real-time GPS location and syncs location pings to a Supabase backend. Built for iOS 17+, portrait-only, iPhone only.

## Tech Stack

- **Language:** Swift 5.9+
- **UI:** SwiftUI (iOS 17 native)
- **Maps:** MapKit
- **Location:** CoreLocation
- **Backend:** Supabase Swift v2 (SPM) — PostgreSQL, anonymous auth, Realtime
- **IDE:** Xcode 15+ required (no CLI build scripts)
- **No test targets** — don't add them without discussion

## Directory Structure

```
ios/                         # Xcode project
  Action/
    Action/                  # App source (Swift)
      ActionApp.swift        # Entry point
      ContentView.swift      # Root UI
      CornerMapView.swift    # Map widget
      App/AppModel.swift     # Service container
      Config/AppConfiguration.swift
      Location/LocationManager.swift
      Services/LocationSyncService.swift
      Map/MapAnnotationProvider.swift
    Config/
      Shared.xcconfig        # Base build settings
      Secrets.example.xcconfig
    Action.xcodeproj/
supabase/
  migrations/
    001_location_pings.sql   # DB schema + RLS policies
web/
  preview.html               # Browser mockup (Leaflet.js)
```

## Build & Run

1. Copy secrets template (one-time):
   ```
   cp ios/Action/Config/Secrets.example.xcconfig ios/Action/Config/Secrets.xcconfig
   ```
2. Fill in `Secrets.xcconfig` with your Supabase project values (see below).
3. Open `ios/Action/Action.xcodeproj` in Xcode 15+.
4. Select your team under Signing & Capabilities.
5. Run on iPhone simulator or device (iOS 17+).

## Secrets Setup

`Secrets.xcconfig` is gitignored — never commit it. It must define:

```
SUPABASE_URL = https://your-project.supabase.co
SUPABASE_ANON_KEY = eyJ...
```

These are injected into `Info.plist` via xcconfig substitution and loaded at runtime by `AppConfiguration.swift`. Use the **anon public key** only — never the service role key.

`AppConfiguration` will use placeholder values in DEBUG if missing; it crashes at launch in Release builds if either value is absent.

## Architecture

```
AppModel (environment object)
├── LocationManager      — CLLocationManager wrapper, permissions, updates
└── LocationSyncService  — throttled Supabase uploads + anonymous auth

ContentView             — root UI, reads AppModel from environment
└── CornerMapView       — MapKit widget, top-trailing corner, 180×160pt
    └── MapAnnotationProvider  — protocol for future marker data
```

## Key Files

| File | Role |
|------|------|
| `ActionApp.swift` | Creates `AppModel`, sets blue tint (0.0, 0.45, 0.90) |
| `AppModel.swift` | Owns and exposes `LocationManager` + `LocationSyncService` |
| `ContentView.swift` | Status UI, location indicators, hosts `CornerMapView` |
| `CornerMapView.swift` | MapKit map, 0.02° zoom span, user location dot |
| `LocationManager.swift` | Permissions, 10m distance filter, best accuracy |
| `LocationSyncService.swift` | Upload throttling, Supabase auth, ping publishing |
| `AppConfiguration.swift` | Reads secrets from Info.plist |
| `001_location_pings.sql` | `location_pings` table, RLS, Realtime publication |

## Location Throttling Knobs (LocationSyncService.swift)

| Constant | Default | Effect |
|----------|---------|--------|
| `minSendInterval` | 5s | Minimum time between uploads |
| `minMovementThreshold` | 25m | Skip upload if moved less than this |
| `heartbeatInterval` | 60s | Force upload even when stationary |

## Backend (Supabase)

- **Table:** `location_pings(id, user_id, latitude, longitude, accuracy_m, created_at)`
- **RLS:** users can only read/write their own rows
- **Auth:** anonymous sign-in on first launch (no email/password for MVP)
- **Realtime:** enabled on `location_pings` for live subscriber dashboards
- Run `supabase/migrations/001_location_pings.sql` in the Supabase SQL editor to set up the schema.

## Conventions

- Use `@Published` on `LocationManager` and `LocationSyncService` properties; consume them via `@StateObject`/`@EnvironmentObject` in views.
- Add new secrets by updating `Secrets.example.xcconfig`, `Info.plist`, and `AppConfiguration.swift` together.
- Implement `MapAnnotationProvider` protocol to add map markers (ICE/agent markers, crowd-sourced pins, etc.) — the empty `DefaultMapAnnotationProvider` is the placeholder.

## What Not To Do

- **Never commit `Secrets.xcconfig`** — it is in `.gitignore` for a reason.
- **Never put the Supabase service role key** in the app or any xcconfig — anon key only.
- **Don't add iPad or macOS targets** — the app is iPhone-only by design.
- **Don't add test targets** without discussion — the project currently has none.
