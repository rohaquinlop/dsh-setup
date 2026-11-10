---
name: plan-clarifier
description: Review a plan from a file, pasted text, issue, or rough idea; find the missing context; ask targeted multiple-choice questions with the recommended answer first; then write an implementation-ready brief. Load before implementing an unclear feature, refactor, or migration.
whenToUse: The user asks to clarify a plan, or a request is too vague to implement safely.
---

# Plan clarifier

Turn an incomplete plan into enough context for safe implementation.

## 1. Load and summarise

Read the file, use the pasted text, or infer cautiously from partial context.
Then output, short:

```
## Understood
- Goal:
- Current plan:
- Known constraints:
- Main unknowns:
```

## 2. Decide whether to ask

Ask only when the missing context changes the implementation. Skip obvious
defaults and low-impact details.

Priority order:

1. Expected behavior.
2. Scope boundaries.
3. Data model and API contracts.
4. Interaction and UX detail.
5. Compatibility, migration, rollout.
6. Error handling.
7. Testing and acceptance criteria.
8. Performance, security, operational risk.

## 3. Ask in one batch

Use `ask_user_question` with the whole round at once. Never drip questions one
per message.

- Three to seven questions per round. Fewer is better.
- Put the recommended option first and mark it recommended.
- Allow multiple answers only where choices can combine.
- Give concrete options with a one-line tradeoff.
- Ask "why it matters" only in the option description, not in the question.
- Include a "decide for me" option when a safe default exists.

If the question tool is unavailable, write the same questions as a numbered
markdown list with lettered options and a `Recommended` marker.

## 4. Process the answers

- Map each selection to a decision.
- Keep an authored answer exactly as written.
- Resolve a contradiction by asking only about the conflict.
- Stop asking once the context is sufficient.
- Otherwise ask one more short round.

Keep a decision log:

```
## Decisions
- <question>: <decision>
## Assumptions delegated to the agent
- <assumption>
```

## 5. Write the brief

```
## Implementation brief
### Goal
### Scope
In:
Out:
### Decisions
### Assumptions
### Acceptance criteria
### Risks
### Steps
### Tests
```

Then ask: implement now, save the brief, or refine further.

## Interaction

- `A`, `B`, `A+C` select options.
- `1:A 2:C` selects per question.
- `author:` or free text is a custom answer.
- `dig deeper` asks a narrower follow-up on that item.
- `you decide` takes the recommendations and records them as assumptions.
- `skip` leaves an item open only when it is safe, otherwise say why it is not.
- `done` or `make brief` writes the brief with the current assumptions.

## Quality bar

- High-signal questions, not a questionnaire.
- Default to the option that cuts scope and risk.
- Do not write code until the context is enough or the user delegates.
- Surface risky assumptions.
- Keep the output compact.
