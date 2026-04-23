# TestFlight Submission - Quick Start Guide

This document is your start-to-finish guide for submitting Acción to TestFlight and the App Store.

## Prerequisites

- **Xcode 15+** installed on macOS
- **Apple Developer Account** (paid membership required)
- **Secrets.xcconfig** configured with valid Supabase credentials
- **Team ID** from Apple Developer Portal

## What You're Submitting

- **App:** Acción (pronounce: ack-see-OWN, means "Action" in Spanish)
- **Version:** 1.0
- **Platforms:** iOS 17+ (iPhone only)
- **Features:** Real-time GPS location, SOS emergency button, trusted contact alerts

## Files You'll Need

All prepared and in the repository:

```
/Users/ahernandez5/action/
├── ios/Action/Action.xcodeproj/     ← Xcode project
├── PRIVACY_POLICY.md                ← Required for App Store
├── APPSTORE_METADATA.md             ← All submission fields
├── DISTRIBUTION_CHECKLIST.md        ← Detailed checklist
├── TESTFLIGHT_QUICK_START.md        ← This file
└── README.md                        ← Feature overview
```

## Timeline

| Step | Duration | Who |
|------|----------|-----|
| Prepare Xcode | 5-10 min | You (GUI) |
| Build & Archive | 5-10 min | Xcode |
| Upload to TestFlight | 5-10 min | Xcode + Apple |
| Processing in App Store Connect | 10-20 min | Apple |
| TestFlight link ready | Total: 30-50 min | You |
| **Total before sharing:** | **~1 hour** | |

*Then, optionally:*

| App Store Submission | 1-2 days | Apple Review |

## Quick Steps

### 1. Configure Secrets (5 minutes)

```bash
# If you haven't already:
cp ios/Action/Config/Secrets.example.xcconfig ios/Action/Config/Secrets.xcconfig

# Edit in your editor:
# Add your Supabase URL and anon key
```

### 2. Open Xcode (30 seconds)

```bash
open ios/Action/Action.xcodeproj
```

### 3. Set Team ID (2 minutes)

1. Select "Action" target (left sidebar)
2. Go to "Signing & Capabilities" tab
3. Select your Team ID from the dropdown
4. Let Xcode create provisioning profiles automatically

### 4. Select Release Destination (30 seconds)

1. Top of Xcode window: Select "Any iOS Device (arm64)" (not simulator)

### 5. Create Archive (5 minutes)

1. Menu: Product → Archive
2. Wait for build to complete
3. Xcode will show Organizer window

### 6. Distribute (5 minutes)

1. In Organizer, select your archive
2. Click "Distribute App"
3. Choose "TestFlight & App Store"
4. Click "Upload"
5. Let Xcode manage signing
6. Click "Upload" to send to Apple

### 7. Check Status (Immediate)

```bash
# Optional: Monitor with tail
tail -f ~/Library/Logs/Xcode/IDEDistributionLogs/*/Xcode\ IDEDistributionLogs.log
```

### 8. Verify in App Store Connect (15-20 min)

1. Go to https://appstoreconnect.apple.com
2. Select "Acción"
3. Go to "TestFlight" tab
4. Wait for build to show (might take 5-15 min)
5. When ready, click on the build to get the public TestFlight link

### 9. Share TestFlight Link

```
https://testflight.apple.com/join/[CODE]
```

Share this link with anyone who wants to beta test!

## That's It!

Your app is now on TestFlight. You can:

- **Share the link** with testers immediately
- **Let TestFlight handle signing** (Apple manages distribution)
- **Monitor crashes** in Xcode → Organizer → Crashes
- **Fix bugs** and create new builds (increment CURRENT_PROJECT_VERSION)

## Optional: Submit to App Store

To make the app available on the official App Store (not just TestFlight):

1. In App Store Connect, go to "App Store" tab
2. Create a new version (1.0.1 or keep as 1.0)
3. Fill in metadata (use APPSTORE_METADATA.md)
4. Upload screenshots (see APPSTORE_METADATA.md)
5. Select TestFlight build
6. Submit for review
7. Wait 1-2 days for Apple's review

## Troubleshooting Quick Fixes

| Problem | Fix |
|---------|-----|
| "Code signing failed" | Set Team ID in Signing & Capabilities tab |
| "Can't find device" | Select "Any iOS Device (arm64)" from dropdown |
| Upload stuck | Wait 5 minutes or restart Xcode |
| Build doesn't appear in App Store Connect | Wait 15 minutes and refresh |
| "Invalid bundle" error | Verify TARGETED_DEVICE_FAMILY = 1 in Build Settings |

For detailed troubleshooting, see **DISTRIBUTION_CHECKLIST.md**.

## What's Happening Behind the Scenes

1. **Xcode builds** your app for arm64 (iPhone hardware)
2. **Code signing** happens automatically (requires Team ID)
3. **Notarization** ensures Apple security (happens during upload)
4. **Upload** sends ~50 MB to Apple
5. **Apple processing** validates the app (5-15 min)
6. **TestFlight ready** in your account
7. **Testers can install** from link you share

## Next Steps

After TestFlight is ready:

1. **Test on real device:** Follow TestFlight link on iPhone
2. **Share with testers:** Send link in email/group chat
3. **Collect feedback:** Monitor crashes and user reports
4. **Fix bugs:** Create new builds as needed
5. **Submit to App Store:** When ready for public release

## Questions?

Check these files in order:

1. `TESTFLIGHT_QUICK_START.md` (this file)
2. `DISTRIBUTION_CHECKLIST.md` (detailed verification)
3. `APPSTORE_METADATA.md` (metadata reference)
4. `PRIVACY_POLICY.md` (legal/compliance)
5. `README.md` (feature overview)

---

**Status:** Ready to submit  
**Last updated:** April 2026  
**Contact:** taquestudios@gmail.com  

🚀 You're ready to launch!
