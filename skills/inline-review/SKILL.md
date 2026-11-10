---
name: inline-review
description: Review a GitHub pull request and post the findings as inline review comments through the gh-inline-review-comments extension. Writes pr-<N>-review-comments.md, then posts one review as comment, approve, or request-changes. Load when the user asks to review a PR with inline comments.
whenToUse: The user asks for an inline review of an existing PR.
---

# Inline PR review

Two phases: write the findings file, then post one review.

Never hardcode a repository or a path. Take both from the checkout or the user.

## Prerequisites

- `gh` authenticated.
- `gh extension list` shows `gh-inline-review-comments`. If it is missing, say
  so and stop:
  `gh extension install rohaquinlop/gh-inline-review-comments`.

## Inputs

| Input | Source | Default |
|---|---|---|
| PR number | user, or `gh pr view --json number` | the branch's PR |
| Repo | `git remote get-url origin` | current checkout |
| Verdict | user wording | `comment` |

| Phrase | Event |
|---|---|
| "request changes", "re-request changes" | `request-changes` |
| "approve" | `approve` |
| anything else | `comment` |

## Phase 1 — Context

```bash
gh pr view <N> --json number,title,headRefOid,body
gh pr diff <N>
```

Read the files around each candidate line and confirm the number against the
PR head (`headRefOid`). A line that is not in the diff gets a 422 from GitHub.
For a deleted line use `side: LEFT` with the old line number.

## Phase 2 — Write `pr-<N>-review-comments.md`

```markdown
# Review Comments — PR #<N> (<title>)

Line numbers refer to the PR head (`<sha>`). Ordered by severity.

---

## 1. <summary> (<severity>)

- filename: `<path>`
- line number: `<line>`
- comment: <what is wrong, why it matters, how to fix it. Include a fenced
  snippet when the fix is short. Point at an existing pattern in the repo.>
```

Rules:

- Order by severity: correctness and safety first, then missing tests and
  convention gaps, then nits.
- Each comment stands alone: no reference to another numbered comment.
- A finding on a file outside the diff is marked "PR-level" and goes into the
  review body.
- Keep the file after posting.

## Phase 3 — Post

Build a JSON array for the inline findings:

```jsonc
[
  {
    "path": "src/foo.py",
    "body": "<finding comment>",
    "line": 42,
    "side": "RIGHT",
    "start_line": 40,
    "start_side": "RIGHT"
  }
]
```

Post one review with every comment batched:

```bash
gh inline-review-comments create <N> \
  --input comments.json \
  --event <verdict> \
  --review-body "<PR-level findings only>" \
  --json
```

Review body rules:

- Only findings that cannot be anchored inline.
- One bullet per finding, the same content as the markdown file.
- No praise, no round narration, no commit SHAs, no CI status, no verdict
  restatement, no greeting.
- When every finding is inline, use the minimum body: the PR title or
  "See inline comments."

`--review-body` is required for `comment` and `request-changes`. Prefer
`--input -` with a heredoc over a temp file. Report `id`, `state`, and
`html_url` from the output.

## Errors

| Symptom | Action |
|---|---|
| 422 "line must be part of the diff" | Fix path, line, or side against `gh pr diff`, then retry |
| Extension missing | Give the install command and stop |
| No findings | Say so. Never post an empty review |

## Report

Name the file written, the number of inline comments, the verdict, and the
review URL.
