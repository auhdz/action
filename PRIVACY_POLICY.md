# Acción Privacy Policy

**Effective Date:** April 2026

## Introduction

Acción ("App", "we", "us", "our") is committed to protecting your privacy. This Privacy Policy explains our data practices and how we collect, use, and share information when you use our mobile application.

## Information We Collect

### Location Data

**Real-Time GPS Location:** When you grant permission, Acción collects your precise GPS coordinates (latitude, longitude, and accuracy) from your device's location services.

- Collection Method: CoreLocation framework (iOS native)
- Frequency: Continuous while the app is active
- Minimum Resolution: Within 10 meters of your actual location
- Permission: iOS "When In Use" (requires explicit user consent)

### Contact Data

**Emergency Contacts:** If you add trusted contacts, the app stores their names, phone numbers, and email addresses locally on your device.

- Storage: Local device storage only (not transmitted by default)
- Purpose: For emergency SOS notifications
- User Control: You can add/remove contacts at any time

### Supabase Backend Data

When you use the location sharing feature, the following data is transmitted to our Supabase backend:

- Your anonymous user ID (UUID generated on first launch)
- GPS coordinates (latitude, longitude)
- Location accuracy (in meters)
- Timestamp of location update
- Ping type (normal or alert)

**Note:** No personal identifiers (name, phone, email) are sent to the backend unless explicitly shared through emergency features.

### Device Identifiers

- Unique anonymous user ID (generated locally, never linked to Apple ID or personal information)
- iOS version (for debugging crashes)

### Crash Reports

If the app crashes, we may collect:
- Stack traces
- Device information
- App version
- iOS version

This is handled by Apple's crash reporting system.

## How We Use Your Information

1. **Location Display:** To show your current location on the map widget
2. **Location History:** To track your movement history for future "trusted viewer" features
3. **Emergency Alerts:** To notify trusted contacts during SOS activation
4. **Service Improvement:** To identify bugs, optimize performance, and improve features
5. **Analytics:** To understand app usage patterns (anonymized only)
6. **Legal Compliance:** To comply with applicable laws and legal processes

## Data Retention

- **Real-Time Location:** Displayed locally on your device only; backend retention configurable
- **Emergency Contacts:** Retained locally until you delete them
- **Location History:** Retained in Supabase according to your privacy settings (default: unlimited unless you configure retention policies)
- **Crash Reports:** Retained by Apple for 30 days

## Data Sharing

We **do not sell or share your personal location data** with third parties, except in these cases:

1. **Trusted Contacts (Future):** When you explicitly share your location with someone (not yet implemented in MVP)
2. **Law Enforcement:** Only if legally required (subpoena, court order)
3. **Service Providers:** Supabase (our data processor) for backend hosting
4. **Account Deletion:** Your data is deleted if you request it

### Supabase Data Processing

Supabase is our backend provider and data processor:
- Location data is stored in PostgreSQL (EU region by default)
- Supabase applies encryption at rest and in transit
- Supabase has a Data Processing Agreement compliant with GDPR
- Supabase location: https://supabase.com/privacy

## Your Privacy Rights

Under GDPR, CCPA, and other privacy laws, you have the right to:

- **Access:** Request a copy of all data we hold about you
- **Rectification:** Correct inaccurate information
- **Deletion:** Request permanent deletion of your account and location history (right to be forgotten)
- **Portability:** Export your data in a standard format
- **Objection:** Opt-out of certain data uses

To exercise these rights, contact us at **privacy@accion.app**.

## Location Permission Transparency

The app displays what iOS permission level you've granted:
- **"Never":** App cannot access location (nothing sent to Supabase)
- **"While Using":** Location shared only when app is active
- **"Always":** Location shared continuously (not implemented in MVP)

You can change location permission anytime in iOS Settings → Privacy → Location Services.

## Security

We implement:
- HTTPS/TLS encryption for all data in transit
- Anonymous authentication (no passwords, email, or API keys stored locally)
- Row-Level Security (RLS) in the backend database (users can only access their own location data)
- No third-party analytics or tracking cookies
- Local device storage is encrypted by iOS

**However:** No transmission over the internet is 100% secure. We cannot guarantee absolute security, and use is at your own risk.

## Children's Privacy

Acción is not intended for children under 13. We do not knowingly collect personal information from children. If we learn that a child under 13 has provided information, we will delete it immediately.

## Changes to This Policy

We may update this Privacy Policy at any time. Changes will be effective immediately upon posting, with an updated "Effective Date" above. Continued use of the app constitutes acceptance of the updated policy.

## Contact Us

For privacy questions, requests, or to exercise your rights:

**Email:** privacy@accion.app

## GDPR Compliance (EU Users)

**Legal Basis:** Your location data is processed based on your explicit consent (iOS permission). You can withdraw consent anytime in iOS Settings.

If you have a privacy complaint, you have the right to lodge a complaint with your national data protection authority.

## California Privacy Rights (CCPA)

California residents have the right to:
- Know what personal information is collected
- Delete personal information
- Opt-out of the "sale" of personal information (we do not sell data)

To request access or deletion, contact privacy@accion.app.

## Additional Disclosures

### Third-Party Services

| Service | Purpose | Privacy Policy |
|---------|---------|-----------------|
| Supabase | Backend database | https://supabase.com/privacy |
| Apple Maps | Map display | https://www.apple.com/privacy/maps/ |

---

**Last Updated:** April 2026

*Acción is a community safety app built with privacy-first principles. We believe location data belongs to you, not us.*
