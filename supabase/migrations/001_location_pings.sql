-- Action: location pings for realtime-capable tracking (trusted viewers / future dashboard).
-- Run in Supabase SQL editor or via CLI after linking this project.

create table if not exists public.location_pings (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
    latitude double precision not null,
    longitude double precision not null,
    accuracy_m double precision,
    recorded_at timestamptz not null default now(),
    created_at timestamptz not null default now()
);

create index if not exists location_pings_user_id_created_at_idx
    on public.location_pings (user_id, created_at desc);

alter table public.location_pings enable row level security;

-- Writers: authenticated users may insert only their own rows (user_id defaults to auth.uid()).
create policy "Users insert own pings"
    on public.location_pings
    for insert
    to authenticated
    with check (auth.uid() = user_id);

-- Readers: users can read their own pings (tighten later if you add a "viewer" role).
create policy "Users select own pings"
    on public.location_pings
    for select
    to authenticated
    using (auth.uid() = user_id);

-- Realtime: allow authenticated clients to receive row events for their own data.
alter publication supabase_realtime add table public.location_pings;
