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
# This script edits all three. It does NOT commit, tag, or push — the
# author retains control over the git history. Run it, review the diffs,
# then commit when satisfied.
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
# Three reference forms:
#   (a) "latest tag `paper-vX.Y`"   — the header pointer
#   (b) "{vX.Y}"                    — bibtex version field
#   (c) "through `paper-vX.Y`)"     — the range terminal
# (a) and (c) both match paper-vX.Y but in distinct phrases, so we target
# each with the surrounding literal to avoid clobbering the range start.
apply "$PAPER_REPO/README.md" \
    "s/latest tag \`paper-v[0-9]+\.[0-9]+(\.[0-9]+)?\`/latest tag \`${TAG}\`/g" \
    "s/\{v[0-9]+\.[0-9]+(\.[0-9]+)?\}/{${VERSION}}/g" \
    "s/through \`paper-v[0-9]+\.[0-9]+(\.[0-9]+)?\`\)/through \`${TAG}\`)/g"

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
echo "[sync] next: commit both repos, tag $TAG in the paper repo, push."
