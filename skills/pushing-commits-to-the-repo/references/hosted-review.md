# Hosted review

Read the repository configuration before waiting on anything: required checks, required reviewers,
and any review bot live in branch protection, `CONTRIBUTING.md`, or the workflow files.

## What counts as a required review

- Required for both same-repository and fork PRs, unless the repository states otherwise.
- Clean means an approval on the current head with no open comments from that reviewer on that head.
- A green check from the reviewer's workflow is not the same as a clean verdict.
- A human approval does not substitute for a required bot review, and the reverse is also true.

## Waiting

- Start the wait as a background command; do not poll in a turn. A wait loop that exits on new
  activity is enough:

  ```bash
  for i in $(seq 1 60); do
    gh pr view <n> --json reviews,comments | grep -q '"reviews":\[[^]]' && exit 0
    sleep 30
  done
  exit 0
  ```

- While a run holds the branch, do not push and do not resolve threads.
- If a review lands on an older head, capture the new SHA and restart the loop.
- When nothing lands after the timeout, say so and hand the PR back; do not invent a verdict.

## Agent-configuration guard

Many review bots refuse a PR that edits instruction files (`AGENTS.md`, `CLAUDE.md`,
`.github/`, `.dsh/`, `docs/`) because the PR could rewrite the reviewer's instructions.

- A red check caused by that guard is the guard working. Do not retry it.
- When the author has write or admin access, the guard is usually skipped.
- Otherwise ask a maintainer to authorize the review of those paths; a label or dispatch tied to a
  write-access event is the usual mechanism.
- Treat a refusal as an unsatisfied gate, not a passing one.
