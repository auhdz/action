# Acción — Brand Style Guide (English)

---

## Brand Colors

| Name | Hex | Use |
|------|-----|-----|
| **ACTION RED** | `#8E2A0B` | Primary brand color — SOS button, CTAs, accents |
| **SAFETY ORANGE** | `#F39A1E` | Pending/warning states, secondary accents |
| **TRUSTY YELLOW** | `#FFD166` | Highlights, future map pins |
| **TRUST NAVY** | `#0D1B2A` | Status cards, headings, dark backgrounds |
| **SAFE CREAM** | `#F7F3ED` | App background — warm, calm, not clinical white |

### Color Principles

- ACTION RED is reserved for high-signal moments: the SOS button, alert states, the KYR button, primary CTAs. Don't dilute it.
- SAFE CREAM replaces pure white as the default background. It signals calm, not emergency.
- TRUST NAVY on SAFE CREAM provides sufficient contrast (meets WCAG AA).
- Never use black (`#000000`) or pure white (`#FFFFFF`) as brand surfaces.

---

## Typography

**Primary:** Satoshi (in progress — will be added via font embed)

**Fallback (current app):** SF Pro (iOS system default)

### Type Scale

| Role | Size | Weight |
|------|------|--------|
| App title | 30pt | Semibold |
| Section heading | 24–28pt | Bold |
| Card heading | 16pt | Semibold |
| Body | 14–16pt | Regular |
| Caption / legal | 12–13pt | Regular |
| Button | 16pt | Semibold |

---

## UI Components

### Buttons

**Primary CTA (e.g., Continue, I Agree)**
- Background: ACTION RED
- Text: White, 16pt Semibold
- Height: 56pt
- Corner radius: 12pt
- Full-width

**Secondary CTA (e.g., Not Now)**
- Background: ACTION RED at 10% opacity
- Text: ACTION RED, 16pt Semibold
- Same dimensions as primary

**Destructive / SOS**
- Background: ACTION RED
- All caps label
- Long-press gesture for primary SOS trigger

### Cards

**Dark status card (You are safe)**
- Background: TRUST NAVY
- Text: White and white at 60% opacity
- Corner radius: 14pt
- Padding: 16pt

**Light info card (Know Your Rights)**
- Background: White
- Border: Black at 7% opacity, 1pt stroke
- Corner radius: 14pt
- Padding: 16pt

### Status Indicators

| State | Color |
|-------|-------|
| Active / OK | Green (system) |
| Warning / Pending | SAFETY ORANGE |
| Error / Sent alert | ACTION RED |
| Unknown | Gray (system) |

---

## Voice & Tone

**Calm and direct.** This app is used in moments of stress. Every word should reduce anxiety, not add to it.

- Say: "You are safe" — not "No incidents detected"
- Say: "Hold 3s to alert your trusted contacts" — not "Activate SOS protocol"
- Say: "Cancel alert" — not "Abort"

**Bilingual-first.** Every user-facing string exists in both English and Spanish. Spanish is not a translation — it is equally primary.

**No surveillance language.** Never use: ICE, enforcement, agents, checkpoint, illegal, undocumented in any user-visible string.

---

## Logo & Wordmark

**App name:** Acción (with accent on the ó — always)

- Never write "Accion" without the accent
- The word is the logo for now — no separate graphic mark yet
- On dark backgrounds: white wordmark
- On light backgrounds: TRUST NAVY wordmark

---

## Spacing

Base unit: **8pt**

- Component internal padding: 12–16pt
- Section gaps: 12–14pt
- Screen edge padding: 24pt
- Button bottom padding: 24–32pt

---

## What Not To Do

- Don't use pure white as the app background — use SAFE CREAM
- Don't use ACTION RED for decorative elements — reserve it for signal moments
- Don't use blue anywhere — it was the old brand, now replaced
- Don't mix tones: if a card uses TRUST NAVY, its text is white, not navy
- Don't skip the accent mark: Acción, not Accion
