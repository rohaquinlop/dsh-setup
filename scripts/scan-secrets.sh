#!/usr/bin/env bash
# Fail when the tree contains a likely secret, credential file, or absolute home path.
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

status=0

echo "1. forbidden file names"
for pattern in '*.pem' '*.key' 'id_rsa*' '.env' '.env.*' 'credentials*' '*.p12' '*.pfx'; do
  while IFS= read -r file; do
    [ -z "$file" ] && continue
    echo "   found: $file"
    status=1
  done < <(git ls-files -co --exclude-standard | grep -Ei "${pattern//\*/.*}" || true)
done

echo "2. secret-shaped strings"
if git ls-files -co --exclude-standard -z | xargs -0 grep -nIE \
  'sk-[A-Za-z0-9]{16,}|gh[pousr]_[A-Za-z0-9]{16,}|AKIA[0-9A-Z]{16}|BEGIN [A-Z ]*PRIVATE KEY|https://[^ ]*:[^ ]*@' 2>/dev/null; then
  status=1
fi

echo "3. absolute home paths and email addresses"
if git ls-files -co --exclude-standard -z | xargs -0 grep -nIE \
  '/Users/[A-Za-z0-9._-]+|/home/[A-Za-z0-9._-]+|[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' 2>/dev/null; then
  status=1
fi

if [ "$status" -eq 0 ]; then
  echo "clean: no secret, credential file, absolute home path, or email found"
else
  echo "review the lines above before committing" >&2
fi
exit "$status"
