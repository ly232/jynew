# 601_XAJH_CH1_FUZHOU.md

## Goal

Implement first 笑傲江湖 vertical slice in 福州.

## Quest ID

```text
xajh_ch1_001
```

## Required Files

```text
Lua/data/quests/xajh_ch1.lua
Lua/data/dialogues/xajh_ch1.lua
Lua/quests/xajh_ch1_handlers.lua
Lua/scenes/fuzhou.lua
```

## Required Flags

```text
qqzj_xajh_ch1_started
qqzj_xajh_ch1_completed
qqzj_xajh_lin_pingzhi_met
qqzj_xajh_qingcheng_ambush_defeated
```

## Quest Outline

1. Player enters 福州.
2. `Start()` initializes NPC visibility.
3. Player talks to 林平之.
4. Dialogue starts.
5. 青城派 ambush battle starts.
6. If battle won, set completion flags.
7. Modify map trigger to avoid repeat.
8. Optional reward.

## Required APIs

```lua
Talk
TryBattle
SetFlagInt
ModifyEvent
jyx2_ReplaceSceneObject
scene_api.BindEvent
```

## Acceptance Criteria

- Quest can be triggered from scene function.
- Dialogue appears.
- Battle can be invoked.
- Completion flag is set.
- Quest cannot repeat after completion.
