# 023_QUEST_RUNTIME.md

## Goal

Implement data-driven quests in Lua.

## File

```text
Assets/Mods/qingqingzijin/Lua/runtime/quest_runtime.lua
```

## Quest State

Use save-backed flags:

```text
qqzj_quest_{quest_id}_started
qqzj_quest_{quest_id}_completed
qqzj_quest_{quest_id}_failed
```

## Quest Data

Store quest definitions under:

```text
Assets/Mods/qingqingzijin/Lua/data/quests/
```

Example:

```lua
QQZJ_DATA_QUESTS["xajh_ch1_001"] = {
  title = "福州初遇",
  requirements = {
    all = { "qqzj_intro_completed" },
    none = { "qqzj_xajh_ch1_completed" }
  },
  steps = {
    { type = "dialogue", id = "dlg_xajh_001" },
    { type = "battle", id = 10001 },
    { type = "reward_item", item_id = 42, count = 1 },
    { type = "set_flag", key = "qqzj_xajh_ch1_completed", value = 1 }
  }
}
```

## Supported Step Types

```text
dialogue
battle
dynamic_battle
reward_item
set_flag
modify_event
replace_scene_object
play_timeline
wait
dark_scene
light_scene
call_lua
```

## Mapping To Existing APIs

Use existing functions:

```lua
Talk
TryBattle
TryBattleWithConfig
AddItem
SetFlagInt
ModifyEvent
jyx2_ReplaceSceneObject
jyx2_PlayTimelineSimple
jyx2_Wait
DarkScence
LightScence
```
