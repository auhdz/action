-- Acción MVP: trusted contacts, viewer tokens, and enhanced location pings.
-- Run in Supabase SQL editor or via CLI after running 001_location_pings.sql.

-- ============================================================================
-- 1. Enhance location_pings table with ping_type
-- ============================================================================

alter table public.location_pings
add column ping_type text not null default 'normal';

alter table public.location_pings
add constraint location_pings_ping_type_check
check (ping_type in ('normal', 'alert'));

create index if not exists location_pings_ping_type_idx
    on public.location_pings (ping_type);

-- ============================================================================
-- 2. Create trusted_contacts table
-- ============================================================================

create table if not exists public.trusted_contacts (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references auth.users (id) on delete cascade,
    name text not null,
    phone_number text not null,
    created_at timestamptz not null default now()
);

create index if not exists trusted_contacts_user_id_idx
    on public.trusted_contacts (user_id);

alter table public.trusted_contacts enable row level security;

-- trusted_contacts RLS: users can only read/write their own rows
create policy "Users select own trusted_contacts"
    on public.trusted_contacts
    for select
    to authenticated
    using (auth.uid() = user_id);

create policy "Users insert own trusted_contacts"
    on public.trusted_contacts
    for insert
    to authenticated
    with check (auth.uid() = user_id);

create policy "Users update own trusted_contacts"
    on public.trusted_contacts
    for update
    to authenticated
    using (auth.uid() = user_id)
    with check (auth.uid() = user_id);

create policy "Users delete own trusted_contacts"
    on public.trusted_contacts
    for delete
    to authenticated
    using (auth.uid() = user_id);

-- ============================================================================
-- 3. Create viewer_tokens table
-- ============================================================================

create table if not exists public.viewer_tokens (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references auth.users (id) on delete cascade,
    token text not null unique,
    created_at timestamptz not null default now()
);

create index if not exists viewer_tokens_token_user_id_idx
    on public.viewer_tokens (token, user_id);

alter table public.viewer_tokens enable row level security;

-- viewer_tokens RLS: public can read by token, users can write own rows
create policy "Public read viewer_tokens by token"
    on public.viewer_tokens
    for select
    to public
    using (true);

create policy "Users insert own viewer_tokens"
    on public.viewer_tokens
    for insert
    to authenticated
    with check (auth.uid() = user_id);

create policy "Users delete own viewer_tokens"
    on public.viewer_tokens
    for delete
    to authenticated
    using (auth.uid() = user_id);

-- ============================================================================
-- 4. Helper function: is_valid_viewer_token
-- ============================================================================

create or replace function public.is_valid_viewer_token(p_user_id uuid, p_token text)
returns boolean as $$
begin
    return exists(
        select 1
        from public.viewer_tokens
        where user_id = p_user_id
          and token = p_token
    );
end;
$$ language plpgsql stable;

-- ============================================================================
-- 5. Add viewer token policy to location_pings
-- ============================================================================

create policy "Public read location_pings via valid viewer token"
    on public.location_pings
    for select
    to public
    using (
        exists (
            select 1
            from public.viewer_tokens vt
            where vt.user_id = location_pings.user_id
              and vt.token = current_setting('app.viewer_token', true)::text
        )
    );
