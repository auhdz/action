# Acción — Pricing Structure & Product Roadmap

> Last updated: May 2026. Review quarterly as hardware roadmap progresses.

---

## The Core Principle

**The app is free. It will always be free for anyone who needs it.**

Revenue comes from three sources — in order of when they come online:
1. **Founding Members** — people who choose to support the mission monthly
2. **Hardware** — the wearable product line (the long game)
3. **B2B licensing** — selling to orgs that serve the community

No feature that directly protects someone's safety will ever be paywalled. If someone is being detained right now, the Emergency button works. The Know Your Rights card works. Location sharing works. All of it, free.

---

## Current Pricing (v1 — App Only)

### Free Tier — Core Safety

| Feature | Free |
|---------|------|
| Emergency SOS button | ✓ |
| 60-second cancel window | ✓ |
| Live location sharing | ✓ |
| Up to 5 trusted contacts | ✓ |
| Know Your Rights (EN + ES) | ✓ |
| Language toggle (English / Spanish) | ✓ |
| Anonymous — no account, no email | ✓ |
| Private web viewer link for contacts | ✓ |

### Founding Member — $3/month

Not a premium tier. A voluntary contribution that supports the platform and signals community investment to future funders.

**What Founding Members get:**
- Name in the app's credits (Settings → About → Founding Members)
- Early access to new features before general release
- Direct line to the founder (private Telegram or Signal group)
- Invitation to test hardware prototypes before public release
- The knowledge that they helped build something for la comunidad

**Why $3:**
- Low enough that it's not a barrier for anyone
- High enough to signal intent (not a rounding error)
- 170 people at $3 = $510 MRR — crosses the signal threshold for angels
- Scales fast: 1,000 Founding Members = $3,000 MRR, enough to self-fund growth

**How to launch it:**
- Add a "Support Acción" button in Settings → links to App Store subscription or Stripe
- Email every TestFlight beta tester personally on launch day
- Frame it as community ownership, not a product upsell

---

## Product Roadmap: Three Phases

### Phase 1 — App (Now)
**Status:** MVP built. App Store submission in progress.

The phone is the device. The SOS button, location sharing, and Know Your Rights card are the product. Free for everyone.

**Revenue target:** $500 MRR (Founding Members) within 60 days of App Store launch.

---

### Phase 2 — Hardware v1: BLE Pendant ($59–79)
**Timeline:** 12–18 months. Funded by angel round + Kickstarter.

A discrete, wearable safety device — designed to look like jewelry, not a tech gadget. Small enough to wear every day. Styled to be worn by the community, not just used by them.

**The problem it solves that the app can't:**
- Phone is in your pocket and you can't reach it
- Phone is being held by someone else
- You need to trigger SOS without being seen using your phone
- You want protection that's always on you, not just when you remember to open the app

**How it works:**
- Pairs with the Acción app on your iPhone via Bluetooth Low Energy (BLE)
- Press the button once → triggers the same SOS flow as the app (60-second countdown, sends location to contacts)
- Press twice → immediate send (no countdown)
- Range: within ~30 feet of your phone (standard BLE range)
- Battery life: 30+ days (BLE uses almost no power)
- No monthly fee — works with the free app

**Design direction: jewelry, not a gadget**
- Pendant on a chain — looks like a necklace
- Small disc or bar form factor, not a chunky tracker
- Colorways: black, gold, silver — not safety orange
- Unbranded option for discretion (no Acción logo visible)
- Designed to be worn every day, not just during risk moments

**Pricing:**
| Option | Price | Notes |
|--------|-------|-------|
| BLE Pendant | $59 | Standard colorway |
| BLE Pendant (gold) | $79 | Premium finish |
| BLE Pendant + 1 year Founding Member | $89 | Bundle |

**Why BLE first (not LTE):**
- No monthly data fee for the user
- Much simpler hardware (no SIM, no carrier contract)
- Much cheaper to manufacture (~$8–12 BOM vs. ~$35–50 for LTE)
- BLE covers most real-world scenarios — the phone is almost always nearby
- Validates hardware demand before investing in LTE complexity

**Go-to-market:**
- Kickstarter campaign as the public launch moment
- Target: $200K in pre-orders (validates demand, funds first production run)
- Community org partners sell or gift them (bulk pricing for orgs)
- Gift market — families buy them for each other

---

### Phase 3 — Hardware v2: LTE Wearable ($99–149 + $5/month)
**Timeline:** 24–36 months. Funded by seed round.

The full vision. A GPS wearable that works **without a phone**. The moment that matters most — when your phone is confiscated, dead, or too far away — this device still fires.

**The problem it solves that BLE can't:**
- Phone is confiscated entirely
- Phone is dead or out of range
- You are separated from your phone
- The one scenario where the app is useless: hardware fills it

**How it works:**
- Embedded LTE-M chip + GPS antenna — no phone required
- Press the button → directly sends GPS coordinates to Acción servers via cellular
- Trusted contacts receive the same SMS + web viewer link as the app SOS
- Works anywhere there's LTE-M coverage (nationwide, low-power cellular)
- Battery life: 7–14 days (LTE-M is significantly more power-efficient than standard LTE)
- Pairs with the app when available for enhanced features (real-time tracking display, battery status)

**Design direction: wearable jewelry**
- The pendant shape carries forward from v1
- Additional form factors: bracelet, ring (longer term)
- Premium materials: stainless steel, matte black aluminum
- Indistinguishable from regular jewelry — no visible tech branding
- Water resistant (IPX5 minimum)

**Pricing:**
| Option | Price | Recurring |
|--------|-------|-----------|
| LTE Wearable (pendant) | $129 | $5/month cellular plan |
| LTE Wearable (bracelet) | $149 | $5/month cellular plan |
| Family pack (2 devices) | $229 | $8/month (two devices) |
| Community org bulk (10+) | $89/device | $4/month/device |

**Why the $5/month data plan works:**
- LTE-M data plans for IoT devices cost ~$1–2/month wholesale at scale
- Margin on the plan funds server costs and customer support
- $5 is the psychological floor for "basically free" — below a Netflix subscription
- Founding Members get $2/month off the data plan

**Manufacturing path:**
- Partner with a Shenzhen CM (contract manufacturer) — same ones used by Tile, Oura, and similar wearables
- Target BOM: $35–50 at first production run of 1,000 units, dropping to $20–30 at 10K units
- Certifications needed: FCC (US), IC (Canada), CE (EU if expanding) — budget $40–80K for certification
- Requires a hardware engineer on team or strong contract firm (budget $75–150K for v2 hardware engineering)

---

## B2B Licensing (v2+)

**Target customers:** Immigration law firms, legal aid nonprofits, community health clinics, churches, school districts with large Latino student populations.

**What they pay for:**
- White-labeled or co-branded version of the app for their clients/members
- Dashboard showing aggregate (anonymized) safety signals from their community
- Bulk hardware pricing for device distribution to clients
- Priority support and custom SMS templates

**Pricing model:**
| Tier | Price | What's included |
|------|-------|-----------------|
| Org Basic | $200/month | Up to 100 users, co-branding |
| Org Standard | $500/month | Up to 500 users, dashboard access |
| Org Pro | $1,200/month | Unlimited users, custom SMS, priority support |
| Hardware bundle | $89/device | BLE pendant for org distribution (min 10 units) |

**Target organizations for first B2B deals:**
- CHIRLA (Los Angeles) — largest immigrant rights org in CA
- CARECEN-LA (Los Angeles) — Central American legal services
- RAICES (Texas) — large national immigration org
- Catholic Charities (multiple cities) — massive Latino community reach
- School districts: LAUSD, Houston ISD, Dallas ISD

---

## Revenue Model Summary

| Phase | Timeline | Revenue Stream | Target |
|-------|----------|---------------|--------|
| App launch | Month 0 | Founding Member $3/month | $500 MRR |
| App growth | Month 3 | 500 Founding Members | $1,500 MRR |
| Hardware v1 | Month 12 | Kickstarter + pendant sales | $60K (one-time) |
| Hardware v1 + B2B | Month 18 | Mix of all streams | $5,000 MRR |
| Hardware v2 | Month 24 | LTE devices + $5/month plans | $15,000 MRR |
| Scale | Month 36 | Full stack: app + hardware + B2B | $30,000+ MRR |

**What unlocks the seed round ($1.5–3M):**
- 5,000–10,000 MAU
- Hardware prototype in hands of 50+ testers
- $10,000+ MRR from any mix of streams
- 2–3 community org partnerships as distribution proof

---

## Unit Economics

### App (Founding Member)
- Cost to serve 1 user: ~$0.003/month (Supabase + Twilio at scale)
- Founding Member revenue: $3/month
- Margin: ~99% (software is nearly free at this scale)

### Hardware v1 (BLE Pendant)
- BOM + assembly: ~$12 (at 1,000 units)
- FCC certification amortized: ~$5/unit at 1,000 units
- Fulfillment + shipping: ~$8
- Total COGS: ~$25
- Selling price: $59–79
- Gross margin: 55–65%

### Hardware v2 (LTE Wearable)
- BOM + assembly: ~$40 (at 1,000 units), ~$22 at 10,000 units
- Cellular plan cost (wholesale): ~$1.50/device/month
- Total COGS (device): ~$55 at 1K units
- Selling price: $129–149 + $5/month
- Device gross margin: ~55% at 1K units, ~80% at 10K units
- Data plan margin: ~70%

### B2B
- Cost to serve an org: ~$50/month (engineering support + infra)
- Org Basic revenue: $200/month
- Gross margin: 75%

---

## Kickstarter Strategy (Hardware v1 Launch)

**Why Kickstarter:**
- Validates demand before manufacturing commitment (no risk)
- Raises manufacturing capital without equity dilution
- Creates press moment — "Latino safety app launches emergency jewelry"
- Builds a community of early believers before retail launch
- $200K goal = first production run of ~2,000 units at target COGS

**Campaign framing:**
- Not "a tech wearable" — "safety jewelry for la comunidad"
- Show the design first, then explain the technology
- Lead with the mission and the community, not the specs
- Campaign video: a family story, not a product demo

**Stretch goals:**
- $200K: Production run, standard colors
- $350K: Premium gold/silver finish added
- $500K: Family pack (2-device bundle) unlocked
- $750K: LTE version development begins

**Timeline:**
- Hardware prototype: Month 9–12
- Kickstarter campaign: Month 12–14
- Production: Month 15–18
- Delivery: Month 18–20
