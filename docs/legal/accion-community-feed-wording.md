# Acción — Community Safety Feed Wording & Design Language

> Feed this entire file to Claude Code when building the community safety feed feature. Every string, label, button, and map pin must follow this language framework exactly.

---

## The Core Principle

**We never track officers. We never report on individuals.**
**We are neighbors telling neighbors how safe they feel.**

Every single word in this feature must reflect that distinction.
This is not semantic preference — it is the legal firewall that keeps the app live.

---

## What The Feature Is (Internal Definition)

The community safety feed is a **neighborhood sentiment tool** — like a real-time mood ring for how safe people feel in an area. Think of it as:

- Waze's "I feel unsafe here" — not "cop spotted"
- Nextdoor's safety posts — not a law enforcement tracker
- A digital neighborhood watch — not surveillance

Users share **how they feel** in an area. Not what they see. Not who they see.

---

## Feed Post Submission — UI Copy

### Prompt Text (What user sees when creating a post)
```
How do you feel about safety in your area right now?
```

### Response Options (Radio buttons — pick one)
```
😰  I feel unsafe right now
⚠️  Something feels off nearby  
👀  Heads up — stay alert in this area
✅  All clear here
```

**Do NOT use:**
- "ICE spotted"
- "Law enforcement in area"
- "Checkpoint nearby"
- "Raid reported"
- "Agents seen"
- Any language referencing specific individuals or agencies

---

### Add a Note (Optional text field)
```
Add details (optional)
```

**Placeholder text:**
```
e.g. "Unusual activity on my block" or "Feels tense near the park"
```

**Character limit:** 100 characters

**Content moderation note for Claude Code:**
Block any submission containing the following strings (case-insensitive):
- "ICE"
- "immigration officer"
- "border patrol"  
- "federal agent"
- "checkpoint"
- Any badge numbers or officer descriptions

Replace with an error message:
```
Please describe how you feel about safety conditions — 
not specific individuals or agencies.
```

---

### Submission Confirmation
```
Your safety update has been shared with your neighborhood.
It will expire in 2 hours.
```

**Spanish:**
```
Tu actualización de seguridad fue compartida con tu vecindario.
Expirará en 2 horas.
```

---

## Feed Display — How Posts Appear

### Post Card Format
```
[Emoji icon]  [Sentiment label]
[Neighborhood name] · [X minutes ago]
[Optional note if provided]
[Report / Flag button]
```

### Example Post Cards (Use these as design reference)

**Unsafe:**
```
😰  Neighbors feeling unsafe nearby
Boyle Heights · 12 min ago
"Unusual activity near the corner store"
```

**Alert:**
```
⚠️  Stay alert in this area  
East LA · 34 min ago
```

**All clear:**
```
✅  Neighbors feel safe here
Lincoln Heights · 5 min ago
"All quiet this morning"
```

---

## Map Pin Labels

### Pin Colors and Labels

| Sentiment | Pin Color | Pin Label |
|---|---|---|
| Unsafe | Red (pulsing) | "Unsafe conditions reported" |
| Heads up | Orange | "Stay alert" |
| All clear | Green | "Neighbors feel safe" |

### Map Pin Tap — Detail Sheet
```
[N] neighbors shared safety updates in this area
Most recent: [X] minutes ago

[View updates] [Share your status]
```

---

## Feed Empty State
```
No safety updates in your area yet.

Be the first to let your neighbors know how things feel.
```

**Spanish:**
```
Aún no hay actualizaciones de seguridad en tu área.

Sé el primero en avisar a tus vecinos cómo se siente el ambiente.
```

---

## Feed Header / Section Title
```
How neighbors feel nearby
```

**Never use:**
- "ICE activity"
- "Law enforcement reports"  
- "Immigration alerts"
- "Enforcement tracker"

---

## Disclaimer (Always visible in feed)
```
Reports reflect how community members personally feel about 
safety conditions. Not verified. Not affiliated with any 
government agency.
```

**Spanish:**
```
Los reportes reflejan cómo se sienten los miembros de la 
comunidad. No están verificados ni afiliados con ninguna 
agencia gubernamental.
```

---

## Reporting / Flagging Inappropriate Posts

### Flag Button Label
```
This seems inaccurate
```

### Flag Confirmation
```
Thanks for flagging. We'll review this post.
Posts that identify specific individuals will be removed.
```

### Auto-Removal Message (shown to poster if removed)
```
Your post was removed. Safety updates should describe 
conditions — not specific people or agencies.
```

---

## Push Notification Copy (Future Feature)

### Alert Near User's Home Area
```
Acción: Neighbors near [Neighborhood] are sharing safety updates.
```

### All Clear Near User's Home Area  
```
Acción: Your neighbors say things feel safe nearby right now.
```

**Never send notifications that say:**
- "ICE reported near you"
- "Enforcement activity detected"
- "Agents in your area"

---

## Notes for Claude Code

- Feed posts expire after 2 hours — hard delete from Supabase, not soft delete
- Posts are anonymous — no user ID attached to public display, only to moderation backend
- Location granularity: neighborhood level only (not street address or exact coordinates)
- All post submissions go through keyword filter before saving to database
- Keyword filter list should be stored server-side (Supabase Edge Function) so it can be updated without app release
- Map clustering: group pins within 0.5 mile radius to avoid precise location inference
- Implement rate limiting: max 3 posts per user per hour to prevent spam
- "All clear" posts should visually outweigh negative posts to avoid creating panic loops
