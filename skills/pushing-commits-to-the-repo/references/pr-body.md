# Title, body, and labels

## Title

Follow the repository's convention, not a personal one. If the repository states a format in
`AGENTS.md`, `CONTRIBUTING.md`, or its PR template, that format wins. Otherwise use a short
imperative title and the conventional prefix the repository already uses in history:
`git log --oneline -20`.

## Body

Start with the closing reference, immediately after any required template header:

```markdown
Closes #<issue>
```

Then, in this order:

1. **What changed.** Two to five lines of prose. What behavior is different for a user.
2. **How it was verified.** The exact checks and their results. Test names when they are specific.
3. **Decisions.** A collapsed section built from `.dsh/branch-context/pr-decisions.md`. Include the
   dated entries and the session ids. Leave out confidential reasoning; the section is public.
4. **Scope notes.** What the PR deliberately does not do, and why, when a reader would ask.
5. **Follow-ups.** Issues filed for out-of-scope work, linked.

Follow the template's mandatory sections when it has them. Do not invent a section the template
already covers.

## Call-path diff, when it earns its place

A short before/after of the changed call chain helps a review of behavior changes. Include it when
the changed path explains the behavior better than prose does, and only one form of it: not both a
summary and a call-path diff.

## Labels

- Read the repository's labels first: `gh label list --limit 200`.
- Apply one package or area label when the repository uses them. For a change spanning areas,
  choose the one whose users the change serves.
- Apply the change-type label (`bug`, `feature`, `docs`, `chore`, `refactor`) when it exists.
- Never set size labels; automation owns them.
- Labelling needs triage permission. If it fails, quote the real error instead of concluding you
  lack permission.

## Assignee and reviewers

- Assign the human who owns the work when the user named one.
- Request review only from people or teams the repository asks for. Do not add a reviewer just to
  move the PR.
