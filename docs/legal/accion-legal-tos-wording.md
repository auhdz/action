# Acción — Terms of Service & Legal Wording

> Feed this entire file to Claude Code when implementing the legal screens, onboarding disclaimers, and any in-app legal copy.

---

## Ground Rules

- This document is a framework, NOT a final legal document
- Have a licensed attorney review before public launch
- Display TOS and Privacy Policy before user completes onboarding
- Require explicit checkbox acceptance — not passive "by continuing you agree"

---

## Terms of Service (In-App Display Version)

### Short Version (Display on onboarding screen — plain language)

```
Before you continue, here's what Acción is and isn't:

✓ Acción is a personal safety app that shares your location 
  with people YOU choose when YOU choose to share it.

✓ Your location is only shared when you activate a safety alert 
  or choose to share it manually.

✓ No personal information is collected or stored beyond your 
  active session.

✗ Acción does not track, monitor, or report on any other 
  individuals, including law enforcement personnel.

✗ Acción cannot guarantee your safety or the response of 
  your contacts.

✗ Acción is not a replacement for emergency services. If you 
  are in immediate physical danger, call 911 when safe to do so.

By continuing, you agree to our full Terms of Service and 
Privacy Policy.
```

---

### Full Terms of Service (Web/Legal Version)

```
ACCIÓN TERMS OF SERVICE
Action Inc. — Last Updated: [DATE]

1. ACCEPTANCE OF TERMS
By downloading or using Acción ("the App"), you agree to be 
bound by these Terms of Service ("Terms"). If you do not agree, 
do not use the App.

2. DESCRIPTION OF SERVICE
Acción is a personal safety and family communication application 
that allows users to share their GPS location with pre-selected 
trusted contacts via SMS. The App includes an SOS alert feature, 
a web-based location viewer, and an anonymous community safety 
information feed.

3. WHAT ACCIÓN IS NOT
Acción is not:
- An emergency response service
- A replacement for 911 or other emergency services
- A law enforcement monitoring or tracking tool
- A tool designed to interfere with, obstruct, or impede any 
  law enforcement activity
- A guarantee of personal safety

4. USER RESPONSIBILITIES
You agree that you will not use Acción to:
- Track, identify, monitor, or report on any individual including 
  law enforcement personnel
- Share false or misleading safety information in the community feed
- Harass, threaten, or endanger any individual
- Violate any applicable local, state, or federal law
- Attempt to obstruct lawful law enforcement activities

5. COMMUNITY SAFETY FEED
The community safety feed allows users to anonymously share 
their personal perception of safety conditions in their 
neighborhood. This feature:
- Does not identify, track, or report on specific individuals
- Does not track law enforcement personnel or activities
- Reflects subjective user-reported safety conditions only
- Is not verified or endorsed by Action Inc.

Action Inc. is not responsible for the accuracy of community 
safety reports and makes no representations about their 
reliability.

6. EMERGENCY SERVICES DISCLAIMER
ACCIÓN IS NOT AN EMERGENCY SERVICE. IN THE EVENT OF AN 
IMMEDIATE THREAT TO LIFE OR SAFETY, CONTACT EMERGENCY SERVICES 
(911) IMMEDIATELY WHEN IT IS SAFE TO DO SO. ACTION INC. IS NOT 
RESPONSIBLE FOR ANY FAILURE TO CONTACT EMERGENCY SERVICES.

7. LIMITATION OF LIABILITY
TO THE MAXIMUM EXTENT PERMITTED BY LAW, ACTION INC. SHALL NOT 
BE LIABLE FOR:
- Any failure of the App to function during an emergency
- Any failure of SMS delivery to trusted contacts
- Any harm resulting from reliance on community safety feed 
  information
- Any harm resulting from actions taken or not taken based on 
  App alerts
- Any indirect, incidental, special, or consequential damages

8. INDEMNIFICATION
You agree to indemnify and hold harmless Action Inc., its 
officers, directors, employees, and agents from any claims, 
damages, or expenses arising from your use of the App or 
violation of these Terms.

9. INTELLECTUAL PROPERTY
Acción and all associated marks, logos, and content are the 
property of Action Inc. You may not reproduce, modify, or 
distribute any part of the App without written permission.

10. TERMINATION
Action Inc. reserves the right to terminate or suspend access 
to the App at any time for violation of these Terms.

11. GOVERNING LAW
These Terms are governed by the laws of the State of Delaware, 
without regard to conflict of law principles.

12. CHANGES TO TERMS
We may update these Terms at any time. Continued use of the App 
after changes constitutes acceptance of the new Terms.

13. CONTACT
Action Inc.
legal@accion.app
```

---

## Privacy Policy (Full Version)

```
ACCIÓN PRIVACY POLICY
Action Inc. — Last Updated: [DATE]

1. INFORMATION WE COLLECT
Acción is designed to collect as little information as possible.

We collect:
- Anonymous device identifier (for authentication only)
- GPS location data (only when you activate a safety alert)
- Phone numbers of your trusted contacts (stored locally on 
  your device only)
- Anonymous community safety reports (no personal identifiers)

We do NOT collect:
- Your name
- Your email address
- Your immigration status or any identity documents
- Any biometric data
- Any financial information
- Any information about your trusted contacts beyond their 
  phone number

2. HOW WE USE YOUR INFORMATION
- Location data is used solely to share your position with your 
  trusted contacts during an active safety alert
- Location data is not stored after your alert session ends
- We do not sell, rent, or share your information with third 
  parties for marketing purposes
- We do not share your information with law enforcement unless 
  compelled by a valid court order

3. LAW ENFORCEMENT REQUESTS
Action Inc. is committed to user privacy. Because we collect 
minimal personal information and do not retain location data 
after sessions end, we have limited data to provide even if 
compelled. We will notify users of law enforcement requests 
to the extent permitted by law.

4. DATA RETENTION
- Active session location data: Deleted when alert is cancelled 
  or expires
- Anonymous community reports: Retained for 24 hours then deleted
- Device authentication token: Retained until app is deleted

5. THIRD PARTY SERVICES
We use the following third-party services:
- Supabase (database and authentication)
- Twilio (SMS delivery)

These services have their own privacy policies. We have 
configured these services to minimize data collection.

6. CHILDREN'S PRIVACY
Acción is not intended for users under 13. We do not knowingly 
collect information from children under 13.

7. YOUR RIGHTS
You may delete your account and all associated data at any time 
from within the App settings.

8. CONTACT
privacy@accion.app
```

---

## In-App Legal Copy (Specific Screens)

### Onboarding — Trusted Contacts Screen
```
The people you add here will receive your location if you 
activate a safety alert. They do not need to download any app.

Only add people you fully trust.
```

### Onboarding — Location Permission Screen
```
Acción needs your location only when you activate a safety 
alert. We never track you in the background.
```

### Community Feed — Disclaimer Banner
```
Community safety reports reflect how neighbors personally 
feel about safety conditions. They are not verified and do 
not represent any official safety assessment.
```

### SOS Confirmation Screen (3-second hold)
```
Hold to send your location to [N] trusted contacts.
You have 60 seconds to cancel.
```

### Cancel Confirmation Screen
```
Alert cancelled. Your contacts have not been notified.
You're good.
```

---

## Notes for Claude Code

- TOS and Privacy Policy must be displayed as scrollable text before onboarding completes
- Require explicit UIButton tap ("I agree") — not a passive continue
- Store acceptance timestamp locally and in Supabase with anonymous user ID
- Both documents must be accessible from Settings screen at all times
- URLs: accion.app/terms and accion.app/privacy must be live before App Store submission
- Display version number and date of TOS in Settings so users know if it changes
- If TOS updates, prompt existing users to re-accept on next app open
