# TPR-039 Plan: ShuiGe Silver Deduction

## Scope

Planning only. No Lua, scene, config, asset, gameplay, battle, companion, or
engine files should change in this task.

Inputs reviewed:

```text
docs/tpr_extraction/TPR_036_OPENING_CHECKPOINT_AFTER_MENGXINGHUN_JOIN.md
docs/tpr_extraction/TPR_023_SHUIGE_BEHAVIOR_AFTER_TRIGGER_PLAN.md
Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
Assets/Mods/jshyl/Configs/Lua/SettingsConfig.lua
Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua
docs/codex_pipeline/004_LUA_RUNTIME_PRINCIPLES.md
docs/codex_pipeline/023_QUEST_RUNTIME.md
```

## Current ShuiGe Baseline

Implemented ShuiGe flow:

| event | quest | current behavior |
|---:|---|---|
| `5203` | `qqzj_protagonist_opening_shuige_entry_hint` | 阿朱 explains ShuiGe rule, explicitly says no silver is charged yet |
| `5204` | `qqzj_protagonist_opening_shuige_entry` | 双儿 confirms entry, unlocks same-scene inner marker, no silver charge |
| `5206` | `qqzj_protagonist_opening_shuige_inner` | inner marker dialogue, no silver charge |
| `5207` | `qqzj_protagonist_opening_shuige_center_chest` | grants `海月清辉` id `209` x1 once |

Current relevant flags:

```text
qqzj_protagonist_opening_shuige_entry_hint_completed
qqzj_protagonist_opening_shuige_entry_started
qqzj_protagonist_opening_shuige_entry_unlocked
qqzj_protagonist_opening_shuige_inner_marker_unlocked
qqzj_protagonist_opening_shuige_entry_completed
qqzj_protagonist_opening_shuige_inner_started
qqzj_protagonist_opening_shuige_inner_dialogue_seen
qqzj_protagonist_opening_shuige_inner_completed
qqzj_protagonist_opening_shuige_center_chest_reward_claimed
```

## 1. Existing APIs For Checking / Removing Silver

Confirmed from current jshyl Lua and pipeline docs:

| need | confirmed API/config | evidence | status |
|---|---|---|---|
| grant item/silver | `AddItem(itemId, count)` | used repeatedly in `jshyl_qqzj_quest.lua`; documented in quest runtime | confirmed for positive grants |
| money item id | `MONEY_ID = 174` | `SettingsConfig.lua` row `MONEY_ID` | confirmed |
| silver config row | item id `174`, name `银两`, `ItemType = 0` | `ItemConfig.lua` row `174` | confirmed |
| check item count | no jshyl usage found | no `GetItem`, `GetItemCount`, `HaveItem`, or equivalent found in allowed Lua/docs | unverified |
| remove item/silver | no jshyl usage found | no removal API usage found in allowed Lua/docs | unverified |

Do not assume `AddItem(174, -3000)` is safe until it is tested in a dedicated
implementation slice. The codebase currently treats `银两` as an item-backed
currency for grants, but the removal and insufficient-funds behavior are not
proven from jshyl Lua alone.

Recommended helper contract for the later implementation:

```lua
-- Namespaced helper, implemented only after verifying the underlying jynew API.
JSHYL.QQZJ.Inventory.GetItemCount(itemId)
JSHYL.QQZJ.Inventory.TryRemoveItem(itemId, count)
```

If the engine already exposes equivalent globals, the helpers should wrap them.
If the only viable primitive is negative `AddItem`, first verify that:

```text
1. it subtracts from id 174 correctly,
2. it does not underflow,
3. it updates save data,
4. it refreshes inventory/status UI after save/load.
```

## 2. Does 银两 Behave Like Inventory Or Currency?

`银两` currently behaves like an inventory-backed currency in jshyl:

| evidence | implication |
|---|---|
| `SettingsConfig.lua` defines `MONEY_ID = 174` | engine likely treats item id `174` as canonical money id |
| `ItemConfig.lua` row `174` is `银两` with `ItemType = 0` | it is represented as an item row, not a medicine/equipment row |
| opening arrival grants `AddItem(174, 10000)` | positive money grant uses the generic item API |
| 燕子坞 chest grants `AddItem(174, 30000)` | large money grant also uses item API |
| 侍剑 training grants `AddItem(174, 500)` | reward idempotency already works for silver grants |

Planning conclusion:

```text
Treat silver as item id 174 for storage and grants, but do not implement a
deduction until an item-count and item-removal path is verified.
```

## 3. Where Deduction Should Occur

Recommended deduction point: `5204` / `qqzj_protagonist_opening_shuige_entry`.

Reason:

```text
The TPR source describes the cost as the entry rule for ShuiGe. The player
should pay before the entry quest unlocks the inner marker. This keeps the
payment tied to access, not to a later chest reward.
```

Do not deduct at `5206`:

```text
5206 represents the already-unlocked inner marker. Charging there would let
the entry state unlock before payment and would confuse old-save migration.
```

Do not deduct at `5207`:

```text
5207 is a specific chest reward. Charging there would make the first chest
look like it costs 3000 silver, instead of the ShuiGe entry rule costing 3000.
```

Recommended future flow:

```text
5203 hint completed
  -> 5204 entry checks/resolves 3000 silver
  -> if paid or legacy-waived, unlock inner marker
  -> 5206 inner dialogue
  -> 5207 and later chest rewards
```

## 4. Required Flags

Add explicit payment-state flags; do not overload existing completion flags.

Recommended flags:

```text
qqzj_protagonist_opening_shuige_entry_silver_cost_started
qqzj_protagonist_opening_shuige_entry_silver_paid
qqzj_protagonist_opening_shuige_entry_silver_legacy_waived
qqzj_protagonist_opening_shuige_entry_silver_cost_resolved
qqzj_protagonist_opening_shuige_entry_insufficient_silver_seen
```

Flag meanings:

| flag | meaning |
|---|---|
| `silver_cost_started` | the payment gate has been presented at least once |
| `silver_paid` | a new-flow save successfully paid `银两` id `174` x3000 |
| `silver_legacy_waived` | an old save had already completed ShuiGe entry before the charge existed; no retroactive deduction |
| `silver_cost_resolved` | either `silver_paid` or `silver_legacy_waived`; safe to keep/open ShuiGe |
| `insufficient_silver_seen` | player saw the insufficient-funds branch at least once |

Avoid using only `silver_paid` as the sole gate because old saves may already
have ShuiGe opened or chest rewards claimed from the pre-charge implementation.

## 5. Behavior If Player Lacks Enough Silver

Recommended insufficient-funds behavior:

```text
1. Show 双儿 dialogue explaining that entry requires 3000 银两.
2. Do not deduct anything.
3. Do not set silver_paid or silver_cost_resolved.
4. Do not newly unlock the inner marker.
5. Set insufficient_silver_seen for save/debug visibility.
6. Return false from the quest so the interaction is clearly incomplete.
```

Important old-save exception:

```text
If the save already has `qqzj_protagonist_opening_shuige_entry_completed` or
`qqzj_protagonist_opening_shuige_inner_marker_unlocked` before the payment
flags exist, do not block that save for lack of silver. Mark the cost as
legacy-waived/resolved instead.
```

Do not send the player to the ShuiGe chest if payment is unresolved in a new
save. The `5207` chest should eventually check `silver_cost_resolved` before
granting source-faithful ShuiGe rewards.

## 6. Old-Save Compatibility

Recommended migration at the start of `qqzj_protagonist_opening_shuige_entry`:

```lua
if Flags.GetBool("qqzj_protagonist_opening_shuige_entry_completed")
    or Flags.GetBool("qqzj_protagonist_opening_shuige_inner_marker_unlocked")
    or Flags.GetBool("qqzj_protagonist_opening_shuige_inner_completed")
    or Flags.GetBool("qqzj_protagonist_opening_shuige_center_chest_reward_claimed") then
    if not Flags.GetBool("qqzj_protagonist_opening_shuige_entry_silver_cost_resolved") then
        Flags.SetBool("qqzj_protagonist_opening_shuige_entry_silver_legacy_waived", true)
        Flags.SetBool("qqzj_protagonist_opening_shuige_entry_silver_cost_resolved", true)
    end
end
```

Rationale:

```text
Players who already entered ShuiGe or claimed the current center chest should
not lose access, get charged retroactively, or become stuck behind a newly
introduced payment gate.
```

For a new save, `silver_cost_resolved` should be set only after real payment.

## 7. Acceptance Criteria

Acceptance criteria for the future implementation slice:

```text
1. 5204 remains the only place that charges the ShuiGe 3000-silver entry cost.
2. A new save with >=3000 银两 can pay once and then unlock ShuiGe entry.
3. A new save with <3000 银两 sees insufficient-funds dialogue and no marker unlock.
4. Repeated 5204 interaction after payment does not deduct again.
5. 5206 and 5207 do not deduct silver.
6. Old saves with ShuiGe already completed/opened are legacy-waived and not charged retroactively.
7. Save/load preserves paid/waived/resolved flags.
8. Silver amount after payment is verified in inventory/status UI or save data.
9. No rewards are granted as part of the payment slice.
10. Existing ShuiGe center chest idempotency remains unchanged.
```

## Recommended TPR-039A Implementation Prompt

Use this only after verifying the actual item count/removal API or designing a
small test around it:

```text
Proceed with TPR-039A: implement ShuiGe 3000-silver entry cost.

Read:
docs/tpr_extraction/TPR_039_SHUIGE_SILVER_DEDUCTION_PLAN.md

Allowed:
- Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- scene edits
- config edits
- new rewards
- new maps
- battles
- companions
- engine C#

Requirements:
1. Deduct 银两 id 174 x3000 only in `qqzj_protagonist_opening_shuige_entry`.
2. Before coding the final helper, verify the available API for:
   - checking item count
   - removing item count
3. If removal uses negative AddItem, prove it does not underflow before using it.
4. Add flags:
   - qqzj_protagonist_opening_shuige_entry_silver_cost_started
   - qqzj_protagonist_opening_shuige_entry_silver_paid
   - qqzj_protagonist_opening_shuige_entry_silver_legacy_waived
   - qqzj_protagonist_opening_shuige_entry_silver_cost_resolved
   - qqzj_protagonist_opening_shuige_entry_insufficient_silver_seen
5. New saves must pay before ShuiGe entry unlocks.
6. Old saves that already opened/completed ShuiGe should be legacy-waived.
7. Do not deduct again on repeated interaction.
8. Do not grant rewards in this slice.
9. Update docs/backlog.
```
