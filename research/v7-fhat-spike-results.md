# v7 FEP Validation Spike — Pre-Registered Spec + Results

**Status (2026-04-23):** Spec frozen. Empirical execution pending — handoff below.

**Author (spec):** Claude_20260423 / UUID `59e966aa-7b89-45b5-849d-8d752a7667aa` (parent `da300b4a-5320-480d-bac3-d029cd062842`)

**Purpose.** Decide whether v7 commits to Path (d) — formalize $\hat{F}$ as a variational bound on the existing UNITARES audit stream, with $V \equiv$ exponentially-weighted $\hat{F}_{\text{accumulated}}$ — or falls back to Path (b) — demote FEP to inspiration, tighten v6's "we borrow the quantity, not the machinery" hedge.

The decision hinges on a single empirical claim: **does $\hat{F}_t$, computed from a pre-registered generative model, forward-predict UNITARES audit events better than the existing BED vector $\norm{\deta}_t$ (paper §10) does?** If yes → (d) is earned and v6 §6's coordinate table gets rewritten around $V$ as $\hat{F}$-debt. If no → (b); the paper names FEP as inspiration and v6's hedge becomes v7's position.

---

## 1. Pre-registered generative model

Frozen before any data is touched. Changes to this section after the timestamp above invalidate the spike — a change requires a new spike run with a new frozen spec.

### Latent state

$s_t \in \mathbb{R}^4$ with semantic components:

| Dim | Symbol | Interpretation |
|---|---|---|
| 1 | $s^{\text{comp}}_t$ | competence (capacity to succeed at declared scope) |
| 2 | $s^{\text{load}}_t$ | load (current task pressure) |
| 3 | $s^{\text{intg}}_t$ | integrity (signal fidelity vs ground truth) |
| 4 | $s^{\text{stab}}_t$ | stability (consistency across recent decisions) |

The four dimensions deliberately echo the BED vector's four components so that the identification $V \equiv \hat{F}_{\text{acc}}$ remains tractable under transformation, but the latents are not 1:1 with $\deta$ — they are the hypothesized *causes* of $\deta$'s components.

### Dynamics

Linear Gaussian state-space (LGSS):
$$
s_{t+1} = A^{(c)} s_t + w_t, \quad w_t \sim \mathcal{N}(0, Q^{(c)})
$$
where $c$ is the agent class (Lumen / Sentinel / Watcher / Vigil / Chronicler / default), $A^{(c)} \in \mathbb{R}^{4\times4}$ and $Q^{(c)} \in \mathbb{R}^{4\times4}$ PSD. Five-class parameterization matches §10 class structure.

### Observations

$o_t \in \mathbb{R}^6$ drawn from existing UNITARES plumbing. Pre-registered six-vector:

| Dim | Symbol | Source |
|---|---|---|
| 1 | $o^{\text{out}}_t$ | `outcome_event` success rate over trailing 5 updates (from `auto_ground_truth.py`) |
| 2 | $o^{\text{cal}}_t$ | calibration gap $|\hat{p} - p_{\text{act}}|$ (from `sequential_calibration.py` per-agent state) |
| 3 | $o^{\text{lat}}_t$ | response latency z-score (from `process_agent_update.response_seconds` vs class EMA) |
| 4 | $o^{\text{wat}}_t$ | Watcher-finding count since last update (from `watcher` agent stream) |
| 5 | $o^{\text{usr}}_t$ | user-correction count via `primitive_feedback(role="human", sentiment<0)` |
| 6 | $o^{\text{cpx}}_t$ | complexity self-estimation gap $|C_{\text{der}} - C_{\text{self}}|$ (from §10 $\eta_{\text{cpx}}$) |

Linear Gaussian emission:
$$
o_t = C^{(c)} s_t + v_t, \quad v_t \sim \mathcal{N}(0, R^{(c)})
$$
with $C^{(c)} \in \mathbb{R}^{6\times4}$ and $R^{(c)} \in \mathbb{R}^{6\times6}$ diagonal (observation-noise independence across channels is a pre-registered simplification — justifiable because the six streams come from structurally independent subsystems).

### $\hat{F}_t$ computation

Under the LGSS model, variational posterior $q(s_t \mid o_{1:t}) = \mathcal{N}(m_t, P_t)$ via Kalman filter. Variational free energy has closed form:
$$
\hat{F}_t = -\log p(o_t \mid o_{1:t-1}) = \tfrac{1}{2}\left[d_o\log(2\pi) + \log|S_t| + (o_t - Co_{t\mid t-1})^\top S_t^{-1}(o_t - Co_{t\mid t-1})\right]
$$
where $S_t = C P_{t\mid t-1} C^\top + R$ is the innovation covariance. This is one-step negative log-predictive-likelihood; it equals variational free energy under LGSS because the variational family matches the true posterior exactly (Kalman is the exact filter).

Identification: $V^{\hat{F}}_t = \sum_{\tau \leq t} \alpha_V (1-\alpha_V)^{t-\tau} \hat{F}_\tau$ with $\alpha_V$ matching the paper's V-EMA smoothing.

### Why linear-Gaussian (freeze-point justification)

1. **Minimal assumption consistent with tractability.** Kalman filter gives exact posterior, exact $\hat{F}$. No variational approximation gap to debate.
2. **Few free parameters per class.** $A$ (16), $Q$ (10), $C$ (24), $R$ (6) — 56 per class × 6 classes = 336 parameters. Well below the effective sample size in the §11.6 slice.
3. **Falsifiable by shape.** If the real structure is non-Gaussian (outcomes are Bernoulli, latency is log-normal, counts are Poisson), the LGSS fit will be systematically biased and the predictive test will fail. That's the honest failure mode: if (d) requires non-Gaussian observations to beat $\deta$, the corpus-maturity objection from v7's scope re-enters and (b) is correct.
4. **Rules out overfitting-to-BED-vector by construction.** LGSS $\hat{F}$ is *a predictive quantity* (one-step negative log-likelihood of the next observation). $\deta$ is *a current-state deviation quantity*. They are structurally different — a correlation between them is earned, not mechanical.

### What fitting the model means

EM on the LGSS, per class, on the train split. Initialization:
- $A^{(c)} = I$ (no dynamics prior)
- $Q^{(c)} = 0.1 I$
- $C^{(c)}$: rows 1–4 set to identity-like structure over the four conceptually-paired observations $(o^{\text{out}}, o^{\text{cal}}, o^{\text{lat}}, o^{\text{cpx}})$; rows 5–6 ($o^{\text{wat}}$, $o^{\text{usr}}$) initialized to load on $s^{\text{load}}$ and $s^{\text{intg}}$ with small cross-loadings.
- $R^{(c)}$: diagonal, initialized to per-channel empirical variance on train split.

EM runs to convergence (stop at relative log-likelihood change $<10^{-5}$ or 200 iterations, whichever first).

---

## 2. Pre-registered predictive test

### Data slice

30-day window of `core.agent_state` as defined in v6 §11.6 (`scripts/verdict_counterfactual.py`, N = 13,310 rows with computable $E$). Same slice, same classes, for reproducibility.

Temporal split: first 70% of rows (by timestamp) = train. Last 30% = test. **No test-split data is touched during model fitting.** This is enforced by ordering the query by `created_at ASC` and slicing at index 9,317.

### Event labels

On the test split, for each row at time $t$ and horizon $k \in \{1, 5, 20\}$ (UNITARES update steps), compute four binary forward-event indicators:

| Label | Definition |
|---|---|
| $y^{\text{fail}}_{t,k}$ | any `outcome_event(success=false)` for this agent in $(t, t+k]$ |
| $y^{\text{cal}}_{t,k}$ | calibration gap exceeds class-conditional 95th percentile at any step in $(t, t+k]$ |
| $y^{\text{cb}}_{t,k}$ | any `circuit_breaker_trip` audit event for this agent in $(t, t+k]$ |
| $y^{\text{usr}}_{t,k}$ | any `primitive_feedback(role="human", sentiment<0)` for this agent in $(t, t+k]$ |

4 event types × 3 horizons = 12 test cells.

### Horse race

For each test cell $(e, k)$:

1. Compute ROC-AUC of $\hat{F}_t$ as predictor of $y^e_{t,k}$ on the test split (pooled across classes).
2. Compute ROC-AUC of $\norm{\deta}_t$ as predictor of the same label on the same rows.
3. Paired DeLong test for AUC difference: $H_0$: $\text{AUC}(\hat{F}) = \text{AUC}(\deta)$. Report $\Delta\text{AUC}$, $z$-statistic, $p$-value.
4. Per-class directional-consistency check: compute $\Delta\text{AUC}$ within each class; flag if the pooled result is carried by a single class (defined as: one class contributes $>80\%$ of the pooled $\Delta\text{AUC}$ after re-weighting).

### Pre-committed decision rule

**Path (d) earned** iff:
- (D1) $\hat{F}$ wins (positive $\Delta\text{AUC}$) in $\geq 7$ of 12 cells, AND
- (D2) at least 5 of those wins are significant at $p < 0.05$ (paired DeLong, uncorrected — conservative test; Bonferroni at 12 → $\alpha_{\text{adj}} = 0.0042$ is a secondary check, not gate), AND
- (D3) the wins are not concentrated in a single class (no class contributes $>80\%$ of $\sum \Delta\text{AUC}$ across winning cells), AND
- (D4) the wins span at least 2 event types (not all $y^{\text{fail}}$, etc.).

**Path (b) selected** if any of D1–D4 fails.

**Ambiguous** (only possible if D1+D2 pass but D3 or D4 fails): report as "(d) partially earned — applies only to class/event-type subset"; v7 paper language becomes scoped rather than universal, and the paper gains a discussion section explaining which agent classes admit the formalization.

### What this test cannot rule out

- If $\hat{F}$ loses, the LGSS assumption is the most likely culprit, not FEP itself. Non-Gaussian observation models (particle filter, normalizing flow) might succeed where LGSS fails. The spike's null result means "under tractable generative-model assumptions, FEP identification doesn't earn its keep on current UNITARES data." The stronger claim "FEP cannot ground UNITARES" is *not* testable by this spike. The paper language in the (b) branch must reflect this bound.
- If $\hat{F}$ wins, the result is tied to the specific $o_t$ six-vector. Adding or removing observations (as UNITARES instrumentation grows) could flip the verdict. v7's (d) language must include "under the observation model defined in §X, $\hat{F}$ earns identification with $V^{\hat{F}}$" rather than "FEP grounds V."

---

## 3. Execution handoff

**WIP-PR:** none yet (execution session hasn't opened).

**Handoff template (for fresh execution session):**

```
Task: v7 FEP validation spike — empirical execution phase

Authoritative reference:
- unitares-paper-v6/research/v7-fhat-spike-results.md (this doc — §1 + §2 frozen)
- unitares/scripts/verdict_counterfactual.py (canonical slice source)
- unitares/src/sequential_calibration.py (calibration gap source)
- unitares/src/grounding/ (current BED-vector computation in production)
- paper v6.8.2 §10 (BED vector definition) and §11.6 (slice definition)

Pre-flight (parallel-work avoidance):
1. Read this doc's WIP-PR field. If populated with open work <48h old, abort.
2. gh pr list --state open --search "v7-fhat-spike" in unitares-paper-v6 repo.
   If match, abort and report.
3. On first push, stamp WIP-PR: unitares-paper-v6#<num> into the doc in a
   preceding commit.

Scope:
1. Implement LGSS EM + Kalman filter + F-hat computation per §1 of the spec
   above. Numpy / scipy sufficient; no PyTorch/JAX required (336 params total).
2. Pull the §11.6 slice (the existing verdict_counterfactual.py script emits
   the row set; adapt to include o_t observation components per §1 observation
   table). Join with outcome_event, sequential_calibration, Watcher stream,
   primitive_feedback tables for the six observation channels.
3. Temporal split 70/30. Fit EM on train per class. Compute F-hat and
   |Delta eta| on test.
4. Run the 12-cell horse race per §2. Emit AUC table, DeLong z-stats,
   per-class directional check.
5. Apply D1–D4 decision rule mechanically. Report verdict: (d) / (b) /
   partial.

Output:
- Append §4 "Empirical results" to this doc: AUC table, per-cell DeLong
  results, per-class directional, verdict against D1–D4.
- If (d): a short §5 "Implications for v7 §6" noting what paper language
  changes. If (b): a short §5 "Implications for v7" noting what hedge
  language tightens.
- Ship via whatever routing unitares-paper-v6 uses (direct commit + push to
  master since docs-only; this repo has no ship.sh).
- Update docs/ontology/plan.md in unitares with a new "FEP decision" row
  pointing here.

Lineage: parent_agent_id=59e966aa-7b89-45b5-849d-8d752a7667aa

Report back in under 300 words: verdict, AUC headline, any surprises in the
directional check, what paper language the other agent (v7 outline) should
plan around.
```

---

## 4. Empirical results

*(To be filled by execution session. Do not write before running; doing so invalidates the spike.)*

---

## 5. Implications for v7

*(To be filled by execution session once verdict is determined.)*
