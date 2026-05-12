# TPR Extraction Framework

## Goal

The final goal is complete implementation of the TPR wiki content at:

```text
https://tpr.inkit.cc/start
```

inside the jshyl MOD (`Assets/Mods/jshyl/**`).

This directory is for planning, extraction, coverage tracking, and implementation backlog only. It must not contain gameplay code, Lua files, Unity assets, or copied wiki prose.

## Current Coverage

Current implementation status is only the Phase 2 vertical slice:

```text
qqzj_intro_abi_guidance
scene event: 10000.lua
scope: local 阿碧 dialogue/reward/battle pattern validation
```

That slice validates the technical quest pattern, but it is not counted as TPR story coverage.

## Coverage Unit

Every TPR wiki page is treated as one implementation unit.

Each page must be inventoried, extracted into quest/backlog records, implemented in jshyl, verified in Unity, then marked complete in the coverage tracker.

## Status Values

Use only these statuses:

```text
not_inventoried
inventoried
extracted
implemented
verified
```

Meaning:

```text
not_inventoried = page known to exist, but not entered as a structured row yet
inventoried = page has a row in PAGE_INVENTORY.md
extracted = quest graph/data has been extracted into implementation-ready tasks
implemented = gameplay files have been created/updated
verified = Unity/manual or automated testing confirms the page works end to end
```

## Future Workflow

Process TPR one page at a time:

```text
one page -> extract quest graph -> implement -> verify -> mark coverage
```

For each page:

1. Add or update the page row in `PAGE_INVENTORY.md`.
2. Extract page content using `QUEST_EXTRACTION_SCHEMA.md`.
3. Add actionable tasks to `IMPLEMENTATION_BACKLOG.md`.
4. Implement only the next smallest playable slice.
5. Verify in Unity.
6. Update `COVERAGE_TRACKER.md`.

## Files

```text
README.md
PAGE_INVENTORY.md
QUEST_EXTRACTION_SCHEMA.md
IMPLEMENTATION_BACKLOG.md
COVERAGE_TRACKER.md
```

## Important Rule

Do not treat a page as implemented because a similar local test exists. The Phase 2 阿碧 slice proves the architecture, not the TPR route content.
