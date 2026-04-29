-- whisper_usage: per-request audit + rate-limit source of truth.
-- Owned by the service role used by the edge function. Clients never read or
-- write directly, so RLS is enabled with no policies (deny-by-default).

create table if not exists public.whisper_usage (
    id           bigserial primary key,
    client_id    text        not null,
    created_at   timestamptz not null default now(),
    audio_bytes  integer     not null,
    language     text,
    success      boolean     not null default true,
    endpoint     text        not null default 'whisper'
);

create index if not exists whisper_usage_client_recent_idx
    on public.whisper_usage (client_id, created_at desc);
create index if not exists whisper_usage_endpoint_idx
    on public.whisper_usage (endpoint, created_at desc);

alter table public.whisper_usage enable row level security;

-- Atomic check rate limit. Returns true if the caller is under the per-client
-- hourly cap; the edge function aborts on false.
-- SECURITY DEFINER so the service-role caller can run it; the function only
-- reads, never writes (insert is done from the edge function after success).
create or replace function public.whisper_rate_limit_ok(
    p_client_id text,
    p_limit     integer
)
returns boolean
language plpgsql
security definer
set search_path = public
as $$
declare
    recent_count integer;
begin
    if p_client_id is null or length(p_client_id) = 0 then
        return false;
    end if;

    select count(*)
      into recent_count
      from public.whisper_usage
     where client_id = p_client_id
       and created_at > now() - interval '1 hour';

    return recent_count < p_limit;
end;
$$;

revoke all on function public.whisper_rate_limit_ok(text, integer) from public;
grant execute on function public.whisper_rate_limit_ok(text, integer) to service_role;
