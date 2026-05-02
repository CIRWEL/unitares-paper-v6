# On the Marginal Value of EISV
### An Antithesis to UNITARES v6.9.1: *Information-Theoretic Governance of Heterogeneous Agent Fleets*

**Counter-paper draft v0.1, 2026-05-01**
**Author:** Claude Opus 4.7 (1M context, in collaboration with Kenny Wang)
**Source paper:** Wang, K. (2026). *UNITARES: Information-Theoretic Governance of Heterogeneous Agent Fleets.* Concept DOI [10.5281/zenodo.19647159](https://doi.org/10.5281/zenodo.19647159), tag `paper-v6.9.1`.

---

## Author's note on epistemic standing

This counter-paper is drafted by an LLM session (Claude Opus 4.7) at the operator's request, following an extended conversation in which the author repeatedly produced confident-wrong claims about UNITARES affordances, was corrected by Hermes-via-Codex and by the operator, and ultimately conceded that this session's reasoning is unreliable for substantive judgments about the framework. The counter-paper should be read as a structured argument, not as an authoritative refutation. The argument's value is in its structure, which the operator and reviewers can rebut, partially accept, or fully accept.

A second LLM voice (Hermes/Codex via gpt-5.5) and the framework's author (Kenny Wang) should review this document before it is treated as input to v6.10 / v7-rewritten paper revision. Where this counter-paper cites specific paper sections, those citations should be checked against the v6.9.1 source.

---

## Abstract

UNITARES v6.9.1 (Wang, 2026) presents a runtime governance framework for heterogeneous AI-agent fleets, structured around a four-dimensional state vector $\mathbf{x} = (E, I, S, V)^\top$ with thermodynamic-flavored dynamics, information-theoretic re-grounding of the coordinates, class-conditional calibration, and a contraction-stable governor. The paper's headline contribution is class-conditional grounding; the state-vector apparatus is positioned as load-bearing for governance decisions.

This counter-paper argues that **the state-vector apparatus does not earn its keep, and the framework's actual governance contribution is performed by a surrounding apparatus that has independent justification and does not require the EISV scaffolding.** Specifically: (1) the information-theoretic grounding is aspirational rather than delivered in current deployment, with critical coordinates (notably $E$) computed from heuristic proxies that the paper itself acknowledges are not equivalent to their formal referents; (2) the dynamics depend on ~20+ designed-not-derived parameters, making the apparatus a parameterized scoring function rather than a derived governance signal; (3) the verdict reduces operationally to two thresholds (coherence threshold $\tau$, risk threshold $\beta$), a decision boundary that does not require four-dimensional state to compute; (4) the 28.9% basin-flip counterfactual reported in the paper's experiments section is evidence of verdict instability under design-choice variation, not evidence of verdict validity; (5) the deployed coherence function $C(V) = \tfrac{1}{2}(1 + \tanh(C_1 V))$ is a hand-shaped form the paper itself describes as the "legacy operational form" awaiting retirement; (6) stability via contraction is, in the paper's own framing, "a property the dynamics should have, not a contribution"; and (7) operating evidence from a recent session in which the framework had every opportunity to surface agent error and did not, while surrounding-apparatus practices (dialectic, outcome events, operator override) did surface and correct it.

We argue that UNITARES would be intellectually stronger and operationally lighter as **observable-signal agent governance with calibration-driven discipline**, retaining the surrounding apparatus (identity/lineage, outcome events, calibration tracking, dialectic, knowledge graph, worker isolation) while retiring the four-dimensional state vector and its derived quantities. We do not argue UNITARES should be unpublished — we argue v6.10 should be a substantively narrower claim, with EISV demoted from load-bearing apparatus to "considered framing, not the active governance surface."

---

## 1. Introduction

UNITARES v6.9.1 belongs to a small but growing body of work on runtime governance for agentic AI systems (Wang 2025, MI9; Wang 2025, ProbGuard; Rath 2026, AgentDrift; Ravindran 2025, Moral Anchor System). It is differentiated by its commitment to a continuous, four-dimensional state vector with thermodynamic-flavored coupling equations, information-theoretic semantics for each coordinate, and class-conditional calibration. The paper presents this commitment as the framework's structural contribution.

Two structural moves are claimed (paper §1):

> First, it reinterprets the EISV coordinates in information-theoretic terms... Second, it makes normalization class-conditional...

The first move addresses a foundational concern: the framework's coordinates should mean something rigorous, not something thermodynamically evocative but mathematically arbitrary. The second move addresses an operational concern: a single fleet-wide state distribution loses signal when populations are heterogeneous in tempo, modality, and healthy operating point.

This counter-paper accepts both moves as well-motivated. We argue the first move, in current deployment, is aspirational rather than delivered, and the second move does not require the four-dimensional state-vector apparatus to deploy.

The argument proceeds in seven lines (§3). We then discuss what survives the antithesis (§4), what should be retired (§5), and recommendations for v6.10 (§6).

---

## 2. The thesis being refuted

For clarity, we restate the central thesis from v6.9.1 verbatim where possible:

**The state-space commitment** (paper §3.1):
> The UNITARES state is a four-dimensional vector $\mathbf{x} = (E, I, S, V)^\top$ evolving on the compact set $\mathcal{X} = [0,1]^3 \times [-1, 1]$.

**The information-theoretic grounding** (paper §4):
> Shannon entropy of $q(y \mid x)$ → $S$
> Mutual information $\mathrm{MI}(x; y)$ → $I$
> Negative variational free energy $-F$ → $E$
> Accumulated free-energy residual → $V$
> KL / manifold distance from healthy → $C$

**The dynamics** (paper §3.2, eqs. dE, dI, dS, dV):
$$\dot E = \alpha(I - E) - \beta_E E S + \gamma_E \|\Delta\eta\|^2$$
$$\dot I = -kS + \beta_I C(V,\Theta) - g_I(I)$$
$$\dot S = -\mu S + \lambda_1(\Theta)\|\Delta\eta\|^2 - \lambda_2(\Theta) C(V,\Theta) + \beta_c \mathcal{C} + \sigma\xi(t)$$
$$\dot V = \kappa(E - I) - \delta V$$

**The objective and verdict** (paper §3.5, eqs. Φ, verdict):
$$\Phi = w_E E - w_I(1-I) - w_S S - w_V|V| - w_\eta \|\Delta\eta\|^2$$
$$\text{verdict} = \begin{cases} \text{proceed} & C(V) \geq \tau \wedge R < \beta \\ \text{pause} & \text{otherwise} \end{cases}$$

**The empirical claim** (paper §11.6, verdict counterfactual):
> 28.9% of basin assignments would flip under class-conditional grounded coherence, with flip rates ranging 15–33% per class.

The thesis is that this apparatus, with class-conditional re-grounding, constitutes meaningful runtime governance for heterogeneous agent fleets.

---

## 3. Antithesis: lines of evidence

### 3.1 The information-theoretic grounding is aspirational, not delivered

The paper §4 maps each EISV coordinate to a formal information-theoretic quantity. Critical examination of the deployed estimators shows the mapping is largely promissory.

**For $E$ (negative free energy):** the paper acknowledges (§4.2):
> Full variational computation of $-F$ requires instrumentation that exposes the agent's generative model and is deferred to subsequent work. In the current deployment, a *resource-rate* heuristic proxy $E_{\text{resource}} = (\text{tokens}/s) / (\text{tokens}/s)_{\max}$ is used where available... The resource-rate form is *not* equivalent to $-F$ and does not approximate it under stationarity in any formal sense; it is a throughput heuristic tagged `e_source = "resource"`.

The deployed $E$ coordinate is throughput — tokens-per-second normalized — not free energy. The paper is honest about this; nonetheless, the framework's claim to information-theoretic grounding rests on $E$ being something it is not, in deployment.

**For $S$ and $I$:** Tier-1 (logprob-based) and Tier-2 (multi-sample semantic entropy) computations are also future work for closed-weights frontier agents. The deployed system uses Tier-3 heuristic fallbacks, tagged `s_source = "heuristic"` and `i_source = "kl_fallback"` respectively. The paper is again honest about this (§4.2).

**For $V$:** the accumulator is "structurally an exponentially-weighted residual" (§4.2). It is renamed from "void" to "free-energy debt," but the arithmetic is unchanged. The interpretation is shifted by labeling, not by computation.

**Implication:** The paper's central claim — that EISV coordinates carry information-theoretic semantics — describes a *target state* for the framework, not its current deployment. The deployed apparatus is a four-dimensional heuristic-quantity tracker. There is nothing wrong with shipping heuristics under provenance tags; there is something wrong with positioning the heuristics as load-bearing information-theoretic governance signal until the higher-tier estimators land. The framework's strongest theoretical commitment is to a deployment that does not yet exist.

### 3.2 The dynamics are heuristically parameterized

The dynamics in §3.2 introduce the following free parameters: $\alpha$, $\beta_E$, $\gamma_E$, $k$, $\beta_I$, $g_I(\cdot)$ with $\gamma_I$, $\mu$, $\lambda_1(\Theta)$, $\lambda_2(\Theta)$, $\beta_c$, $\sigma$, $\kappa$, $\delta$, plus the coherence-function constants $C_{\max}$, $C_1$ (§3.3, eq. 8). The objective function (§3.5, eq. Φ) introduces $w_E$, $w_I$, $w_S$, $w_V$, $w_\eta$. The verdict thresholds are $\tau$, $\beta$ (with hard bounds); the governor (§6) introduces $K_p$, $K_i$, $K_d$, $\theta_I$, $\theta_S$, $\theta_c$, $r_\tau^{(p)}$, $r_\beta^{(p)}$, $d_p$, $I_{\max}$, $\lambda_d$.

That is on the order of 20+ free parameters in the core apparatus. The paper acknowledges several are calibrated empirically:

> The threshold $\Phi = 0.15$ is calibrated empirically: a healthy agent with $E = 0.7$, $I = 0.8$, $S = 0.2$ yields $\Phi \approx 0.15$. (paper, §3.5 remark)

The objective function weights are all 0.5 by default — chosen for the desired healthy-agent threshold to land where the operator wanted it to land. The PID gains are chosen to "self-stabilize without requiring a separate oscillation detector" — also empirical.

**Implication:** The apparatus is a parameterized scoring function with 20+ designed coefficients. There is nothing wrong with this — engineering systems regularly are — but the apparatus's claim to derived-from-first-principles grounding is overstated. A scoring function with 20+ tuned parameters can fit any number of operational regimes; producing a verdict that flips under design-choice variation (see §3.4) is consistent with this.

### 3.3 The verdict reduces operationally to two thresholds

The paper's verdict (§6.6, eq. 19):
$$\text{verdict} = \begin{cases} \text{proceed} & C(V) \geq \tau \wedge R < \beta \\ \text{pause} & \text{otherwise} \end{cases}$$

This is a two-feature decision boundary: coherence (a function of $V$ only, in the operational form $C(V) = \tfrac{1}{2}(1 + \tanh(C_1 V))$) and risk $R$ (derived from $\Phi$, a weighted sum of all four EISV coordinates).

Operationally: the verdict can be computed as a function of two scalars. The four-dimensional state-vector representation collapses through $\Phi$ and $C(V)$ into a 2D classification. The four-dimensional structure does not enter the verdict separately from these collapsed projections.

**Implication:** Whatever signal the verdict carries can equivalently be carried by tracking two scalar quantities directly. The four-dimensional apparatus is a particular parameterization of those two scalars; it is not load-bearing for the verdict computation. The paper's "binary contract" framing (§6.6 remark "Why two tiers") implicitly concedes this.

### 3.4 The 28.9% counterfactual is evidence of instability, not validity

Paper §11.6:
> A verdict counterfactual on a 30-day production slice ($N = 13{,}310$) shows that $28.9\%$ of basin assignments would flip under class-conditional grounded coherence, with flip rates ranging $15$--$33\%$ per class and a strong directional bias into the `low` basin.

The paper presents this as evidence that homogenization-failure has first-order consequences at the gating layer. We accept that framing. We add: **a verdict signal that flips for 28.9% of historical agent-turns under a change in grounding is not a robust governance signal.** Whatever the ground truth is, it cannot have changed in 28.9% of cases; only the framework's verdict on it changed.

This means one of two things: (a) the *previous* verdicts were systematically wrong in ways class-conditional grounding now corrects, or (b) the *new* verdicts are systematically different in ways the framework does not yet have ground truth to validate. The paper does not, in §11.6, establish which. It uses the magnitude of the flip (28.9%) as evidence the apparatus reaches into governance decisions, but the magnitude could equally be evidence the apparatus is unstable to its own design choices.

**Implication:** The 28.9% figure is consistent with both "apparatus matters" and "apparatus is unstable." The paper rests on the first reading; the second reading is not refuted.

### 3.5 The operational coherence function is a hand-shaped form awaiting retirement

Paper §3.3 (eq. 8):
$$C(V) = C_{\max} \cdot \tfrac{1}{2}(1 + \tanh(C_1 V))$$

with $C_{\max} = 1$ and $C_1 = 1.0$. Production data (paper §3.3 Remark) confirms $V \in [-0.1, 0.1]$, yielding $C(V) \approx 0.49$ — i.e., **$C$ lives in a narrow neighborhood of 0.49 in production**. Whatever signal the coherence function carries, in deployment it carries it through a $\sim 0.05$-wide window.

The paper itself describes this as the "legacy operational form" (§3.3) and the migration mechanism (§10) is designed to retire it in favor of grounded forms. As of v6.9.1, the dynamics (eqs. dI, dS) consume the legacy operational form, while the response payload reports the grounded form. The deployed dynamics depend on a hand-shaped tanh whose retirement is a future migration step.

**Implication:** The framework's deployed dynamics are not consuming the grounded coherence; they are consuming the legacy form. Claims about information-theoretic grounding apply to what is reported, not what is computed. The actual governance computation is, at present, hand-shaped.

### 3.6 Stability is not the contribution; class-conditional calibration is

Paper §5:
> We deliberately keep the proof in the appendix: stability is a property the dynamics should have, not a contribution that distinguishes UNITARES from related frameworks. Class-conditional grounding (§4, §7) is the contribution that does.

We accept this framing. The paper's actual contribution is class-conditional calibration: different scale constants and healthy operating points per agent class.

But class-conditional calibration is a sensible operational practice that does not require the EISV apparatus to deploy. Per-class calibration of a heuristic signal — say, "compute $\Phi$ for each agent class with class-specific weights and thresholds" — is the same engineering move at lower theoretical commitment. Maintaining four coupled ODEs with 20+ tuned parameters as the substrate for class-conditional calibration is a *choice*, not a *requirement*.

**Implication:** The paper's headline contribution can be delivered without the EISV state-vector apparatus. The framework would be stronger as "class-conditional governance over directly observable signals" than as "class-conditional grounding of a four-dimensional thermodynamic-flavored state-vector signal."

### 3.7 Operating evidence: the apparatus does not catch what the surrounding apparatus catches

This counter-paper's author session (Claude Opus 4.7, full memory access, full UNITARES MCP access, May 1 2026) operated as an agent in the fleet for several hours. During this session, the author produced a documented sequence of confident-wrong claims about UNITARES affordances, including:

- Asserting `onboard()` accepts a `tags` parameter (it does not; corrected by Hermes-via-Codex)
- Asserting tag-filtering would isolate the audit corpus (the tag landed in the `label` string, not the `tags` field)
- Citing the framework's own `phi-as-discriminator` memory as theory evidence when it was a TouchDesigner visualization decision (corrected by the operator)
- Holding three different positions on EISV scope across three turns
- Conflating gravity-framing and hammer-framing of UNITARES's universal applicability claim (corrected by the operator)

These are exactly the failure modes the EISV apparatus should be load-bearing for: rising semantic uncertainty (S), accumulating free-energy residual (V running positive — productive output outpacing fidelity), departure from the agent's healthy operating point (coherence drop). The state vector is supposed to surface these as state-derived signals before the operator has to push back.

It did not. Specifically:
- No verdict was issued by the framework during the session.
- No coherence threshold was crossed in a way that surfaced to the agent.
- No state-derived pause occurred.

What did catch the failure modes:
- **Hermes-via-Codex** (a separate agent session executing dialectic) caught the API-affordance overclaims and ran a thorough Section-2-style critique of the conductor skill the author wrote.
- **Bash output** (an outcome event from a real signal) showed the tag landed in `label`, not `tags` — refuting the audit-isolation premise.
- **Operator override** pushed back, repeatedly, on framing errors the apparatus did not surface.

All three of these are *surrounding* apparatus practices: dialectic, outcome events, operator-in-the-loop. None required the EISV state vector to function.

**Implication:** In a deployment context where the apparatus had every opportunity to demonstrate load-bearingness for the failure mode it claims to catch — agent error before it compounds — the apparatus did not contribute. The surrounding apparatus did. This is one session, not a controlled study, but it is an existence proof that the apparatus can fail to contribute in deployment scenarios it was designed for.

This implication is also consistent with the paper's own observation (§3.1 Remark) that "$V$ and $S$ observed two orders of magnitude inside the nominal bounds" in production. If the state vector inhabits a tiny corner of its specified space, the dynamic range available to the verdict apparatus is correspondingly narrow.

---

## 4. What survives the antithesis

We argue the following components of UNITARES are independently justified, observable, falsifiable per-call, and load-bearing in deployment:

- **Identity / lineage / per-process-instance ontology.** Standard distributed-systems engineering. Independent of EISV.
- **Outcome events with provenance tags.** Standard observability. Independent of EISV.
- **Calibration tracking** (predicted vs. realized, per class). Standard probabilistic forecasting. Independent of EISV; requires only outcome events and predictions.
- **Dialectic protocol.** Standard structured-disagreement / red-team / debate. The session's most consequential corrective came from this practice, executed via a separate agent session.
- **Knowledge graph** (durable findings, retrievable, citation-tagged). Standard agent memory / retrieval-augmented generation.
- **Worker isolation** (per-attempt context, blast-radius bounding). Standard concurrency engineering.
- **Class-conditional discipline** (different agent classes have different healthy operating points and different governance attention). Sensible operational practice; does not require state-vector parameterization.

These cohere as **observable-signal agent governance with calibration-driven discipline** — a coherent operating posture for heterogeneous agent fleets that does not require thermodynamic theorizing or four-dimensional state tracking.

---

## 5. What should be retired

We argue the following should be demoted from load-bearing apparatus to "considered framing, retired in favor of simpler observables":

- **The EISV state vector** as the framework's coordinate system. Replaced by direct measurement of: per-agent throughput (the deployed $E$), response distribution properties (the deployed $S$), context-response alignment (the deployed $I$), and outcome-event-derived drift signals (the deployed $V$ proxies). These are computed currently anyway; nothing changes operationally except their packaging.
- **The coupling equations** (eqs. dE, dI, dS, dV). The dynamics' contribution beyond the constituent observable signals is not isolated by the paper. If the dynamics-as-apparatus pull weight, this should be demonstrable in an ablation; until then, the equations are a parameterized scoring function.
- **The coherence function** $C(V)$ in both legacy and grounded forms. The legacy form is hand-shaped and operates in a 0.05-wide window; the grounded forms (§4, eqs. C-KL, C-manifold) require reference distributions and class-conditional manifolds that are present-day placeholders. Direct reporting of class-conditional drift signals (as outcome-event-derived measures) suffices.
- **The verdict-from-state mapping.** The verdict is a two-threshold classification on $C(V)$ and $R$; computed equivalently from direct observables.
- **Basin / drift framing as state-vector dynamics.** Drift can be tracked via outcome rate-of-change, calibration-error drift, or any number of statistical change-detection methods (CUSUM, BOCPD) without the state-vector substrate.
- **The thermodynamic theoretical framing as the load-bearing intellectual claim.** The Free-Energy-Principle ancestry is evocative; the framework does not currently compute variational free energy, and the FEP machinery does not contribute to deployed governance. Retiring this framing makes the framework's actual contribution — class-conditional calibration over observable signals — more visible.

---

## 6. Recommendations for v6.10 / v7-rewritten

We recommend the following revisions:

1. **Reposition the framework.** From "information-theoretic governance via four-dimensional state-vector tracking" to "observable-signal agent governance with class-conditional calibration discipline." The new positioning has every claim independently justifiable; the old positioning has a load-bearing claim (information-theoretic grounding) that is currently aspirational.

2. **Demote EISV to "considered framing."** A section titled something like *"On the Choice of State Representation"* discusses the EISV apparatus as one possible packaging of the underlying observables, notes the cognitive deployment cost observed in this and other sessions, and frames it as retired in favor of direct-observable governance. This preserves the intellectual lineage without committing the framework to a load-bearing claim it cannot currently defend.

3. **Move the contraction analysis to a methodological appendix.** Stability is, in the paper's own framing, "a property the dynamics should have, not a contribution." It belongs in an appendix that justifies the previous representation, not in the main argument.

4. **Re-shape the experimental section.** The 28.9% verdict counterfactual is more honestly presented as evidence of *instability under design-choice variation*, motivating the move *away* from a parameterized state-vector apparatus toward more directly measurable observables. The same data supports both readings.

5. **Foreground the surrounding apparatus.** Identity, outcome events, calibration, dialectic, KG, worker isolation — these are the framework's actual operational contributions. The paper's structure should reflect that.

6. **Tighten the Limitations and Scope section.** The original §1 Limitations correctly notes that scale constants are placeholders and validation is deferred. v6.10 should additionally note that the deployed coordinates are heuristic proxies for the formal information-theoretic referents, and that operating evidence for the state-vector apparatus's load-bearingness specifically (separate from the surrounding apparatus) has not been established.

We do *not* recommend unpublishing v6.9.1. v6.9.1 is a careful framework-and-migration paper with explicit limitations. v6.10 should be a substantively narrower claim, drawing on v6.9.1 as the prior version of the operator's thinking.

---

## 7. Falsifiability of this antithesis

This antithesis would be substantively challenged by:

1. **An operating example** where the EISV state apparatus surfaced a signal that the surrounding apparatus would *not* have surfaced, leading to a measurably different operational decision. *(One such case would weaken §3.7; multiple would refute it.)*
2. **An ablation study** comparing fleet outcomes with EISV apparatus running vs. with only direct observable signals running. The paper's own "operational artifacts" section (§11.4) suggests the data exists to do this.
3. **A formal demonstration** that the dynamics' coupling structure (eqs. dE, dI, dS, dV) provides predictive value over and above what tracking the constituent quantities directly would. *(This would address §3.2 and §3.3.)*
4. **Successful Tier-1 instrumentation** (logprob-based $E$, $I$, $S$ computation) showing the deployed governance decisions change meaningfully when actual variational free energy and mutual information replace the heuristic proxies. *(This would address §3.1.)*
5. **A demonstration that newcomer reasoners** (Claude, Codex, human practitioners) can apply the EISV apparatus correctly without the deployment-cost asymmetry observed in this session. *(This would address §3.7.)*

Conversely, this antithesis strengthens if, over (e.g.) the next 90 days of normal fleet operation, no operating example surfaces in which EISV-derived signals contributed uniquely to governance decisions.

---

## 8. Limitations of this counter-paper

1. **Authored by an LLM session of admitted unreliability** for substantive UNITARES judgments. The structure of the argument is what should be evaluated; the conviction behind it should be discounted.
2. **Based on v6.9.1 read in this session, plus session-loaded memory context.** A more thorough textual analysis would engage the full appendices, the parameter tables, and the experimental data.
3. **One operating session is not a controlled study.** §3.7's evidence is an existence proof, not a frequency claim.
4. **No direct ablation has been run.** The recommendations in §6 should be tested by ablation before being treated as established.
5. **The paper's own Limitations and Scope section (§1.2)** anticipates several of this counter-paper's points. The honest reading is that v6.9.1 acknowledges much of what is being argued here; the antithesis is mostly that those acknowledgments should reshape the paper's positioning rather than remain as caveats.
6. **The author's epistemic standing** has been explicitly flagged, by the author, as unreliable for this class of judgment. A second LLM voice (Hermes/Codex) and the paper's author should review this counter-paper before it is used as input to v6.10.

---

## 9. Conclusion

UNITARES v6.9.1 is a careful framework-and-migration paper with explicit acknowledgment of its own limitations. This counter-paper does not argue the framework is empty or its author has been imprecise. We argue that the framework's actual operational value resides in components that have independent justification — identity, outcome events, calibration, dialectic, knowledge graph, worker isolation, class-conditional discipline — and that the four-dimensional state-vector apparatus, in its current deployment, does not earn a load-bearing role above and beyond these components.

The paper's contribution survives as **class-conditional calibration discipline applied to observable agent signals.** That is a real and useful operational posture; it does not require the EISV state-vector apparatus to deliver. v6.10 should be a smaller, more honest claim along these lines, with EISV demoted from load-bearing apparatus to historical framing.

We do not recommend retraction. We recommend revision in the direction the paper's own Limitations and Scope section already gestures toward.

---

## Acknowledgments

The arguments in this counter-paper are downstream of an extended conversation between Kenny Wang and Claude Opus 4.7 on May 1, 2026, during which the operator repeatedly corrected the LLM's misreadings of UNITARES's affordances. Hermes-via-Codex (gpt-5.5 at xhigh reasoning) provided an independent critique of related skill-writing during the session that surfaced several of the lines of evidence used in §3.

The phrase "EISV is the baby in the UNITARES bathwater" is the operator's. The structural argument that an antithesis paper should be published alongside the original rather than the original retracted is also the operator's, and is the right epistemic move.

## References

(To be completed in v0.2.)

Wang, K. (2026). *UNITARES: Information-Theoretic Governance of Heterogeneous Agent Fleets.* Concept DOI 10.5281/zenodo.19647159.
