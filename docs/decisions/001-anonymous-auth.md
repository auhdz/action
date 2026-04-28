# ADR 001: Anonymous Supabase Auth

**Decision:** Use Supabase anonymous sign-in instead of email/password or social login.

**Why:** The app protects users who may fear government scrutiny. Requiring an email address creates a paper trail that could be subpoenaed or leaked. Anonymous auth lets the app function with zero personally identifiable information stored server-side.

**Trade-off:** Users cannot recover their account if they delete the app. Acceptable for MVP — trusted contacts can always be re-added.
