# How Acción Works — Technical Explainer

> Written for non-technical audiences: investors, community org partners, press, and legal reviewers. No jargon.

---

## How Anonymity Works

When you download Acción, the app never asks for your name, email address, or phone number. Instead, it creates a random secret code — like a parking lot ticket — that belongs only to your device. That code is stored in your phone's secure storage. No one else has it.

**All your data is linked to that random code — not to you.**

Here's what the database actually contains:
```
Random code: a3f9-2b1c-...
GPS coordinates: 34.0522, -118.2437
Timestamp: 2026-04-29 14:32:00
```

No name. No email. No immigration status. No ID number. Nothing that identifies who this is.

**If law enforcement subpoenaed the database:**
They would find random codes, GPS coordinates, and phone numbers for trusted contacts. They would have no way to know which device has which random code — that information only exists on the user's physical phone. The data tells them nothing without the device.

---

## How Trusted Contacts Are Stored Without Exposing the User

During onboarding, the user enters the phone numbers of people they trust. Those phone numbers are stored in the database linked to the user's random code — not to any identity.

**What this means:**
- The system knows: "Random code a3f9 is connected to phone numbers 213-555-0100 and 323-555-0200"
- The system does NOT know: whose device has random code a3f9, or what the relationship is between these phone numbers

The trusted contacts' phone numbers are stored. The protected user's phone number is never captured.

---

## How the SOS SMS Works

When the user holds the SOS button:

1. The app looks up: "What trusted contact phone numbers are linked to my random code?"
2. The app records the current GPS location
3. A message is sent to a secure server (Supabase Edge Function)
4. The server sends an SMS to each trusted contact phone number via Twilio
5. The SMS contains a secure web link: `accion.app/watch/[token]`
6. The contact opens the link in any browser and sees the user's live location on a map

**The user's phone number is never used.** The SMS comes from Acción's Twilio number, not from the user's phone. The user is never identified in the message — only by name (which they entered during setup as a nickname or first name of their choosing).

---

## The 60-Second Cancel Window — How It Currently Works and What Needs to Change

### Current behavior (v1):
When SOS is activated:
1. An "alert" record is immediately inserted into the database
2. The database webhook fires immediately
3. Twilio sends the SMS immediately
4. The web viewer immediately shows the red alert state
5. If the user cancels within 60 seconds: a second "false alarm" SMS is sent to contacts

**This means: the trusted contacts receive the alert SMS before the cancel is possible.**

The cancel in v1 sends a follow-up message: *"Update from [Name]: They are safe. This was a false alarm."* It does NOT prevent the first SMS from being sent.

### What needs to change (v1.1 planned fix):
The correct behavior is: **wait 60 seconds before sending the SMS.** The web viewer can show alert state immediately (to help family who might already be watching), but the SMS should only send if the user does NOT cancel within 60 seconds.

**Better flow:**
1. User holds SOS button → countdown begins (60 seconds)
2. Web viewer immediately shows alert state (family watching can see it)
3. Countdown visible on screen: "Alerting contacts in 45s... 30s..."
4. If user cancels: no SMS sent, web viewer returns to normal
5. If 60 seconds pass: SMS sent to all contacts with the web viewer link

**This is a known architectural fix planned for v1.1.**

---

## How the Web Viewer Works

Each user gets a permanent private link: `accion.app/watch/[unique-token]`

This link is generated once and stored permanently. When someone opens the link:
- If the user is in normal state: blue dot on map, "All good" message
- If the user has triggered SOS: red pulsing dot, "ALERT" message, timestamp
- The page updates in real time using Supabase Realtime — no refreshing needed

**What makes it private:**
The token in the URL is a random 24-character string. There is no way to guess it or enumerate it. The only way to get the link is if the user shares it (via SMS during SOS) or gives it to someone directly.

**No account required to view it.** Family members open it in Safari, Chrome, or any browser. No download. No login.

---

## Pricing Model: Why $4/Month Is Right

### The ethical question: can we charge for a safety app?

The core safety feature (SOS button) will always be free. No one should be denied a panic button because they can't afford $4/month. But the operational reality is real:

| Cost | Monthly estimate |
|------|-----------------|
| Supabase backend (database, auth, Realtime) | $25–$100 |
| Twilio SMS (per alert sent) | ~$0.0075/SMS × estimated sends | 
| Server infrastructure | $20–$50 |
| Apple/Google developer accounts | ~$10/month amortized |

At 1,000 users, these costs are manageable. At 50,000 users, they are significant. A $4/month tier from even 5% of users covers infrastructure and enables growth.

### The freemium line:

**Free — always:**
- SOS button (up to 3 trusted contacts)
- Know Your Rights card (full feature)
- Private web viewer link
- Bilingual EN/ES toggle
- Basic TOS and privacy protections

**Familia — $4/month:**
- Up to 5 trusted contacts (expanded from 3)
- Community safety map access
- Check-in timer ("I'm heading out — alert my contacts if I don't check in by 6pm")
- Family dashboard (trusted contacts can see your status proactively, not just on SOS)
- Priority SMS delivery

### Why $4/month is the right price point:
- One Starbucks drink
- Less than Netflix
- A price the community can absorb, but a real signal of commitment
- The "Founding Member" framing during early launch creates pride of ownership
- Accelerator math: 500 paying users × $4 = $2,000 MRR. That's a real signal.

---

## Community Safety Map: v1 or v1.5?

### The density problem (original concern):
A map with no pins is worse than no map — it falsely signals "all clear."

### The solution that moves it to v1 (partnership model):
Instead of waiting for users, Acción partners with 3–5 community Instagram/social accounts before launch. These accounts become "verified contributors" — they can submit safety reports directly to Acción's map via a simple web form or API.

When the map launches with verified partner reports feeding it, the density problem is solved from day one.

**v1 map launch condition:** Sign 3 verified contributor accounts before launch.
**v1.5 fallback:** If partners aren't signed before launch, ship map in v1.5 once you have 1,000+ users in a city.

### Map feature label (critical):
- NEVER: "ICE activity," "enforcement spotted," "raid reported"
- ALWAYS: "Community safety report," "Neighbors reported unusual activity," "How neighbors feel nearby"

---

## Data the App DOES and DOES NOT Collect

| Data | Collected? | Why |
|------|-----------|-----|
| User's name | No | Never asked |
| User's email | No | Anonymous auth only |
| User's phone number | No | Never captured |
| User's immigration status | No | Never asked |
| Random device identifier | Yes | Needed to link data to device |
| GPS location | Yes, temporarily | Only during active alert |
| Trusted contact phone numbers | Yes | Needed to send SOS SMS |
| TOS acceptance timestamp | Yes | Legal requirement |
| Language preference | Yes (local only) | Stored on device, not server |

**What happens to GPS data:** Currently retained in database. Planned policy: auto-delete pings older than 30 days (v1.1 improvement).
