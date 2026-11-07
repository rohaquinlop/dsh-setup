#!/usr/bin/env bash
# Move this setup between a harness home and this repository.
#   ./sync.sh push    copy the live setup here, rewrite machine paths, scan, show git status
#   ./sync.sh pull    copy this repository into the live setup (overwrites live files)
#   ./sync.sh check   scan this repository for secrets and personal paths
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DSH_HOME="${DSH_HOME:-$HOME/.dsh}"
PROFILE="${DSH_PROFILE:-desktop}"
ACTION="${1:-}"

usage() {
  cat <<'USAGE'
Usage: ./sync.sh push|pull|check

  DSH_HOME     Harness home (default: ~/.dsh)
  DSH_PROFILE  Profile name (default: desktop)

  push   copy live skills and profile files here, rewrite the bundle path,
         run the secret scan, then print git status
  pull   copy this repository into the live setup, overwriting live files
  check  run the secret scan only
USAGE
}

case "$ACTION" in
  push)
    [ -d "$DSH_HOME/skills" ] || { echo "error: $DSH_HOME/skills does not exist" >&2; exit 1; }
    [ -d "$DSH_HOME/profiles/$PROFILE" ] || { echo "error: profile $PROFILE does not exist" >&2; exit 1; }

    rm -rf "$ROOT/skills"
    mkdir -p "$ROOT/skills"
    cp -R "$DSH_HOME/skills/." "$ROOT/skills/"

    mkdir -p "$ROOT/profiles/$PROFILE"
    for file in cordis.patch.yml cordis.yml pnpm-workspace.yaml; do
      source="$DSH_HOME/profiles/$PROFILE/$file"
      [ -f "$source" ] && cp "$source" "$ROOT/profiles/$PROFILE/$file"
    done

    if [ -f "$DSH_HOME/profiles/$PROFILE/package.json" ]; then
      sed -E 's|("dsh-shepherd"[[:space:]]*:[[:space:]]*"link:)[^"]*(")|\1__DSH_SHEPHERD__\2|' \
        "$DSH_HOME/profiles/$PROFILE/package.json" > "$ROOT/profiles/$PROFILE/package.json"
    fi

    "$ROOT/scripts/scan-secrets.sh"
    echo
    echo "Repository status:"
    git -C "$ROOT" status --short
    echo
    echo "Review the diff, then commit and push."
    ;;
  pull)
    [ -d "$ROOT/skills" ] || { echo "error: run this from the repository root" >&2; exit 1; }
    echo "Copying the repository into $DSH_HOME (existing live files are overwritten)."
    "$ROOT/install.sh" --force
    ;;
  check)
    "$ROOT/scripts/scan-secrets.sh"
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac
