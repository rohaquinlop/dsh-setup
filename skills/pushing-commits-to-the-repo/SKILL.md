---
name: pushing-commits-to-the-repo
description: Open and advance a PR — write current metadata, apply the bounded pre-push review gate and its exemptions, push, watch CI, and triage comments. Use whenever you open a PR or push a commit.
---

# Pushing commits to the repository

One change, one PR, one review loop. The local review gate runs before every push; the hosted
gates run after it. This skill owns the loop, the merge bar, and the PR metadata. Detail lives in
`references/`; read the one a step names.

## Model tiers

- Drive the PR on the strong model. A PR needs judgment across the diff, CI, and review threads.
- Use the light model for the metadata check and for scouting reviews.
- Pass the model explicitly when the dispatch accepts one, and set effort from the PR's complexity.

## Merge bar

The user merges. You never merge, and you never enable auto-merge unless the user asks.

A PR satisfies the bar when, on the current head:

- every required check passes, including coverage;
- every required review is present and clean (repository configuration decides which);
- every review thread is resolved or answered, and every finding is fixed or refuted with evidence;
- the title, body, and labels match the change.

When the repository configures a size-based bar, read its rules instead of inventing one. An
obviously trivial PR still needs green CI; do not use that exception unless the repository states it.

## Open the PR

1. Push the branch, then create the PR against the target branch:
   `gh pr create --base <target> --title <title> --body-file <file>`.
2. Title and body follow the repository's template and conventions; see `references/pr-body.md`.
   Put every closing reference (`Closes #N`) at the start of the body.
3. Publish the decisions from `.dsh/branch-context/pr-decisions.md` in a collapsed section. It is
   public: leave out confidential reasoning, keep session ids.
4. Apply the labels the repository defines; read them with `gh label list --limit 200`. Apply one
   package or area label when the repository uses them. Never set size labels; they are automatic.
5. Assign the human who owns the work when the user named one.

## Pre-push review gate

Run the `pre-push-review` skill before every push. It owns the reviewer contract, the scope, and the
budget: three review calls per round plus one verify call.

- Record each call in `pr-decisions.md` with the reviewed commit and tree.
- When the budget is spent, fix the last findings, run the verify call, and triage it on the record.
- A delta that is exempt needs no call; see `references/exemptions.md`. Compute it from the last
  **reviewed** SHA, not the last pushed one, and record the class and its check.
- Never use the implementing agent as the reviewer. Never treat the gate as test execution.
- Attempt the push. If it fails, read the real error; do not infer a rule from metadata.

## After the push

Capture the head SHA. Every gate below must prove it covered that SHA; if the head moves, capture
the new one and restart the loop.

1. **Sync metadata.** Update title, body, verification, and the decisions section for the pushed
   commit. The local decisions log is authoritative.
2. **Watch CI.** Require the repository's CI workflow to succeed for the captured SHA; a green run
   certifies its jobs. Start the watch as a background command and end the turn:
   `gh pr checks <n> --watch --interval 30`. Do not poll.
3. **Wait for required hosted review**, when the repository configures one. See
   `references/hosted-review.md`. Do not substitute a local review for a required one.
4. **Triage every comment**, bot or human. See `references/triage.md`.
5. Stop when checks are green, required reviews are clean, and threads are settled on the current
   head. Report the PR URL, what changed, what ran, reviews used, and what remains for the user.

## Hand back

Run the final metadata check after CI and review comments settle: title, body, and labels against
this skill, the repository's `AGENTS.md`, and the PR template. Dispatch a fresh subagent on the
light model when the repository is large or the metadata is contested; otherwise check it yourself.
Committed changes restart the loop; metadata-only edits do not.

## Never

- Merge, enable auto-merge, force-push an open PR branch, or rewrite pushed history.
- Push while a review run holds the branch.
- Edit CI or review workflows to satisfy a gate.
- Silently ignore a comment or close a thread without a reply.
