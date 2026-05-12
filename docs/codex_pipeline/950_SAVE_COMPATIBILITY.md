# 950_SAVE_COMPATIBILITY.md

# Save Compatibility

## Goal

Ensure narrative expansion does not break existing JYNew saves.

## Compatibility Strategy

Use versioned additive save data.

```yaml
base_save:
  existing_data: unchanged

narrative_extension:
  version: 1
  world_flags: {}
  quest_states: {}
  event_history: []
```

## Migration Rules

### Version 0 to Version 1

If narrative extension is missing:

```text
Create empty narrative extension
Initialize default flags
Do not alter player inventory unless required
```

## Regression Checks

Codex should ensure:

- old save loads
- new save loads
- missing narrative fields are tolerated
- corrupt narrative data logs error and falls back safely if possible

## Acceptance Criteria

- No existing save is invalidated.
- Narrative data is optional for old saves.
- New narrative state survives save/load.
