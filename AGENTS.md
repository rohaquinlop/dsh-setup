# Personal agent instructions

Personal machine, personal projects. Nothing here serves an employer. Claude
Code and Pi keep their own settings elsewhere; this file is the DeepSeek
Harness setting.

The harness loads this file once per session, before the project instructions.
A project `AGENTS.md` is more specific and wins where the two disagree.

## Response style

- The `i-have-adhd` skill owns the shape of a reply. Load it when the shape
  matters.
- Lead with the result or the decision. No preamble, no recap, no closers.
- One idea per sentence. Active voice. Bullets for two or more items.
- Never narrate tool use. Report only what changed, what was verified, and what
  failed.

## Scope

- Complete the task the codebase needs: tests, types, error handling, imports,
  wiring. Do not ship a knowingly weaker first pass.
- Stay inside the task's natural scope. No "while I'm here" refactors, renames,
  or doc rewrites that nobody asked for.
- Report an adjacent bug in one line. Do not fix it until I say so.
- When I ask for options or a comparison, list them and stop.
- Prefer the smallest correct diff. Comment only a non-obvious why, never what
  the code already says.

## Git

- Never commit, push, branch, amend, rebase, or reset unless I ask.
- Commit on the current branch. No new branch unless I ask.
- Conventional Commits. The `git-commit` skill owns message rules and staging.
- Stage only the files you touched. Never `git add .` or `git add -A`.
- Keep a manifest and its lockfile in one commit: `pyproject.toml` with
  `uv.lock`, `package.json` with its lockfile.
- No `Co-Authored-By` and no generated-with trailer.
- Never commit `.sdd/`, `.env`, credentials, or scratch files.
- `git fetch` before any branch comparison or merge.
- Every push runs through the `pushing-commits-to-the-repo` skill. Its review
  gate and push guard always apply.

## Python

- Use `uv`. Never call `python`, `python3`, `pip`, or `pip3` directly.
- Load the `uv` skill for the full command reference.
- Run a script with `uv run`, add a dependency with `uv add`, take a one-off
  dependency with `uv run --with`, run a tool with `uvx`, install a tool with
  `uv tool install`.
- Keep `uv.lock` committed. Never edit it by hand.
- Follow the existing toolchain of a project that already uses a different one.

## Verification

- Run the code path yourself instead of asking me to check it.
- Review your own diff before you say done, then fix what you find.
- Do not re-verify something you already verified directly.
- State a hypothesis as a hypothesis, then test it.
- Clean up the processes, containers, and temp files you started, and say so.

## Definition of done

- Run the project's own checks before you say done: the test, lint, and format
  commands written in its `AGENTS.md` or manifest.
- Never claim a check passed unless you read its output.
- If a check cannot run here, name it and say why.

## Bug fixes

- Reproduce the bug in a failing test before you change the code, when the
  project has a test suite.
- Fix the cause, not the symptom. Re-run the failing test and then the suite.

## Session start

- In a repository with `.dsh/branch-context/`, read the brief, the decisions
  log, and the latest handoff before you act.
- When a repository has no `AGENTS.md` and the work is more than a one-line fix,
  offer the `init` skill.

## Subagents

- Do not delegate implementation. Subagents are for read-only exploration or an
  independent review.
- Use direct tools when a handful of calls will do.
- Ask before spawning one for a large task.
- Ask for a short synthesised finding, never a file dump.

## Skills and docs

- Check the existing skills first. Match on overlap, not on name.
- Keep a skill portable: no company names, no private stack details, no
  hardcoded home paths.
- One consolidated skill beats two overlapping ones.
- Save generated docs in the repository, never in a scratch directory.
- The `init` skill writes a project's `AGENTS.md`.

## Working rules

- An ambiguous request gets one short question, not a list of assumptions.
- Load `plan-clarifier` when a plan needs more context before implementation.
- Use plan mode for multi-step work that needs my approval. Then implement,
  then verify.
- Never end an implementation turn on a status message. End it with DONE,
  BLOCKED, or FAILED, and name the validation that ran.
