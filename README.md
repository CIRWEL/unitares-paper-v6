# UNITARES v6

**Information-Theoretic Governance of Heterogeneous Agent Fleets**

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19647160.svg)](https://doi.org/10.5281/zenodo.19647160)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC_BY_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

Paper artifact repository for v6 of the UNITARES research program.

- 📄 [`unitares-v6.pdf`](./unitares-v6.pdf) — the paper (29 pages)
- 📝 [`unitares-v6.tex`](./unitares-v6.tex) — LaTeX source
- 🖼 [`figures/`](./figures/) — 6 figures from production deployment data (Feb 20, 2026 snapshot and Apr 18, 2026 30-day window)

## What this paper introduces

Two structural reframings of UNITARES:

1. **Information-theoretic grounding** of the EISV state vector — `S` as Shannon entropy of the response distribution, `I` as mutual information between context and response, `E` as negative variational free energy, `V` as accumulated free-energy residual. Each coordinate ships with a tiered computation recipe (logprob, multi-sample, heuristic) and a provenance-tagged scale constant.

2. **Class-conditional calibration** as a first-class design constraint — fleet-wide normalization is rejected as the wrong target for heterogeneous deployments (embodied creatures, persistent autonomous services, session-bounded coding assistants, ephemeral parser agents). Scale constants and healthy operating points are functions of an agent class, keyed on existing identity tags, with fleet-wide defaults retained only as fallback behavior.

Methodologically, the paper introduces a **pipeline-ordering migration mechanism** (§12) that allows the semantic coordinates of a deployed governance framework to be re-grounded without changing live governance behavior during the transition. This mechanism is presented as a reusable pattern beyond UNITARES itself.

## Headline empirical finding

A **verdict counterfactual on a 13,310-row production slice** (§11.6) shows that 28.9% of basin assignments flip when the grounded class-conditional coherence replaces the legacy fleet-wide `tanh` form on the same state vectors, with flip rates ranging 15–33% per class and a dominant direction into the `low` basin. This is direct empirical support for the homogenization-failure-mode argument: a fleet-wide constant chosen to span the worst-case envelope is necessarily permissive relative to the tighter envelopes of specific classes.

## What this paper is and isn't

This is a **framework + migration paper**. Its primary claims are architectural and methodological: that heterogeneous fleets require class-conditional calibration, that the EISV coordinates can be reinterpreted information-theoretically without changing the governing dynamics, and that a deployed governance system can be re-grounded by separating decision-producing from presentation-producing stages in the request pipeline.

Three boundaries matter. First, the class-conditional calibration protocol is specified (§8), and the manifold-coherence path is measured on five agent classes over a 30-day production window (§11.5). Second, the remaining `S_scale`, `I_scale`, `E_scale` constants — used only by the higher-fidelity tier-1 (logprob) and tier-2 (multi-sample) estimators — remain provenance-tagged placeholders awaiting inference-layer instrumentation. Third, the production results in §11 are a descriptive snapshot of the deployed system rather than a controlled validation study across stable parameter regimes.

The paper should therefore be read as establishing the framework, the migration mechanism, and the shape of the empirical program, while deferring full class-conditional validation to subsequent work.

## Reading aids

Four terms the paper uses up front:

- **Variational free energy** (`−F`, used as the `E` coordinate) — the Free-Energy-Principle quantity measuring how well an agent's predictions match outcomes; high `E` = low surprise.
- **Cosmological soup** — the failure mode of averaging a heterogeneous agent fleet into a single state distribution, in which no population structure survives normalization.
- **Manifold coherence** (`C = 1 − ‖Δ‖₂ / ‖Δ‖_max`) — distance from the agent class's healthy operating point, used as a class-conditional replacement for the legacy `tanh`-of-`V` coherence.
- **Basin flip** — a change in governance-basin assignment (`high` / `boundary` / `low`) when the same state vector is classified under different coherence formulas.

## Companion code

The deployed governance system that this paper describes lives at:
- [CIRWEL/unitares](https://github.com/CIRWEL/unitares)

The grounding implementation (Phases 1 + 2 referenced in §12) was merged to `master` via [PR #26](https://github.com/CIRWEL/unitares/pull/26).

## Building the PDF

Standard LaTeX install (TeX Live or MacTeX) covers all dependencies:

```bash
pdflatex unitares-v6.tex
pdflatex unitares-v6.tex   # second pass for cleveref/bibliography resolution
```

Required packages: `amsmath`, `amssymb`, `mathtools`, `bm`, `graphicx`, `booktabs`, `hyperref`, `cleveref`, `natbib`, `xcolor`, `caption`.

## Citation

```bibtex
@article{wang2026unitares-v6,
  author    = {Wang, Kenny},
  title     = {{UNITARES}: Information-Theoretic Governance of Heterogeneous Agent Fleets},
  year      = {2026},
  publisher = {Zenodo},
  doi       = {10.5281/zenodo.19647160},
  url       = {https://doi.org/10.5281/zenodo.19647160},
  version   = {v6.5}
}
```

The concept DOI above resolves to the latest version; each tagged release (`paper-v6.0` through `paper-v6.5`) has its own version DOI.

## License

Paper text and figures: [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/)

## Author

Kenny Wang, Independent Researcher
[CIRWEL Systems](https://cirwel.com)
