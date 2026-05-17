# TPR-033 Plan: Opening Tool Rewards

## Scope

Planning only. No gameplay, Lua, scene, config, asset, battle, companion, or
engine files should change in this task.

Inputs reviewed:

```text
docs/tpr_extraction/TPR_032_OPENING_CHECKPOINT_AFTER_SHUIGE_CHEST.md
docs/tpr_extraction/TPR_018_OPENING_REWARD_ITEM_AUDIT.md
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua
```

## Item Evidence

The required opening tool items now exist as inert rows in generated item
config:

| item | id | source evidence | current behavior |
|---|---:|---|---|
| `司南针` | `205` | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:267` | inert QQZJ/TPR opening item |
| `狼牙燕翎` | `206` | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:268` | inert QQZJ/TPR opening item |
| `秦皇照骨镜` | `207` | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:269` | inert QQZJ/TPR opening item |
| `洛阳铲` | `208` | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:270` | inert QQZJ/TPR opening item |

All four rows have no active stat/combat effect in the current config and can
be granted safely as key/story items.

## 1. Grant Order

Recommended order:

1. Grant `司南针` id `205` through the existing 秋荻 guard quest.
2. Grant `狼牙燕翎` id `206`, `秦皇照骨镜` id `207`, and `洛阳铲` id `208`
   together through the existing family briefing quest.

Reasoning:

```text
司南针 belongs to the same source beat as 秋荻托付 and the already-implemented
九转熊蛇丸 x10 reward.

The three tool items are grouped in the extraction under 二叔/三叔 family
briefing rewards and should share one idempotency flag.
```

Do not grant these through ShuiGe chest logic. They are opening/travel/tool
rewards, not 水阁宝箱 rewards.

## 2. Quest / Event Grant Sites

Use existing opening chain first:

| reward group | quest id | event path | implementation note |
|---|---|---|---|
| 秋荻 navigation reward | `qqzj_protagonist_opening_qiudi_guard` | existing `5200.lua` chain through `jshyl_qqzj_quest.lua` | extend existing reward branch; keep `5200.lua` thin |
| 二叔/三叔 tools | `qqzj_protagonist_opening_family_briefing` | existing `5200.lua` chain through `jshyl_qqzj_quest.lua` | add a separate tools reward branch after briefing dialogue |

No new scene triggers are required for the next implementation slice. Separate
physical 二叔/三叔 triggers can be introduced later after the source-faithful
scene layout is planned.

## 3. Inert Item Policy

Keep all four items inert for now.

Do not implement mechanics yet for:

```text
司南针 navigation
狼牙燕翎 route proof / token behavior
秦皇照骨镜 hidden-object detection
洛阳铲 digging / tomb interaction
```

Future mechanics should be route-gated by explicit flags and implemented only
when a page extraction requires them. For this opening slice, the source
coverage target is inventory possession and save compatibility.

## 4. ShuiGe Or Later Beat Classification

| item | belongs to ShuiGe? | belongs to later route mechanics? | current opening use |
|---|---|---|---|
| `司南针` | no | possibly navigation affordance later | 秋荻 reward |
| `狼牙燕翎` | no | possibly route credential later | 二叔/三叔 reward |
| `秦皇照骨镜` | no | possible hidden clue tool later | 二叔/三叔 reward |
| `洛阳铲` | no | possible digging/tomb tool later | 二叔/三叔 reward |

They should be recorded as opening story/tool rewards now and can become
mechanically meaningful in later route-specific tasks.

## 5. Proposed Flags

Preserve existing reward flags and add one specific compatibility-safe flag for
`司南针`.

### 秋荻 Reward

Existing flag:

```text
qqzj_protagonist_opening_qiudi_guard_reward_claimed
```

This already guards `九转熊蛇丸` id `16` x10. Because current saves may already
have this flag set before `司南针` existed, do not rely on it alone for the new
item. Add:

```text
qqzj_protagonist_opening_qiudi_guard_sinanzhen_claimed
```

Implementation should:

```text
if qiudi_guard_completed and not sinanzhen_claimed:
  grant 司南针 id 205 x1
  set sinanzhen_claimed
```

This lets existing saves that already claimed the old 秋荻 reward receive the
newly-added exact item once.

### Family Briefing Tools

Use the extraction's intended tools flag:

```text
qqzj_protagonist_opening_family_briefing_tools_claimed
```

Implementation should:

```text
if family_briefing_completed and not tools_claimed:
  grant 狼牙燕翎 id 206 x1
  grant 秦皇照骨镜 id 207 x1
  grant 洛阳铲 id 208 x1
  set tools_claimed
```

Keep existing hook flags unchanged:

```text
qqzj_protagonist_opening_family_briefing_hangzhou_hook_unlocked
qqzj_protagonist_opening_family_briefing_kaifeng_hook_unlocked
```

Those flags represent narrative route hints, not item idempotency.

## 6. Proposed TPR-034 Implementation

Allowed implementation files should be limited to:

```text
Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
docs/tpr_extraction/COVERAGE_TRACKER.md
docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md
```

No event dispatcher edits should be needed because both rewards can be reached
through the existing `5200.lua` chain.

Recommended behavior:

1. After 秋荻 guard completion, grant `司南针` id `205` x1 once.
2. After family briefing completion, grant `狼牙燕翎` id `206` x1,
   `秦皇照骨镜` id `207` x1, and `洛阳铲` id `208` x1 once.
3. Existing saves with completed dialogue should be able to claim these new
   items on repeated interaction.
4. Repeated interaction after flags are set should show already-claimed or
   already-briefed dialogue without duplicate items.
5. Do not add mechanics, map unlocks, companions, scene edits, or ShuiGe
   payouts.

## 7. Acceptance Criteria

For TPR-034:

```text
1. 司南针 id 205 x1 is granted exactly once.
2. 狼牙燕翎 id 206 x1 is granted exactly once.
3. 秦皇照骨镜 id 207 x1 is granted exactly once.
4. 洛阳铲 id 208 x1 is granted exactly once.
5. Old saves with 秋荻/briefing already completed can still receive the newly
   introduced items once.
6. Save/load preserves the new reward flags.
7. Repeated interaction does not duplicate any item.
8. No ShuiGe rewards, silver deduction, maps, battles, companions, scene edits,
   config edits, or engine changes are introduced.
```

Manual Unity verification:

```text
1. Start or load jshyl in 52_yanziwu.
2. Trigger the 5200 opening chain through `jshyl_murong_opening`.
3. Complete or repeat 秋荻 guard interaction and verify 司南针 appears once.
4. Complete or repeat family briefing and verify the three tools appear once.
5. Save and reload.
6. Repeat the interaction and verify no duplicates are granted.
```

## 8. Risks

| risk | mitigation |
|---|---|
| Existing saves already have `qqzj_protagonist_opening_qiudi_guard_reward_claimed` set | use new `qqzj_protagonist_opening_qiudi_guard_sinanzhen_claimed` flag |
| Existing saves already have family briefing completed before tools existed | grant tools from completed-state repeated interaction using `qqzj_protagonist_opening_family_briefing_tools_claimed` |
| 5200 chain becomes overloaded | no new event id needed yet; future physical NPC separation should get its own planning task |
| Inert items disappoint as nonfunctional tools | document them as opening story/tool items; implement mechanics only when source pages require them |
| Item ids 205-208 were added outside the older audit | cite generated `ItemConfig.lua` rows and keep TPR-018 as historical pre-TPR-029 audit context |
| Future separate 二叔/三叔 triggers conflict with existing flags | keep reward flags source-named and independent of the current trigger path |

## Recommended Implementation Prompt

```text
Proceed with TPR-034: implement opening tool rewards.

Allowed:
- Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Requirements:
1. Extend existing opening chain rewards only.
2. Grant 司南针 id 205 x1 once after 秋荻 guard completion.
3. Use flag qqzj_protagonist_opening_qiudi_guard_sinanzhen_claimed.
4. Grant 狼牙燕翎 id 206 x1, 秦皇照骨镜 id 207 x1, 洛阳铲 id 208 x1 once after family briefing completion.
5. Use flag qqzj_protagonist_opening_family_briefing_tools_claimed.
6. Preserve existing rewards and flags.
7. Do not add mechanics, maps, companions, ShuiGe rewards, config edits, scene edits, battles, or engine changes.
```
