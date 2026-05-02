---
name: accion-legal-compliance
description: Ensure Acción app meets all legal requirements before App Store launch. Use this skill whenever you need to: draft or review the privacy policy, create or refine Terms of Service, implement the "delete my data" CCPA/CPRA feature, validate TCPA SMS compliance, prepare emergency liability disclaimers, or audit the app for regulatory gaps before TestFlight/App Store submission. Covers five key risk areas—TCPA violations, app failure during emergency, data breach liability, CCPA/CPRA non-compliance, and immigration-specific liability—and provides checklists for pre-launch legal readiness.
---

# Acción Legal Compliance Skill

## Overview

Before Acción ships to real users, it must satisfy five key legal requirements. This skill provides the checklist, implementation guidance, and template language for each one.

**The five risk areas:**
1. **TCPA violation** (highest risk) — SMS compliance
2. **App failure during emergency** (medium risk) — liability disclaimers
3. **Data breach of phone numbers** (medium risk) — privacy controls
4. **CCPA/CPRA non-compliance** (medium risk, guaranteed before App Store) — privacy policy + delete button
5. **Immigration-specific liability** (low but real) — marketing/messaging guardrails

**What protects you most:**
- Anonymous auth (no PII = less exposure in a breach)
- RLS on every table (access control)
- 24-hour data TTL on normal pings (less data to breach)
- Strong ToS + privacy policy (required anyway)

---

## Pre-Launch Checklist

Before you submit to TestFlight or the App Store, you must complete all of these.

**Non-negotiable (App Store will reject without these):**
- [ ] **Privacy Policy** — Published on your website (`accion.app/privacy`), URL entered in App Store Connect
- [ ] **Terms of Service** — Published on your website (`accion.app/terms`), linked from app
- [ ] **Apple App Store Privacy Nutrition Labels** — Filled out in App Store Connect (separate from privacy policy URL — do not skip this)
- [ ] **Delete My Data button** — One tap in Settings calls `delete_all_user_data()` Supabase function + deletes auth user. CCPA/CPRA requires it.
- [ ] **TCPA checkbox** — Required unchecked box in contact picker onboarding step
- [ ] **SOS success/failure state** — User must be told whether SMS actually sent

**Strongly recommended before launch:**
- [ ] One-hour consultation with a privacy attorney ($500) — they will catch state-specific issues
- [ ] Written breach notification plan (internal doc)
- [ ] Audit of all marketing copy for immigration-liability language

---

## Actual Data Schema (Source of Truth)

> **Always cross-reference the skill against `docs/data-architecture.md` when schema changes.**

Our Supabase tables are:

| Table | Contains | Retention |
|-------|----------|-----------|
| `auth.users` | Anonymous UUID only — no email, no name | Until `delete_all_user_data()` is called (see note below) |
| `location_pings` | lat/lng/accuracy/timestamp/ping_type | 24h for `normal`, 7 days for `alert`/`cancel` (pg_cron TTL job) |
| `trusted_contacts` | contact name + phone number | Until user deletes or calls delete function |
| `viewer_tokens` | 48-char hex token | Until user deletes or calls delete function |

**There is no `sos_alerts` table.** SOS events are rows in `location_pings` with `ping_type = 'alert'`. Any code or policy referencing `sos_alerts` is wrong — use `location_pings` with a `ping_type` filter.

**Auth user deletion note:** The `delete_all_user_data()` function deletes rows from the 4 tables above, but the anonymous user in `auth.users` remains unless you also call a server-side admin deletion. See Section 4 for the complete implementation.

---

## 1. TCPA Violation — Highest Risk Right Now

### The Problem

When your Edge Function texts someone's trusted contact, that person **never opted in** to receive SMS from Twilio/Acción. The Telephone Consumer Protection Act has statutory damages of **$500–$1,500 per message**.

- 5 contacts per alert × 10,000 alerts = 50,000 messages = **class action territory**

### The Defense

The user chose those contacts and initiated the alert — but **you need that to be airtight in your Terms of Service.**

### Required Action: TCPA Consent Language in Onboarding

During the **trusted contacts picker** step of onboarding, add a **required unchecked checkbox** before the user can proceed. It must be unchecked by default — pre-checked checkboxes are not valid consent under TCPA.

```
☐ I confirm my trusted contacts have agreed to receive emergency
  SMS alerts from me through this app.
```

This language must appear:
- In the onboarding flow (required unchecked checkbox)
- In the Terms of Service (full liability section)
- In the Privacy Policy (under "SMS Communications")

### Implementation Checklist

- [ ] Add required **unchecked** checkbox in `ContactPickerView.swift` (SwiftUI `Toggle` defaulting to `false`)
- [ ] Cannot tap Continue without checking it
- [ ] Include exact checkbox text in Terms of Service
- [ ] Terms state that Acción is not responsible if user gave false phone numbers or contacts did not consent
- [ ] Document in privacy policy under "SMS and Twilio"

### Sample ToS Language

```
SMS Communications & User Consent

By checking the "I confirm my trusted contacts have agreed to
receive emergency SMS alerts" box during onboarding, you confirm that:

1. You have disclosed to each trusted contact that you will be
   texting their phone number via Acción and Twilio in emergency
   situations.

2. Each trusted contact has consented to receive these SMS messages.

3. You are solely responsible for obtaining this consent. Acción
   and Twilio are not responsible if a trusted contact disputes
   receipt of these messages or claims they did not consent.

4. Acción will not be liable if SMS delivery fails, is delayed,
   or is filtered as spam by the recipient's carrier.

Statutory Damages: You acknowledge that SMS is governed by the
Telephone Consumer Protection Act (TCPA), 47 U.S.C. § 227, which
carries statutory damages of $500–$1,500 per message for violations.
By using this feature, you assume full responsibility for TCPA
compliance.
```

---

## 2. App Failure During Emergency — Medium Risk

### The Problem

If someone presses EMERGENCY, the SMS fails, and something bad happens — their family could argue the app gave false confidence.

### Required Actions

#### A. Strong Disclaimer in ToS

```
Emergency Button Disclaimer & Limitation of Liability

1. No Guarantee of Delivery: The Emergency button sends SMS messages
   to your trusted contacts via Twilio. We cannot guarantee that:

   - The SMS will be delivered
   - The SMS will be delivered immediately
   - The SMS will not be filtered by carrier spam filters
   - The phone numbers in your contacts list are valid
   - Your trusted contacts will receive or read the message
   - Your location will be accurate or will be transmitted

2. No Substitute for 911: This app is designed to alert your family,
   not to replace emergency services. In an emergency, call 911.

3. No Liability: Acción will not be liable for any damages, claims,
   or injuries arising from:

   - Failed, delayed, or blocked SMS delivery
   - Inaccurate location data
   - Your failure to contact emergency services
   - Any action or inaction taken by your trusted contacts
   - Any reliance on this app as a primary safety mechanism

4. Use at Your Own Risk: You use this app entirely at your own risk.
```

#### B. In-App Success/Failure State (Required)

Show the user clearly whether SMS actually sent. The current `sosSentCard` shows a success state. You must also show failure if `insertAlertPing()` throws:

```swift
// In ContentView, after fireSOS() — surface the error state
private func fireSOS() async {
    smsPending = false
    timer?.invalidate()
    timer = nil
    do {
        try await syncService.insertAlertPing()
        // sosSentCard already shown via isSosActive && !smsPending
    } catch {
        // Show failure card instead of success card
        sosFailureMessage = error.localizedDescription
        isSosFailed = true
        isSosActive = false
    }
}
```

### Implementation Checklist

- [ ] Add emergency disclaimer to Terms of Service
- [ ] Implement failure state in ContentView (currently only success is shown)
- [ ] After SMS succeeds, show checkmark and timestamp (already done)
- [ ] If SMS fails, show error message and "Try Again" button

---

## 3. Data Breach of Phone Numbers — Medium Risk

### What You've Already Done Right

- ✓ RLS policies on every table
- ✓ Supabase encrypts at rest
- ✓ Anonymous auth (no email = less exposure)
- ✓ 24-hour TTL on location pings

### What You Still Need

- [ ] Privacy policy that discloses phone number storage
- [ ] Breach notification procedure that doesn't rely on email (you don't collect it — use in-app notification)

### Sample Privacy Policy Language

```
Data Storage & Security

Trusted Contact Phone Numbers:
- We store phone numbers you provide to alert your contacts during
  an emergency.
- These phone numbers are protected by row-level security (only you
  can access your own contacts list) and encrypted at rest by
  Supabase.

In Case of a Data Breach:
- If we discover that your data has been exposed, we will notify you
  within 60 days via in-app notification (we do not collect your email).
- We will disclose what data was breached, when it occurred, and what
  steps we are taking to secure it.
```

### Implementation Checklist

- [ ] Add data storage section to privacy policy
- [ ] Breach notification method = in-app notification (not email — you don't have it)
- [ ] Keep written breach response plan (see templates.md Section 5)

---

## 4. CCPA/CPRA Non-Compliance — Required Before App Store

### The Law

The current law is the **California Privacy Rights Act (CPRA)**, which replaced and strengthened CCPA as of January 1, 2023. The compliance steps are the same — just reference CPRA, not the older CCPA name.

Apple **requires a privacy policy URL** for App Store submission — you cannot ship without one.

### Required Action: Privacy Policy

Write a privacy policy covering:
- What data you collect (phone numbers, location, timestamps)
- Why you collect it (emergency alerts)
- How long you keep it (24h TTL for location pings, 7 days for alert pings)
- Who can access it (trusted contacts via viewer token, RLS-protected)
- How to delete it (delete button in settings)
- Contact info for privacy questions

### Required Action: Apple App Store Privacy Nutrition Labels

In App Store Connect, under your app → App Privacy, you must declare:
- **Location**: Precise location, used for app functionality, not linked to identity ✓
- **Contact Info**: None collected ✓
- **Identifiers**: User ID (anonymous), used for app functionality, not linked to identity ✓
- **Usage Data**: None ✓

This is **separate from your privacy policy URL** and must be filled out before submission.

### Required Action: Delete My Data (Complete Implementation)

The delete function must do two things: delete from all four tables AND delete the anonymous auth user. Otherwise the UUID persists in `auth.users`.

```sql
-- Migration: 004_delete_user_data_function.sql
-- Run in Supabase SQL Editor

CREATE OR REPLACE FUNCTION public.delete_all_user_data()
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  current_user_id UUID;
  deleted_pings INT := 0;
  deleted_contacts INT := 0;
  deleted_tokens INT := 0;
BEGIN
  current_user_id := auth.uid();

  IF current_user_id IS NULL THEN
    RAISE EXCEPTION 'User must be authenticated to delete data';
  END IF;

  -- Delete from location_pings (normal + alert + cancel ping_types)
  DELETE FROM public.location_pings WHERE user_id = current_user_id;
  GET DIAGNOSTICS deleted_pings = ROW_COUNT;

  -- Delete from trusted_contacts
  DELETE FROM public.trusted_contacts WHERE user_id = current_user_id;
  GET DIAGNOSTICS deleted_contacts = ROW_COUNT;

  -- Delete from viewer_tokens
  DELETE FROM public.viewer_tokens WHERE user_id = current_user_id;
  GET DIAGNOSTICS deleted_tokens = ROW_COUNT;

  -- Note: auth.users deletion must be done server-side via admin API
  -- after this function returns (see SwiftUI implementation in templates.md)

  RETURN json_build_object(
    'success', true,
    'deleted_pings', deleted_pings,
    'deleted_contacts', deleted_contacts,
    'deleted_tokens', deleted_tokens
  );
END;
$$;

GRANT EXECUTE ON FUNCTION public.delete_all_user_data() TO authenticated;
REVOKE EXECUTE ON FUNCTION public.delete_all_user_data() FROM anon;
```

After calling this RPC from the app, you must also delete the auth user server-side. The cleanest approach is a second Edge Function `delete-account` that calls `supabase.auth.admin.deleteUser(userId)` using the service role key — which must never touch the client.

### Implementation Checklist

- [ ] Write and publish privacy policy (see templates.md)
- [ ] Add privacy policy URL in App Store Connect
- [ ] Fill out Apple Privacy Nutrition Labels in App Store Connect
- [ ] Deploy `004_delete_user_data_function.sql`
- [ ] Create `delete-account` Edge Function that deletes the auth user
- [ ] Add "Delete All My Data" button in Settings — calls RPC then Edge Function
- [ ] Test: after deletion, user cannot log back in with same anonymous session
- [ ] Test: no rows remain in any table for that user_id

---

## 5. Immigration-Specific Liability — Low but Real

### Required Wording

The app must **never claim it will prevent detention or guarantee safety**.

```
What This App Does:
- Sends your location to trusted family contacts
- Alerts them immediately when you press the Emergency button
- Provides a private web link they can open to track you

What This App Does NOT Do:
- We cannot prevent detention
- We cannot guarantee your safety
- We cannot replace 911 or emergency services
- We are not a lawyer or legal service
```

### Implementation Checklist

- [ ] Remove any language claiming the app prevents or stops detention
- [ ] Remove any language guaranteeing safety
- [ ] Review App Store description for overpromising
- [ ] Add "not a substitute for 911 or legal services" to onboarding or Settings

---

## Implementation Order (Prioritized)

**Week 1 — Must-haves before any real users see the app:**
1. TCPA checkbox in `ContactPickerView` onboarding step
2. Deploy delete function (SQL migration 004)
3. Create `delete-account` Edge Function
4. Draft privacy policy from templates.md

**Week 2 — Required before App Store submission:**
5. Publish privacy policy at `accion.app/privacy`
6. Publish Terms of Service at `accion.app/terms`
7. Add Settings screen with privacy policy link, ToS link, and Delete button
8. Fill out Apple Privacy Nutrition Labels in App Store Connect
9. Add SOS failure state to ContentView

**Week 3 — Strongly recommended:**
10. One-hour privacy attorney consultation ($500) before submission
11. Audit marketing copy for immigration-liability language
12. Write and file breach notification plan

---

## FAQ

**Q: Do I need a lawyer to draft this?**
A: The templates cover Acción's specific risks. A lawyer would cost $2k–5k to draft from scratch. Invest in a one-hour review consultation ($500) after you've drafted these — they'll catch state-specific issues.

**Q: What if I'm not in California?**
A: CPRA applies to any California resident's data, regardless of where the company is. Apple requires a privacy policy regardless of state. If you have EU users, GDPR applies and is stricter — consult a lawyer before launching internationally.

**Q: Can I pre-fill the TCPA checkbox?**
A: No. It must be **unchecked by default**. Pre-checked is not valid consent under TCPA.

**Q: What if the SMS fails and I can't contact the family?**
A: Show the failure state in-app so the user knows to try another method or call 911. The limitation-of-liability language in ToS covers you for the failure itself — but only if you told the user it failed.

**Q: The privacy policy says "open-source" — should it?**
A: Only if the source code is publicly available on GitHub or similar. If it's not public, remove that claim. A false statement in a legal document is worse than omitting it.

---

## Related Resources

- **Data Architecture**: `docs/data-architecture.md` — schema and retention policy
- **CPRA**: California Privacy Rights Act (effective Jan 1, 2023 — supersedes CCPA)
- **TCPA**: 47 U.S.C. § 227
- **Apple App Store Review Guidelines**: Section 5.1 (Privacy)
- **Apple App Store Connect**: App Privacy section (Privacy Nutrition Labels)
