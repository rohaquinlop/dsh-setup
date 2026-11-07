---
name: complete-partial-pr
description: Evaluate and complete an issue or PR whose patch fixes only a narrow symptom of the reported problem. Use when asked "is this enough?", "what did the contributor miss?", or to improve a branch that may miss adjacent surfaces, protocol states, tests, docs, or historical decisions. Not a general code review.
---

# Complete a partial PR

Three things are separate:

1. The contributor's exact patch.
2. The user pain point behind the issue.
3. The contract the project should support.

Only the third decides the final shape. The patch is evidence, not the boundary.

## When it applies

- A patch fixes the reported error but not the rest of the user's workflow.
- A fix handles one data shape but not roundtrip semantics.
- A protocol has more states, fields, or variants than the patch covers.
- The user asks whether a contribution is enough, or asks you to improve the branch.
- History suggests the patch contradicts an earlier decision.

For a plain review, run `pre-push-review` instead. For a PR with no local context, run `adopt-pr`
first.

## Method

1. **Resolve the work item.** PR number or branch, its commits, its linked issues, and the current
   review threads. Write the user workflow that failed, the exact symptom fixed, the contract a
   user would reasonably expect, the variants that contract implies, and a deliberate non-goal.
2. **Verify the contract from sources**, not from the patch: the protocol or provider docs, the
   project's public API docs, and the existing tests that encode current behavior. Note versions.
3. **Map the surface.** Every place the same contract appears: loaders and serializers, request
   builders and response parsers, streaming paths, configuration, docs, and tests. A fix in one
   place that skips a sibling is the finding.
4. **Check history.** `git blame` and `git log` on the touched code, plus past PRs for the same
   symbol. A contradicting decision is a blocker until the user resolves it.
5. **Classify the gap**: required for correctness or the reported workflow, a regression test for
   behavior that must not silently change, nice to have, or out of scope.
6. **Decide.** Complete the contract unless the broader behavior is a separate product decision.
   For a public API, protocol, durable-behavior, or safety change with no settled answer, ask before
   coding. Record the decision with `branch-context`.
7. **Implement conservatively.** Match the repository's idiom and the narrowest correct surface.
   Add the test that fails without the change.
8. **Verify and hand to `pushing-commits-to-the-repo`** for review, push, and metadata. If you post
   a comment, say what the patch covered, what else you checked, what you added, which sources you
   used, and which tests ran.

## Output

End with: work item and branch, sources checked, historical decisions checked, surfaces covered,
tests added, commands run, and remaining non-goals.

## Delegation

Research lanes fit subagents: spec research, codepath mapping, history research, test-shape review.
Keep branch choice, synthesis, implementation, and push decisions local. Give each subagent one
narrow question and an exact output shape; require a source for every claim.
