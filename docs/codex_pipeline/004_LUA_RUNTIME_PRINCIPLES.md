# 004_LUA_RUNTIME_PRINCIPLES.md

## Goal

Define how narrative runtime must be implemented under the official MOD model.

## Core Principle

The MOD runtime should use Lua, not newly compiled C#.

The developer manual explains that MODs use a Lua VM through xLua because packaged MODs need cross-platform execution inside the host app. Newly added C# code is not safe for normal MOD distribution unless it becomes part of the platform/app.

## Lua VM Model

Assume:

- One Lua VM per loaded MOD.
- Lua runs on the Unity main thread.
- Lua can call exposed Unity/C# APIs through existing bridges.
- Lua global namespace pollution is possible.
- MOD can define or override Lua functions.

## Lua File Types

### Lua Library Files

Loaded once at MOD startup through `Assets/Mods/jshyl/ModSetting.asset` / `PreloadedLua`.

Use for:

```text
Lua/jshyl_main.lua
Lua/jshyl_qqzj_runtime.lua
Lua/jshyl_qqzj_flags.lua
Lua/jshyl_qqzj_dialogue.lua
Lua/jshyl_qqzj_scene_api.lua
Lua/jshyl_qqzj_routes.lua
Lua/jshyl_qqzj_quest.lua
Lua/runtime/event_bus.lua
Lua/runtime/world_flags.lua
Lua/runtime/quest_runtime.lua
Lua/runtime/dialogue_runtime.lua
```

Recommended `PreloadedLua` ordering:

```text
jshyl_main
jshyl_qqzj_runtime
jshyl_qqzj_flags
jshyl_qqzj_dialogue
jshyl_qqzj_scene_api
jshyl_qqzj_routes
jshyl_qqzj_quest
```

### Scene/Quest Script Files

Called repeatedly by map events.

Use for:

```text
Lua/scenes/fuzhou.lua
Lua/quests/xajh_ch1.lua
```

## Async-Style Calls

Use existing APIs such as:

```lua
Talk(...)
ShowYesOrNoSelectPanel(...)
SetFlagInt(...)
ModifyEvent(...)
AddItem(...)
TryBattle(...)
TryBattleWithConfig(...)
jyx2_ReplaceSceneObject(...)
jyx2_PlayTimelineSimple(...)
jyx2_Wait(...)
```

## Namespacing Rule

All new global tables must be namespaced:

```lua
JSHYL = JSHYL or {}
JSHYL.QQZJ = JSHYL.QQZJ or {}
JSHYL.QQZJ.EventBus = {}
JSHYL.QQZJ.WorldFlags = {}
JSHYL.QQZJ.QuestRuntime = {}
```

Avoid generic globals such as:

```lua
EventBus = {}
QuestManager = {}
```
