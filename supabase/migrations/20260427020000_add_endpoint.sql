-- Tag each row with which API endpoint produced it. Lets us split TTS vs STT
-- usage in dashboards while keeping a shared per-device rate limit.

alter table if exists public.whisper_usage
    add column if not exists endpoint text not null default 'whisper';

create index if not exists whisper_usage_endpoint_idx
    on public.whisper_usage (endpoint, created_at desc);
