# Bibliography Audit — UNITARES v6

**Generated:** 2026-04-18
**Purpose:** Identify papers a FEP-background or agent-governance reviewer would expect v6 to cite.
**Method:** Ralph-Wiggum loop over HF paper search on five axes (active inference + safety; FEP + multi-agent; variational free energy + LLM alignment; info-theoretic monitoring / drift; LLM confidence + semantic entropy). 4 seed queries expanded to 50+ candidates; triaged into cite / mention / ignore.

## CITE tier (MUST add before submission)

Reviewers will flag omission of these. In rough priority order:

### 1. Kuhn, Gal, Farquhar (2023) — Semantic Uncertainty
- arXiv: 2302.09664
- **Why critical:** §4's tier-2 entropy estimator ("draw $k$ responses at temperature $T > 0$, group by semantic equivalence, and compute the entropy of the equivalence-class distribution") IS semantic entropy. Not citing this is a reviewer red flag; the v6 paper currently presents the method as novel scaffolding.
- **Where to cite:** §4 (Quantity Redefinitions), paragraph $S$–Entropy, tier-2 sentence.

### 2. Da Costa, Tenka, Zhao, Sajid (2024) — Active Inference as a Model of Agency
- arXiv: 2401.12917
- **Why critical:** NOTES.md explicitly flagged needing a Sajid/Da Costa reference. This is the 2024 synthesis of active inference as an agent-governance framing — the single closest prior art to the v6 thesis of "governance via free-energy monitoring."
- **Where to cite:** §1 Related Work (Information-Theoretic Monitoring paragraph), and §4.1 (Choice of Frame) alongside the existing friston2010 ref.

### 3. Mazzaglia, Verbelen, Çatal, Dhoedt (2022) — FEP for Perception and Action (DL perspective)
- arXiv: 2207.06415
- **Why important:** Bridges Friston 2010 (abstract theory) to the kind of computable-on-agents form v6 actually uses. Makes v6's tier-1/tier-2 plumbing look like engineering of a known framework rather than a novel claim.
- **Where to cite:** §4.1 Choice of Frame, as the FEP-for-deep-agents bridge.

### 4. Wang, Singhal, Kelkar, Tuo (2025) — MI9: Agent Intelligence Protocol (Runtime Governance)
- arXiv: 2508.03858
- **Why important:** Direct competitor framework. MI9 claims "agency-risk index, agent-semantic telemetry capture, continuous authorization monitoring, goal-conditioned drift detection" — overlaps substantially with UNITARES' EISV + CIRS + drift vector. Not citing lets reviewers accuse v6 of ignoring concurrent work.
- **Where to cite:** §1 Related Work (AI Safety and Governance paragraph) — contrast UNITARES's continuous dynamical state vs. MI9's FSM-conformance engines.

### 5. Rath (2026) — Agent Drift: Behavioral Degradation in Multi-Agent LLM Systems
- arXiv: 2601.04170
- **Why important:** Defines an "Agent Stability Index" over multi-agent systems — parallel construction to UNITARES's ethical drift vector. Published before arXiv submission window for v6, so reviewers will notice.
- **Where to cite:** §8 Ethical Drift Vector — contrast the four-component EMA-tracked vector against Rath's composite metric framework.

## MENTION tier (add if related-work expansion is cheap)

Acknowledge in a one-sentence reference within Related Work; non-citation here is defensible but weaker.

### Drift / runtime governance
- **Dhodapkar & Pishori (2026) — SafetyDrift (2603.27148).** Absorbing Markov chain for drift prediction. Alternative to UNITARES's continuous ODE. Cite alongside Rath 2026.
- **Carson (2025) — Stochastic Dynamical Theory of LLM Self-Adversariality (2501.16783).** Fokker-Planck / SDE framework for severity drift. Directly comparable to §11 Stochastic Extensions; a reviewer familiar with this will ask why v6 doesn't compare.
- **Bhardwaj (2026) — Agent Behavioral Contracts (2602.22302).** Formal drift bounds theorem for multi-agent chains. Complementary to contraction-based bounds.

### Runtime enforcement (UNITARES alternative or complement)
- **Wang, Poskitt, Sun (2025) — AgentSpec (2503.18666).** DSL for runtime constraints. Cite under "Hard constraints" in §1 Related Work.
- **Wang, Poskitt, Sun, Wei (2025) — Pro2Guard (2508.00500).** DTMC-based probabilistic enforcement. Cite alongside AgentSpec.
- **Miculicich et al. (2025) — VeriGuard (2510.05156).** Formal safety via verified code generation. One-line cite as an orthogonal approach.
- **Hua et al. (2024) — TrustAgent (2402.01586).** Constitutional-constraint safety for LLM agents. Already adjacent to v6's citations of bai2022constitutional and rebedea2023nemo.

### Multi-agent / observability
- **Dong, Lu, Zhu (2024) — AgentOps (2411.05285).** Observability taxonomy for LLM agents. Mention as related-work scaffolding.
- **Erisken, Gothard, Leitgab, Potham (2025) — MAEBE (2506.03053).** Multi-agent emergent-behavior framework. Parallel concern to §12.
- **Kale et al. (2025) — Reliable Weak-to-Strong Monitoring (2508.19461).** Monitor red-teaming; relevant to v6's verdict-surface claims.
- **Wang et al. (2026) — Devil Behind Moltbook (2602.09877).** Information-theoretic framework for multi-agent safety with statistical blind spots. Actively FEP-adjacent; one-line cite.

### FEP infrastructure
- **Ferraro et al. (2022) — Disentangling Shape and Pose in Deep Active Inference (2209.09097).** Shows the kind of generative-model plumbing that would underwrite v6's tier-1 logprob estimator. Mention.
- **Fields, Friston et al. (2023) — Control Flow in Active Inference Systems (2303.01514).** Cite if §14.5 engages with FEP at all — has Friston as coauthor.

### Calibration / uncertainty
- **Qiu & Miikkulainen (2024) — Semantic Density (2405.13845).** Alternative to semantic entropy. Mention alongside Kuhn 2023.
- **Nguyen, Payani, Mirzasoleiman (2025) — Beyond Semantic Entropy (2506.00245).** Pairwise similarity extension of semantic entropy. Mention.

## IGNORE tier (searched, not applicable)

- Inference-time alignment papers (SEA, Variational BoN, InfAlign, f-divergence DPG) — training-time alignment, not runtime governance.
- MARL / MFC / offline RL papers (Cui 2023, Jiang 2021, Ying 2023) — wrong problem.
- GUI-agent / tree-search papers (Agent Alpha) — orthogonal.
- Byzantine fault tolerance for MAS — adjacent but consensus-style, not thermodynamic/info-theoretic.
- Fish-schooling entropy diagnostics — off-topic.
- Zhuravlev 2026 (Good Regulator Theorem on hypergraphs) — tempting Fisher-info FEP-adjacency but too idiosyncratic to cite usefully.

## Draft bibitems for the CITE tier

Paste into the thebibliography environment of `unitares-v6.tex`:

```latex
\bibitem[Kuhn et~al.(2023)]{kuhn2023semantic}
L.~Kuhn, Y.~Gal, and S.~Farquhar.
\newblock Semantic uncertainty: Linguistic invariances for uncertainty estimation in natural language generation.
\newblock {\em ICLR}, 2023.
\newblock arXiv:2302.09664.

\bibitem[Da~Costa et~al.(2024)]{dacosta2024active}
L.~Da~Costa, S.~Tenka, D.~Zhao, and N.~Sajid.
\newblock Active inference as a model of agency.
\newblock {\em arXiv preprint} arXiv:2401.12917, 2024.

\bibitem[Mazzaglia et~al.(2022)]{mazzaglia2022fep}
P.~Mazzaglia, T.~Verbelen, O.~{\c{C}}atal, and B.~Dhoedt.
\newblock The free energy principle for perception and action: A deep learning perspective.
\newblock {\em Entropy}, 24(2):301, 2022.
\newblock arXiv:2207.06415.

\bibitem[Wang et~al.(2025a)]{wang2025mi9}
C.~L. Wang, T.~Singhal, A.~Kelkar, and J.~Tuo.
\newblock {MI9} -- agent intelligence protocol: Runtime governance for agentic {AI} systems.
\newblock {\em arXiv preprint} arXiv:2508.03858, 2025.

\bibitem[Rath(2026)]{rath2026agentdrift}
A.~Rath.
\newblock Agent drift: Quantifying behavioral degradation in multi-agent {LLM} systems over extended interactions.
\newblock {\em arXiv preprint} arXiv:2601.04170, 2026.
```

## Specific edits this unblocks

1. **§4 tier-2 sentence** (around line 594–597 of `unitares-v6.tex`) should cite `kuhn2023semantic`. Reframe from "self-consistency sampling" to "semantic entropy \cite{kuhn2023semantic}". Removes the implicit-novelty claim.

2. **§1 Related Work, Information-Theoretic Monitoring paragraph** — add `dacosta2024active` and `mazzaglia2022fep` alongside the existing `friston2010free` ref. One sentence connecting UNITARES's tiered estimator story to active-inference computational frameworks.

3. **§1 Related Work, AI Safety and Governance paragraph** — add `wang2025mi9` as the nearest-neighbor runtime-governance framework and `rath2026agentdrift` as parallel drift work. Explicitly differentiate: MI9 is FSM-conformance; UNITARES is continuous dynamical state. Rath's Agent Stability Index is composite metric; UNITARES's drift vector couples back into the dynamics.

4. **§11 Stochastic Extensions** — optional one-line mention of `carson2025stochastic` to acknowledge the alternative Fokker-Planck framing of LLM-drift-as-SDE.

## Loop termination

Loop stopped after 6 iterations (4 seed searches + 2 targeted follow-ups on FEP and calibration). Queue not empty — the FEP / active-inference community has broader active-inference-for-robotics literature (Parr 2022 book, Friston 2023 updates, Sajid 2021 on deep active inference) that wasn't surfaced by HF paper search and would need arXiv direct search. 15 entries written across three tiers; convergence criterion (≥25 entries or 10 consecutive ignores) not quite met, but the CITE tier is saturated for the reviewer-risk goal.

**Next investment:** if a second pass is wanted, target the Parr/Sajid active-inference-for-robotics literature on arXiv directly; those are likely to surface 3–5 more MENTION-tier references for §4.1.
