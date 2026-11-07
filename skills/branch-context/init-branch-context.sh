#!/usr/bin/env bash
# Create the branch-context state for the current worktree.
# Idempotent: existing files are kept. Prints the state directory.
set -euo pipefail

HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WORKTREE="$(git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "error: not inside a git worktree" >&2
  exit 1
}
DIR="$WORKTREE/.dsh/branch-context"
mkdir -p "$DIR/handoffs"

copy_if_missing() {
  local template="$HERE/$1" target="$DIR/$2"
  [ -e "$target" ] && return 0
  cp "$template" "$target"
}

copy_if_missing issue-brief.template.md issue-brief.md
copy_if_missing pr-decisions.template.md pr-decisions.md
copy_if_missing handoffs-index.template.md handoffs-index.md

# Keep the state out of git without editing the team's ignore file.
COMMON="$(git -C "$WORKTREE" rev-parse --path-format=absolute --git-common-dir)"
mkdir -p "$COMMON/info"
grep -qxF '.dsh/' "$COMMON/info/exclude" 2>/dev/null || printf '%s\n' '.dsh/' >> "$COMMON/info/exclude"

echo "$DIR"
