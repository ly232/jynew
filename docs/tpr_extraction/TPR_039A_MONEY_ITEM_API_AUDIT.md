# TPR-039A Audit: Money / Item Removal APIs

## Scope

Planning and API audit only. No Lua, scene, config, asset, gameplay, battle,
companion, or engine files changed in this task.

Inputs reviewed:

```text
docs/tpr_extraction/TPR_039_SHUIGE_SILVER_DEDUCTION_PLAN.md
Assets/Mods/jshyl/Lua/**
Assets/Mods/JYX2/Lua/**
Assets/Mods/SAMPLE/Lua/**
Assets/Mods/xiastart_roguelike/Lua/**
```

## 1. Existing APIs Found

| need | API / pattern | status |
|---|---|---|
| check whether player has enough money | `JudgeMoney(amount)` | found in JYX2 and SAMPLE scripts |
| read current money count | `GetMoneyCount()` | found in SAMPLE gambling script |
| deduct money without reward popup | `AddItemWithoutHint(174, -amount)` | found in JYX2 and SAMPLE scripts |
| deduct money with normal item mutation | `AddItem(174, -amount)` | found in SAMPLE scripts |
| deduct non-money item silently | `AddItemWithoutHint(itemId, -count)` | found widely in JYX2 scripts |
| deduct non-money item with normal item mutation | `AddItem(itemId, -count)` | found in SAMPLE scripts |
| check whether player has at least one item | `HaveItem(itemId)` | found in JYX2 and SAMPLE scripts |
| use item gate | `UseItem(itemId)` | found in JYX2 scripts |

No separate arbitrary item-count API was found in the inspected Lua scripts.
For money specifically, `JudgeMoney(amount)` and `GetMoneyCount()` are the
available count/check APIs.

## 2. Evidence / Examples

### Money Check Before Deduction

`Assets/Mods/JYX2/Lua/ka575.lua`:

```lua
if JudgeMoney(20) == true then goto label1 end;
...
AddItemWithoutHint(174, -20);
```

`Assets/Mods/SAMPLE/Lua/50.lua`:

```lua
if JudgeMoney(100) == true then goto label1 end;
...
AddItemWithoutHint(174, -100);
```

### Money Deduction With `AddItem`

`Assets/Mods/SAMPLE/Lua/196.lua`:

```lua
if JudgeMoney(100) == true then goto label1 end;
...
AddItem(174, -100);
```

### Current Money Count

`Assets/Mods/SAMPLE/Lua/195.lua`:

```lua
AddItem(174, -GetMoneyCount() // 2);
AddItem(174, GetMoneyCount() // 2);
AddItem(174, -GetMoneyCount());
AddItem(174, GetMoneyCount());
```

### Silent Money Deduction In Inn / Service Scripts

`Assets/Mods/JYX2/Lua/ka502.lua`:

```lua
if JudgeMoney(200) == true then goto label1 end;
...
AddItemWithoutHint(174, -200);
```

`Assets/Mods/JYX2/Lua/ka234.lua`:

```lua
if JudgeMoney(10) == true then goto label1 end;
...
AddItemWithoutHint(174, -10);
```

### Non-Money Item Check / Removal

`Assets/Mods/JYX2/Lua/ka676.lua`:

```lua
if HaveItem(138) and HaveItem(139) and HaveItem(140) and HaveItem(141) and HaveItem(142) then goto labelS end;
...
AddItemWithoutHint(138, -1);
AddItemWithoutHint(139, -1);
AddItemWithoutHint(140, -1);
AddItemWithoutHint(141, -1);
AddItemWithoutHint(142, -1);
```

`Assets/Mods/SAMPLE/Lua/910.lua`:

```lua
if UseItem(24) == true then goto label0 end;
...
AddItem(24, -1);
```

## 3. Is `AddItem(174, -3000)` Valid?

Yes, negative `AddItem` against money id `174` is a valid existing pattern.

Evidence:

```text
SAMPLE/Lua/196.lua uses AddItem(174, -100)
SAMPLE/Lua/195.lua uses AddItem(174, -GetMoneyCount() // 2)
SAMPLE/Lua/195.lua uses AddItem(174, -GetMoneyCount())
```

However, for a quiet service/payment flow, `AddItemWithoutHint(174, -3000)` is
the better match because the existing inn and service scripts use
`AddItemWithoutHint` after `JudgeMoney`.

Recommended conclusion:

```text
Use JudgeMoney(3000) to check affordability.
Use AddItemWithoutHint(174, -3000) to deduct ShuiGe entry cost.
Use AddItem(174, -3000) only if a visible item-change popup is explicitly wanted.
```

## 4. Separate Count-Check API

Money-specific count/check APIs:

| API | use |
|---|---|
| `JudgeMoney(amount)` | boolean affordability check |
| `GetMoneyCount()` | current money amount |

Item-specific APIs found:

| API | use |
|---|---|
| `HaveItem(itemId)` | boolean possession check, not quantity |
| `UseItem(itemId)` | gate around item usage, not quantity |

No generic `GetItemCount(itemId)` usage was found in the inspected Lua files.
For TPR-039B, no generic item-count helper is needed because ShuiGe payment is
money-specific.

## 5. Safe Deduction Implementation Strategy

Recommended implementation for `qqzj_protagonist_opening_shuige_entry`:

```text
1. Migrate old ShuiGe saves first.
2. If silver_cost_resolved is already true, do not deduct.
3. If this is a new unresolved save, call JudgeMoney(3000).
4. If JudgeMoney(3000) is false:
   - set insufficient-silver flag
   - show 双儿 insufficient-funds dialogue
   - return false
   - do not unlock ShuiGe marker if it is not already unlocked
5. If JudgeMoney(3000) is true:
   - optionally record before = GetMoneyCount() if available
   - call AddItemWithoutHint(174, -3000)
   - set silver_paid and silver_cost_resolved
   - continue existing 5204 entry unlock flow
6. Repeated interaction checks silver_cost_resolved and never deducts again.
```

Recommended flags, copied from TPR-039:

```text
qqzj_protagonist_opening_shuige_entry_silver_cost_started
qqzj_protagonist_opening_shuige_entry_silver_paid
qqzj_protagonist_opening_shuige_entry_silver_legacy_waived
qqzj_protagonist_opening_shuige_entry_silver_cost_resolved
qqzj_protagonist_opening_shuige_entry_insufficient_silver_seen
```

Recommended old-save migration:

```text
If any pre-payment ShuiGe progress flag is already true, set:
- qqzj_protagonist_opening_shuige_entry_silver_legacy_waived
- qqzj_protagonist_opening_shuige_entry_silver_cost_resolved

Do not retroactively deduct 3000 silver from these saves.
```

Pre-payment progress flags:

```text
qqzj_protagonist_opening_shuige_entry_completed
qqzj_protagonist_opening_shuige_inner_marker_unlocked
qqzj_protagonist_opening_shuige_inner_completed
qqzj_protagonist_opening_shuige_center_chest_reward_claimed
```

## 6. Recommended TPR-039B Implementation Prompt

```text
Proceed with TPR-039B: implement ShuiGe 3000-silver entry cost.

Read:
docs/tpr_extraction/TPR_039_SHUIGE_SILVER_DEDUCTION_PLAN.md
docs/tpr_extraction/TPR_039A_MONEY_ITEM_API_AUDIT.md

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
2. Use `JudgeMoney(3000)` for affordability.
3. Use `AddItemWithoutHint(174, -3000)` for the deduction.
4. Add/observe flags:
   - qqzj_protagonist_opening_shuige_entry_silver_cost_started
   - qqzj_protagonist_opening_shuige_entry_silver_paid
   - qqzj_protagonist_opening_shuige_entry_silver_legacy_waived
   - qqzj_protagonist_opening_shuige_entry_silver_cost_resolved
   - qqzj_protagonist_opening_shuige_entry_insufficient_silver_seen
5. New saves must pay before ShuiGe entry unlocks.
6. If the player lacks 3000 银两, show dialogue and do not unlock entry.
7. Old saves with ShuiGe already opened/completed should be legacy-waived.
8. Repeated interaction after payment or waiver must not deduct again.
9. Do not grant rewards in this slice.
10. Update docs/backlog.
```

