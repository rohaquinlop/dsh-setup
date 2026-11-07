# Checklists

## Integration surfaces to check

| Surface | Question |
|---|---|
| Input parsing | Does every documented shape parse, including empty and malformed? |
| Output or serialization | Is the roundtrip lossless for the fields the change touches? |
| Streaming | Does the change behave the same in a streamed and a non-streamed path? |
| Errors | Does the new path surface a clear error rather than a generic one? |
| Configuration | Does a new option have a default, validation, and docs? |
| Compatibility | Does an old caller keep working without changes? |
| Docs | Is the user-facing doc updated with the behavior? |
| Tests | Does a test fail without the change, and cover every new branch? |

## Evidence to cite

- Protocol or provider docs: URL plus the section name.
- Project docs: file path plus heading.
- Current behavior: the test name or the code path.
- Historical decision: PR number and comment URL.

A claim without a source is an opinion; label it as one.

## When not to widen the PR

- The broader behavior is a product decision nobody has made.
- The fix needs a schema or protocol change the repository has not approved.
- The wider work belongs to a different area with different reviewers.
- The issue itself is invalid; say so instead of building on it.

In each case, record the decision and the reason, and link the follow-up.
