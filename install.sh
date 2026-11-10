#!/usr/bin/env bash
# Copy this setup into a DeepSeek Harness home. Existing files are kept unless --force.
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DSH_HOME="${DSH_HOME:-$HOME/.dsh}"
PROFILE="${DSH_PROFILE:-desktop}"
# The harness exports DSH_PROFILE for its own profile, so a run from a harness
# terminal inherits a name this repo may not ship. Fall back to the shipped one.
if [ ! -d "$ROOT/profiles/$PROFILE" ]; then
  echo "warn: profile '$PROFILE' is not in this repository; using desktop" >&2
  PROFILE=desktop
fi
SHEPHERD_PATH="${DSH_SHEPHERD_PATH:-$HOME/opensource-projects/dsh-shepherd}"
FORCE=0

usage() {
  cat <<'USAGE'
Usage: ./install.sh [--force]

  DSH_HOME           Harness home (default: ~/.dsh)
  DSH_PROFILE        Profile name (default: desktop)
  DSH_SHEPHERD_PATH  Checkout of dsh-shepherd (default: ~/opensource-projects/dsh-shepherd)
  --force            Overwrite existing files instead of skipping them
USAGE
}

for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    --help|-h) usage; exit 0 ;;
    *) echo "unknown argument: $arg" >&2; usage >&2; exit 2 ;;
  esac
done

command -v git >/dev/null 2>&1 || { echo "error: git is required" >&2; exit 1; }
[ -d "$ROOT/skills" ] || { echo "error: run this from the repository root" >&2; exit 1; }

copy_file() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] && [ "$FORCE" -ne 1 ]; then
    echo "skip (exists): $dst"
    return 0
  fi
  cp "$src" "$dst"
  echo "wrote: $dst"
}

echo "Installing into $DSH_HOME (profile: $PROFILE)"

mkdir -p "$DSH_HOME/skills"
for dir in "$ROOT"/skills/*/; do
  name="$(basename "$dir")"
  mkdir -p "$DSH_HOME/skills/$name"
  cp -R "$dir". "$DSH_HOME/skills/$name/"
  chmod +x "$DSH_HOME/skills/$name"/*.sh 2>/dev/null || true
  echo "skills: $name"
done

# The harness reads $DSH_HOME/AGENTS.md as the user-global instruction chain,
# before any project AGENTS.md.
if [ -f "$ROOT/AGENTS.md" ]; then
  copy_file "$ROOT/AGENTS.md" "$DSH_HOME/AGENTS.md"
fi

copy_file "$ROOT/profiles/$PROFILE/cordis.patch.yml" "$DSH_HOME/profiles/$PROFILE/cordis.patch.yml"
copy_file "$ROOT/profiles/$PROFILE/cordis.yml" "$DSH_HOME/profiles/$PROFILE/cordis.yml"
copy_file "$ROOT/profiles/$PROFILE/pnpm-workspace.yaml" "$DSH_HOME/profiles/$PROFILE/pnpm-workspace.yaml"

tmp="$(mktemp)"
sed "s|__DSH_SHEPHERD__|$SHEPHERD_PATH|g" "$ROOT/profiles/$PROFILE/package.json" > "$tmp"
copy_file "$tmp" "$DSH_HOME/profiles/$PROFILE/package.json"
rm -f "$tmp"

cat <<EOF

Next steps:
1. Install the matching bundle if it is missing:
   plugin_manager { action: "install_bundle", target: "$SHEPHERD_PATH" }
2. Restart the app, or let the profile reload.
3. Confirm: plugin_manager list_plugins shows the dsh-shepherd rows, and the skill catalog lists every skill in skills/.
EOF
