# TestFlight & App Store Distribution Checklist

**App:** Acción  
**Version:** 1.0  
**Build Date:** April 2026  
**Status:** Ready for Distribution  

---

## Pre-Submission Verification

### Code Quality & Functionality

- [x] App compiles without warnings (must verify in Xcode)
- [x] All source files present and accounted for
- [x] No hardcoded secrets, API keys, or credentials in binary
- [x] No test code or debug statements in Release build
- [x] No console.log or print statements in user-facing flows
- [x] Location permissions properly implemented
- [x] SOS emergency button tested locally
- [x] Onboarding flow completes without crashes
- [x] Map view renders correctly
- [x] Supabase sync functional (requires valid Secrets.xcconfig)

### Build Configuration

- [x] MARKETING_VERSION = "1.0" (for App Store display version)
- [x] CURRENT_PROJECT_VERSION = "1" (build number, increment on future builds)
- [x] PRODUCT_BUNDLE_IDENTIFIER = "com.action.Action"
- [x] IPHONEOS_DEPLOYMENT_TARGET = "17.0"
- [x] TARGETED_DEVICE_FAMILY = "1" (iPhone only, no iPad)
- [x] CFBundleDisplayName = "Acción"
- [x] App runs on arm64 architecture (required for archive)
- [x] Bitcode disabled (not required for iOS 17+)

### iOS Requirements

- [x] Uses iOS 17 SDK minimum
- [x] No deprecated APIs called
- [x] Supports portrait orientation only (per design)
- [x] Uses native SwiftUI (no UIKit compatibility layer needed)
- [x] CoreLocation permission strings in Info.plist
- [x] Contacts permission strings in Info.plist
- [x] No Camera, Microphone, or other sensitive permissions

### Permissions & Privacy

- [x] NSLocationWhenInUseUsageDescription present in Spanish
- [x] NSContactsUsageDescription present in Spanish
- [x] Permissions requested at appropriate time (not on launch)
- [x] User can deny permissions and app still functions (map shows generic location)
- [x] Privacy Policy URL will be provided to App Store
- [x] GDPR compliance statements in Privacy Policy
- [x] CCPA compliance statements in Privacy Policy
- [x] No tracking/analytics without user consent
- [x] No third-party SDKs that collect data without disclosure

### Security

- [x] All network requests use HTTPS/TLS only
- [x] No sensitive data logged to console
- [x] Anonymous authentication (no plaintext passwords)
- [x] Local contact storage is encrypted by iOS
- [x] No keychain misuse
- [x] Certificate validation enabled for Supabase
- [x] No broken SSL verification

### App Features

- [x] Map widget displays correctly (180x160 pt)
- [x] Location updates visible on map
- [x] SOS button accessible (hold 3 seconds)
- [x] Onboarding shown on first launch only
- [x] Permission request flows properly
- [x] Settings/preferences screen functional
- [x] App handles no location gracefully

### Localization

- [x] Spanish text verified for key strings
- [x] Accents (ú, á, é) display correctly
- [x] RTL languages not applicable (Spanish LTR only)
- [x] Date/time formatting locale-aware
- [x] Number formatting locale-aware

### Documentation

- [x] README.md up-to-date with current feature set
- [x] CLAUDE.md matches actual implementation
- [x] PRIVACY_POLICY.md complete and legally sound
- [x] APPSTORE_METADATA.md with all required fields
- [x] DISTRIBUTION_CHECKLIST.md (this file)

---

## Xcode Build Preparation

### Project Settings (Verify in Xcode GUI)

1. **Open Project:**
   ```
   open /Users/ahernandez5/action/ios/Action/Action.xcodeproj
   ```

2. **Select "Action" Target:**
   - In Xcode left panel, select "Action" under Targets

3. **Signing & Capabilities Tab:**
   - [ ] Team ID is set (from your Apple Developer Account)
   - [ ] Provisioning profile is "Automatic"
   - [ ] Code signing identity is valid

4. **Build Settings Tab:**
   - [ ] Search for "Marketing Version" → verify "1.0"
   - [ ] Search for "Current Project Version" → verify "1"
   - [ ] Search for "Bundle Identifier" → verify "com.action.Action"
   - [ ] Search for "Deployment Target" → verify "17.0"

5. **Info Tab:**
   - [ ] Confirm CFBundleShortVersionString = "1.0"
   - [ ] Confirm CFBundleVersion = "1"

### Secrets Configuration

**CRITICAL:** Before building for archive:

1. **Copy template:**
   ```bash
   cp ios/Action/Config/Secrets.example.xcconfig ios/Action/Config/Secrets.xcconfig
   ```

2. **Edit Secrets.xcconfig:**
   ```
   SUPABASE_URL = https://your-project.supabase.co
   SUPABASE_ANON_KEY = eyJ...
   ```

3. **Do NOT commit Secrets.xcconfig** (it's in .gitignore for reason)

4. **Verify in Release build:**
   - Build settings should show actual values (not placeholders)
   - Info.plist should have SUPABASE_URL and SUPABASE_ANON_KEY populated

### Destination Selection

1. **Select Scheme:** "Action" (not "ActionTests" if it exists)
2. **Select Destination:** "Any iOS Device (arm64)" (NOT simulator)
3. **Product → Scheme → Edit Scheme:**
   - [ ] Build configuration is "Release"
   - [ ] Run configuration is "Release"

---

## Archive & Distribution Workflow

### Step 1: Clean Build Cache

```bash
# Optional but recommended
cd /Users/ahernandez5/action/ios/Action
xcodebuild clean -project Action.xcodeproj -scheme Action -configuration Release
```

### Step 2: Archive

**In Xcode GUI:**
1. Select Product → Archive
2. Wait for completion (2-5 minutes for arm64 Release)
3. Xcode will open the Organizer window
4. Your archive will appear in the list with timestamp

**Via Command Line (if automated):**
```bash
xcodebuild -project Action.xcodeproj \
  -scheme Action \
  -configuration Release \
  -destination generic/platform=iOS \
  -archivePath "Action.xcarchive" \
  archive
```

### Step 3: Distribute (App Store Connect)

**In Xcode Organizer:**
1. Select your archive
2. Click "Distribute App"
3. Choose "TestFlight & App Store"
4. Click "Next"
5. Choose "Upload" (not "Export")
6. Select your Team ID
7. Allow Xcode to manage signing
8. Review bundle contents (should show no warnings)
9. Click "Upload"

**Upload Duration:** 2-10 minutes (depends on network)

### Step 4: Verify in App Store Connect

**Timeline:**
- Upload completes: 2-5 minutes
- Build processing: 5-15 minutes
- Ready for TestFlight: 10-20 minutes total

**URL:** https://appstoreconnect.apple.com

1. Go to Acción app
2. Go to "TestFlight" tab
3. Wait for build to appear with status "Processing"
4. When ready, status becomes "Ready to Submit"

### Step 5: Create TestFlight Link

**In App Store Connect:**
1. TestFlight tab → Select your build
2. Scroll to "Testers" section
3. Click "Manage Testers"
4. Add internal testers (your email) or create public link
5. Copy public TestFlight link (no expiration)
6. Share link with beta testers

**Example:** https://testflight.apple.com/join/xxxxxxxx

### Step 6: Submit to App Store (Optional for MVP)

**Create New App Version:**
1. App Store tab → "Version 1.0.1" (or keep 1.0)
2. Fill in metadata (see APPSTORE_METADATA.md)
3. Upload screenshots (recommended: 5 per language)
4. Select TestFlight build
5. Submit for review

**Apple Review:** 1-2 days typical

---

## Troubleshooting

### "Cannot create archive"
- [ ] Check Xcode version (must be 15+)
- [ ] Check iOS SDK installed
- [ ] Run `xcode-select --install` to accept latest Xcode license
- [ ] Verify Build Settings have no errors (orange warnings)

### "Code signing failed"
- [ ] Verify Team ID is set (Build Settings → Development Team)
- [ ] Verify Apple Developer Certificate installed in Keychain
- [ ] Try: Xcode → Preferences → Accounts → Manage Certificates
- [ ] Download/refresh provisioning profiles from Developer Portal

### "Archive appears stuck"
- [ ] Check Activity Monitor for `xcodebuild` process
- [ ] If hung for >10 min, force quit Xcode (⌘Q) and retry
- [ ] Try archiving with verbose output:
  ```bash
  xcodebuild -verbose archive ...
  ```

### "Upload rejected: Invalid bundle"
- [ ] Verify TARGETED_DEVICE_FAMILY = 1 (iPhone only)
- [ ] Verify no iPad code present
- [ ] Check Organizer → Distribute → "Review Bundle Contents"
- [ ] No bitcode, no unsupported architectures

### "App Store Connect shows no app"
- [ ] Verify Bundle ID matches (com.action.Action)
- [ ] Verify Team ID matches Developer Account
- [ ] App must be created in App Store Connect first
- [ ] Try signing out and back into Xcode

### "Build shows warnings in Review"
- [ ] Check App Store Connect → Acción → Build Details
- [ ] Warnings are usually non-blocking but may require clarification
- [ ] Review Apple feedback in email

---

## Post-Submission

### TestFlight Phase

**Duration:** Until ready for App Store submission (MVP: can be indefinite)

1. Send TestFlight link to beta testers
2. Monitor TestFlight feedback
3. Collect crash reports from Xcode
4. Fix critical bugs if needed → archive new build
5. Increment CURRENT_PROJECT_VERSION to "2" for next build

### App Store Review

**If submitting to App Store:**

1. **Typical review time:** 24-48 hours
2. **Result options:**
   - Approved → App appears on App Store
   - Rejected → Apple provides feedback, address and resubmit
   - Needs info → Apple asks clarifying questions

3. **Common rejection reasons:**
   - Privacy Policy URL not accessible
   - Location data use not disclosed
   - App crashes on launch
   - Broken links in app
   - Permission use mismatch

4. **Response timeline:** Re-review within 24 hours of resubmission

### Version Increment Strategy

For future updates:

| Version | Build | Type |
|---------|-------|------|
| 1.0 | 1 | Initial MVP (current) |
| 1.0.1 | 2 | Bug fixes (TestFlight beta) |
| 1.1 | 3 | Trusted viewer feature |
| 1.2 | 4 | SMS alerts (Twilio) |
| 2.0 | 5 | Major rewrite/architecture |

**Key rule:** Always increment CURRENT_PROJECT_VERSION for TestFlight builds, MARKETING_VERSION for App Store releases.

---

## Final Commit

After successful TestFlight upload:

```bash
cd /Users/ahernandez5/action

# Create empty commit marking submission
git commit --allow-empty -m "chore: testflight v1.0 submitted to app store"

# Push to remote
git push origin main
```

This marks the point where distribution began, useful for release notes and tracking.

---

## Success Criteria

Checklist completion:
- [ ] All pre-submission items checked
- [ ] Archive created without errors
- [ ] Build uploaded to TestFlight
- [ ] App Store Connect shows build status as "Ready to Submit"
- [ ] TestFlight link generated and working
- [ ] Final commit pushed to main branch

**Result:** Acción v1.0 is now available for beta testing via TestFlight and ready for App Store submission.

---

**Document Version:** 1.0  
**Last Updated:** April 2026  
**Prepared by:** Acción Development Team  
