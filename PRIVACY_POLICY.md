# Privacy Policy

**Last Updated:** April 22, 2026

## Overview

Acción is a personal security app designed to protect your safety by sharing your location with trusted contacts. We are deeply committed to protecting your privacy and being transparent about how we handle your data.

## Information We Collect

### Location Data
- **Real-time GPS location:** Your latitude, longitude, and accuracy measurements as you use the app
- **Location history:** Each location ping is timestamped and stored in our database
- **Trigger events:** When you activate the emergency button, we record the alert and your location at that moment

### Contact Information
- **Phone numbers:** Only the phone numbers of your trusted emergency contacts that you explicitly add
- **Contact names:** The names you assign to your trusted contacts

### Device Information
- **Device identifier:** A unique anonymous session ID for your device (no device name or IDFA)
- **App version:** The version of Acción you are running
- **Basic usage logs:** Which features you interact with (onboarding steps, emergency button presses)

### Authentication Data
- **Anonymous user ID:** A unique identifier generated on first launch to identify your data in our system
- **No email or password:** We never collect personal identifiers like email addresses or passwords

## How We Use Your Information

### Location Data
- **Real-time sharing:** To display your location to trusted contacts you've authorized
- **Emergency alerting:** To send your coordinates to emergency contacts when you activate the alert button
- **Viewer links:** To allow you to generate and share a private link that shows your current location to authorized viewers
- **Service improvement:** To analyze usage patterns and improve the reliability of the app (anonymized)

### Contact Information
- **Emergency notifications:** To send SMS alerts to your trusted contacts when you press the emergency button
- **Your control:** You can edit or delete contacts at any time

### Device Information
- **App stability:** To diagnose crashes and improve app performance
- **Feature analytics:** To understand which features are most useful

## Data Retention

- **Location pings:** Stored indefinitely in your account (you can request deletion at any time)
- **Trusted contacts:** Stored until you delete them
- **Viewer tokens:** Generated on-demand and never shared; you can revoke access at any time
- **Anonymous user ID:** Tied to your device; clearing app data will generate a new ID on next launch

## Data Storage & Security

- **Supabase backend:** All data is stored on Supabase servers encrypted at rest and in transit (TLS 1.3+)
- **Database security:** Your location data is protected by row-level security (RLS) policies — only you and your authorized viewers can see your location
- **No third-party data brokers:** We never sell or share your location data with advertisers or data brokers
- **Viewer tokens:** Treated as opaque cryptographic credentials, never exposed in browser history or logs

## Anonymous Authentication

Acción uses **anonymous authentication** by default:
- No email signup required
- No password to remember
- Your anonymous session is tied to your device
- If you uninstall the app, a new session is created on reinstall

## Viewer Links

When you generate a viewer link to share with someone:
- The link contains a secure token that grants temporary access to your location
- You control who receives this link and can revoke access at any time
- The recipient cannot see your contact information or trusted contacts
- The recipient only sees your real-time location

## Your Rights

You have the right to:
- **Access:** Request a copy of all location data we have collected
- **Delete:** Request permanent deletion of your account and all associated data
- **Withdraw consent:** Deny location permission at any time via iOS Settings
- **Revoke access:** Delete trusted contacts or revoke viewer tokens to stop sharing

To exercise these rights, contact us at taquestudios@gmail.com.

## Changes to This Policy

We may update this privacy policy as we add features or improve our services. We will notify you of material changes via the app. Continued use of Acción constitutes acceptance of the updated policy.

## Contact Us

If you have questions about this privacy policy or how we handle your data, please contact us at:

**Email:** taquestudios@gmail.com

---

## Summary

**What we collect:** Location, trusted contact phone numbers, anonymous session ID, minimal device info.

**Why:** To enable real-time location sharing and emergency alerts to people you trust.

**How it's protected:** Encrypted storage, row-level security, anonymous authentication, no third-party sharing.

**Your control:** You control who sees your location, can revoke access anytime, and can request deletion.

Acción respects your privacy. Your safety, autonomy, and security come first.
