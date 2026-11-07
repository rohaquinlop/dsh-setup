# Artifacts

All under `.dsh/local-notes/<feature>-audit/` in the candidate worktree.

| File | Produced by | Content |
|---|---|---|
| `scope.md` | scoping subagent | Fact sheet: feature, providers, surfaces, components, stated scope |
| `research/<topic>.md` | one research subagent per topic | Sourced findings, versions, documented vs inferred |
| `research/practitioner.md` | practitioner subagent | Integrator pain points, failures, tuning, comparisons |
| `test-suite-design.md` | driver | T-numbered behavior catalog, performance targets, A-numbered requirements |
| `gaps/<area>.md` | one gap subagent per area | Covered, partial, missing, unimplemented?, unmapped tests |
| `review-items.md` | driver | Verified A and B findings |
| `draft-pr-comments.md` | draft subagents | One comment per accepted item, with precedent |
| `improvement-suggestions.md` | advocate subagent | Suggestions the driver accepted |

## Review item shape

```markdown
### A3 — <behavior> is not implemented for <provider>

- Evidence: <doc or code path>
- Expected: <behavior the user relies on>
- Proof command: <targeted test or repro>
- Precedent: <link>
- Minimal fix: <one sentence>
```

## Closing status table

| Phase | Artifact | State |
|---|---|---|
| Scope | scope.md | done |
| Research | research/ | done |
| Design | test-suite-design.md | done |
| Gap | gaps/ | done |
| Verify | review-items.md | done |
| Draft | draft-pr-comments.md | pending triage |
