// Supabase Edge Function: tts
//
// Receives a text string from the iOS app, rate-limits by per-install device
// id (shares the limit with /transcribe), proxies to OpenAI's text-to-speech
// endpoint, and returns the resulting MP3 bytes.
//
// Deploy:  supabase functions deploy tts
// Secrets: supabase secrets set OPENAI_API_KEY=sk-...   (already set for Whisper)
//
// The iOS client caches the MP3 by content hash, so each unique question is
// charged exactly once per device. Server-side caching is a future
// optimization — the per-question text repeats across all users, so we could
// cut cost ~99% by caching in Supabase Storage.

// deno-lint-ignore-file no-explicit-any
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";

const OPENAI_API_KEY = Deno.env.get("OPENAI_API_KEY") ?? "";
const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

const MAX_TEXT_LEN = 1_000;                    // hard char cap per request
const RATE_LIMIT_PER_HOUR = 120;               // shared with /transcribe via the same RPC
const TTS_MODEL = "tts-1";
const ALLOWED_VOICES = new Set([
  "nova", "alloy", "echo", "fable", "onyx", "shimmer",
]);
const DEFAULT_VOICE = "nova";
const TTS_TIMEOUT_MS = 30_000;

const corsHeaders: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-device-id",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function jsonError(status: number, body: Record<string, unknown>): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "content-type": "application/json" },
  });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  if (req.method !== "POST") {
    return jsonError(405, { error: "method_not_allowed" });
  }
  if (!OPENAI_API_KEY) {
    return jsonError(500, { error: "server_misconfigured" });
  }

  // ── Identify caller ─────────────────────────────────────────────────────
  const deviceHeader = (req.headers.get("x-device-id") ?? "").trim();
  const fwd = req.headers.get("x-forwarded-for") ?? "";
  const ip = fwd.split(",")[0].trim() || "unknown";
  const clientId = deviceHeader || `ip:${ip}`;
  if (clientId.length > 128) {
    return jsonError(400, { error: "invalid_client_id" });
  }

  // ── Parse body ──────────────────────────────────────────────────────────
  let body: { text?: string; voice?: string };
  try {
    body = await req.json();
  } catch {
    return jsonError(400, { error: "invalid_json" });
  }
  const text = (body.text ?? "").trim();
  if (!text) {
    return jsonError(400, { error: "missing_text" });
  }
  if (text.length > MAX_TEXT_LEN) {
    return jsonError(413, { error: "text_too_long" });
  }
  const voice = ALLOWED_VOICES.has(body.voice ?? "")
    ? body.voice as string
    : DEFAULT_VOICE;

  // ── Rate limit (shared bucket with /transcribe) ─────────────────────────
  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const { data: rateOk, error: rateErr } = await admin.rpc(
    "whisper_rate_limit_ok",
    { p_client_id: clientId, p_limit: RATE_LIMIT_PER_HOUR },
  );
  if (rateErr) {
    console.error("rate_limit_rpc_error", rateErr);
    return jsonError(500, { error: "rate_limit_check_failed" });
  }
  if (rateOk !== true) {
    return jsonError(429, { error: "rate_limit_exceeded" });
  }

  // ── Forward to OpenAI ───────────────────────────────────────────────────
  const ctrl = new AbortController();
  const timeout = setTimeout(() => ctrl.abort(), TTS_TIMEOUT_MS);

  let openaiRes: Response;
  try {
    openaiRes = await fetch("https://api.openai.com/v1/audio/speech", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${OPENAI_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: TTS_MODEL,
        voice,
        input: text,
        response_format: "mp3",
      }),
      signal: ctrl.signal,
    });
  } catch (err: any) {
    clearTimeout(timeout);
    console.error("tts_fetch_failed", err?.message ?? err);
    return jsonError(502, { error: "upstream_unreachable" });
  }
  clearTimeout(timeout);

  if (!openaiRes.ok) {
    const detail = await openaiRes.text().catch(() => "");
    console.error("tts_upstream_error", openaiRes.status, detail);
    return jsonError(502, {
      error: "upstream_error",
      status: openaiRes.status,
    });
  }

  const audio = await openaiRes.arrayBuffer();

  // ── Log usage (best-effort) ─────────────────────────────────────────────
  admin
    .from("whisper_usage")
    .insert({
      client_id: clientId,
      audio_bytes: audio.byteLength,
      language: null,
      success: true,
      endpoint: "tts",
    })
    .then(({ error }) => {
      if (error) console.error("usage_insert_error", error);
    });

  return new Response(audio, {
    status: 200,
    headers: {
      ...corsHeaders,
      "content-type": "audio/mpeg",
      // Tell URLSession to cache; same text+voice produces the same bytes.
      "cache-control": "public, max-age=2592000, immutable",
    },
  });
});
