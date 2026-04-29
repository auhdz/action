# Acción — Twilio SMS Wording

> Feed this entire file to Claude Code when implementing SMS templates in the Twilio Edge Function.

---

## Ground Rules (Never Violate These)

- NEVER use the words: ICE, immigration, deportation, raid, agents, officers, enforcement, illegal, undocumented
- NEVER reference law enforcement of any kind in any SMS copy
- ALWAYS frame messages as personal safety and family communication
- ALWAYS keep messages under 160 characters where possible (one SMS segment)
- ALWAYS include the cancel/false alarm link in every alert message

---

## SMS Templates

### 1. SOS Alert — Primary Message
Sent to all trusted contacts the moment SOS is triggered.

```
[Name] needs you. They've shared their live location:
accion.app/watch/[token]

Open the link to see where they are right now.
```

**Character count:** ~97 + token length. Safe for one segment.

---

### 2. SOS Alert — Spanish Version
```
[Nombre] necesita tu ayuda. Compartieron su ubicación:
accion.app/watch/[token]

Abre el enlace para ver dónde están ahora.
```

---

### 3. False Alarm / Cancel Message
Sent if user cancels within the 60-second window.

```
Update from [Name]: They are safe. No action needed.
This was a false alarm. You can ignore the previous message.
```

**Spanish:**
```
Actualización de [Nombre]: Están bien. No se necesita acción.
Fue una falsa alarma. Puedes ignorar el mensaje anterior.
```

---

### 4. Check-In Safe Message (Future Feature)
Sent when user taps "I'm safe" after arriving somewhere.

```
[Name] has safely arrived and wanted you to know.
No action needed.
```

**Spanish:**
```
[Nombre] llegó con seguridad y quiso avisarte.
No se necesita ninguna acción.
```

---

### 5. Twilio Business Registration Description
Use this exact wording when registering your use case with Twilio.

**Business Name:** Action Inc.
**Brand Name:** Acción

**Use Case Category:** Emergency Alerts / Personal Safety

**Use Case Description (copy verbatim):**
```
Acción is a personal safety app that allows users to share their 
live GPS location with pre-selected trusted family members and 
friends during an emergency. When a user activates a safety alert, 
an SMS is sent to their saved contacts containing a secure link to 
view the user's real-time location on a web page. Users can cancel 
the alert within 60 seconds. No personal data is stored beyond the 
active session. Messages are transactional safety alerts sent only 
to contacts that the user has explicitly added to their trusted 
network. This is not a marketing or promotional service.
```

**Message Flow:** One-way outbound only. Contacts receive alerts but cannot reply through the system.

**Opt-In Method:** Users explicitly add trusted contacts during onboarding within the app. Contacts are informed they have been added as a trusted emergency contact.

---

## Words That Will Get You Rejected By Twilio

Avoid ALL of the following in any message content or registration forms:

| Banned Word/Phrase | Why |
|---|---|
| ICE | Flags as immigration enforcement content |
| Immigration | Flags as political/enforcement content |
| Deportation | Flags as political content |
| Raid | Flags as potentially inciting content |
| Law enforcement | Flags as emergency services misuse |
| 911 | Cannot imply replacement of emergency services |
| Danger (use sparingly) | Can trigger emergency protocol flags |
| Illegal | Flags as discriminatory content |

---

## Notes for Claude Code

- Implement templates as constants in the Edge Function, not hardcoded strings
- Accept `name`, `token`, and `lang` (en/es) as parameters
- Default to English, switch to Spanish if `lang === 'es'`
- Log send status but never log message content (privacy)
- Cancel message must fire immediately when user cancels — do not wait
