# TPR-015 Audit: 5202 Treasure / Chest Flow

## Scope

Planning only. No Lua, scene, config, map, reward, battle, companion, or engine
behavior was changed.

Inputs reviewed:

```text
docs/tpr_extraction/TPR_013_OPENING_CHAIN_AUDIT.md
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
Assets/Mods/jshyl/Lua/5202.lua
```

## 1. What 5202 Currently Does

`Assets/Mods/jshyl/Lua/5202.lua` is an ad hoc treasure script:

```text
if GetFlagInt("jshyl_yanzi_treasure_taken") == 1 then goto empty_chest end;
AddItem(174, 30000);
SetFlagInt("jshyl_yanzi_treasure_taken", 1);
ModifyEvent(...);
ShowMessage("获得银两三万。");
```

Current behavior:

```text
1. Checks legacy flag jshyl_yanzi_treasure_taken.
2. If not claimed, grants item id 174 x30000.
3. Sets legacy flag jshyl_yanzi_treasure_taken.
4. Calls ModifyEvent to disable/change the scene event.
5. Shows a claimed or empty message.
```

Scene binding from prior audit:

```text
jshyl_yanzi_treasure -> event 5202
```

## 2. Does It Correspond To TPR Opening Chest / 还施水阁 Content?

Partially, but only at a very broad home-base chest level.

It may correspond loosely to this extracted beat:

```text
双儿 room chests | 银子 | 30000 each chest | service/chest flags TBD
```

It does not correspond to full `还施水阁` opening content:

```text
1. It is not the 还施水阁 entry encounter.
2. It does not implement the 阿朱/双儿 encounter.
3. It does not charge 银两 -3000.
4. It does not grant center-room rewards.
5. It does not grant 阿碧-room four-chest rewards.
6. It does not mark journey-start completion.
```

Conclusion:

```text
5202 can be refactored into a named QQZJ quest as a legacy/safe treasure chest
flow, but it should not be marked as complete source coverage for the 水阁宝箱
or 还施水阁 sequence.
```

## 3. Existing Rewards And Item IDs

Existing reward:

| reward | item id | quantity | evidence |
|---|---:|---:|---|
| 银两 | 174 | 30000 | `5202.lua` uses `AddItem(174, 30000)` |

Known item meaning:

```text
Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua has 银两 as item id 174.
```

Existing legacy flag:

```text
jshyl_yanzi_treasure_taken
```

## 4. Missing / Unverified Rewards

The extracted opening spec lists several chest rewards that are not implemented
by `5202` and remain unresolved:

```text
center room:
- 海月清辉
- 九霄环佩
- 天书竹简

阿碧 room chests:
- 朱颜碧
- 缀玉华裳
- 湖畔舞剑图
- 各门派暗器 x20
- 九转熊蛇丸 x20

双儿 room chests:
- 银子 30000 each chest
```

Current status:

```text
Only one 银两 id 174 x30000 chest exists in 5202.
The named center-room and 阿碧-room item ids are unresolved.
The number and placement of source-faithful chest objects are unverified.
```

## 5. Recommended Quest ID

Recommended for refactoring the existing behavior only:

```text
qqzj_yanziwu_treasure_silver_chest
```

Reason:

```text
This name is deliberately narrower than qqzj_protagonist_opening_shuige_rewards.
It preserves the current single silver chest without claiming full 还施水阁 or
水阁宝箱 source coverage.
```

Do not use this quest id yet:

```text
qqzj_protagonist_opening_shuige_rewards
```

That quest should be reserved for the future source-faithful chest set after
scene bindings and item ids are verified.

## 6. Proposed Flags

New named flags:

```text
qqzj_yanziwu_treasure_silver_chest_started
qqzj_yanziwu_treasure_silver_chest_reward_claimed
qqzj_yanziwu_treasure_silver_chest_completed
```

Legacy compatibility flag to preserve:

```text
jshyl_yanzi_treasure_taken
```

Migration rule:

```text
If jshyl_yanzi_treasure_taken is true, set the new reward_claimed and completed
flags before reward logic runs.
```

Reward idempotency rule:

```text
Grant AddItem(174, 30000) only if neither the new reward flag nor the legacy
flag indicates the chest has already been claimed.
```

## 7. Can Implementation Be Lua-Only?

Yes, for the refactor only.

Lua-only implementation can:

```text
1. Convert 5202.lua into a thin JSHYL.QQZJ.Quest.Run dispatcher.
2. Add qqzj_yanziwu_treasure_silver_chest to jshyl_qqzj_quest.lua.
3. Preserve AddItem(174, 30000).
4. Preserve legacy flag jshyl_yanzi_treasure_taken.
5. Preserve repeat empty-chest behavior.
6. Keep ModifyEvent behavior if needed to match the existing script.
```

Lua-only implementation cannot:

```text
1. Add missing chest objects.
2. Bind center-room or 阿碧-room chest triggers.
3. Add missing items to config.
4. Implement the full 还施水阁 entry sequence.
5. Verify physical chest placement in Unity.
```

## 8. Risks

```text
1. Naming this as 水阁宝箱 would overstate coverage. The current 5202 chest is
   only one silver chest.

2. Removing ModifyEvent could change scene behavior if the object is expected to
   disappear/disable after claiming. Preserve it unless a Unity test proves the
   named quest flags are sufficient.

3. Failing to migrate jshyl_yanzi_treasure_taken would duplicate silver in old
   saves.

4. AddItem(174, 30000) follows current behavior, but money-as-item semantics
   should still be reviewed before implementing the future -3000 water-pavilion
   cost.

5. Full TPR chest rewards require item audits and likely scene edits. Refactoring
   5202 should be documented as architecture cleanup, not source completion.
```

## 9. Acceptance Criteria

For a future `TPR-016` implementation:

```text
1. 5202.lua becomes a thin dispatcher.
2. New named quest qqzj_yanziwu_treasure_silver_chest is added.
3. Existing reward remains 银两 id 174 x30000.
4. Existing legacy flag jshyl_yanzi_treasure_taken is preserved/migrated.
5. New reward flag prevents duplicate rewards.
6. Repeated interaction shows empty/claimed dialogue.
7. Existing ModifyEvent behavior is preserved unless explicitly scoped otherwise.
8. No scene/config/engine/map/new item changes.
9. Docs/backlog state this is not full 水阁宝箱 coverage.
```

Recommended next prompt:

```text
Proceed with TPR-016: refactor 5202 treasure chest into qqzj_yanziwu_treasure_silver_chest. Preserve AddItem(174, 30000), jshyl_yanzi_treasure_taken, and repeat empty-chest behavior. Do not implement 还施水阁 or source chest rewards yet.
```
