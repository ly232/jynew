# TPR-010 Plan: Remaining 主角剧情：开局 Content

## Scope

Planning only. No Lua, scene, config, map, engine, battle, or reward behavior is changed.

Inputs reviewed:

```text
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md
Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
Assets/Mods/jshyl/Lua/5202.lua
Assets/Mods/jshyl/Lua/5204.lua
Assets/Mods/jshyl/Lua/5205.lua
Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua
```

Current implemented opening chain:

```text
5200.lua
  -> qqzj_protagonist_opening_arrival
  -> qqzj_protagonist_opening_qiudi_guard
  -> qqzj_protagonist_opening_family_briefing
```

## Current Scene / Script Findings

Existing named triggers in `52_yanziwu`:

```text
jshyl_shuanger_rest     -> event 5201
jshyl_abi_hint          -> event 10000
jshyl_yanzi_treasure    -> event 5202
jshyl_azhu_hint         -> event 5203
jshyl_murong_opening    -> event 5200
jshyl_shijian_training  -> event 5205
```

Existing related Lua files:

```text
5202.lua: ad hoc chest reward, grants 银两 id 174 x30000 with legacy flag jshyl_yanzi_treasure_taken
5204.lua: 阿碧/水阁 hint dialogue, but no matching scene trigger was found
5205.lua: ad hoc 侍剑 training, prompts battle 145 and grants 银两 id 174 x500 on victory
```

No current named trigger was found for:

```text
大哥 return / 慕容复归来
还施水阁 entry
阿朱/双儿 forced encounter
center-room reward chests
阿碧 room four chests
separate 二叔/三叔 physical NPCs
```

## 1. Recommended Next Slice

Recommended next implementation slice:

```text
TPR-010A: qqzj_protagonist_opening_brother_return
```

Implement it first as a dialogue-only continuation from the current `5200.lua` opening chain, gated after:

```text
qqzj_protagonist_opening_family_briefing_completed
```

Reason:

```text
The source beat after family briefing is 大哥 return.
However, the current scene has no verified exit/return trigger for 大哥, and most
of the 大哥 medicine reward ids are unresolved. A dialogue-only slice preserves
story order without inventing map/scene/reward behavior.
```

Recommended follow-up slices after TPR-010A:

```text
TPR-010B: 大哥 reward item-id audit
TPR-010C: 大哥 verified reward grant, if enough ids are verified
TPR-011A: 还施水阁 entry planning/scene binding
TPR-012A: 侍剑 training refactor into named quest flags
```

## 2. Dialogue-Only, Reward-Only, Or Scene Edits?

### 大哥 Return

Recommendation:

```text
Start as dialogue-only.
```

Why:

```text
No current `52_yanziwu` trigger clearly represents the source's outward-exit
大哥 return event. Reusing `5200.lua` keeps the next slice playable and avoids
scene edits. Rewards should wait until item ids are verified.
```

Later proper version:

```text
Requires scene edits for a real exit/return trigger or a placed 大哥 NPC.
```

### 大哥 Return Rewards

Recommendation:

```text
Do not implement until item ids are audited.
```

Current read-only evidence:

```text
玉真散 exists: item id 5
九转灵宝丸 exists: item id 14
金创药 was not found by exact-name search
少阳丹 was not found by exact-name search
人参养荣丸 was not found by exact-name search
```

The source reward bundle should not be partially granted in a story slice unless
the partial-grant behavior is explicitly accepted.

### 还施水阁 Entry

Recommendation:

```text
Requires scene/object verification before implementation.
```

Why:

```text
The extraction references entering 还施水阁 and meeting 阿朱/双儿, but the current
scene trigger list has no clear `还施水阁 entry` trigger. `5204.lua` exists as an
阿碧/水阁 hint, but no matching scene binding was found.
```

### Chest Rewards

Recommendation:

```text
Requires both item id audit and scene/chest binding.
```

Current state:

```text
5202.lua is a single ad hoc treasure trigger for 银两 id 174 x30000.
It does not represent the full source chest set.
```

### 侍剑 / 十二金钗 Training

Recommendation:

```text
Can be refactored later with existing event 5205 and battle 145, but not as the
very next slice.
```

Why:

```text
It already has a trigger and battle path, but it is currently ad hoc Lua, not the
named quest architecture. It also needs idempotency/victory flags and the source
effect `主角武常 +20` needs API verification.
```

## 3. Required Item ID Verification List

Verify before granting any remaining opening rewards:

### 大哥 Return Rewards

```text
金创药 x20         unresolved
少阳丹 x20         unresolved
玉真散 x20         verified candidate: id 5
人参养荣丸 x20     unresolved
九转灵宝丸 x20     verified candidate: id 14
```

### 二叔/三叔 Tools Still Deferred

```text
狼牙燕翎           unresolved
秦皇照骨镜         unresolved
洛阳铲             unresolved
```

### 还施水阁 / Chest Rewards

```text
海月清辉           unresolved
九霄环佩           unresolved
天书竹简           unresolved
朱颜碧             unresolved
缀玉华裳           unresolved
湖畔舞剑图         unresolved
各门派暗器 x20     exact item list unresolved; base throwable ids 96-105 exist
九转熊蛇丸 x20     verified: id 16
银两               verified: id 174, but money API semantics still need review
```

### Service / Training Rewards

```text
明玉丹             unresolved
主角武常 +20       not an item; API/effect path unresolved
```

## 4. Required Existing Map / Object Verification

Before implementing the full remaining opening content, verify:

```text
1. Whether there is an existing exit trigger in 52_yanziwu that can host 大哥 return.
2. Whether a 大哥/慕容复 NPC already exists or must be placed.
3. Whether 还施水阁 is represented as a physical room/door/object in 52_yanziwu.
4. Whether 5204.lua should be bound to an existing object, renamed, or replaced.
5. Whether `jshyl_yanzi_treasure` / 5202 should become 双儿 room chest content or remain a temporary test chest.
6. Whether center-room and 阿碧-room chests already exist as objects without named event bindings.
7. Whether battle 145 is a safe 十二金钗-style battle or merely a placeholder.
8. Which API modifies 主角武常 safely and persists through save/load.
```

## 5. Proposed Quest ID / Event ID / Flags

### Next Slice: 大哥 Return Dialogue

Quest id:

```text
qqzj_protagonist_opening_brother_return
```

Recommended event strategy for the smallest slice:

```text
reuse event id 5200
reuse event file Assets/Mods/jshyl/Lua/5200.lua
```

Dispatch chain:

```text
arrival
  -> qiudi_guard
  -> family_briefing
  -> brother_return
```

Future proper scene event:

```text
event id 5206 or 5207 can be reserved later for a real 大哥 return trigger,
but do not create it until scene edits are in scope.
```

Flags:

```text
qqzj_protagonist_opening_brother_return_started
qqzj_protagonist_opening_brother_return_dialogue_seen
qqzj_protagonist_opening_brother_return_reward_claimed
qqzj_protagonist_opening_brother_return_completed
```

For TPR-010A dialogue-only implementation:

```text
Set started, dialogue_seen, completed.
Do not set reward_claimed.
```

Prerequisite:

```text
qqzj_protagonist_opening_family_briefing_completed
```

### Future Slice: 还施水阁 Entry

Quest id:

```text
qqzj_protagonist_opening_shuige_entry
```

Event strategy:

```text
Requires scene/object verification. Do not bind blindly to 5204.
```

Flags:

```text
qqzj_protagonist_opening_shuige_entry_started
qqzj_protagonist_opening_shuige_entry_silver_paid
qqzj_protagonist_opening_shuige_entry_completed
```

### Future Slice: 水阁 Rewards

Quest id:

```text
qqzj_protagonist_opening_shuige_rewards
```

Flags:

```text
qqzj_protagonist_opening_shuige_rewards_started
qqzj_protagonist_opening_shuige_rewards_center_claimed
qqzj_protagonist_opening_shuige_rewards_abi_chests_claimed
qqzj_protagonist_opening_shuige_rewards_completed
```

### Future Slice: 侍剑 Training

Quest id:

```text
qqzj_yanziwu_services_shijian_training
```

Event strategy:

```text
reuse event id 5205 after refactoring 5205.lua into named quest dispatch
```

Flags:

```text
qqzj_yanziwu_services_shijian_training_started
qqzj_yanziwu_services_shijian_training_won
qqzj_yanziwu_services_shijian_training_wuchang_granted
```

## 6. Risks

```text
1. Reusing 5200 for 大哥 return is not spatially faithful to the source. It is a
   temporary narrative continuation until a real exit/return trigger exists.

2. Granting only the verified subset of 大哥 rewards could diverge from the
   source. Prefer an audit first, then either exact rewards or an explicit
   placeholder strategy.

3. 5202 and 5205 are legacy ad hoc scripts. Refactoring them into named quest
   handlers must preserve existing saves and avoid duplicate rewards.

4. `银两` id 174 works as an item in current slices, but true money add/remove
   semantics still need API review before implementing the -3000 水阁 cost.

5. Chest implementation may need scene edits. Creating grouped reward dialogue
   without chest objects would be playable but less faithful.

6. Battle 145 may not visually or mechanically match 十二金钗. Verify before
   treating it as source coverage.

7. `主角武常 +20` is a stat mutation, not an item reward. An incorrect API could
   fail to persist or corrupt role data.
```

## 7. Acceptance Criteria

For the recommended next implementation, TPR-010A:

```text
1. No scene edits.
2. No config edits.
3. No engine C# changes.
4. No new maps.
5. No item rewards yet.
6. No battles.
7. No companions.
8. Existing 5200.lua remains a thin dispatcher.
9. Existing arrival, qiudi_guard, family_briefing, and 阿碧 validation behavior remain intact.
10. After qqzj_protagonist_opening_family_briefing_completed, interacting with 5200 reaches qqzj_protagonist_opening_brother_return.
11. The following flags are set and persist:
    - qqzj_protagonist_opening_brother_return_started
    - qqzj_protagonist_opening_brother_return_dialogue_seen
    - qqzj_protagonist_opening_brother_return_completed
12. qqzj_protagonist_opening_brother_return_reward_claimed remains unset.
13. Repeat interaction shows already-returned/already-briefed dialogue.
```

## Recommended Next Prompt

```text
Proceed with TPR-010A: implement qqzj_protagonist_opening_brother_return as dialogue-only via the existing 5200.lua chain. Do not grant 大哥 rewards yet; do not edit scenes, configs, battles, companions, or maps.
```
