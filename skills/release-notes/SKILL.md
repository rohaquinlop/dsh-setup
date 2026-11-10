---
name: release-notes
description: Write release notes for a new version from git history and the format of past releases, then optionally create the tag and publish the GitHub release. Load when the user asks for release notes, a changelog entry, or to publish a release.
whenToUse: A version is about to ship and the notes or the release do not exist yet.
---

# Release notes

Write the notes, save them, then publish only when asked.

## 1. Version and scope

- Use the version the user gives.
- Otherwise read the project's version file, compare it with the latest tag, and
  confirm what is unreleased.
- Classify as major, minor, or patch from the semver components.

```bash
git tag --sort=-v:refname | head -5
git log --oneline --no-merges <prev-tag>..HEAD
git log --format="%h %s" <prev-tag>..HEAD
git log -1 --format="%ci" <prev-tag>
git log --merges --format="%h %s" <prev-tag>..HEAD
```

If a version file disagrees with the request, check the log for bump and revert
commits before writing anything.

Merged PRs and new contributors:

```bash
gh pr list --state merged --base main --json number,title,author,mergedAt,url \
  --jq '.[] | select(.mergedAt > "<prev-tag-date>")'
gh pr list --state merged --json author --jq '[.[].author.login] | unique'
```

## 2. Match the past style

Read the last two or three releases before writing.

```bash
gh release view <prev-tag> --json body,tagName
```

Note the section names, whether a summary paragraph opens the notes, where the
PR list goes, whether new contributors get a section, and the Full Changelog
line at the end. Copy that shape.

## 3. Group the changes

| Prefix | Section |
|---|---|
| `feat` | Features |
| `fix` | Fixed |
| `perf` | Performance |
| `refactor` | Changed |
| `docs` | Documentation |
| `test` | Tests, or fold into Fixed |
| `build`, `chore`, `ci` | Chores |

Follow the most recent release when the section names differ.

## 4. Write the body

```
[One or two sentences of summary for a patch release]

## Features

- What changed, why it mattered, and the impact. (#42)

## Fixed

- ...

## PRs

- conventional-commit(scope): message by @author in <PR URL>

## New Contributors

- @user made their first contribution in <PR URL>

**Full Changelog**: <compare URL from prev tag to new tag>
```

Rules:

- A bullet says what changed and why. Do not repeat the commit subject.
- Backticks for code, paths, flags, and types.
- `(#NN)` inside a section, full link in the PR list.
- No emoji section markers unless the past releases use them.

Save the body to the project root as `RELEASE_NOTES_<version>.md` for review.
Report a short summary, then ask before publishing.

## 5. Tag and publish when asked

```bash
git log -1 --format="%H" main
git tag <version> <commit>
git push origin <version>
```

The tag must point at the current main commit, never a detached or stale one.

```bash
gh release create <version> -F - <<'BODY'
<notes body>
BODY
gh release edit <version> --title "<version>"
gh release view <version> --json name,tagName,url --jq '{name, tagName, url}'
```

Add `--draft` or `--prerelease` when the user asks.

## Edge cases

| Case | Action |
|---|---|
| No previous tag | Start from the first commit |
| Tag on a stale commit | Delete the tag and release, recreate on main |
| Release already exists | Check it, then ask before overwriting |
| No PRs in range | Group raw commit subjects by type |
| Several repositories | Use the current checkout's remote |

If the project dispatches releases to downstream repositories, check that each
one actually created a release, not only a tag:

```bash
gh release view <tag> --repo <owner/repo> --json tagName
```
