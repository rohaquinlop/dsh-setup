---
name: git-commit
description: Commit message conventions and commit execution rules. Load before running any git commit, staging files, or writing a commit message. Covers Conventional Commits, one commit per concern, lockfile pairing, and what never goes into a commit.
whenToUse: The user asks to commit, stage, or group changes.
---

# Git commits

Conventional Commits, one concern per commit.

```
<type>(<scope>): <short description>
```

## Types

| Type | Use for |
|---|---|
| `feat` | new behavior |
| `fix` | bug fix |
| `refactor` | no behavior change, no bug fix |
| `perf` | performance |
| `test` | tests only |
| `docs` | documentation only |
| `build` | build system, dependencies |
| `ci` | CI configuration |
| `chore` | maintenance |

## Scope

One word, taken from this repository's own vocabulary: a directory, a module, a
package, or a service name that already exists here. Do not import a scope from
another project. Use `deps`, `config`, `ci`, or `docs` for cross-cutting work.
Omit the scope only when the change truly spans many modules.

## Description

- Lowercase, no closing period.
- Imperative mood: "add retry logic", not "added retry logic".
- About 70 characters or fewer.
- Enough context to understand the change without reading the diff.

Examples:

```
feat(api): add payload validation on ingestion
fix(auth): handle expired tokens without crashing
refactor(worker): extract batch processing into a private method
build(deps): upgrade requests to 2.32.0
docs(config): document required environment variables
```

## Grouping

1. List the changed files with `git status --short`.
2. Read the diffs with `git diff` and `git diff --staged`.
3. Group by concern. Each group gets one type and one scope.
4. Commit foundational changes before the changes that consume them.
5. Stage explicit paths, or hunks with `git add -p`.

```bash
git add lib/rate_limiter.py
git commit -m "feat(lib): add rate limiter"

git add api/handler.py
git commit -m "feat(api): apply the rate limiter to incoming requests"
```

Never `git add .` or `git add -A` unless the user explicitly asks for one commit
of every change and the diff has been read.

Pair a manifest with its lockfile in one commit: `pyproject.toml` with
`uv.lock`, `package.json` with its lockfile, `Cargo.toml` with `Cargo.lock`,
`go.mod` with `go.sum`.

## Execution rules

- Commit only when the user asks.
- Never push unless the user asks.
- Never amend, rebase, reset, or discard changes without explicit approval.
- Leave unrelated changes alone.
- If staged changes already exist, inspect them before staging more.
- If a hook fails, report it. Do not bypass the hook without approval.
- No AI co-author line and no generation footer.
- Never stage `.env`, credentials, backup files, or `.sdd/` artifacts.

## Avoid

```
fix: bug fix                     # vague
chore: changes                   # vague
feat(api): added passkey login   # not imperative
fix(worker): changed line 42     # restates the diff
feat(api): add search and update CI cache   # two concerns
```
