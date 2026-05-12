# 024_SAVE_AND_STATE.md

## Goal

Persist narrative state using the existing game save system.

## Important Correction

Do not implement a new save system by default.

Use:

```lua
SetFlagInt(...)
ModifyEvent(...)
```

and existing map state mechanisms.

## State Categories

### Persistent Through Flags

```text
quest started/completed/failed
route selected/locked
character joined/left
major branch choices
unique item obtained
```

### Persistent Through Map Events

Use `ModifyEvent` when a scene trigger should change permanently.

Examples:

```text
disable used trigger
change interaction script
hide/show object on re-entry
```

### Persistent Through Dynamic Scene Object Calls

Use for visual state during current scene:

```lua
jyx2_ReplaceSceneObject(...)
```

If state must survive re-entry, also back it with flags and Start() initialization.

## Scene Start Rehydration

Each scene's `Start()` function should:

1. read QQZJ flags
2. show/hide dynamic objects
3. bind or disable events
4. restore NPC availability
