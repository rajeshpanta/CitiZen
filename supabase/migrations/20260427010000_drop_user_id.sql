-- Migrate whisper_usage from user-based (uuid) to device-based (text) keying.
-- Run this once if you applied the original 20260427000000 migration before
-- the auth simplification. Safe to run on a fresh DB too — it's all guarded.

drop function if exists public.whisper_rate_limit_ok(uuid, integer);

alter table if exists public.whisper_usage
    drop column if exists user_id;

alter table if exists public.whisper_usage
    add column if not exists client_id text;

-- Backfill any rows that lost their user_id (none expected at this point).
update public.whisper_usage
   set client_id = 'legacy:' || id::text
 where client_id is null;

alter table public.whisper_usage
    alter column client_id set not null;

drop index if exists public.whisper_usage_user_recent_idx;
create index if not exists whisper_usage_client_recent_idx
    on public.whisper_usage (client_id, created_at desc);

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
