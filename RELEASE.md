# UNITARES v6 — Release Artifacts

This file collects the metadata you'll paste into Zenodo and GitHub when releasing the paper. Edit numbers/text where flagged `<<EDIT>>` before submitting.

---

## Zenodo upload

### Files to upload
- `unitares-v6.pdf` — the compiled paper
- `unitares-v6.tex` — LaTeX source (optional but appreciated)
- `figures/` directory (optional; the PDF includes them inline)

### Metadata (fill into Zenodo's web form)

**Upload type:** Publication → Preprint

**Title:**
```
UNITARES: Information-Theoretic Governance of Heterogeneous Agent Fleets
```

**Authors:**
- Kenny Wang, Independent Researcher, CIRWEL Systems
  - ORCID: `<<EDIT — paste your ORCID if you have one, otherwise leave blank>>`

**Description:** (paste the abstract verbatim)
```
We present UNITARES, a governance framework for heterogeneous fleets of autonomous AI agents. Each agent carries a four-dimensional state vector x = (E, I, S, V)^T intended to support continuous governance rather than discrete after-the-fact filtering. The central design constraint is heterogeneity: the populations we govern include embodied agents with sensor-driven state, persistent autonomous services, session-bounded coding assistants, and ephemeral parser agents. These do not share an output modality, a tempo, or a healthy operating point, so fleet-wide normalization is the wrong target.

UNITARES addresses this with two structural moves. First, it reinterprets the EISV coordinates in information-theoretic terms: S as response-distribution entropy, I as context-response mutual information, E as negative variational free energy or a resource-rate proxy, and V as an accumulated free-energy residual. Second, it makes normalization class-conditional: scale constants and healthy operating points are functions of an agent class keyed on existing identity tags, with fleet-wide defaults retained only as fallback behavior.

Because UNITARES was already deployed, re-grounding the coordinates raised a live-systems problem in addition to a mathematical one. We therefore introduce a pipeline-ordering migration mechanism that preserves governance behavior while allowing grounded values to populate canonical response fields. Stability of the dynamics is preserved under the reformulation and established by contraction analysis (Appendix B).

We illustrate the framework with a production deployment snapshot from February 20, 2026, covering 903 registered agents and 75 active agents. These results should be read as partial deployment evidence for the framework and migration strategy, not as full empirical validation of the class-conditional grounding. Per-class calibration results and higher-tier estimators (logprob and multi-sample) are deferred to subsequent work.
```

**Publication date:** `2026-04-18` (or the date you actually upload)

**Keywords:**
```
autonomous governance
information theory
variational free energy
heterogeneous multi-agent systems
class-conditional calibration
AI safety
free energy principle
Shannon entropy
```

**License:** Creative Commons Attribution 4.0 International (CC-BY 4.0)

**Communities (optional):** none — independent researcher

**Related identifiers:** if you have GitHub URLs once released:
- `Is supplemented by` → `https://github.com/CIRWEL/unitares` (the codebase)
- `Is supplement to` → `https://github.com/CIRWEL/unitares-v3-or-similar` (if you Zenodo v3/v5 separately, link them)

**Notes (optional, internal):**
```
Phase 1 of the EISV grounding program. Phase 2 calibration appendix forthcoming.
Supersedes v5 (Contraction-Theoretic Governance of Autonomous Agent Thermodynamics).
```

---

## GitHub release in CIRWEL/unitares

### Tag name
```
paper-v6.0
```

### Release title
```
Paper v6: Information-Theoretic Governance of Heterogeneous Agent Fleets
```

### Release notes (paste into GitHub's release-body box)

```markdown
## Paper release: UNITARES v6

26-page paper introducing two structural reframings of UNITARES:

1. **Information-theoretic grounding** of the EISV state vector — S as Shannon entropy, I as mutual information, E as negative variational free energy, V as accumulated free-energy residual, with tiered computation recipes and provenance-tagged scale constants.
2. **Class-conditional calibration** as a first-class design constraint — fleet-wide normalization is rejected; scale constants and healthy operating points are functions of an agent class keyed on identity tags.

Methodologically, the paper introduces a **pipeline-ordering migration mechanism** for re-grounding the semantic coordinates of a deployed framework without changing live governance behavior. The mechanism is presented as a reusable pattern beyond UNITARES itself.

### What's in this release

- `unitares-v6.pdf` — the paper (26 pages)
- `unitares-v6.tex` — LaTeX source
- `figures/` — 6 figures (PDF + PNG @ 300dpi) carried over from v5, all from the Feb 20, 2026 production snapshot
- `NOTES.md` — working notes on the v6 reorganization
- `RELEASE.md` — this file

### Companion DOI

If a Zenodo DOI is minted for this release, it appears here: `<<EDIT — paste DOI URL after Zenodo upload>>`

### What this release is and isn't

This is a **framework + migration paper**, not a fully validated empirical paper. The class-conditional calibration protocol is specified; the per-class empirical constants are not yet reported. Tier-1 (logprob) and tier-2 (multi-sample) computation paths are stubbed pending plugin-side instrumentation. Phase 2 calibration data and the calibration appendix follow in subsequent work.

### Building the PDF

```bash
cd unitares-v6
pdflatex unitares-v6.tex
pdflatex unitares-v6.tex   # second pass for cleveref/bib resolution
```

Required packages: amsmath, amssymb, mathtools, bm, graphicx, booktabs, hyperref, cleveref, natbib, xcolor, caption. Standard TeX Live install covers everything.

### License

Paper text and figures: CC-BY 4.0
Code in CIRWEL/unitares: see repository LICENSE
```

---

## Post-upload steps (one-time)

After Zenodo issues a DOI:

1. **Update the GitHub release notes** — paste the Zenodo DOI URL into the placeholder.

2. **Update the paper's bibliography** — replace the `wang2026unitares-v3` and `wang2026unitares-v5` bibitem stubs in `unitares-v6.tex` with actual URLs (or DOIs if you Zenodo v3/v5 too). Recompile and re-upload to both Zenodo and GitHub.

3. **Optional — submit to a workshop.** Workshops that accept independent-researcher submissions without academic affiliation include:
   - NeurIPS SafeAI workshop
   - ICML Workshop on Trustworthy ML
   - AAAI workshops (varies by year)
   Direct submission, no arXiv prerequisite. Worth doing once the paper has matured through one or two reading passes.

4. **Optional — request arXiv endorsement.** Once a sympathetic reviewer engages substantively with the paper, ask if they can endorse you in `cs.MA` or `cs.LG`. One endorsement unlocks unrestricted future submissions. Don't lead with this ask; let it come up naturally.

---

## Commands you'll run (when ready)

```bash
# 1. Upload to Zenodo via web UI (no CLI; their API requires a token Kenny doesn't yet have).
#    Browse to: https://zenodo.org/uploads/new

# 2. GitHub release — assuming the unitares repo has a papers/ directory already:
cd /Users/cirwel/projects/unitares
mkdir -p papers/v6
cp /Users/cirwel/projects/docs/unitares-v6/unitares-v6.{tex,pdf} papers/v6/
cp -r /Users/cirwel/projects/docs/unitares-v6/figures papers/v6/
cp /Users/cirwel/projects/docs/unitares-v6/NOTES.md papers/v6/
cp /Users/cirwel/projects/docs/unitares-v6/RELEASE.md papers/v6/
git add papers/v6/
git commit -m "paper(v6): Information-Theoretic Governance of Heterogeneous Agent Fleets"
git push
gh release create paper-v6.0 \
  --title "Paper v6: Information-Theoretic Governance of Heterogeneous Agent Fleets" \
  --notes-file papers/v6/RELEASE-notes.md \
  papers/v6/unitares-v6.pdf
```

Note: split the GitHub release-body section above into a separate `RELEASE-notes.md` file before running `gh release create`, since the full RELEASE.md has Zenodo metadata mixed in that doesn't belong on the GitHub release page.
