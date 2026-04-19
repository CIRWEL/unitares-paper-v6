# UNITARES Identity Collision Fix — Plan

**Status:** draft for review, no server code changes yet
**Date:** 2026-04-18
**Latest update:** revised after KG audit revealed most proposed ideas were already in flight

## The problem in one line

Fresh `onboard()` calls from stateless Claude sessions without a prior `continuity_token` collide with the canonical per-day `Claude_<date>` agent via `structured_agent_id` dedup, resulting in the freshly-minted UUID being archived within ~30 seconds before its first `process_agent_update` can succeed.

## What the KG already knows (reviewed 2026-04-18)

A prior-art search against the UNITARES knowledge graph found this problem is **already open work**, not a novel discovery. Don't reinvent:

- **`2026-04-18T03:11` (`9e052529`, status=open, medium severity)** — "Claude.ai HTTP MCP transport + mobile fingerprint instability = silent identity forking." Same class of bug; filed this morning by a different session. The failure mode I hit on stdio transport is a sibling, not a separate bug. My contribution: `2026-04-18T22:38:52.592295` extends that thread with the Claude Code stdio reproduction.

- **`2026-04-06T02:34` (`91230e69` / The-CIRWEL-Group, architectural_decision, foundational)** — "Identity design principle: resume=True is a contract — resolve to existing identity or fail explicitly, never silently create a fork." The architectural frame already exists. A parallel principle for `force_new=True` is the new claim this plan argues for.

- **`2025-12-26T21:25` (Gemini-Y, insight, open)** — "Fleet Identity Concept: Instead of shared UUIDs, use tags/metadata for grouping. Individual agents get unique UUIDs (birth). Fleet emerges from queries." This is exactly the "forked-identity architectural refactor" I was about to propose as Phase 4. It's already in the KG.

- **`2025-12-15T23:31` (opus_governance_architect, note, open)** — cryptographic api_keys as proof-of-identity. This is the "client-side nonce / secret in context" concept I was about to propose as Phase 3. Already in the KG.

- **`2025-12-23T00:53` (test_force_new, note, open)** — the `force_new` parameter was added explicitly "to fix session binding confusion." Which makes the current dedup-archive-on-force_new behavior a regression against its stated purpose.

- **`2026-04-15T21:29` (dogfood, resolved)** — 99.2% ghosts (2,615 of 2,636 identities). Current `agent(action=list)` shows 685/252/2604 out of 3289 — the problem class persists.

- **`2026-04-16T07:12` (Tessera, resolved)** — PATH 0 UUID-direct lookup replaced the token/session resolution chain for resident agents (Lumen, Sentinel, etc.). Ephemeral / fresh-onboard paths did not get the same fix.

## The narrow novel claim this plan contributes

**Principle:** `force_new=True` is also a contract. Once a UUID is minted with `force_new=True`, the server must not auto-archive it as a `structured_agent_id` duplicate of a pre-existing agent on the same day, because the caller has explicitly asked for a fresh identity.

This is parallel to the `2026-04-06` resume contract but for the opposite direction. The existing KG has the resume principle but does not (yet) have this one articulated.

## Open questions to answer before coding

Q1. What exactly archives my fresh `force_new=true` UUIDs? Candidates: `_should_rebadge_agent_id` (handlers.py:1158), an `archive_orphan_agents` cron, or `resolve_session_identity`'s own dedup path. *Server logs for one of my archived UUIDs would settle this in one grep.*

Q2. Is the dedup on `structured_agent_id`, `session_key`, or something else? The `agent(action=list)` output shows fresh dogfood-test agents with 1 update persist fine — so "1-update cleanup" is not the rule. Something about the `Claude_<date>` structured_agent_id specifically triggers archival.

Q3. Did the `test_force_new` (2025-12-23) change actually land in the current `handle_onboard_v2` path, or has it drifted since?

## Proposed plan (unchanged shape, revised scope)

### Phase 1: Diagnose (30–60 min, no code)

1. Grep server logs for one of my three archived UUIDs (`0f009240`, `aae1f95c`, `2ea032b4`) around 2026-04-18T21:47–22:03 UTC. Identify the archival trigger.
2. Read `resolve_session_identity` (services/identity_continuity.py) — does `force_new=True` bypass all dedup, or is there a latent dedup layer?
3. Read `_should_rebadge_agent_id` (handlers.py:1158) and the rebadging path.
4. Re-read the 2025-12-23 `test_force_new` commit history to confirm the behavior it documented is the behavior we have.
5. Write up the actual causal chain in 3–5 sentences and update `2026-04-18T22:38:52.592295` with resolution details.

### Phase 2: Minimal server-side fix

Root-cause-specific. Most likely shape: `force_new=True` unconditionally mints a fresh UUID AND a fresh structured_agent_id (e.g., append a short random suffix: `Claude_20260418_a7b2`), avoiding collision with the canonical daily agent. Alternative: drop the structured_agent_id dedup from the archival criterion.

**Regression test:** `test_onboard_force_new_survives_same_day_claude_collision` — two back-to-back `onboard(name=..., force_new=true)` calls from the same session on the same day, after a canonical `Claude_<date>` already exists, must both yield distinct, non-archived UUIDs that each accept a `process_agent_update` within 30 seconds of creation.

### Phase 3: Client-side nonce (DEFER)

The "secret key in context" idea is already in the KG as api_key proof-of-identity (`2025-12-15T23:31`). If Phase 2 resolves the dedup-archive, this path's original motivation is gone. If Phase 2 surfaces a deeper fingerprint-instability issue (per 9e052529's root cause), revisit. Do not build this until there's evidence Phase 2 isn't sufficient.

### Phase 4: Forked-identity refactor (DEFER to Gemini-Y thread)

Already captured as `2025-12-26T21:25` Gemini-Y (open, architectural). Not novel. If someone picks up the fleet-identity work, this plan's Phase 2 fix becomes a stopgap that can be removed once the refactor lands. Do not duplicate the proposal.

## What we will NOT do

- Not propose api_keys or fleet identity as new ideas (both already in KG).
- Not promote `identity(agent_uuid=..., resume=true)` as the onboarding pattern — it's namespace collision masquerading as continuity (user's accurate description).
- Not touch the resume-by-token or resume-by-UUID paths — they work and are covered by the 2026-04-06 contract principle.
- Not change archival cron cadence. Fix the trigger, not the timer.

## Success criteria

After Phase 2 alone:
- Two `onboard(name=..., force_new=true)` from different Claude Code sessions on the same day, each followed immediately by a `process_agent_update`, both succeed.
- Both agents appear in `agent(action=list)` as status=active after 60 seconds.
- Existing resume-by-token and resume-by-UUID flows remain green (pre-existing tests pass).

## Rollback plan

Every change lands as one commit with the regression test paired. If Phase 2's structured_agent_id change breaks downstream (e.g., the `2026-04-15T21:29` ghost-proliferation tracking queries that assume `Claude_<date>` uniqueness), `git revert` restores. The pre-existing continuity-token path is untouched.

## Estimated effort

- Phase 1 (diagnose via logs + code read): 30–60 min.
- Phase 2 (fix + regression test): 1–2 hr.
- Total: one working session. Phase 3 and 4 are deferred.
