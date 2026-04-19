# UNITARES v6

**Information-Theoretic Governance of Heterogeneous Agent Fleets**

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19647159.svg)](https://doi.org/10.5281/zenodo.19647159)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC_BY_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

- 📄 [`unitares-v6.pdf`](./unitares-v6.pdf) — the paper (29 pages, latest tag `paper-v6.6`)
- 📝 [`unitares-v6.tex`](./unitares-v6.tex) — LaTeX source
- 🖼 [`figures/`](./figures/) — 6 figures from deployment data (Feb 20, 2026 snapshot; Apr 18, 2026 30-day window)

---

## What the paper argues

Governance of autonomous AI agents is usually assembled from output filters, dashboards, and post-hoc evaluators — each operating on a population the designer imagined as roughly homogeneous. UNITARES argues that this assumption fails once a real fleet is heterogeneous: embodied agents with sensor-driven state, persistent autonomous services, session-bounded coding assistants, and ephemeral parser agents do not share an output modality, a tempo, or a healthy operating point. Fleet-wide normalization is then the wrong target, and a governance framework that collapses the population to a single distribution — what we call *cosmological soup* — loses signal exactly where signal matters.

The paper makes two structural moves:

1. **Information-theoretic grounding of the EISV state vector** — `S` as Shannon entropy of the response distribution, `I` as mutual information between context and response, `E` as negative variational free energy, `V` as accumulated free-energy residual. Each coordinate ships with a tiered computation recipe (logprob, multi-sample, heuristic) and a provenance-tagged scale constant.

2. **Class-conditional calibration** — scale constants and healthy operating points are functions of an agent class, keyed on existing identity tags, with fleet-wide defaults retained only as fallback. Phase 2 measurement on five production classes (Lumen, Sentinel, Vigil, Watcher, default) over a 30-day window is reported in §11.5; per-class manifold radii span a 3.3× range, directly contradicting the fleet-wide assumption.

## The headline finding

A verdict counterfactual on a 13,310-row production slice (§11.6) shows that **28.9% of governance basin assignments flip** when the grounded class-conditional coherence replaces the legacy fleet-wide `tanh` form on the same state vectors. Flip rates range 15–33% per class, with a dominant directional bias into the `low` basin — the fleet-wide form was systematically permissive relative to tighter class envelopes. The homogenization-failure-mode argument has first-order consequences at the gating layer, not only at the reported-value layer.

## The methodological contribution

Re-grounding a deployed framework while service continues is a live-systems problem distinct from the mathematical one. §12 documents a **pipeline-ordering migration mechanism** that separates decision-producing from presentation-producing pipeline stages: governance verdicts fire on legacy values while the grounding computation runs as a post-verdict enrichment, so grounded values populate canonical response fields without changing live governance behavior. The mechanism generalizes beyond UNITARES — any deployed agent framework facing a semantic-coordinate change can apply it, given a request pipeline with explicit ordering between decision and presentation stages.

## Scope

The contraction analysis (Appendix B), the grounded coordinate definitions (§4), and the class-conditional calibration protocol (§8) are fully specified. The manifold-coherence path is measured per-class on production data. The `S_scale`, `I_scale`, `E_scale` constants — used only by the higher-fidelity tier-1 (logprob) and tier-2 (multi-sample) estimators — remain provenance-tagged placeholders awaiting inference-layer instrumentation. Per-class results in §11.5 are a descriptive measurement on the deployed system rather than a controlled validation study across stable parameter regimes; the paper flags this explicitly (§11.7).

## Reading aids

- **Variational free energy** (`−F`, used as the `E` coordinate) — the Free-Energy-Principle quantity measuring how well an agent's predictions match outcomes; high `E` = low surprise.
- **Cosmological soup** — the failure mode of averaging a heterogeneous agent fleet into a single state distribution, in which no population structure survives normalization.
- **Manifold coherence** (`C = 1 − ‖Δ‖₂ / ‖Δ‖_max`) — distance from the agent class's healthy operating point, used as a class-conditional replacement for the legacy `tanh`-of-`V` coherence.
- **Basin flip** — a change in governance-basin assignment (`high` / `boundary` / `low`) when the same state vector is classified under different coherence formulas.

## Companion code

The deployed governance system this paper describes:
- [CIRWEL/unitares](https://github.com/CIRWEL/unitares)

The grounding implementation (Phases 1+2 referenced in §12) was merged to `master` via [PR #26](https://github.com/CIRWEL/unitares/pull/26).

## Building the PDF

```bash
pdflatex unitares-v6.tex
pdflatex unitares-v6.tex   # second pass for cleveref and bibliography
```

Required packages: `amsmath`, `amssymb`, `mathtools`, `bm`, `graphicx`, `booktabs`, `hyperref`, `cleveref`, `natbib`, `xcolor`, `caption`.

## Citation

```bibtex
@article{wang2026unitares-v6,
  author    = {Wang, Kenny},
  title     = {{UNITARES}: Information-Theoretic Governance of Heterogeneous Agent Fleets},
  year      = {2026},
  publisher = {Zenodo},
  doi       = {10.5281/zenodo.19647159},
  url       = {https://doi.org/10.5281/zenodo.19647159},
  version   = {v6.6}
}
```

The concept DOI above resolves to the latest version; each tagged release (`paper-v6.0` through `paper-v6.6`) has its own version DOI.

## License

Paper text and figures: [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/)

## Author

Kenny Wang, Independent Researcher
[CIRWEL Systems](https://cirwel.com)
