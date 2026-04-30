# Acción — Android Plan

> Android is not optional. It's where the community is.

---

## Why Android Is Urgent for Acción

### The data on the Latino community and Android

| Stat | Source |
|------|--------|
| Android users average $61K household income; iPhone users average $85K | Backlinko/DemandSage 2024 |
| Android = 80–90% market share in Latin America (Mexico, Central America, South America) | Statista 2024 |
| 28.2 million people in the US live in mixed-status households — >90% own smartphones | Urban Institute / Migration Policy 2021 |
| iPhone dominates US overall (65%), but that skews White/high-income demographics | Backlinko 2024 |

**The direct implication:** A significant portion of the community Acción is built for uses Android. Launching iOS-only means the people who need this most — lower-income, immigrant-origin families — are excluded on day one. This is not acceptable for a safety app.

Dr. Borges is right: Android is faster and cheaper than the App Store.

---

## Google Play vs Apple App Store: The Practical Comparison

| Factor | Google Play | Apple App Store |
|--------|-------------|-----------------|
| Developer account | $25 one-time | $99/year |
| Internal testing | Available immediately, no review needed | Requires review (1–2 days) |
| Public review timeline | 1–3 days typically | 1–7 days typically |
| Review strictness | Less restrictive on community/safety apps | Higher risk for Acción's content type |
| Installs without App Store | APK sideloading possible | Impossible without jailbreak |

**Bottom line:** Android is faster to launch, cheaper to maintain, and lower risk of content rejection for an app in Acción's sensitive category.

---

## How to Test Android Without an Android Device

### Option 1: Android Studio Emulator (Free, on your Mac)
1. Download Android Studio: developer.android.com/studio
2. Create a virtual device (AVD): Pixel 7, Android 14
3. Run the app in the emulator — it behaves like a real device
4. Location can be simulated via the emulator's GPS controls
5. **This is where you start**

### Option 2: Google Play Internal Testing Track
- Once you have an Android APK, upload to Google Play Console
- Internal testing track = immediate install, no review, up to 100 testers
- Cost: $25 one-time for the developer account
- Testers install via a direct link — no public App Store listing needed

### Option 3: BrowserStack or Firebase Test Lab
- Cloud-based real device testing
- BrowserStack: browserstack.com — 100+ real Android devices accessible via browser
- Firebase Test Lab: firebase.google.com/products/test-lab — automated testing on Google's device farm
- Useful for: verifying GPS behavior and SMS on physical hardware before launch

### Option 4: Buy a $100 Android test device
- Motorola Moto G Power (~$150) or Samsung Galaxy A15 (~$120)
- The same device profile as most Latino community members
- Best for real-world feel testing
- Available on Amazon or Best Buy

---

## Technology Choice for Android Build

### The question: Kotlin native vs React Native vs Flutter

Given that Acción is already built in SwiftUI (iOS-only), there are three paths:

**Option A: Kotlin native Android (Recommended for v1)**
- Build a separate Android app in Kotlin + Jetpack Compose
- Uses the exact same Supabase backend (no backend changes)
- Supabase Kotlin SDK: production-ready (github.com/supabase-community/supabase-kt)
- Timeline: 2–3 weeks for feature parity with iOS
- Pros: Native performance, full access to Android APIs, identical Supabase integration
- Cons: Two codebases to maintain going forward

**Option B: React Native / Expo (Recommended for v2+ scalability)**
- Rewrite both iOS and Android in JavaScript/TypeScript
- One codebase, deploy to both platforms
- Expo makes setup fast: expo.dev
- Supabase has a React Native quickstart with the same SDK
- Timeline: 4–6 weeks (longer initial build, but eliminates dual maintenance forever)
- Pros: One codebase, faster iteration going forward
- Cons: Rewrites iOS from scratch, some performance considerations

**Option C: Flutter**
- Google's cross-platform framework using Dart
- Largest cross-platform adoption (46% of cross-platform developers as of 2025)
- Similar timeline to React Native
- Pros: High performance, strong community
- Cons: Dart is not used anywhere else in the stack — adds a new language

### Recommendation

**For getting Android launched fast:** Kotlin native. The Supabase Kotlin SDK is mature, the backend needs zero changes, and 2–3 weeks is achievable.

**For the long-term codebase:** Plan a React Native or Flutter rewrite for v2 when you have an engineering team. One codebase halves your maintenance burden as the product grows.

---

## What the Android App Needs (Feature Parity with iOS)

**v1 Android — must have:**
- [ ] Anonymous Supabase auth (same as iOS)
- [ ] Trusted contacts setup (1–5 contacts)
- [ ] SOS button (3-second hold)
- [ ] 60-second cancel window
- [ ] Live location tracking + Supabase sync
- [ ] Bilingual EN/ES toggle
- [ ] Know Your Rights screen
- [ ] TOS acceptance screen

**v1 Android — nice to have (can ship after):**
- [ ] Web viewer (already works — it's a website, OS-agnostic)
- [ ] Community safety map (v1.5)

---

## Step-by-Step Android Launch Plan

### Week 1: Setup
1. Download Android Studio on your Mac
2. Create a virtual Pixel 7 emulator (Android 14)
3. Register Google Play developer account: play.google.com/console ($25)
4. Set up a new Android project in Android Studio (Kotlin, Jetpack Compose)
5. Add Supabase Kotlin SDK to the project

### Week 2: Core Build
6. Implement anonymous auth using Supabase Kotlin SDK
7. Build the onboarding flow (TOS → contacts → location)
8. Implement GPS location tracking (Android LocationManager or FusedLocationProviderClient)
9. Build the SOS button with hold-to-confirm

### Week 3: Polish and Test
10. Add bilingual toggle (same LanguageManager logic, adapted)
11. Add Know Your Rights screen
12. Test on emulator + internal testing track via Google Play
13. Fix any Supabase integration issues
14. Upload APK to Google Play internal testing — share link with 10 testers

### Week 4: Launch
15. Submit to Google Play production (1–3 day review)
16. Android is live — announce alongside or shortly after iOS App Store

---

## Android Distribution Advantages

**Sideloading (APK distribution):**
Android allows direct APK downloads — no App Store needed. Before Google Play approval, you can distribute the APK directly via a download link. Community orgs can host it on their own websites. This is a meaningful distribution channel that iOS cannot match.

**Community org distribution:**
A community org can host the Acción APK on their website with a QR code. Latino families download and install it directly. This is legal, private, and bypasses any app store review entirely for initial distribution.

**Google Play Families / Accessibility:**
Google Play has no equivalent to Apple's 1.4.3 risk. Safety apps with community reporting features have been approved without issue on Google Play. Lower regulatory risk for the community feed feature.

---

## Metrics to Track Post-Android Launch

- Android vs iOS install ratio (expect Android to be higher in the target community)
- Android retention vs iOS (tests whether the product resonates equally)
- Android SOS activations — if higher per capita than iOS, validates the Android-first hypothesis
