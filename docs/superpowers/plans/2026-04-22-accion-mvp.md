# Acción MVP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a fully functional iOS safety app to TestFlight and App Store with live location sharing, SOS escalation, and SMS alerts to family.

**Architecture:** Three-layer system — iOS sender app (onboarding → location tracking → SOS), Supabase backend (tables, RLS, Edge Function for SMS), web viewer (private link, Realtime updates). All three layers must work end-to-end for a single test user to trigger SOS and have family receive SMS with working link.

**Tech Stack:** Swift 5.9 + SwiftUI, Supabase v2 SDK, Contacts framework, MapKit, Supabase Realtime JS (web), Twilio for SMS.

---

## File Structure Overview

**New iOS files (onboarding layer):**
- `ios/Action/Action/Onboarding/OnboardingView.swift` — container for 3-step flow
- `ios/Action/Action/Onboarding/WelcomeView.swift` — step 1
- `ios/Action/Action/Onboarding/ContactPickerView.swift` — step 2, contact selection UI
- `ios/Action/Action/Services/ContactsService.swift` — Contacts framework wrapper
- `ios/Action/Action/Services/ViewerTokenService.swift` — token generation and storage

**Modified iOS files:**
- `ios/Action/Action/ActionApp.swift` — show onboarding on first launch
- `ios/Action/Action/ContentView.swift` — add SOS button + 60s cancel state
- `ios/Action/Action/Services/LocationSyncService.swift` — include `ping_type` in inserts
- `ios/Action/Action/App/AppModel.swift` — wire ContactsService, ViewerTokenService
- `ios/Action/Config/Shared.xcconfig` — update display name
- `ios/Action/Action/Info.plist` — update display name, add Contacts usage

**Backend (Supabase):**
- `supabase/migrations/002_accion_mvp.sql` — schema: `ping_type`, `trusted_contacts`, `viewer_tokens`, RLS
- `supabase/functions/send-sos-sms/index.ts` — Edge Function, Twilio integration

**Web viewer:**
- `web/preview.html` — rewrite to support Realtime + alert states + token-based auth

---

## Tasks

### Task 1: Create Supabase Migration for MVP Schema
- Create `supabase/migrations/002_accion_mvp.sql` with all schema changes
- Add `ping_type` column to `location_pings` with default 'normal'
- Create `trusted_contacts` table with RLS
- Create `viewer_tokens` table with RLS
- Add helper function `is_valid_viewer_token`
- Update RLS on `location_pings` for viewer token access

### Task 2: Create ContactsService for iOS
- Create `ios/Action/Action/Services/ContactsService.swift`
- Implement Contacts framework integration
- `TrustedContact` struct with id, name, phoneNumber
- `fetchAllContacts()` method to read device contacts
- Request Contacts permission

### Task 3: Create ViewerTokenService for iOS
- Create `ios/Action/Action/Services/ViewerTokenService.swift`
- Implement token management (ensure token exists, retrieve it)
- `ensureViewerTokenExists()` async method
- `getViewerLink()` method to generate shareable URL
- Store and retrieve tokens from Supabase

### Task 4: Create OnboardingView and WelcomeView
- Create `ios/Action/Action/Onboarding/OnboardingView.swift` with 3-step flow
- Create `ios/Action/Action/Onboarding/WelcomeView.swift` with features explanation
- Create `OnboardingState` class to track current step
- `LocationPermissionView` as final step

### Task 5: Create ContactPickerView
- Create `ios/Action/Action/Onboarding/ContactPickerView.swift`
- Search and select contacts (max 5)
- Display "Para tu seguridad..." safety nudge
- Save selected contacts to Supabase `trusted_contacts` table
- Ensure viewer token exists after saving contacts

### Task 6: Update ActionApp to Show Onboarding on First Launch
- Modify `ios/Action/Action/ActionApp.swift`
- Add `@AppStorage("hasSeenOnboarding")` flag
- Show `OnboardingView` if not seen, `ContentView` if completed
- Set flag to true when onboarding completes

### Task 7: Add SOS Button to ContentView
- Modify `ios/Action/Action/ContentView.swift`
- Add large SOS button with "EMERGENCIA" label
- 3-second hold-to-confirm gesture
- 60-second cancel window after confirmation
- Update status to show "ALERTA ACTIVADA" during cancel window
- Trigger `LocationSyncService.insertAlertPing()`
- Reset with `resetAlertPing()` if cancelled

### Task 8: Update LocationSyncService to Include ping_type
- Modify `ios/Action/Action/Services/LocationSyncService.swift`
- Add `insertAlertPing()` method (inserts with ping_type='alert')
- Add `resetAlertPing()` method (inserts with ping_type='normal')
- Update regular location updates to include `ping_type='normal'`

### Task 9: Create Supabase Edge Function for SMS Alerts
- Create `supabase/functions/send-sos-sms/index.ts`
- Trigger on INSERT to `location_pings` where `ping_type='alert'`
- Fetch trusted contacts and viewer token
- Send SMS via Twilio: "[Name] activó una alerta de emergencia. Ve su ubicación: [link]"
- Handle errors gracefully

### Task 10: Build Web Viewer with Realtime + Alert States
- Rewrite `web/preview.html` completely
- Token-based auth from URL
- Fetch latest location ping on load
- Subscribe to Realtime updates for new pings
- Normal state: blue dot, "Está bien"
- Alert state: red pulsing dot, "ALERTA", audio alert
- Update last-update timestamp every minute
- Responsive design for mobile

### Task 11: Update Build Config and Display Name
- Modify `ios/Action/Config/Shared.xcconfig` — set display name to "Acción"
- Modify `ios/Action/Action/Info.plist` — add display name, Contacts and Location permissions

### Task 12: Test End-to-End and Prepare for TestFlight
- Configure Secrets with Supabase credentials
- Run Supabase migrations
- Deploy Edge Function with Twilio secrets
- Build and run on simulator
- Test full flow: onboarding → location tracking → SOS → SMS → web viewer
- Create App Store metadata and privacy policy

### Task 13: Prepare TestFlight Build and App Store Submission
- Increment build number in Xcode
- Create TestFlight build
- Generate shareable TestFlight link
- Submit to App Store for review
- Final commit

---

## Verification Checklist (per task)

After each task, verify:
- Code compiles without warnings
- Changes match spec requirements
- Tests pass (if applicable)
- Commits are atomic and well-described
- No debug code or placeholders left
