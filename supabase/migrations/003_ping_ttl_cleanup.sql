-- Acción: Automatic location ping TTL cleanup.
-- Prevents unbounded storage growth as users scale.
--
-- Normal pings:  deleted after 24 hours  (only needed for live tracking)
-- Alert pings:   deleted after 7 days    (brief audit window, then gone)
--
-- To run: paste this entire file into the Supabase SQL editor, then execute.
-- Requires: pg_cron extension enabled in Supabase dashboard
--   Dashboard → Database → Extensions → search "pg_cron" → enable

-- ============================================================================
-- 1. Cleanup function
-- ============================================================================

create or replace function public.cleanup_old_pings()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
    -- Normal background pings: keep 24 hours only
    delete from public.location_pings
    where ping_type = 'normal'
      and created_at < now() - interval '24 hours';

    -- Alert pings: keep 7 days, then delete
    delete from public.location_pings
    where ping_type = 'alert'
      and created_at < now() - interval '7 days';

    -- Cancel pings: keep 7 days alongside alert pings
    delete from public.location_pings
    where ping_type = 'cancel'
      and created_at < now() - interval '7 days';
end;
$$;

-- Only the service role can call this function directly
revoke all on function public.cleanup_old_pings() from public, anon, authenticated;
grant execute on function public.cleanup_old_pings() to service_role;

-- ============================================================================
-- 2. Schedule hourly execution via pg_cron
--    If pg_cron is not enabled, skip this block and use the manual approach
--    described in the comment below.
-- ============================================================================

-- Runs at the top of every hour
select cron.schedule(
    'accion-cleanup-pings',          -- job name (unique)
    '0 * * * *',                     -- cron: every hour on the hour
    'select public.cleanup_old_pings()'
);

-- ============================================================================
-- To verify the schedule was created:
--   select * from cron.job;
--
-- To run a manual cleanup right now (useful after first deploy):
--   select public.cleanup_old_pings();
--
-- To remove the schedule if needed:
--   select cron.unschedule('accion-cleanup-pings');
--
-- If pg_cron is unavailable (older Supabase projects):
-- Use Supabase Edge Functions + a cron trigger instead:
--   1. Create a new Edge Function called "cleanup-pings"
--   2. Body: await supabase.rpc('cleanup_old_pings')
--   3. In Supabase Dashboard → Edge Functions → set cron schedule: 0 * * * *
-- ============================================================================
