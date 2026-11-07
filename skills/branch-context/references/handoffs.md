# Handoffs

A handoff carries the work from one session to the next. Write it for an agent that has this
repository, this branch, and none of your conversation.

## Write one

```bash
~/.dsh/skills/branch-context/append-handoff.sh [--writer <skill>] "<summary>" [body.md]
```

- `--writer` tags the index line when a skill owns the handoff.
- Omit the body path and the script prints a stub to fill with `write` or `edit`. Prefer writing
  the body first and passing its path.
- Calling it again in the same session amends your handoff: same file, same index line.

## Body sections

```markdown
# Handoff · YYYY-MM-DD · <summary>

## Done
- ...

## Next
- ... (ordered; the first item is where the next agent starts)

## Commitments and constraints carried forward
- ... (verbatim, or "none")

## Key paths
- `path` — why

## Open questions
- ... (or "none")

## Branch-context pointers
- Brief: issue-brief.md (still valid? yes/no)
- Decisions appended this session: <titles or "none">
- Plan file, if any: <path>
```

**Commitments and constraints is a required check, not an optional extra.** Sweep the session for
two things and quote them verbatim:

- Constraints the user stated that are not already in the brief's Constraints section. Modality is
  the payload: "always X unless Y" and "always X" are different instructions.
- Promises you made and have not kept, to the user or on the record in a PR or review comment. A
  promise dropped across a session boundary is the expensive kind: the next agent cannot know it.

A longer, accurate handoff beats a short lossy one.

## Lanes

- Each entry stores an immutable `lane-id` from `$DSH_SESSION_ID`, then `$CLAUDE_CODE_HOST_SESSION_ID`
  or `$CODEX_THREAD_ID`, then tmux. `$HANDOFF_LANE` overrides all of them.
- Without a lane identity `append-handoff.sh` refuses to write. Set `HANDOFF_LANE` when the harness
  exports no session id.
- Several agents can share one worktree and index. `latest-handoff.sh` matches only the exact lane.
- Labels live in `handoffs/.lanes` as `<id> <label>`; rename one there without changing ownership.
- A new session or fork gets a new id. Copy the `Successor lane: HANDOFF_LANE=<id>` line the script
  prints into the continuation prompt, and tell the successor to pass it:

  ```bash
  HANDOFF_LANE=<id> ~/.dsh/skills/branch-context/latest-handoff.sh
  ```

  Never tell a successor to read the newest entry.

## Turning the session over

1. Write the remaining work as a concrete plan: next steps, files, verification.
2. Persist: unlogged decisions, then the handoff body, then the index update.
3. Tell the user to start a new session in this worktree, and give them the preserved lane id.
   DeepSeek Harness does not clear context for you; a compaction keeps this conversation and is not
   a handoff.

When the user asks for a handoff without turning the session over, do step 2 only.
