# Supabase backend for CitiZen mock interview

This folder holds the cloud pieces for the mock-interview voice flow:

- `functions/transcribe/` — Edge Function that proxies audio to OpenAI
  Whisper. The OpenAI API key lives only here (Supabase secret), never in
  the iOS bundle.
- `migrations/` — `whisper_usage` table + `whisper_rate_limit_ok` RPC used
  by the function for per-device rate limiting.
- `config.toml` — `verify_jwt = false` because the app has no sign-in.
  Supabase still requires the anon key in the request to route it; per-device
  rate limiting happens inside the function.

Quizzes still use Apple's on-device `SFSpeechRecognizer`. Whisper is mock
interview only.

## Deploy

```bash
# 1. Install the CLI (skip if you already have it)
brew install supabase/tap/supabase

# 2. Link this folder to your Supabase project
cd /Users/smile/Desktop/CitiZen
supabase link --project-ref usglgeosqhtxbyxsugre

# 3. Apply the migrations
supabase db push

# 4. Set the OpenAI key as a function secret
supabase secrets set OPENAI_API_KEY=sk-...

# 5. Deploy the function
supabase functions deploy transcribe
```

## iOS config

Already wired into `Citizenship-Info.plist`:

```xml
<key>SUPABASE_URL</key><string>https://usglgeosqhtxbyxsugre.supabase.co</string>
<key>SUPABASE_ANON_KEY</key><string>eyJ...</string>
```

If neither is set, `MockInterviewView` falls back to the on-device
`LocalSTTService` so dev builds without backend creds still run.

## Verify

```bash
# Tail logs while you exercise the mic in the simulator
supabase functions logs transcribe --tail
```

## How requests are identified (no auth)

The iOS app generates a UUID once on first launch, stores it in the
Keychain, and sends it as `X-Device-Id` on every transcription request.
The edge function rate-limits on this. Keychain entries persist across app
deletes on iOS, so deleting and reinstalling the app reuses the same id.

This is **not** a security boundary — anyone with the Supabase URL and
anon key can hit the function. It just stops accidental loops and gives
us per-install usage telemetry. If you ever see abuse, the next step is
App Attest (verifies the request came from a real, unmodified iOS build).

## Cost guardrails

- Hard cap: 5 MB per request (rejected at the function before OpenAI sees it).
- Rate limit: 60 requests / hour / device, enforced by the RPC.
- Whisper price (Apr 2026): $0.006/minute. A 60-question interview at ~10s
  per answer is ~10 minutes total → ~$0.06 per full mock interview.

To raise the rate limit, change `RATE_LIMIT_PER_HOUR` in
`functions/transcribe/index.ts` and redeploy.
