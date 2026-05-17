# TPR-030 Plan: ShuiGe Chest Reward Binding

## Scope

Planning only. No Lua, scene, config, gameplay, asset, battle, companion, or
engine files were changed.

Inputs reviewed:

```text
docs/tpr_extraction/TPR_027_SHUIGE_OPENING_COVERAGE_CHECKPOINT.md
docs/tpr_extraction/TPR_028_MISSING_ITEM_CONFIG_STRATEGY.md
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua
Assets/Mods/jshyl/Lua/5203.lua
Assets/Mods/jshyl/Lua/5204.lua
Assets/Mods/jshyl/Lua/5206.lua
Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
```

Note:

```text
The prompt references TPR_028_OPENING_ITEM_CONFIG_STRATEGY.md. The repo's
actual filename is TPR_028_MISSING_ITEM_CONFIG_STRATEGY.md.
```

## 1. Item IDs Now Safe To Grant

Existing verified items:

| item | id | source-safe status |
|---|---:|---|
| `九转熊蛇丸` | `16` | exact existing item; safe for 阿碧-room chest later |
| `银两` | `174` | exact existing currency item; safe for silver chest flows |

New inert TPR opening items from TPR-029:

| item | id | source-safe status |
|---|---:|---|
| `司南针` | `205` | safe for future 秋荻 reward completion |
| `狼牙燕翎` | `206` | safe for future 二叔/三叔 tool reward |
| `秦皇照骨镜` | `207` | safe for future 二叔/三叔 tool reward |
| `洛阳铲` | `208` | safe for future 二叔/三叔 tool reward |
| `海月清辉` | `209` | safe for first ShuiGe center-room chest slice |

Still missing and not safe to grant:

```text
金创药
少阳丹
人参养荣丸
明玉丹
九霄环佩
天书竹简
朱颜碧
缀玉华裳
湖畔舞剑图
source-faithful 各门派暗器 exact bundle
```

## 2. First TPR Opening Chest Reward To Implement

Recommended first chest reward:

```text
center-room ShuiGe chest: 海月清辉 id 209 x1
```

Why this first:

```text
1. It is a named ShuiGe center-room reward from the extraction.
2. Its exact id now exists.
3. It is inert, so there is no combat/equipment balancing risk.
4. It exercises the complete chest reward pattern with one item.
5. It avoids the still-missing 九霄环佩 / 天书竹简 rows.
```

Do not implement in the first chest slice:

```text
九霄环佩
天书竹简
朱颜碧
缀玉华裳
湖畔舞剑图
各门派暗器
九转熊蛇丸 x20
silver deduction -3000
```

Recommended player-facing wording:

```text
还施水阁中先取一件清雅旧藏：海月清辉。余下书阁藏品待日后整理。
```

This makes the partial reward explicit without pretending the full source chest
has been exhausted.

## 3. Existing 5206 Marker Or Separate Chest Trigger?

Recommendation:

```text
Add a separate chest trigger. Do not use existing 5206 for rewards.
```

Keep current responsibilities:

| event id | object | responsibility |
|---:|---|---|
| `5203` | `jshyl_azhu_hint` | 阿朱 hint toward ShuiGe |
| `5204` | `jshyl_shuige_entry` | entry gate and inner marker unlock |
| `5206` | `jshyl_shuige_inner_marker` | inner ShuiGe arrival/preparation dialogue |

Add a new dedicated reward trigger:

| proposed event id | proposed object | responsibility |
|---:|---|---|
| `5207` | `jshyl_shuige_center_chest` | first center-room chest reward |

Why not reuse 5206:

```text
1. 5206 already represents "first step inside ShuiGe" and repeated dialogue.
2. Reward idempotency is clearer when the physical chest has its own event id.
3. Later center-room rewards can evolve without changing the entry marker.
4. It matches the extraction's distinction between ShuiGe entry and ShuiGe
   reward containers.
```

Scene implication:

```text
TPR-031 should add one interactive scene object under the ShuiGe same-scene
area, preferably near `jshyl_shuige_inner_marker_visible`, named
`jshyl_shuige_center_chest`, bound to event id 5207.
```

If a scene edit is temporarily too risky, fallback is possible:

```text
Use 5206 as a temporary reward-confirmation dialogue only if the user explicitly
approves no scene edit. That fallback is not recommended for the canonical path.
```

## 4. Proposed Event ID / Quest ID / Flags

Event file:

```text
Assets/Mods/jshyl/Lua/5207.lua
```

Thin dispatcher:

```lua
JSHYL.QQZJ.Quest.Run("qqzj_protagonist_opening_shuige_center_chest")
do return end
```

Named quest:

```text
qqzj_protagonist_opening_shuige_center_chest
```

Gate after:

```text
qqzj_protagonist_opening_shuige_inner_completed
```

Flags:

```text
qqzj_protagonist_opening_shuige_center_chest_started
qqzj_protagonist_opening_shuige_center_chest_reward_claimed
qqzj_protagonist_opening_shuige_center_chest_completed
```

Reward:

```text
海月清辉 id 209 x1
```

Compatibility:

```text
No legacy chest flag exists for this specific ShuiGe center chest. Do not reuse
`qqzj_yanziwu_treasure_silver_chest_*` or `jshyl_yanzi_treasure_taken`; those
belong to the existing 燕子坞 silver chest, not ShuiGe.
```

Future expansion flags, not for TPR-031:

```text
qqzj_protagonist_opening_shuige_center_chest_full_reward_claimed
qqzj_protagonist_opening_shuige_abi_chests_started
qqzj_protagonist_opening_shuige_abi_chests_reward_claimed
```

Use these only after remaining item ids exist.

## 5. Silver Deduction -3000

Recommendation:

```text
Keep -3000 silver deferred.
```

Reasons:

```text
1. The first chest slice should verify one positive reward path only.
2. Negative `AddItem(174, -3000)` behavior has not been isolated in a tiny test.
3. Charging before full ShuiGe payout may feel hostile and source-incomplete.
4. Silver deduction is tied to 阿朱/双儿 entry, not to the chest object itself.
```

Future silver task:

```text
Plan a separate TPR task for qqzj_protagonist_opening_shuige_entry_silver_paid.
That task should verify whether negative AddItem works, whether the player can
be blocked by insufficient silver, and how repeated interaction is handled.
```

## 6. Exact Acceptance Criteria

For the next implementation slice:

```text
1. Add one scene trigger named `jshyl_shuige_center_chest`.
2. Bind it to event id `5207`.
3. Create `Assets/Mods/jshyl/Lua/5207.lua` as a thin quest dispatcher.
4. Add quest handler `qqzj_protagonist_opening_shuige_center_chest`.
5. Gate the quest after `qqzj_protagonist_opening_shuige_inner_completed`.
6. First successful interaction grants exactly `海月清辉` id 209 x1.
7. Set `qqzj_protagonist_opening_shuige_center_chest_reward_claimed`.
8. Repeated interaction must not duplicate the reward.
9. Save/load must preserve the reward claimed/completed state.
10. Do not deduct silver.
11. Do not grant 九霄环佩, 天书竹简, 阿碧-room rewards, 暗器, or medicines.
12. Do not modify config tables.
13. Do not add battles, companions, map transitions, or engine C#.
14. Update backlog/coverage after implementation.
```

Manual Unity verification:

```text
1. Start jshyl and reach 52_yanziwu.
2. Complete ShuiGe hint -> entry -> inner marker flow.
3. Confirm the new center chest trigger is visible/reachable.
4. Interact once and verify 海月清辉 appears in inventory.
5. Interact again and verify no duplicate reward.
6. Save, reload, and verify the chest remains claimed.
7. Confirm no silver is deducted.
```

## 7. Recommended Implementation Prompt

```text
Proceed with TPR-031: implement first ShuiGe center chest reward.

Read:
docs/tpr_extraction/TPR_030_SHUIGE_CHEST_REWARD_BINDING_PLAN.md

Allowed:
- Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
- Assets/Mods/jshyl/Lua/5207.lua
- Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- config edits
- item icons/art
- existing reward rewrites
- silver deduction
- new maps
- battles
- companions
- engine C#

Requirements:
1. Add one dedicated interactive trigger:
   `jshyl_shuige_center_chest`
2. Bind it to event id `5207`.
3. Create `5207.lua` as a thin dispatcher:
   `JSHYL.QQZJ.Quest.Run("qqzj_protagonist_opening_shuige_center_chest")`
4. Add named quest:
   `qqzj_protagonist_opening_shuige_center_chest`
5. Gate after:
   `qqzj_protagonist_opening_shuige_inner_completed`
6. Grant exactly:
   `海月清辉` item id 209 x1
7. Use flags:
   - `qqzj_protagonist_opening_shuige_center_chest_started`
   - `qqzj_protagonist_opening_shuige_center_chest_reward_claimed`
   - `qqzj_protagonist_opening_shuige_center_chest_completed`
8. Reward must be idempotent.
9. Do not deduct 3000 silver.
10. Do not grant any other ShuiGe rewards.

Done when:
- player can claim 海月清辉 once from the dedicated ShuiGe chest
- repeated interaction does not duplicate reward
- save/load preserves state
- docs/backlog mark TPR-031 implemented
```
