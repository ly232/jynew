# 024_SAVE_SYSTEM.md

# Narrative Save System

## Goal

Extend the existing JYNew save system to persist narrative state without breaking existing saves.

## Required Narrative Save Data

```yaml
narrative_save_version: 1

world_flags:
  lin_pingzhi_met: true

quest_states:
  xajh_ch1_fuzhou: Completed

event_history:
  - event_id: EVT_000001
    event_type: QUEST_STARTED

route_states:
  xajh:
    selected_route: righteous
    locked_routes:
      - dark
```

## Save Compatibility Rules

### Must Do

- Add versioning.
- Use optional fields.
- Handle missing narrative state gracefully.
- Provide migration hooks.

### Must Not Do

- Do not remove existing save fields.
- Do not change existing IDs.
- Do not force old saves to fail.
- Do not serialize scene-object references directly.

## Rebuild Strategy

On load:

```text
Load existing base save
Load narrative snapshot
Restore world flags
Restore quest states
Optionally replay event history for validation
```

## Migration Strategy

If old save has no narrative state:

```text
Initialize narrative system with default flags
Set intro_completed based on existing player state if inferable
```

## Acceptance Criteria

- Existing saves load.
- New narrative saves load.
- World flags restore.
- Quest states restore.
- Event history can be inspected.
