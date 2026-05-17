# Phase 3D Audit: TPR Opening Slice

## Scope

This audit compares the current implementation against:

```text
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
docs/tpr_extraction/COVERAGE_TRACKER.md
docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md
Phase 3C implementation summary / commit 0188a2ac0
```

No gameplay changes are made by this document.

## 1. Implemented Parts

Implemented subsection:

```text
主角剧情：开局 -> qqzj_protagonist_opening_arrival
```

Implemented behavior:

```text
event id: 5200
event file: Assets/Mods/jshyl/Lua/5200.lua
quest id: qqzj_protagonist_opening_arrival
quest handler: JSHYL.QQZJ.Quest handler in jshyl_qqzj_quest.lua
map: 52_yanziwu
trigger: existing jshyl_murong_opening trigger
reward: 银两 item id 174 x10000
repeat behavior: completed-state dialogue, no duplicate reward
save state: save-backed flags through JSHYL.QQZJ.Flags
legacy compatibility: old jshyl_opening_done flag is migrated/mirrored
```

Implemented flags:

```text
qqzj_protagonist_opening_arrival_started
qqzj_protagonist_opening_arrival_reward_claimed
qqzj_protagonist_opening_arrival_completed
jshyl_opening_done
```

Technical validation:

```text
Unity smoke-load passed after Phase 3C.
jshyl_qqzj_quest preloaded successfully.
52_yanziwu loaded with active player validation.
```

## 2. Remaining Parts

The following extracted opening content remains unimplemented:

```text
qqzj_protagonist_opening_qiudi_guard
  - 慕容秋荻托付
  - 司南针 reward
  - 九转熊蛇丸 x10 reward
  - 孟星魂 assignment flag
  - no real companion join yet unless explicitly scoped later

qqzj_protagonist_opening_family_briefing
  - 二叔/三叔 dialogue
  - 狼牙燕翎, 秦皇照骨镜, 洛阳铲 rewards
  - 杭州 and 开封 route hint flags

qqzj_protagonist_opening_brother_return
  - 大哥/慕容复 return dialogue
  - starter medicine bundle

qqzj_protagonist_opening_shuige_entry
  - 还施水阁 entry
  - 阿朱/双儿 encounter
  - 3000 silver cost behavior

qqzj_protagonist_opening_shuige_rewards
  - center room rewards
  - 阿碧 room chest rewards
  - formal opening-chain completion

qqzj_yanziwu_services
  - 双儿 rest/chests
  - 阿朱 avatar/model service
  - 阿碧 medicine/rest service
  - 侍剑 / 十二金钗 training
  - 慕容秋荻明玉丹 service
  - later-week home-base functions
```

## 3. Risks

Current risks:

```text
1. The 5200 trigger now does less than the old ad hoc opening script.
   Old script joined 孟星魂 and gave broad instructions. Phase 3C intentionally
   removed that behavior from this trigger to keep the slice small.

2. The old jshyl_opening_done flag now maps to only the arrival subsection.
   This preserves old saves from double rewards, but it no longer means the
   full TPR opening chain is complete.

3. The implementation uses AddItem(174, 10000) for silver.
   This matches existing jshyl usage, but UI/save behavior still needs manual
   verification in the playable flow.

4. Coverage docs use section-level status `partially_implemented`.
   The original site-wide status list does not include partial page status.
   This is useful for sections, but future docs should clarify page status vs
   section implementation status.

5. Existing Phase 2 阿碧 validation remains separate.
   It must not be counted as TPR opening coverage until intentionally migrated
   into a real TPR service or moved aside as debug/test content.

6. Unity/editor-generated water material and UserSettings diffs are present in
   the working tree and should remain unstaged unless intentionally addressed.
```

## 4. Item 174 / 银两 Verification

Static verification:

```text
Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua contains item id 174 named 银两.
Existing jshyl scripts already use AddItem(174, ...):
  - 5202.lua grants 30000
  - 5205.lua grants 500
```

Conclusion:

```text
Item id 174 is a valid existing jshyl item for 银两.
```

Still needs manual verification:

```text
1. Trigger 5200 in Unity.
2. Confirm the inventory/money UI reflects +10000 银两 as expected.
3. Repeat the trigger and confirm no duplicate grant.
4. Save/load and confirm repeat-state dialogue remains.
```

## 5. Recommended Next Smallest Slice

Recommended next slice:

```text
qqzj_protagonist_opening_qiudi_guard
```

Why this is next:

```text
It is the direct continuation of opening arrival.
It still uses 慕容秋荻 / the existing 5200 interaction.
It can be implemented as dialogue + flags only first.
It can defer real companion joining and unresolved item ids.
It keeps scope smaller than family briefing, exits, chest rewards, or battles.
```

Recommended scope:

```text
1. Add a second named quest stage after arrival completion.
2. Present 慕容秋荻托付 dialogue.
3. Set a story flag that 孟星魂 has been assigned as protector.
4. Do not call Join yet.
5. Do not grant 司南针 / 九转熊蛇丸 until item ids are verified, unless the implementation task first verifies those ids.
6. Branch repeated interaction to already-assigned dialogue.
```

## 6. Exact IDs For Next Slice

Reuse:

```text
event id: 5200
event file: Assets/Mods/jshyl/Lua/5200.lua
map: 52_yanziwu
trigger: jshyl_murong_opening
```

Next quest id:

```text
qqzj_protagonist_opening_qiudi_guard
```

Next flags:

```text
qqzj_protagonist_opening_qiudi_guard_started
qqzj_protagonist_opening_qiudi_guard_dialogue_seen
qqzj_protagonist_opening_qiudi_guard_mengxinghun_assigned
qqzj_protagonist_opening_qiudi_guard_completed
```

Optional later reward flags, only after item-id verification:

```text
qqzj_protagonist_opening_qiudi_guard_reward_claimed
```

Prerequisite flag:

```text
qqzj_protagonist_opening_arrival_completed
```

Handler flow:

```text
5200.lua -> JSHYL.QQZJ.Quest.Run("qqzj_protagonist_opening_arrival")

Inside arrival handler:
  if arrival not completed:
    run arrival
  else:
    run/dispatch qqzj_protagonist_opening_qiudi_guard
```

Alternative:

```text
5200.lua -> JSHYL.QQZJ.Quest.Run("qqzj_protagonist_opening_arrival")
arrival handler calls JSHYL.QQZJ.Quest.Run("qqzj_protagonist_opening_qiudi_guard")
only after arrival completion.
```

## 7. Acceptance Criteria

For the next slice:

```text
1. No new maps.
2. No engine C# changes.
3. No config table rewrites.
4. No real companion Join unless explicitly approved for that slice.
5. No unverified item rewards.
6. Existing qqzj_intro_abi_guidance behavior remains intact.
7. First interaction after arrival completion shows 慕容秋荻托付 dialogue.
8. The following flags persist after save/load:
   - qqzj_protagonist_opening_qiudi_guard_started
   - qqzj_protagonist_opening_qiudi_guard_dialogue_seen
   - qqzj_protagonist_opening_qiudi_guard_mengxinghun_assigned
   - qqzj_protagonist_opening_qiudi_guard_completed
9. Repeated interaction shows already-assigned dialogue.
10. Unity smoke-load passes.
11. Manual Unity check confirms no duplicate arrival silver and no runtime Lua errors.
```
