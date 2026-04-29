# Acción — Apple App Store Submission Wording

> Feed this entire file to Claude Code when preparing App Store Connect metadata, screenshots, and review notes.

---

## Ground Rules (Never Violate These)

- NEVER mention ICE, immigration enforcement, deportation, or raids anywhere in App Store metadata
- NEVER position the app as a law enforcement tracking tool
- ALWAYS lead with personal safety and family communication
- ALWAYS frame community features as "neighbors sharing how safe they feel"
- Category must be Utilities — NOT News, NOT Social Networking

---

## App Store Metadata

### App Name
```
Acción: Family Safety
```

### Subtitle (30 characters max)
```
Keep your loved ones close
```

### Category
- **Primary:** Utilities
- **Secondary:** Lifestyle

### Age Rating
**4+** — No objectionable content. Safety alerts are text-based location sharing only.

---

### Description (4,000 characters max)

Use this exact copy:

```
Acción keeps your family connected when it matters most.

With one press of a button, Acción instantly shares your live 
location with the people you trust — no app download required 
on their end. Your loved ones open a secure link and see exactly 
where you are, in real time.

SIMPLE BY DESIGN
Acción was built for moments when you don't have time to think. 
Three steps and you're protected: add your trusted contacts, 
grant location access, and you're ready. When you need help, 
hold the button. That's it.

YOUR PEOPLE, YOUR NETWORK
Choose up to 5 trusted contacts — family members, close friends, 
anyone you rely on. When you activate a safety alert, they all 
receive a secure SMS link to your live location instantly. No app 
required on their end.

BUILT FOR PRIVACY
Acción is designed with your privacy first. No account creation 
required. No personal information collected. Your location is only 
shared when you choose to share it — and only with the people you 
trust.

BILINGUAL
Acción is fully available in English and Spanish. One tap switches 
the entire app. Built for families that speak both.

60-SECOND CANCEL
Accidentally triggered an alert? No problem. You have 60 seconds 
to cancel before your contacts are notified. Peace of mind in 
both directions.

COMMUNITY SAFETY FEED
See how neighbors in your area are feeling about safety conditions 
right now. Share your own status to help your community stay 
informed. No personal information is shared in the feed — only 
anonymous neighborhood-level safety conditions.

Acción. Your safety. Your people. Your community.
```

---

### Keywords (100 characters max, comma separated)
```
safety,emergency,location,family,alert,SOS,seguridad,familia,comunidad,panic button,safe
```

---

### Support URL
```
https://accion.app/support
```

### Marketing URL
```
https://accion.app
```

### Privacy Policy URL
```
https://accion.app/privacy
```

---

## App Review Notes

Include these notes verbatim in the "Notes for App Review" field:

```
Acción is a personal safety and family communication app. 

The core feature is an SOS button that shares the user's live GPS 
location via SMS with pre-selected trusted contacts. Contacts 
receive a link to view the location in a web browser — no app 
download required.

The secondary feature is a community safety feed where users 
anonymously share neighborhood-level safety conditions. This 
feature does not track, identify, or report on any individuals 
including law enforcement. Users share how they personally feel 
about safety in their area — similar to a neighborhood watch 
communication tool.

To test the SOS feature:
1. Complete onboarding (add a test phone number as trusted contact)
2. Hold the SOS button on the home screen for 3 seconds
3. An SMS will be sent to the test number with a live location link
4. Use the 60-second cancel window to prevent SMS if testing

No account creation is required. The app uses anonymous 
authentication. No personal data is stored beyond the active 
session.

Primary language: English. Full Spanish translation available 
via the language toggle on every screen.
```

---

## Screenshot Captions (App Store Preview Text)

### Screenshot 1 — Home Screen / SOS Button
```
One button. Your people know you're safe.
```

### Screenshot 2 — Onboarding / Add Contacts
```
Choose up to 5 people you trust completely.
```

### Screenshot 3 — Web Viewer
```
Your family sees your location. No app needed.
```

### Screenshot 4 — Community Feed
```
Know how your neighborhood feels right now.
```

### Screenshot 5 — Bilingual Toggle
```
Todo en español. One tap.
```

---

## What NOT To Include Anywhere In App Store Submission

| Never Include | Reason |
|---|---|
| ICE, immigration, deportation | Triggers App Store guideline 1.4.3 review |
| "Track law enforcement" | Immediate rejection + potential removal |
| "Raid alerts" | Same as above |
| References to undocumented status | Flags as potentially discriminatory |
| "Avoid checkpoints" | Implies facilitating illegal activity |
| Political statements of any kind | Violates App Store neutrality guidelines |

---

## App Store Guideline Compliance Notes

### Guideline 1.4.3 (Our Specific Risk)
Apple bans apps that "facilitate illegal activity or enable evasion of enforcement."
**Our defense:** Acción facilitates family communication and personal safety — not evasion of any enforcement. The community feed shares how neighbors *feel* about safety conditions, which is constitutionally protected speech equivalent to a neighborhood watch.

### Guideline 5.1 (Privacy)
We comply fully — anonymous auth, no PII collected, location shared only on user initiation.

### Guideline 4.3 (Spam)
SMS is sent only to explicitly opted-in contacts. One-way transactional only.

---

## Notes for Claude Code

- App Store screenshots must show SOS button as primary UI, community feed as secondary
- Do not show map pins labeled with any law enforcement terminology
- Community feed pins should be labeled "neighbors feel unsafe here" not "ICE spotted"
- All metadata strings above should be stored in `AppStoreMetadata.swift` or equivalent config file for easy updating
