# TPR-025 Plan: First 还施水阁 Inner Marker Interaction

## Scope

Planning only. No Lua, scene, config, gameplay, asset, battle, companion, or
engine files were changed.

Inputs reviewed:

```text
docs/tpr_extraction/TPR_023_SHUIGE_BEHAVIOR_AFTER_TRIGGER_PLAN.md
docs/tpr_extraction/TPR_018_OPENING_REWARD_ITEM_AUDIT.md
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
```

Current baseline:

```text
entry trigger: jshyl_shuige_entry
entry event id: 5204
entry quest: qqzj_protagonist_opening_shuige_entry

inner marker: jshyl_shuige_inner_marker
unlock flag: qqzj_protagonist_opening_shuige_inner_marker_unlocked
unlock mechanism: jyx2_FixMapObject moves marker from off-map to visible same-scene position
current issue: marker is still bound to 5204, so it repeats entry behavior
```

## 1. Should The Marker Become Interactive?

Yes, but it should become a distinct interaction, not another copy of the 5204
entry gate.

Recommended change:

```text
jshyl_shuige_entry -> 5204 -> qqzj_protagonist_opening_shuige_entry
jshyl_shuige_inner_marker -> 5206 -> qqzj_protagonist_opening_shuige_inner
```

Reasoning:

```text
1. 5204 owns the doorway/entry state and unlocks the marker.
2. The inner marker should represent the first step inside 还施水阁.
3. Keeping both objects on 5204 makes repeated interaction ambiguous and makes
   future chest/reward binding harder to reason about.
```

## 2. Proposed Event Id

Use event id:

```text
5206
```

Why `5206`:

```text
5200 opening chain
5201 双儿 rest
5202 silver chest
5203 阿朱 entry hint
5204 true ShuiGe entry gate
5205 侍剑 training
5206 first ShuiGe inner marker interaction
```

Required file for implementation:

```text
Assets/Mods/jshyl/Lua/5206.lua
```

Thin dispatcher:

```lua
JSHYL.QQZJ.Quest.Run("qqzj_protagonist_opening_shuige_inner")
do return end
```

## 3. Dialogue-Only First?

Yes. The first inner marker interaction should be dialogue/flags only.

Recommended content:

```text
双儿/旁白 confirms the player has stepped into the inner 水阁 area.
The game records that preliminary sorting / 整理物品 has happened.
It explicitly says chests and silver settlement are still deferred.
```

Do not implement in this slice:

```text
teleport
scene transition
silver deduction
item rewards
chest opening
battle
companion changes
```

This keeps the first marker interaction small and independently verifiable.

## 4. Chest Rewards: Safe, Missing, Deferred

Safe exact ids from current config:

| reward | id | status |
|---|---:|---|
| 九转熊蛇丸 | 16 | exact id exists; safe later for 阿碧-room chest x20 |
| 银两 | 174 | exact id exists; safe later for silver chest variants |

Missing exact source items:

```text
海月清辉
九霄环佩
天书竹简
朱颜碧
缀玉华裳
湖畔舞剑图
```

Underspecified/deferred:

```text
各门派暗器 x20 each
```

Existing thrown weapon ids `96-105` are available primitives, but the source
does not yet define the exact set well enough for a source-faithful chest.

Recommendation:

```text
Do not grant any ShuiGe chest reward in TPR-026. Plan a later TPR item/config
slice for exact source items, then a separate chest-binding slice.
```

## 5. Silver Deduction

Defer `-3000` silver.

Reason:

```text
1. Existing implemented rewards add 银两 id 174, but a negative AddItem flow has
   not been verified as safe.
2. The current player-facing flow already says silver settlement is deferred.
3. Charging silver before chest/reward behavior exists would create cost without
   source-complete payoff.
```

Future plan:

```text
Audit money APIs separately.
If silver item id 174 supports negative quantities safely, implement:
qqzj_protagonist_opening_shuige_entry_silver_paid
only after entry and inner marker interactions are stable.
```

## 6. Proposed Quest Id And Flags

Quest:

```text
qqzj_protagonist_opening_shuige_inner
```

Event:

```text
event id: 5206
event file: Assets/Mods/jshyl/Lua/5206.lua
scene object: jshyl_shuige_inner_marker
```

Gate after:

```text
qqzj_protagonist_opening_shuige_inner_marker_unlocked
```

Flags:

```text
qqzj_protagonist_opening_shuige_inner_started
qqzj_protagonist_opening_shuige_inner_dialogue_seen
qqzj_protagonist_opening_shuige_inner_preparation_seen
qqzj_protagonist_opening_shuige_inner_completed
```

Do not add yet:

```text
qqzj_protagonist_opening_shuige_entry_silver_paid
qqzj_protagonist_opening_shuige_rewards_center_claimed
qqzj_protagonist_opening_shuige_rewards_abi_chests_claimed
```

## 7. Scene Edit Requirements

Required scene edit for the next implementation:

```text
Change jshyl_shuige_inner_marker m_InteractiveEventId from 5204 to 5206.
```

No new scene object is required.

Do not change:

```text
jshyl_shuige_entry
jshyl_azhu_hint
jshyl_yanzi_treasure
jshyl_shijian_training
jshyl_abi_hint / 10000
```

Validation expectation:

```text
Unity start-scene event Lua validation will require Assets/Mods/jshyl/Lua/5206.lua
to exist before the scene is considered valid.
```

## 8. Acceptance Criteria

For the next implementation slice:

```text
1. After 5204 unlocks the inner marker, the marker uses event id 5206.
2. 5206.lua dispatches to qqzj_protagonist_opening_shuige_inner.
3. Interacting with the marker displays first inner ShuiGe dialogue.
4. The quest sets started, dialogue_seen, preparation_seen, and completed flags.
5. Repeated marker interaction branches to already-prepared dialogue.
6. No silver is deducted.
7. No item or chest rewards are granted.
8. No teleport or scene transition occurs.
9. Save/load preserves the inner interaction flags.
10. Existing 5200/5201/5202/5203/5204/5205/10000 triggers remain bound.
11. Unity start-scene event Lua validation passes.
```

## Recommended Implementation Prompt

```text
Proceed with TPR-026: implement first 还施水阁 inner marker dialogue.

Read:
docs/tpr_extraction/TPR_025_SHUIGE_INNER_MARKER_INTERACTION_PLAN.md

Allowed:
- Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
- Assets/Mods/jshyl/Lua/5206.lua
- Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- config edits
- new maps
- teleport/scene transition
- item rewards
- silver deduction
- chest rewards
- battles
- companions
- engine C#

Requirements:
1. Change jshyl_shuige_inner_marker to interactive event id 5206.
2. Create 5206.lua as a thin dispatcher.
3. Add qqzj_protagonist_opening_shuige_inner.
4. Gate after qqzj_protagonist_opening_shuige_inner_marker_unlocked.
5. Dialogue/flags only.
6. Set:
   - qqzj_protagonist_opening_shuige_inner_started
   - qqzj_protagonist_opening_shuige_inner_dialogue_seen
   - qqzj_protagonist_opening_shuige_inner_preparation_seen
   - qqzj_protagonist_opening_shuige_inner_completed
7. Do not deduct silver.
8. Do not grant rewards.
9. Do not teleport.
10. Update docs/backlog.
```
