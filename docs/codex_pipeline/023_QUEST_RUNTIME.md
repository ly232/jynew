# 023_QUEST_RUNTIME.md

## Goal

Implement data-driven quests in Lua.

## File

```text
Assets/Mods/jshyl/Lua/runtime/quest_runtime.lua
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
Assets/Mods/jshyl/Lua/data/quests/
```

Example:

```lua
JSHYL = JSHYL or {}
JSHYL.QQZJ = JSHYL.QQZJ or {}
JSHYL.QQZJ.Data = JSHYL.QQZJ.Data or {}
JSHYL.QQZJ.Data.Quests = JSHYL.QQZJ.Data.Quests or {}

JSHYL.QQZJ.Data.Quests["xajh_ch1_001"] = {
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

## Validated Vertical Slice Pattern

The first validated jshyl quest slice is:

```text
scene trigger -> Lua/10000.lua -> JSHYL.QQZJ.Quest.Run("qqzj_intro_abi_guidance")
```

Use this as the canonical pattern for future small quest slices.

### 1. Scene Trigger Dispatch

In a Unity scene, a `GameEvent` interaction trigger owns an interactive event id.
For the reference slice in `52_yanziwu`, the trigger points to:

```text
m_InteractiveEventId: 10000
```

Because jshyl uses the normal MOD Lua file pattern, interacting with that trigger executes:

```text
Assets/Mods/jshyl/Lua/10000.lua
```

Keep scene event files tiny. They should identify the quest and delegate.

### 2. Event File Delegation

Reference event file:

```lua
JSHYL.QQZJ.Quest.Run("qqzj_intro_abi_guidance")
do return end
```

Do not put reusable quest state machines directly in numbered event files once a flow has more than one step. Put the behavior under `JSHYL.QQZJ.Quest` or an explicitly namespaced quest module.

### 3. Named Quest Flags

Use clear, quest-scoped flags:

```text
qqzj_intro_abi_guidance_started
qqzj_intro_abi_guidance_reward_claimed
qqzj_intro_abi_guidance_sparring_won
qqzj_intro_abi_guidance_completed
```

Recommended shape:

```text
qqzj_{quest_id}_{stage}
```

For simple quests, prefer explicit stage flags over compressed numeric state. Explicit flags are easier to migrate, inspect in saves, and preserve across incremental slices.

### 4. Legacy Flag Preservation

When refactoring a previously shipped slice, never assume old save flags can be deleted.

For `qqzj_intro_abi_guidance`, the old Phase 2 flags are preserved and migrated:

```text
qqzj_phase2a_abi_intro_ack
qqzj_phase2b_abi_reward_claimed
qqzj_phase2c_abi_sparring_won
```

Safe migration rule:

1. Read legacy flags at quest start.
2. Copy old progress into new quest flags.
3. When setting equivalent new progress, also mirror the old flag if older saves or scripts may still inspect it.
4. Do not clear legacy success flags.

### 5. Reward Idempotency

Rewards must be guarded by a dedicated reward flag.

Reference reward:

```text
item id: 3
item name: 小还丹
count: 1
flag: qqzj_intro_abi_guidance_reward_claimed
api: AddItem(3, 1)
```

Pattern:

```lua
if not Flags.GetBool(rewardFlag) then
    AddItem(itemId, count)
    Flags.SetBool(rewardFlag, true)
end
```

Set the reward flag immediately after granting the item. Repeated interactions must branch to already-claimed dialogue and must not call `AddItem` again.

### 6. Optional Battle Victory Flags

Optional battles should use a separate victory flag and should not be forced on repeated interaction.

Reference battle:

```text
battle id: 7
battle name: 斗胡斐
flag: qqzj_intro_abi_guidance_sparring_won
api: TryBattle(7)
```

Pattern:

```lua
if Flags.GetBool(victoryFlag) then
    -- show completed dialogue
    return true
end

if Dialogue.YesNo("是否进行一次切磋？") then
    if TryBattle(battleId) then
        Flags.SetBool(victoryFlag, true)
        Flags.SetBool(completedFlag, true)
    end
end
```

Only set the victory flag when `TryBattle(...)` returns true. If the player declines or loses, leave the flag unset so the battle can be retried.

### 7. Save/Load Behavior

Quest state must be written through `JSHYL.QQZJ.Flags`, which wraps jynew's save-backed flag APIs.
Do not store authoritative quest progress in Lua globals only.

Validated save-backed state for the reference slice:

```text
started flag persists
reward claimed flag prevents duplicate 小还丹
sparring won flag prevents forced repeat battle
completed flag marks the slice done
```

Manual verification for future slices should include:

1. Trigger the interaction.
2. Claim the reward.
3. Repeat the interaction and confirm no duplicate reward.
4. Complete the optional battle.
5. Save and reload.
6. Repeat the interaction and confirm completed-state dialogue.

### 8. Future Slice Checklist

When adding the next quest slice:

1. Bind one scene trigger to one numbered Lua event file.
2. Keep the numbered Lua file as a thin dispatcher.
3. Register or implement a named `JSHYL.QQZJ.Quest` handler.
4. Define explicit stage flags before adding rewards or battles.
5. Guard every unique reward with an idempotency flag.
6. Set battle victory flags only after `TryBattle(...)` succeeds.
7. Preserve/migrate any old flags if refactoring existing content.
8. Smoke-load Unity and manually verify interaction, reward, battle return, repeat branch, and save/load.
