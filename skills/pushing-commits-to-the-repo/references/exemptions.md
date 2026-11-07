# Exempt deltas and review scope

## Scope of one review

- The first substantive review assesses the full branch against its merge base.
- A follow-up assesses changes since the last reviewed tree, plus affected callers and invariants.
  It also checks that prior findings are fixed.
- Widen the scope for a substantive redesign, an upstream interaction, or an explicit request.
- The reviewer may widen the scope when the changed content requires it.
- A verdict belongs to reviewed content: record the commit and tree with the scope. A later HEAD
  with the same tree keeps the verdict.

## When a later push needs no new call

Classify the actual delta since the last **reviewed** SHA, not the last pushed one. Write the class,
the check you ran, and the reviewed SHA it chains from into `pr-decisions.md`.

| Exempt delta | Check |
|---|---|
| Test-only or fixture-only changes to established behavior | full diff is test code or data; cite the expectation; run the affected tests; a snapshot must not bless a new regression |
| Formatter or lint autofix output | run the tool on the reviewed SHA in a scratch checkout; its tree equals HEAD's |
| Comments or docstrings only | no non-comment line in `git diff <reviewed>..HEAD` |
| Target-branch merge with no conflict resolution | the diff against the old base equals the diff against the new base |
| Return to a tree that was already reviewed | `git rev-parse HEAD^{tree}` equals a recorded reviewed tree |
| Lockfile-only dependency bump | only lock and manifest paths changed |

Anything else re-reviews. Size is never the test.

Four deltas look exempt and are not:

- a re-recorded fixture whose request or payload changed;
- a conflict resolution inside an otherwise-exempt merge;
- a snapshot that accepts a newly observed regression;
- any public API change, including a rename.

Applying a review finding uses the same classification: an exact suggested edit is not an exemption.

## Prose-only documentation

A prose-only change touches natural-language text, including docstring prose. It excludes code,
examples, configuration, schemas, CI logic, machine-read data, and substantive instruction or
review-policy wording.

- Skip the pre-push gate and the additional-review question.
- Handle title, body, and labels directly.
- Keep CI and every hosted review that runs; triage comments already posted.
- Never edit workflows or triggers to use this exception.

## Mechanical refreshes

A mechanical text or data refresh changes no code, runtime behavior, CI logic, or policy wording,
such as regenerating a table from a script. Skip the local review and the second-opinion question.
Keep CI and hosted reviews.

## To claim a class not in this file

Write the rubric rung the delta could touch and why it cannot, in `pr-decisions.md`, before pushing.
