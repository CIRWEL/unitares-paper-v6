# UNITARES v6 — Working Notes

## Status: First-pass spine drafted (2026-04-18)

Source: `unitares-v6.tex` started from a verbatim copy of v5.5 and has been reorganized around the new spine: heterogeneity + grounding lead, contraction analysis demoted to appendix. Currently 2477 lines, 10 `\todo{}` markers tracking remaining work.

## What shipped in this push (2026-04-18)

| Change | Status |
|---|---|
| Title swap → "Information-Theoretic Governance of Heterogeneous Agent Fleets" | ✅ |
| Abstract rewritten (heterogeneity + grounding lead) | ✅ |
| §1 Introduction rewritten with new 6-contribution list | ✅ |
| §1 Related Work — new Information-Theoretic Monitoring lead paragraph | ✅ |
| §2 Heterogeneous Agent Fleets (new) | ✅ |
| §3 EISV Dynamics — heavy edit, info-theoretic from start, state-space narrowed | ✅ |
| §4 Information-Theoretic Grounding (carried from v5.5) | ✅ |
| §5 Stability — replaced 120-line §Contraction with 30-line summary pointing to App B | ✅ |
| §9 Class-Conditional Calibration (new) | ✅ |
| §10 Re-Grounding a Deployed Framework (new) | ✅ |
| §13 Experiments — added §Class Composition + reframing remark on fleet aggregates | ✅ |
| §14.5 → "Why We Left Thermodynamics" — replaces apologetic disclaimer with new info-theory/FEP correspondence table | ✅ |
| §15 Conclusion rewritten | ✅ |
| App B — full theorem + proof + equilibrium proposition consolidated | ✅ |
| Bibliography — Friston 2010, Shannon 1948 added | ✅ |

## Remaining work (6 informational `\todo{}` markers, no blockers)

The 6 remaining `\todo{}` entries are all informational annotations on new sections (e.g., "v6 — drafted; empirical class-conditional values land with Phase 2 corpus appendix"). They are reviewer flags, not action items. The blocking work has been resolved:

| Item | Status |
|---|---|
| Class composition table populated from real production DB | ✅ (3286 total / 2601 real / 27 active-7d, with Lumen at 101k updates) |
| App A grounding scale-constants table with provenance column | ✅ (Table A.4 added) |
| v3/v5 self-citations | ✅ (`wang2026unitares-v3`, `wang2026unitares-v5` stubs in bibliography; replace bibitem details with arXiv IDs once posted) |
| §10.4 composite-tag-classes forward-ref to calibration appendix | Auto-resolves when Phase 2 lands |

| Section | Optional polish | Priority |
|---|---|---|
| §6 I-Channel Saturation | Light consistency pass — text still uses pre-grounded language in places | S |
| §7 Adaptive Governor / §8 Ethical Drift | Light pass — verify no thermodynamic vocabulary leaked through | S |
| §11 Stochastic Extensions / §12 Multi-Agent Network | Light pass | S |
| Production data refresh | v5 deployment table reports 903 agents from Feb 2026 snapshot; current is 3286 total / 27 active. Decide: keep v5 snapshot for consistency with experimental claims, or refresh entire experiments to April 2026 numbers. | M |

## Current section order (15 main + 3 appendices)

1. Introduction
2. Heterogeneous Agent Fleets
3. EISV Dynamics
4. Information-Theoretic Grounding
5. Stability
6. I-Channel Saturation Analysis
7. Adaptive Governor (CIRS v2)
8. Ethical Drift Vector
9. Class-Conditional Calibration
10. Re-Grounding a Deployed Framework
11. Stochastic Extensions
12. Multi-Agent Network
13. Experiments
14. Discussion
15. Conclusion

App A. Parameter Tables
App B. Proof of Contraction (Full)
App C. Saturation Diagnostics

(Originally proposed reorganizing to 12 sections; current 15 reflects the conservative choice to keep §Saturation, §Stochastic, §Network as separate sections rather than fold them. The contribution-to-section mapping is clean as-is.)

## Open design decisions still to make

- **Final title**: drafted as "Information-Theoretic Governance of Heterogeneous Agent Fleets". Alternates worth weighing: "Class-Conditional Information Geometry for Multi-Agent Governance", or "Re-Grounding Agent Governance: From Thermodynamic Metaphor to Variational Free Energy".
- **Class Composition counts**: Table 13.2 has placeholder counts for session-bounded and ephemeral; need to query the production identity DB for exact numbers.
- **Calibration appendix**: still forthcoming; Phase 2 calibration data hasn't been measured yet. v6 ships with placeholder constants and forward-promises the empirical appendix.
- **Reviewer with FEP background**: needed before arXiv submission.

## Original spine plan (preserved for context)

## Spine change vs v5

| | v5 | v6 |
|---|---|---|
| Title | "Contraction-Theoretic Governance of Autonomous Agent Thermodynamics" | "Information-Theoretic Governance of Heterogeneous Agent Fleets" |
| Headline contribution | Contraction proof (α_c = 0.02) | Class-conditional grounded EISV + migration |
| Frame | Phenomenological EISV with thermodynamic analogy | Shannon + variational free energy from §1 onward |
| Differentiator | Stability of the dynamics | Heterogeneity of the fleet |
| Contraction proof | §3 + Appendix B | Demoted to Appendix |
| §Connections to Thermodynamics | Apologetic disclaimer | Replaced — paper no longer claims thermo, claims info theory |

## Target shape (~12 sections + 3 appendices)

| Section | Source | Action | Effort |
|---|---|---|---|
| Abstract | New | Rewrite — heterogeneity + grounding lead, contraction in supporting role | M |
| 1. Introduction | v5.5 §1 | Rewrite — new contributions list, new related-work positioning | M |
| 2. Heterogeneous Agent Fleets | New | Write from scratch — the cosmic-soup argument, why class structure matters, what UNITARES actually runs (Lumen / Vigil / Sentinel / Watcher / Steward / ephemeral) | L |
| 3. Information-Theoretic Grounding | v5.5 §3 (already drafted) | Light edit — promote from "addition" to spine, remove "we previously said X" hedging | S |
| 4. Class-Conditional Calibration | New | Write from scratch — partition the corpus by tag/label, compute scale constants per class, present the per-class healthy operating points | L |
| 5. EISV Dynamics | v5.5 §2 | Heavy edit — present coordinates as info-theoretic from the start, not phenomenological-then-grounded | M |
| 6. Adaptive Governor | v5.5 §5 | Light edit — keep, refresh language | S |
| 7. Ethical Drift | v5.5 §6 | Light edit | S |
| 8. Migration Story | New | Write from scratch — dual-compute, pipeline-ordering as gating-preservation mechanism, lessons from re-grounding a deployed framework. **Distinct contribution.** | M |
| 9. Multi-Agent Network | v5.5 §8 | Light edit — extend coupling discussion to acknowledge per-class network structure | S |
| 10. Experiments | v5.5 §9 | Heavy edit — re-present the production data through the heterogeneity lens; add per-class breakdowns where data permits | L |
| 11. Discussion | v5.5 §10 | Edit — keep "Adjust Expectations Not Measurements" (§10.1) which is genuinely a UNITARES principle; rewrite §10.5 (Connections to Thermodynamics) entirely as "Why we left thermodynamics" | M |
| 12. Conclusion | v5.5 §11 | Rewrite — new framing | S |
| App A. Parameters | v5.5 App A | Light edit — add provenance column to scale constants | S |
| App B. Contraction Proof | v5.5 App B | **Move from main body** — keep proof intact, reframe intro to "Stability is preserved under the grounded coordinates" | S |
| App C. Saturation | v5.5 App C | Keep | None |
| App D. Calibration Protocol | New | Write — §3.4 measurement procedure formalized with class-conditional protocol | M |
| References | v5.5 + Friston | Add: Friston 2010 (already done in v5.5), Shannon 1948, Cover & Thomas (information theory text), maybe Kullback-Leibler 1951 | S |

**Effort estimate:** S = 1-2 hr, M = 2-4 hr, L = 4-8 hr. Total ≈ 35-50 hours of writing. One week is doable if Kenny drives the voice/intro/contributions and I scaffold + draft + iterate the technical sections.

## What's NOT moving from v5

- Most of v5's mathematical content stays — the equations, the proofs, the data. The reframing changes meaning, not arithmetic.
- 5 of 6 figures still apply (fig1-5). Fig 6 (knowledge graph discoveries) might or might not — depends on whether v6 keeps the KG section.
- Bibliography keeps almost entirely; add a few info-theory + FEP references.

## What the new contribution list looks like

v5 lists six contributions: EISV dynamics, contraction analysis, saturation resolution, adaptive governor, ethical drift, production validation.

v6 should lead with:
1. **Information-theoretic grounding of the EISV state vector** — Shannon + variational free energy with computable quantities replacing phenomenological coordinates
2. **Class-conditional calibration** — heterogeneity as a design constraint, not a corner case; per-class scale constants keyed on identity tags
3. **Dual-compute migration** — pipeline-ordering as a mechanism to re-ground a deployed framework without changing gating behavior; reusable pattern for live-system reframing
4. **Adaptive governor with PID phase-aware control** (kept from v5)
5. **Ethical drift as a four-component vector with EMA baseline tracking** (kept from v5)
6. **Production deployment evidence** (kept from v5, reframed by class)

Contraction analysis is no longer in the contribution list — it's a stability result in the appendix.

## Open design decisions for v6

- **Title**: "Information-Theoretic Governance of Heterogeneous Agent Fleets" is my proposal. Alternates: "Re-Grounding Agent Governance: From Thermodynamic Metaphor to Variational Free Energy" (story-style) | "Class-Conditional Information Geometry for Multi-Agent Governance" (more technical).
- **Whether to keep the §Connections to Thermodynamics subsection at all.** v6 is no longer thermodynamic-shaped, so the section's purpose changes. Options: (a) delete entirely, (b) keep as a "Why not thermodynamics" historical/methodological note, (c) absorb into Discussion.
- **How honest to be about the lack of empirical class-conditional data**. Phase 2 calibration hasn't run yet. v6 can present the framework with placeholder constants and forward-promise the empirical appendix, OR wait for Phase 2 data and ship v6 with the appendix already in. Week timeline forces (a).
- **Reviewer for v6 with FEP background** — spec §7 open question. Worth identifying before submission.

## Workflow

`unitares-v6/` is not a git repo (parent `docs/` isn't either). Working directly on disk. Kenny tracks revision points in this NOTES.md.
