# 900_TESTING_STRATEGY.md

# Testing Strategy

## Goal

Make narrative content testable and regression-safe.

## Test Types

### Runtime Unit Tests

- event bus emits events
- reducers update flags
- condition evaluator works
- quest state transitions work

### Content Validation Tests

Validate YAML/JSON:

- IDs are unique
- referenced dialogue exists
- referenced battle exists
- referenced item exists or has fallback
- route locks are valid
- no impossible requirements

### Playtest Smoke Tests

For each chapter:

```text
start quest
run required dialogue
complete battle
complete quest
save game
load game
verify flags
```

## Debug Tools

Codex should add editor/debug tools:

```text
PrintWorldFlags
PrintQuestStates
ForceStartQuest
ForceSetFlag
ReplayNarrativeEvents
ValidateNarrativeContent
```

## Acceptance Criteria

- Narrative content can be validated without full manual playthrough.
- Save/load can be smoke-tested.
- Broken references are caught early.
