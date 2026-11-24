# ADR 0001: Backend stack

- **Status:** Accepted
- **Date:** 2026-11-24
- **Issue:** MYP-6 (spike)

## Context

The app needs its first backend. What we know from the domain model (`docs/domain.md`, MYP-5):

- The data is **relational**: Trainer → Program → Workout ↔ Exercise → Video, plus users and workout sessions. Workout ↔ Exercise is N–N.
- Data is **scoped by trainer**: a signed-in user sees only their trainer's content. This must be enforced on the server, not trusted to the client.
- Sign-in must support **Sign in with Apple** (required by App Store rules once any third-party sign-in exists, and the natural choice for an iOS-first app).
- One developer, iOS/Swift background, small budget.
- The app has **no third-party dependencies** today, and we want to keep it that way: the client should talk to the backend over plain HTTP with `URLSession`.

## Options compared

| | Supabase | Firebase | Vapor + Postgres | NestJS + Postgres |
|---|---|---|---|---|
| **Learning curve** | Low. SQL + a dashboard; REST API is generated from the tables. | Low to start, but NoSQL data modeling and security rules are their own skill. | Medium. Swift is familiar, but server-side Swift, Fluent ORM, deployment and auth are all new and less documented. | High. New language (TypeScript), framework, ORM and deployment. |
| **Cost** | Free tier: 2 projects, 500 MB DB, 50k MAU. Free projects pause after ~1 week idle. Pro: $25/month, no pausing. | Spark (free) is generous for Firestore. Postgres via Data Connect needs Cloud SQL (from ~$9/month) on the Blaze plan. | Hosting + managed Postgres: roughly $5–25/month (e.g. Fly.io, Railway, Render). No free managed auth. | Same as Vapor. |
| **Auth / Sign in with Apple** | Built in (Supabase Auth). Native iOS flow: send Apple's ID token to `POST /auth/v1/token?grant_type=id_token`. Works with plain `URLSession`. | Built in (Firebase Auth), but in practice used through the Firebase SDK. | Build it: verify Apple ID tokens, issue our own sessions/JWTs, refresh, account deletion. | Build it (Passport/JWT libraries help). |
| **Relational data** | Native Postgres: foreign keys, joins, constraints. Embedded relations in one GET (`select=*,workouts(*)`). | Firestore is a document store: N–N and joins mean denormalizing and duplicating data. Data Connect adds Postgres, but through GraphQL and the SDK. | Native Postgres. | Native Postgres. |
| **Trainer scoping** | Postgres Row Level Security policies using the signed-in user (`auth.uid()`), enforced by the database. | Firestore security rules. | Hand-written checks in every endpoint. | Hand-written checks (guards). |
| **Client without SDK** | Yes: REST (PostgREST) + Auth HTTP API, documented. | Possible via REST, but awkward and not the supported path; offline/realtime features need the SDK. | Yes, we design the API. | Yes, we design the API. |
| **Lock-in** | Low to medium. Data is standard Postgres (`pg_dump`); PostgREST and the auth server are open source, and the whole stack can be self-hosted. RLS policies and `auth.users` would need porting if we left. | High. Proprietary data model and rules, SDK-centric client. | Very low. | Very low. |
| **Operational work** | Low: managed DB, backups, auth, API, storage (for videos/images later). | Low. | High: servers, migrations, backups, monitoring, auth security. | High. |

Pricing is from the providers' pricing pages and 2026 guides; check them again before going to production.

## Decision

**Use Supabase** (managed Postgres + Supabase Auth + the generated REST API), called from the app with `URLSession` and **no Supabase SDK**.

Why:

1. **Fits the domain.** The MYP-5 model is relational, and Supabase is plain Postgres. The schema in MYP-10 can be written as ordinary SQL migrations.
2. **Trainer scoping in the database.** "A user only sees their trainer's content" becomes RLS policies instead of checks spread across endpoints.
3. **Least work for one developer.** Auth (including Sign in with Apple), the API, backups and file storage come with it, so the effort goes into the app.
4. **Keeps the app dependency-free.** Everything we need is reachable over HTTP; the proof of concept below does it with ~40 lines of `URLSession` code.
5. **Low lock-in.** If we outgrow it, the data and SQL move to any Postgres, and a custom API (e.g. Vapor) can replace PostgREST behind the same repository protocols in the app.

## Consequences

- **Database-shaped API.** The client talks to tables/views through PostgREST. Screens that need a specific response shape (e.g. the Programs home) will use Postgres views or RPC functions so the app doesn't stitch many calls together. MYP-9 (API contract) should define these.
- **Keys.** The app ships the project's **publishable (anon) key**. It is public by design; RLS is what protects the data. The **secret / service_role key must never be in the app** or the repo.
- **RLS is mandatory** on every table before real data goes in. A table without policies is either closed (RLS on, no policy) or fully open (RLS off) — never leave it off.
- **Free tier pauses** after about a week without requests. Fine for development; move to Pro before real users.
- **Sign in with Apple without the SDK** means we implement the native flow ourselves: `AuthenticationServices` → ID token + nonce → Supabase Auth token endpoint → store the session in the Keychain and refresh it. To be designed in the auth task.
- **No business logic on our own server for now.** If we need it later (payments, webhooks), Supabase Edge Functions or a small separate service can be added.

## Proof of concept

The app makes a real GET to Supabase with `URLSession` and no SDK:

- `mypersonalfit/Data/Sources/SupabaseWorkoutsDataSource.swift` — builds `GET {project}/rest/v1/workouts` with the `apikey` and `Authorization` headers and decodes the snake_case JSON into `Workout`.
- `mypersonalfit/Data/Repositories/ProgramsRepository.swift` — `SupabaseProgramsRepository` turns that list into the Programs home (first workout is featured, the rest are popular).
- `mypersonalfit/Data/Sources/BackendConfig.swift` — project URL and publishable key.
- `docs/poc/seed.sql` — the temporary `workouts` table and rows used by the PoC.

The PoC table mirrors today's Swift `Workout` struct so the current screen works unchanged. It is **not** the real schema: MYP-10 replaces it with the tables from `docs/domain.md`.
