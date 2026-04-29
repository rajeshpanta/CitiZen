// Supabase Edge Function: match
//
// Receives a spoken transcript + the four (or up-to-six) multiple-choice
// options from the iOS app and asks gpt-4o-mini which option the user meant.
// Returns the index, or null if the answer is genuinely unrelated.
//
// Used as the fallback after AnswerMatcher.localMatch fails. Tuned to be
// generous toward ESL paraphrases — if the user shows understanding of the
// right answer, we pick that option even when the wording differs.
//
// Deploy:  supabase functions deploy match
// Secrets: OPENAI_API_KEY (already set, shared with /transcribe and /tts)

// deno-lint-ignore-file no-explicit-any
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.4";

const OPENAI_API_KEY = Deno.env.get("OPENAI_API_KEY") ?? "";
const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

const MAX_SPOKEN_LEN = 800;
const MAX_OPTIONS = 6;
const MAX_OPTION_LEN = 300;
const RATE_LIMIT_PER_HOUR = 200;        // shared bucket via whisper_rate_limit_ok
const MODEL = "gpt-4o-mini";
const OPENAI_TIMEOUT_MS = 15_000;

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

interface MatchBody {
  spoken?: string;
  options?: string[];
  question?: string;
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
  const deviceHeader = (req.headers.get("x-device-id") ?? "").trim();
  const fwd = req.headers.get("x-forwarded-for") ?? "";
  const ip = fwd.split(",")[0].trim() || "unknown";
  const clientId = deviceHeader || `ip:${ip}`;
  if (clientId.length > 128) {
    return jsonResponse(400, { error: "invalid_client_id" });
  }

  // ── Parse body ──────────────────────────────────────────────────────────
  let body: MatchBody;
  try {
    body = await req.json();
  } catch {
    return jsonResponse(400, { error: "invalid_json" });
  }
  const spoken = (body.spoken ?? "").trim();
  const question = (body.question ?? "").trim();
  const options = Array.isArray(body.options) ? body.options : [];

  if (!spoken) return jsonResponse(400, { error: "missing_spoken" });
  if (spoken.length > MAX_SPOKEN_LEN) {
    return jsonResponse(413, { error: "spoken_too_long" });
  }
  if (options.length === 0 || options.length > MAX_OPTIONS) {
    return jsonResponse(400, { error: "invalid_options" });
  }
  if (options.some((o) => typeof o !== "string" || o.length > MAX_OPTION_LEN)) {
    return jsonResponse(400, { error: "invalid_option_value" });
  }

  // ── Rate limit (shared bucket with /transcribe and /tts) ───────────────
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

  // ── Build prompt ────────────────────────────────────────────────────────
  // Generous matching prompt — the goal is to give credit for understanding,
  // not penalize wording. Mirrors how a real USCIS officer judges spoken
  // answers from non-native speakers.
  const optionLines = options
    .map((o, i) => `${i}. ${o}`)
    .join("\n");

  const systemPrompt =
    "You evaluate spoken answers from non-native English speakers preparing for the U.S. citizenship test. " +
    "Your job is to map a spoken answer to the multiple-choice option it best corresponds to.\n\n" +
    "Be generous and user-favorable:\n" +
    "- The answer does NOT need to be word-for-word. Reward understanding.\n" +
    "- Paraphrases, partial answers, synonyms, related concepts, and number words (\"twenty seven\" = \"27\") all count.\n" +
    "- Mild speech-recognition errors are common — pick the option that most plausibly matches what the speaker meant.\n" +
    "- Pick the single best option even if the match isn't perfect, as long as the speaker is clearly attempting that answer.\n" +
    "- Only return null if the spoken answer is genuinely unrelated to all options (off-topic, gibberish, \"I don't know\", or a different question entirely).\n\n" +
    "Respond with ONLY a JSON object: {\"index\": <integer 0..N-1 or null>}. No prose, no explanation.";

  const userPrompt =
    `Question: ${question}\n\nOptions:\n${optionLines}\n\nThe speaker said: "${spoken}"\n\nWhich option (0..${options.length - 1}) did they mean?`;

  // ── Call OpenAI ─────────────────────────────────────────────────────────
  const ctrl = new AbortController();
  const timeout = setTimeout(() => ctrl.abort(), OPENAI_TIMEOUT_MS);

  let openaiRes: Response;
  try {
    openaiRes = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${OPENAI_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: MODEL,
        messages: [
          { role: "system", content: systemPrompt },
          { role: "user", content: userPrompt },
        ],
        temperature: 0,
        max_tokens: 30,
        response_format: { type: "json_object" },
      }),
      signal: ctrl.signal,
    });
  } catch (err: any) {
    clearTimeout(timeout);
    console.error("openai_fetch_failed", err?.message ?? err);
    return jsonResponse(502, { error: "upstream_unreachable" });
  }
  clearTimeout(timeout);

  if (!openaiRes.ok) {
    const detail = await openaiRes.text().catch(() => "");
    console.error("openai_upstream_error", openaiRes.status, detail);
    return jsonResponse(502, {
      error: "upstream_error",
      status: openaiRes.status,
    });
  }

  let chat: any;
  try {
    chat = await openaiRes.json();
  } catch {
    return jsonResponse(502, { error: "upstream_bad_json" });
  }

  const content = chat?.choices?.[0]?.message?.content as string | undefined;
  if (!content) {
    console.error("openai_empty_content", chat);
    return jsonResponse(502, { error: "upstream_empty" });
  }

  // Parse the JSON returned by GPT. Defensive: even with response_format
  // enforced, validate the index lies in range.
  let parsed: { index: number | null };
  try {
    parsed = JSON.parse(content);
  } catch {
    console.error("gpt_response_not_json", content);
    return jsonResponse(502, { error: "upstream_invalid_json" });
  }

  let index: number | null = null;
  if (typeof parsed.index === "number" &&
      Number.isInteger(parsed.index) &&
      parsed.index >= 0 &&
      parsed.index < options.length) {
    index = parsed.index;
  }

  // ── Log usage (best-effort) ─────────────────────────────────────────────
  admin
    .from("whisper_usage")
    .insert({
      client_id: clientId,
      audio_bytes: 0,
      language: null,
      success: index !== null,
      endpoint: "match",
    })
    .then(({ error }) => {
      if (error) console.error("usage_insert_error", error);
    });

  return jsonResponse(200, { index });
});
