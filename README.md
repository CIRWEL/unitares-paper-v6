# UNITARES v6

**Information-Theoretic Governance of Heterogeneous Agent Fleets**

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19647160.svg)](https://doi.org/10.5281/zenodo.19647160)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC_BY_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

Paper artifact repository for v6 of the UNITARES research program.

- 📄 [`unitares-v6.pdf`](./unitares-v6.pdf) — the paper (26 pages)
- 📝 [`unitares-v6.tex`](./unitares-v6.tex) — LaTeX source
- 🖼 [`figures/`](./figures/) — 6 figures, all from the production snapshot of February 20, 2026

## What this paper introduces

Two structural reframings of UNITARES:

1. **Information-theoretic grounding** of the EISV state vector — `S` as Shannon entropy of the response distribution, `I` as mutual information between context and response, `E` as negative variational free energy (or its resource-rate proxy), `V` as accumulated free-energy residual. Each coordinate ships with a tiered computation recipe (logprob, multi-sample, heuristic) and a provenance-tagged scale constant.

2. **Class-conditional calibration** as a first-class design constraint — fleet-wide normalization is rejected as the wrong target for heterogeneous deployments (embodied creatures, persistent autonomous services, session-bounded coding assistants, ephemeral parser agents). Scale constants and healthy operating points are functions of an agent class, keyed on existing identity tags, with fleet-wide defaults retained only as fallback behavior.

Methodologically, the paper introduces a **pipeline-ordering migration mechanism** that allows the semantic coordinates of a deployed governance framework to be re-grounded without changing live governance behavior during the transition. This mechanism is presented as a reusable pattern beyond UNITARES itself.

## What this paper is and isn't

This is a **framework + migration paper**. The class-conditional calibration protocol is specified; per-class empirical constants are not yet reported. Tier-1 (logprob) and tier-2 (multi-sample) computation paths are stubbed pending plugin-side instrumentation. Empirical class-conditional results are deferred to subsequent work.

The empirical content is a single **production snapshot of February 20, 2026** (903 registered agents, 75 active), described as partial deployment evidence — not as full empirical validation of the grounded framework.

## Companion code

The deployed governance system that this paper describes lives at:
- [CIRWEL/unitares](https://github.com/CIRWEL/unitares)

The Phase 1 grounding implementation referenced in §10 is on branch `feat/grounding-spec` (PR #26).

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
  version   = {v6.0.1}
}
```

The DOI above resolves to the latest version. The repository is mirrored at <https://github.com/CIRWEL/unitares-paper-v6>.

## License

Paper text and figures: [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/)

## Author

Kenny Wang, Independent Researcher
[CIRWEL Systems](https://cirwel.com)
