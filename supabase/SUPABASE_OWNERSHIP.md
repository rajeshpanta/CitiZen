# Supabase Ownership Map — READ BEFORE CHANGING ANYTHING

This Supabase project (`usglgeosqhtxbyxsugre`) is **SHARED by two separate apps**:

- **Citizen** (this repo) — whisper / voice USCIS prep app
- **Semora** — AI syllabus scanner (separate codebase)

A change to the wrong app's objects can break the other app. **Every table is also
tagged in the database via `COMMENT ON TABLE`** (visible in the Supabase dashboard
Table Editor). Before any `DROP` / `ALTER` / `DELETE` / `TRUNCATE`, confirm the
object belongs to the app you're working on.

## Tables

### 🟩 CITIZEN (this app) — safe to manage from this repo
`whisper_usage` — whisper/voice usage + rate-limit log (`client_id`-based, anonymous,
no `user_id`). RLS enabled with no client policies → written server-side only by the
`transcribe` edge function.

### 🟦 SEMORA (other app) — DO NOT TOUCH from Citizen
`tasks`, `courses`, `semesters`, `course_meetings`, `course_office_hours`,
`profiles`, `syllabus_uploads`, `parse_runs`, `gemini_call_log`, `entitlements`,
`consumed_transactions`, `receipt_validation_log`

### 🟨 SHARED — both apps write here
`analytics_events` — every row carries an **`app_name`** column (`'citizen'` | `'semora'`).
- Always **filter by `app_name`** when reading.
- **NEVER `DELETE` / `TRUNCATE` without an `app_name = 'citizen'` filter** — unscoped wipes BOTH apps' events.
- RLS: open `INSERT` for `anon` + `authenticated` (anonymous, device-based analytics).
- Indexes: `idx_analytics_events_app_name (app_name, created_at desc)`, `idx_analytics_events_name_created (event_name, created_at desc)`.

## Edge functions

### 🟩 CITIZEN (this app)
- `transcribe` — sends audio to OpenAI Whisper, returns transcript
- `tts` — fetches OpenAI text-to-speech audio for premium voice playback
- `match` — GPT-4o-mini grader for ESL paraphrase matching when the local
  Jaccard match fails

### 🟦 SEMORA (other app)
- `parse-syllabus` — Gemini-based syllabus parsing
- `validate-receipt` — StoreKit receipt validation

## Functions / triggers
- **Citizen:** `whisper_rate_limit_ok` — used by the `transcribe` edge function.
- **Semora:** `is_pro`, `current_user_is_pro`, `delete_user_account`, `handle_new_user`,
  `enforce_free_scan_limit`, `enforce_free_course_limit`, `enforce_free_semester_limit`,
  `*_assert_parent_owner` (tasks/courses/course_meetings/course_office_hours/parse_runs/syllabus_uploads),
  `parent_row_user_id` ← DO NOT modify from Citizen

## Storage buckets
- `syllabi` (private) — **SEMORA only**, per-user RLS policies. Citizen has no bucket.

## Rules to avoid cross-app accidents
1. Only `DROP`/`ALTER`/`TRUNCATE` a table whose comment names **your** app (or that's listed above under your app).
2. For shared `analytics_events`: always scope by `app_name = 'citizen'`; never bulk-delete unscoped.
3. Any new **shared** table must carry an `app_name` column.
4. Apply Citizen schema changes via **committed migrations** in `supabase/migrations/` so they're tracked (ad-hoc changes look "orphaned" to other sessions and may get cleaned up).
5. When unsure, read the table's `COMMENT` in the dashboard before changing anything.

## Client-side notes
- `AnalyticsService.swift` posts events with `Prefer: return=minimal`. Do NOT switch
  to `return=representation` — that triggers an implicit SELECT, which fails (no
  SELECT policy by design, since the table has no user_id and adding one would
  expose Semora's analytics to Citizen clients and vice versa).
- `AnalyticsService.swift` explicitly sends `app_name: "citizen"` in the payload.
  The DB column also has a default of `'citizen'`, so this is defensive belt-and-
  suspenders — keep both.

_Last verified against the live schema: 2026-06-19 (full audit: 14 tables, RLS, functions, triggers, storage, FKs)._
