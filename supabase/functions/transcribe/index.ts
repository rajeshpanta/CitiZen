// Supabase Edge Function: transcribe
//
// Receives an audio file from the iOS app, rate-limits by per-install device
// id, forwards the audio to OpenAI Whisper, and returns the transcript as
// JSON. No user authentication — the app is no-login.
//
// Deploy:  supabase functions deploy transcribe
// Secrets: supabase secrets set OPENAI_API_KEY=sk-...
//
// Supabase still requires an `Authorization: Bearer <anon-key>` header to
// route the request even with verify_jwt = false (it's just routing, not
// auth). Real abuse protection (App Attest, device check, IP throttling
// upstream) is out of scope here.

// deno-lint-ignore-file no-explicit-any
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";

const OPENAI_API_KEY = Deno.env.get("OPENAI_API_KEY") ?? "";
const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

const MAX_AUDIO_BYTES = 5 * 1024 * 1024;       // 5 MB hard cap
const RATE_LIMIT_PER_HOUR = 60;                // per-device, sliding 60 minutes
const WHISPER_MODEL = "whisper-1";
const WHISPER_TIMEOUT_MS = 30_000;

const corsHeaders: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type, x-device-id",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function jsonResponse(status: number, body: Record<string, unknown>): Response {
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
    return jsonResponse(405, { error: "method_not_allowed" });
  }

  if (!OPENAI_API_KEY) {
    return jsonResponse(500, { error: "server_misconfigured" });
  }

  // ── Identify caller ─────────────────────────────────────────────────────
  // The iOS client sends a stable per-install UUID in X-Device-Id (stored in
  // its Keychain). It's spoofable, but it's enough to stop accidental loops
  // and gives us per-install usage telemetry. Fall back to the client IP if
  // the header is missing — better than nothing for naive abuse.
  const deviceHeader = (req.headers.get("x-device-id") ?? "").trim();
  const fwd = req.headers.get("x-forwarded-for") ?? "";
  const ip = fwd.split(",")[0].trim() || "unknown";
  const clientId = deviceHeader || `ip:${ip}`;
  if (clientId.length > 128) {
    return jsonResponse(400, { error: "invalid_client_id" });
  }

  // ── Rate limit ──────────────────────────────────────────────────────────
  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const { data: rateOk, error: rateErr } = await admin.rpc(
    "whisper_rate_limit_ok",
    { p_client_id: clientId, p_limit: RATE_LIMIT_PER_HOUR },
  );
  if (rateErr) {
    console.error("rate_limit_rpc_error", rateErr);
    return jsonResponse(500, { error: "rate_limit_check_failed" });
  }
  if (rateOk !== true) {
    return jsonResponse(429, { error: "rate_limit_exceeded" });
  }

  // ── Parse multipart audio ───────────────────────────────────────────────
  let form: FormData;
  try {
    form = await req.formData();
  } catch {
    return jsonResponse(400, { error: "invalid_multipart" });
  }
  const audio = form.get("audio");
  const language = (form.get("language") as string | null) ?? null;
  if (!(audio instanceof File)) {
    return jsonResponse(400, { error: "missing_audio" });
  }
  if (audio.size === 0) {
    return jsonResponse(400, { error: "empty_audio" });
  }
  if (audio.size > MAX_AUDIO_BYTES) {
    return jsonResponse(413, { error: "audio_too_large" });
  }

  // ── Forward to OpenAI Whisper ───────────────────────────────────────────
  const openaiForm = new FormData();
  openaiForm.append("file", audio, audio.name || "audio.m4a");
  openaiForm.append("model", WHISPER_MODEL);
  openaiForm.append("response_format", "json");
  if (language && /^[a-z]{2}$/i.test(language)) {
    openaiForm.append("language", language.toLowerCase());
  }

  const ctrl = new AbortController();
  const timeout = setTimeout(() => ctrl.abort(), WHISPER_TIMEOUT_MS);

  let openaiRes: Response;
  try {
    openaiRes = await fetch("https://api.openai.com/v1/audio/transcriptions", {
      method: "POST",
      headers: { Authorization: `Bearer ${OPENAI_API_KEY}` },
      body: openaiForm,
      signal: ctrl.signal,
    });
  } catch (err: any) {
    clearTimeout(timeout);
    console.error("whisper_fetch_failed", err?.message ?? err);
    return jsonResponse(502, { error: "upstream_unreachable" });
  }
  clearTimeout(timeout);

  if (!openaiRes.ok) {
    const detail = await openaiRes.text().catch(() => "");
    console.error("whisper_upstream_error", openaiRes.status, detail);
    return jsonResponse(502, {
      error: "upstream_error",
      status: openaiRes.status,
    });
  }

  let payload: { text?: string };
  try {
    payload = await openaiRes.json();
  } catch {
    return jsonResponse(502, { error: "upstream_bad_json" });
  }

  const text = (payload.text ?? "").trim();

  // ── Log usage (best-effort, don't fail the request) ────────────────────
  admin
    .from("whisper_usage")
    .insert({
      client_id: clientId,
      audio_bytes: audio.size,
      language: language ?? null,
      success: true,
    })
    .then(({ error }) => {
      if (error) console.error("usage_insert_error", error);
    });

  return jsonResponse(200, { text });
});
