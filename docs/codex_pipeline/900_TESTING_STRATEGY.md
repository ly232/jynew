# 900_TESTING_STRATEGY.md

## Goal

Test the MOD using official workflow.

## Testing Modes

### Full MOD Test

Start Unity Editor, press Play, load platform, select MOD.

### Single Scene Test

Open a scene under:

```text
Assets/Mods/jshyl/Maps/GameMaps/
```

Press Play.

This can create a new save for testing the scene directly.

## Lua Hot Reload Caveat

Lua script files can often be modified in Editor without restarting the whole game.

However:

- Lua library files loaded at MOD initialization may require reload/restart.
- Config table changes may require restarting the game.

## Test Checklist

```text
[ ] scene loads
[ ] Start() runs
[ ] NPC appears correctly
[ ] trigger binds correctly
[ ] dialogue appears
[ ] battle starts if needed
[ ] flags update
[ ] re-entering scene restores state
[ ] quest cannot repeat if completed
```
