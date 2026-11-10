---
name: init
description: Scan a project and generate or update its AGENTS.md with the tech stack, build, test, and lint commands, structure, and conventions. Load when the user says "init", "generate AGENTS.md", "update AGENTS.md", "create the agent context file", or asks for project context. Not for reading or explaining an existing AGENTS.md.
whenToUse: A repository has no AGENTS.md, or its AGENTS.md is stale.
---

# Init

Write an `AGENTS.md` that gives any agent enough context to work in this repo
without reading the whole tree.

The harness loads `AGENTS.md` from the project root down to the working
directory, so the file must stay useful and short.

## Phase 1 — Detect the project

- Manifests: `package.json`, `tsconfig.json`, `pyproject.toml`, `setup.py`,
  `Cargo.toml`, `go.mod`, `pom.xml`, `build.gradle`, `Gemfile`,
  `composer.json`, `mix.exs`.
- Framework config: `next.config.*`, `vite.config.*`, `astro.config.*`,
  `svelte.config.*`, `tailwind.config.*`, Django, Flask, FastAPI, Rails,
  Spring, Axum.
- Lockfiles decide the package manager: `package-lock.json`, `pnpm-lock.yaml`,
  `yarn.lock`, `bun.lockb`, `uv.lock`, `Cargo.lock`, `go.sum`.
- Monorepo markers: `pnpm-workspace.yaml`, `turbo.json`, `nx.json`, `lerna.json`,
  workspaces in `package.json`.

## Phase 2 — Find the commands

- `package.json` scripts: build, test, lint, dev, start, format, check,
  typecheck.
- `Makefile` targets.
- `pyproject.toml` `[tool]` sections: pytest, ruff, mypy, black.
- CI config: `.github/workflows/*.yml`, `.gitlab-ci.yml`, `Jenkinsfile`.
- `Dockerfile` and `docker-compose.yml`.

Copy the command as it is written in this repo. Never invent a script name.

## Phase 3 — Detect conventions

- Linter and formatter config: `.eslintrc*`, `eslint.config.*`, `.prettierrc*`,
  `ruff.toml`, `.flake8`, `clippy.toml`, `.rubocop.yml`, `.editorconfig`.
- Git hooks: `.husky/`, `.pre-commit-config.yaml`.
- Commit style: `commitlint.config.*`, `git log --oneline -n 20`.
- Contribution rules: `CONTRIBUTING.md`, `.github/PULL_REQUEST_TEMPLATE.md`.
- Existing context files: `AGENTS.md`, `CLAUDE.md`, `CODE_STYLE.md`.

## Phase 4 — Map the structure

- Top-level directories and their purpose.
- Entry points.
- Where tests live and how they are named.
- Two or three levels deep at most.

## Phase 5 — Write the file

```markdown
# {Project}

> {one-line description}

## Tech stack
- Language and version
- Framework
- Package manager
- Runtime

## Structure
```text
{annotated tree, two levels}
```

## Commands
```bash
{install}
{dev}
{build}
{test}
{lint and format}
```

## Conventions
- {linter and formatter rules that are not obvious}
- {commit style}
- {test location and pattern}

## Key files
- `{path}` — {purpose}

## Avoid
- {detected anti-patterns and CONTRIBUTING rules}
```

Rules:

- 80 to 200 lines for a normal project.
- Every command copy-pasteable.
- Self-contained: no link needed to understand the project.
- State what the scan could not detect instead of guessing.

## Phase 6 — Update an existing file

1. Read the current file first.
2. Keep custom sections that a scan cannot produce.
3. Refresh the sections where the scan is more accurate.
4. Never overwrite a project-specific rule.
5. If the user said "generate" without "update", ask before overwriting.

## Edge cases

| Case | Action |
|---|---|
| No file exists | Generate from scratch |
| `CLAUDE.md` exists | Read it, write `AGENTS.md`, mention the other file |
| Large monorepo | Ask for the subdirectory to scope |
| Almost empty repo | Write what exists, mark the rest as not detected |

## Report

Give the path written, the sections that came from the scan, and the ones left
for the user to confirm.
