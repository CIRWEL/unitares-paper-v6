#!/usr/bin/env bash
# sync-paper-version.sh — bump version references across paper + companion repos
#
# When a new paper-v6.N is being tagged, three files hold the previous version
# string and need to stay in sync:
#
#   1. CITATION.cff                           (this repo)
#   2. README.md                              (this repo)
#   3. README.md                              (companion unitares repo)
#
# This script edits files only. It does NOT commit, tag, push, or cut
# releases — the author retains control over git and GitHub state.
# Run it, review the diffs, then run the full release ritual yourself.
#
# Full release ritual (what this script is one step of):
#
#   1. ./scripts/sync-paper-version.sh vX.Y     # this script
#   2. Review diffs, rebuild PDF, commit both repos
#   3. git tag -a paper-vX.Y -m "..."
#   4. git push && git push origin paper-vX.Y
#   5. gh release create paper-vX.Y --latest \
#          --title "Paper vX.Y: ..." --notes-file <path>
#
# Step 5 is load-bearing for citation: the .github/workflows/zenodo-publish.yml
# workflow triggers on Release events (NOT on tag pushes) and is what mints the
# new Zenodo version DOI. A tag without a corresponding Release leaves the
# concept DOI pointing at the last properly-released version — the Zenodo
# badge will silently go stale.
#
# The workflow uploads BOTH the source archive and unitares-v6.pdf as
# top-level files on Zenodo, so the PDF is previewable directly on the
# record page (the prior Zenodo-GitHub integration only attached the source
# zip, burying the PDF inside it). Pre-flight: ensure unitares-v6.pdf is
# rebuilt and committed at the release tag.
#
# Usage:
#   ./scripts/sync-paper-version.sh v6.7
#   ./scripts/sync-paper-version.sh v6.7 --dry-run
#
# The companion repo path defaults to /Users/cirwel/projects/unitares; override
# with UNITARES_REPO=/other/path.

set -euo pipefail

usage() {
    cat <<EOF
usage: sync-paper-version.sh <version> [--dry-run]

  <version>     New paper version (e.g. 'v6.7' or '6.7'; both accepted)
  --dry-run     Print what would change without modifying files

environment:
  UNITARES_REPO  Path to companion unitares repo
                 (default: /Users/cirwel/projects/unitares)
EOF
    exit 2
}

[[ $# -lt 1 ]] && usage

RAW="${1:-}"
DRY_RUN=0
shift
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=1 ;;
        *) echo "unknown flag: $1" >&2; usage ;;
    esac
    shift
done

# Normalize: 'v6.7' and '6.7' both become 'v6.7'
VERSION="v${RAW#v}"
if [[ ! "$VERSION" =~ ^v[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
    echo "invalid version '$RAW' — expected vMAJOR.MINOR (e.g. v6.7)" >&2
    exit 2
fi
TAG="paper-${VERSION}"
TODAY="$(date -u +%Y-%m-%d)"

PAPER_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UNITARES_REPO="${UNITARES_REPO:-/Users/cirwel/projects/unitares}"

if [[ ! -f "$PAPER_REPO/CITATION.cff" ]]; then
    echo "CITATION.cff not found at $PAPER_REPO — wrong directory?" >&2
    exit 1
fi
if [[ ! -f "$UNITARES_REPO/README.md" ]]; then
    echo "unitares README not found at $UNITARES_REPO — set UNITARES_REPO env var" >&2
    exit 1
fi

echo "[sync] target:  $TAG (version=$VERSION, date=$TODAY)"
echo "[sync] paper:   $PAPER_REPO"
echo "[sync] runtime: $UNITARES_REPO"
[[ $DRY_RUN -eq 1 ]] && echo "[sync] DRY RUN — no files will change"
echo

# Use sed with extended regex and in-place edit. The patterns below target
# distinct contexts so we do not accidentally rewrite historical ranges like
# "paper-v6.0 through paper-v6.6" incorrectly.

apply() {
    local file="$1"; shift
    if [[ $DRY_RUN -eq 1 ]]; then
        echo "[dry] would edit $file"
        for pat in "$@"; do echo "       $pat"; done
        return 0
    fi
    for pat in "$@"; do
        # BSD sed needs -i '' on macOS; use -i.bak then rm for portability
        sed -E -i.bak "$pat" "$file"
    done
    rm -f "$file.bak"
    echo "[ok] $file"
}

# ─── 1. CITATION.cff ────────────────────────────────────────────────────
apply "$PAPER_REPO/CITATION.cff" \
    "s/^version: \".*\"/version: \"${VERSION}\"/" \
    "s/^date-released: .*/date-released: ${TODAY}/"

# ─── 2. Paper README.md ─────────────────────────────────────────────────
# Reference forms to update:
#   (a) "latest tag `paper-vX.Y`"                      — backtick header pointer
#   (b) "latest tag [`paper-vX.Y`](...)"               — markdown-linked header pointer
#   (c) "{vX.Y}"                                       — bibtex version field
#   (d) "through `paper-vX.Y`)"                        — range terminal
#   (e) "Latest: paper-vX.Y" badge alt-text            — shields.io image label
#   (f) "latest-paper--vX.Y-" shield URL slug          — shields.io encodes `-` as `--`
#   (g) "/releases/tag/paper-vX.Y" URL path            — GitHub release link
# (a)/(b)/(d) all mention the tag but in distinct phrases; each pattern is
# anchored by its surrounding literal to avoid clobbering historical
# version-history lines or the range start in "v6.0 through v6.N".
apply "$PAPER_REPO/README.md" \
    "s/latest tag \`paper-v[0-9]+\.[0-9]+(\.[0-9]+)?\`/latest tag \`${TAG}\`/g" \
    "s/latest tag \[\`paper-v[0-9]+\.[0-9]+(\.[0-9]+)?\`\]/latest tag [\`${TAG}\`]/g" \
    "s/\{v[0-9]+\.[0-9]+(\.[0-9]+)?\}/{${VERSION}}/g" \
    "s/through \`paper-v[0-9]+\.[0-9]+(\.[0-9]+)?\`\)/through \`${TAG}\`)/g" \
    "s/Latest: paper-v[0-9]+\.[0-9]+(\.[0-9]+)?/Latest: ${TAG}/g" \
    "s/latest-paper--v[0-9]+\.[0-9]+(\.[0-9]+)?-/latest-paper--${VERSION}-/g" \
    "s|/releases/tag/paper-v[0-9]+\.[0-9]+(\.[0-9]+)?|/releases/tag/${TAG}|g"

# ─── 3. Unitares README.md ──────────────────────────────────────────────
# Single reference form: "latest: `paper-vX.Y`"
apply "$UNITARES_REPO/README.md" \
    "s/latest: \`paper-v[0-9]+\.[0-9]+(\.[0-9]+)?\`/latest: \`${TAG}\`/g"

echo
if [[ $DRY_RUN -eq 1 ]]; then
    echo "[sync] dry run complete — no changes written"
    exit 0
fi

echo "[sync] done. Review the diffs:"
echo "  (cd $PAPER_REPO && git diff -- CITATION.cff README.md)"
echo "  (cd $UNITARES_REPO && git diff -- README.md)"
echo
echo "[sync] remaining release ritual (do NOT skip the gh release step):"
echo "  1. rebuild PDF: (cd $PAPER_REPO && tectonic unitares-v6.tex)"
echo "  2. commit both repos"
echo "  3. (cd $PAPER_REPO && git tag -a $TAG -m \"Paper $VERSION: <tagline>\")"
echo "  4. (cd $PAPER_REPO && git push && git push origin $TAG)"
echo "  5. gh release create $TAG --repo CIRWEL/unitares-paper-v6 --latest \\"
echo "       --title \"Paper $VERSION: <tagline>\" --notes-file <path>"
echo
echo "[sync] why step 5 matters: Zenodo mints the version DOI on Release"
echo "       events, not on tag pushes. Skipping it leaves the badge stale."
