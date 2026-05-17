# TPR-013 Audit: 主角剧情：开局 Chain Consolidation

## Scope

Planning/audit only. No Lua, scene, config, map, battle, reward, companion, or
engine behavior was changed.

Inputs reviewed:

```text
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
docs/tpr_extraction/COVERAGE_TRACKER.md
docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md
Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
Assets/Mods/jshyl/Lua/5200.lua
Assets/Mods/jshyl/Lua/5201.lua
Assets/Mods/jshyl/Lua/5202.lua
Assets/Mods/jshyl/Lua/5203.lua
Assets/Mods/jshyl/Lua/5204.lua
Assets/Mods/jshyl/Lua/5205.lua
Assets/Mods/jshyl/Lua/10000.lua
Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
```

## 1. Playable Opening Beats

Playable through `5200.lua` / `jshyl_murong_opening`:

```text
1. qqzj_protagonist_opening_arrival
   - 慕容秋荻 opening dialogue
   - starting silver via AddItem(174, 10000)
   - save-backed arrival flags

2. qqzj_protagonist_opening_qiudi_guard
   - 孟星魂 assigned as story/bodyguard flag
   - 九转熊蛇丸 id 16 x10
   - save-backed guard/reward flags

3. qqzj_protagonist_opening_family_briefing
   - 二叔/三叔 narrative handoff
   - 杭州/开封 hook flags
   - no actual maps or tools unlocked

4. qqzj_protagonist_opening_brother_return
   - 大哥 return dialogue
   - verified partial medicine reward
   - save-backed reward flag
```

Playable through other existing bound triggers:

```text
10000.lua / jshyl_abi_hint
  - qqzj_intro_abi_guidance technical validation slice
  - not counted as TPR coverage

5201.lua / jshyl_shuanger_rest
  - 双儿 rest service, ad hoc Lua

5202.lua / jshyl_yanzi_treasure
  - single ad hoc chest, 银两 id 174 x30000

5203.lua / jshyl_azhu_hint
  - 阿朱 杭州/pouch hint, ad hoc dialogue

5205.lua / jshyl_shijian_training
  - 侍剑 training prompt
  - TryBattle(145)
  - grants 银两 id 174 x500 on victory
```

`5204.lua` exists as an 阿碧/水阁 hint, but no matching `52_yanziwu` trigger was
found in the current scene binding scan.

## 2. Reward Status

### Implemented Exactly Or As Verified Partial

| beat | reward | status | flag |
|---|---|---|---|
| opening arrival | 银两 id 174 x10000 | implemented, but money API semantics still worth later review | `qqzj_protagonist_opening_arrival_reward_claimed` |
| 秋荻托付 | 九转熊蛇丸 id 16 x10 | implemented exact verified item | `qqzj_protagonist_opening_qiudi_guard_reward_claimed` |
| 大哥归来 | 玉真散 id 5 x20 | implemented exact verified item | `qqzj_protagonist_opening_brother_return_reward_claimed` |
| 大哥归来 | 九转灵宝丸 id 14 x20 | implemented exact verified item | same as above |

### Partial Or Missing

| beat | reward | status |
|---|---|---|
| 秋荻托付 | 司南针 | missing exact item; not granted |
| 二叔/三叔 | 狼牙燕翎 | missing exact item; not granted |
| 二叔/三叔 | 秦皇照骨镜 | missing exact item; not granted |
| 二叔/三叔 | 洛阳铲 | missing exact item; not granted |
| 大哥归来 | 金创药 x20 | missing exact item; not granted |
| 大哥归来 | 少阳丹 x20 | missing exact item; not granted |
| 大哥归来 | 人参养荣丸 x20 | missing exact item; not granted |
| 还施水阁 entry | 银两 -3000 | not implemented; money removal API unresolved |
| 水阁 center room | 海月清辉 / 九霄环佩 / 天书竹简 | item ids unresolved; not implemented |
| 阿碧 room chests | 朱颜碧 / 缀玉华裳 / 湖畔舞剑图 / 暗器 / 九转熊蛇丸 x20 | mostly unresolved; not implemented as source chest content |
| 慕容秋荻 service | 明玉丹 | item id unresolved; not implemented |

### Existing Ad Hoc Rewards Not Yet Source-Coverage

```text
5202.lua grants 银两 id 174 x30000 using legacy flag jshyl_yanzi_treasure_taken.
5205.lua grants 银两 id 174 x500 after TryBattle(145).
10000.lua grants 小还丹 id 3 in the technical 阿碧 validation slice.
```

These are playable behaviors, but they should not be marked as completed TPR
opening coverage until refactored into named QQZJ quest flags or verified
against the source beat.

## 3. Is `5200.lua` Too Overloaded?

`5200.lua` itself remains thin:

```lua
JSHYL.QQZJ.Quest.Run("qqzj_protagonist_opening_arrival")
```

However, the named quest chain behind that single trigger is now doing too much:

```text
arrival -> qiudi_guard -> family_briefing -> brother_return
```

Assessment:

```text
5200.lua is acceptable as the initial opening-chain entry point, but it should
not absorb the remaining opening content. Further beats should move to the
already-bound scene triggers where possible:

- 5202 for chest/reward behavior
- 5205 for 侍剑 training
- future scene-bound trigger for 还施水阁 entry
```

Reason:

```text
The next source beats depend on physical scene affordances: entering 还施水阁,
opening chests, and choosing training. Keeping all of that behind 慕容秋荻's
single trigger would make the mod harder to test and less faithful to player
movement.
```

## 4. Next-Step Options

### 还施水阁 Entry

Status:

```text
Important source beat, but likely requires scene/object binding.
```

Why:

```text
The extraction says entering 还施水阁 triggers 阿朱/双儿 encounter and a -3000
silver cost. Current scene scan found no clear `还施水阁 entry` trigger. 5204.lua
exists as a 水阁 hint, but no bound scene object was found.
```

Needed before implementation:

```text
1. Verify or add a trigger for 还施水阁 entry.
2. Decide event id, likely 5204 if binding it is safe.
3. Verify money removal API or decide exact AddItem(174, negative) behavior only after engine/API review.
```

### Chest Rewards

Status:

```text
Requires scene binding and item audit.
```

Why:

```text
Only one chest-like trigger is currently visible: jshyl_yanzi_treasure -> 5202.
The source has center-room rewards and 阿碧-room chests with mostly unresolved
item ids.
```

Lua-only partial option:

```text
Refactor 5202 into a named quest preserving legacy flag jshyl_yanzi_treasure_taken.
This can improve architecture without claiming full source chest coverage.
```

### 侍剑 / 十二金钗 Training Refactor

Status:

```text
Best next Lua-only candidate.
```

Why:

```text
jshyl_shijian_training is already bound to event 5205, and 5205 already starts
TryBattle(145). A small refactor can make it follow the validated quest pattern:
thin event file -> JSHYL.QQZJ.Quest.Run -> named flags -> idempotent victory flag.
```

Caveats:

```text
1. Battle 145 still needs verification before marking it faithful 十二金钗 source coverage.
2. The source effect 主角武常 +20 is not implemented and needs API verification.
3. The current 银两 id 174 x500 reward is ad hoc and should either be preserved
   as temporary behavior or removed only in an explicitly scoped task.
```

### Missing Item Creation / Verification

Status:

```text
Not Lua-only if exact items are created.
```

Why:

```text
Creating missing medicines/tools/chest items requires config edits and probably
regenerating config Lua, so it is outside a small Lua-only implementation slice.
```

Could be planned next if the priority is source fidelity for rewards.

## 5. Which Next Slice Requires Scene Edits?

Requires scene edits or at least Unity scene binding verification:

```text
1. 还施水阁 entry
2. 阿朱/双儿 forced encounter at water-pavilion entry
3. Center-room reward containers
4. 阿碧-room four chests
5. Physical 二叔/三叔 NPC triggers
6. Proper 大哥 return at exit/world-access point
```

Does not require scene edits:

```text
1. Refactor 5205 侍剑 training into named quest architecture.
2. Refactor 5202 single treasure chest into named quest architecture while
   preserving `jshyl_yanzi_treasure_taken`.
3. Add/adjust docs and audits.
4. Add missing item reward behavior only if exact item ids already exist.
```

Requires config edits:

```text
1. Creating missing medicines/tools/chest items.
2. Adding exact TPR item rewards that do not exist in ItemConfig.lua.
3. Changing or validating battle 145 as a real 十二金钗 battle if current config is insufficient.
```

## 6. Recommended Next Implementation Task

Recommended next slice:

```text
TPR-014: Refactor 侍剑 / 十二金钗 training into named quest flow.
```

Why this next:

```text
It is the smallest meaningful Lua-only step after the 5200 chain:
- Uses existing scene trigger jshyl_shijian_training.
- Reuses existing event id 5205.
- Reuses existing battle 145 for now.
- Does not need scene edits, config edits, new maps, new items, or engine C#.
- Moves an existing ad hoc gameplay script toward the validated QQZJ pattern.
```

Proposed quest id:

```text
qqzj_yanziwu_services_shijian_training
```

Proposed event file:

```text
Assets/Mods/jshyl/Lua/5205.lua
```

Proposed flags:

```text
qqzj_yanziwu_services_shijian_training_started
qqzj_yanziwu_services_shijian_training_declined
qqzj_yanziwu_services_shijian_training_won
qqzj_yanziwu_services_shijian_training_reward_claimed
qqzj_yanziwu_services_shijian_training_completed
```

Compatibility plan:

```text
Preserve current behavior unless explicitly changed:
- prompt for battle
- TryBattle(145)
- on victory, grant 银两 id 174 x500 exactly once

Add TODO for 主角武常 +20 because stat API is unresolved.
Do not claim battle 145 as verified 十二金钗 fidelity until Unity/battle config is checked.
```

Acceptance criteria for TPR-014:

```text
1. 5205.lua becomes a thin JSHYL.QQZJ.Quest.Run dispatcher.
2. The named quest lives in jshyl_qqzj_quest.lua.
3. Player can still decline training.
4. Player can start battle 145.
5. Victory sets save-backed flags.
6. The 银两 id 174 x500 reward is idempotent.
7. Repeat interaction does not duplicate the reward.
8. No scene/config/engine/map/new item changes.
9. Coverage/backlog clearly says this is an architectural refactor, not full verified source coverage for 十二金钗.
```

## 7. Alternate Next Task If Source Fidelity Is Preferred

If the priority is continuing the exact mandatory opening chain rather than
refactoring existing services, choose:

```text
TPR-014-alt: Plan and bind 还施水阁 entry trigger.
```

This requires scene binding work and should not be attempted under Lua-only
constraints.
