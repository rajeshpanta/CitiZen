-- Analytics events table for app usage telemetry.
--
-- Receives writes from the iOS app's SupabaseAnalytics backend (see
-- AnalyticsService.swift). Posts arrive at /rest/v1/analytics_events
-- via the public anon key. Reads happen in the SQL Editor using the
-- service-role key for analysis — never from the iOS client.
--
-- Column rationale:
--   device_id    — stable per-install UUID from Keychain
--                  (DeviceID.current). Anonymous, not linkable to
--                  any third party.
--   properties   — arbitrary JSONB so new events can carry new
--                  fields without an ALTER TABLE migration.
--   app_version  — "X.Y.Z (build N)" string; lets us bucket events
--                  by release for cohort analysis.
--   platform     — "ios" today; future-proof for android/web.
--   created_at   — server-side timestamp so device-clock skew can't
--                  reorder events in analysis queries.
create table public.analytics_events (
    id bigserial primary key,
    event_name text not null,
    properties jsonb,
    device_id text,
    app_version text,
    platform text,
    created_at timestamptz default now(),
    -- Shared between CitiZen and Semora (same Supabase project).
    -- Defaults to 'citizen' so CitiZen's existing AnalyticsService
    -- needs no code change; Semora explicitly sends 'semora' in its
    -- POST body to override the default.
    app_name text not null default 'citizen'
);

-- RLS: anon role can INSERT only. No SELECT/UPDATE/DELETE from the
-- public key — those operations require the service-role key.
-- This is a write-only sink from the client's perspective.
alter table public.analytics_events enable row level security;

create policy "anon insert" on public.analytics_events
    for insert to anon with check (true);

-- Most queries filter by event_name and order by recency, so a
-- composite index on (event_name, created_at desc) is the
-- right shape for the analysis workload.
create index idx_analytics_events_name_created
    on public.analytics_events (event_name, created_at desc);

-- Per-app filtering is the second most common query pattern
-- (separating CitiZen vs Semora data).
create index idx_analytics_events_app_name
    on public.analytics_events (app_name, created_at desc);
