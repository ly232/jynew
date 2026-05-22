# TPR-048: Apprenticeship 狼牙燕翎 Consumption Plan

## Scope

Planning only. This document audits existing Lua item APIs and designs how apprenticeship should consume `狼牙燕翎` item id `206`.

No Lua, config, scene, gameplay, Unity asset, or engine files are changed by TPR-048.

## Current State

Implemented before this plan:

```text
TPR-044: irreversible apprenticeship branch choice flags.
TPR-047: exact apprenticeship skill config rows ids 206-210.
```

Still missing:

```text
狼牙燕翎 consumption
skill grant / slot wash
武学常识 +50
2周+ battle gate
ShuiGe upper study
```

`狼牙燕翎` source:

```text
item id: 206
grant source: qqzj_protagonist_opening_family_briefing_tool_reward_claimed
use source: give to 阿碧 or one of 四大家将 to choose apprenticeship branch
```

## Existing Item APIs

Read-only API evidence:

| API | evidence | behavior |
|---|---|---|
| `HaveItem(itemId)` | `Assets/BuildSource/Lua/main.lua` maps it to `luaBridge.HaveItem`; JYX2 scripts use it for non-money items | Boolean possession check, enough for count >= 1. |
| `AddItem(itemId, count)` | `Jyx2LuaBridge.AddItem`; comment says `count` can be negative | Adds/removes item and displays pop info. |
| `AddItemWithoutHint(itemId, count)` | `Jyx2LuaBridge.AddItemWithoutHint`; many JYX2 scripts remove items with negative count | Adds/removes item silently. |
| `JudgeMoney(amount)` / `GetMoneyCount()` | money-only APIs | Not useful for item id 206 except as a pattern for pre-check before removal. |

Existing script patterns:

```text
JYX2/Lua/ka676.lua:
  if HaveItem(138) and HaveItem(139) ... then
    AddItemWithoutHint(138, -1)
    ...

JYX2/Lua/ka528.lua:
  if HaveItem(183) == true then ...

SAMPLE/Lua/196.lua:
  item uniqueness uses HaveItem(item)
```

Conclusion:

```text
Use HaveItem(206) as the count >= 1 check.
Use AddItemWithoutHint(206, -1) for the actual consumption.
```

`AddItem(206, -1)` is technically valid because engine comments say negative count is allowed, but `AddItemWithoutHint(206, -1)` is preferred for quest accounting because dialogue already explains the exchange and existing JYX2 material-consumption scripts use the no-hint form.

## Count-Check Limitations

No generic `GetItemCount(itemId)` Lua API is exposed in `BuildSource/Lua/main.lua`; only `GetMoneyCount()` is exposed for money.

Practical implication:

```text
TPR-049 can only verify possession of at least one 狼牙燕翎 through HaveItem(206).
It should remove exactly one with AddItemWithoutHint(206, -1).
```

This is sufficient because the source requires one token.

## Where Consumption Should Occur

Recommended location:

```text
After branch selection is confirmed, before any skill grant/stat reward is applied.
```

Why not consume before branch selection:

```text
The player should be able to review or decline the five mentor routes without paying the token.
```

Why not wait until per-branch skill reward:

```text
The token represents committing to apprenticeship. Delaying until a later reward slice would leave branch-selected saves in a misleading "chosen but unpaid" state for too long.
```

Recommended TPR-049 behavior:

```text
1. If no branch is selected yet, final branch confirmation must require HaveItem(206).
2. If HaveItem(206) is false, show missing-token dialogue and do not lock a new branch.
3. If HaveItem(206) is true, lock the selected branch and consume exactly one token.
4. Mark consumption/cost flags.
5. Do not grant skills or stats yet.
```

## Old-Save Compatibility

TPR-044 already allowed branch selection without consuming item id `206`.

Recommended migration:

```text
If branch is already selected and token cost is unresolved:
  - if HaveItem(206), consume one token and set consumed/cost-resolved flags.
  - if not HaveItem(206), set legacy-waived/cost-resolved flags and do not block the save.
```

Rationale:

```text
Older saves reached a valid state under the rules available at that time. Blocking them after the fact would be worse than waiving one inert key item.
```

New saves after TPR-049 should not get the waiver path unless a branch was already selected before the new consumption logic runs.

## Proposed Flags

Consumption state:

```text
qqzj_protagonist_apprenticeship_langya_yanling_consumed
qqzj_protagonist_apprenticeship_langya_yanling_cost_resolved
qqzj_protagonist_apprenticeship_langya_yanling_missing
qqzj_protagonist_apprenticeship_langya_yanling_legacy_waived
```

Existing related flags:

```text
qqzj_protagonist_apprenticeship_branch_selected
qqzj_protagonist_apprenticeship_selected_branch_id
qqzj_protagonist_apprenticeship_choose_master_completed
qqzj_protagonist_apprenticeship_branch_abi
qqzj_protagonist_apprenticeship_branch_dengbaichuan
qqzj_protagonist_apprenticeship_branch_baobutong
qqzj_protagonist_apprenticeship_branch_fengboe
qqzj_protagonist_apprenticeship_branch_gongyegan
```

## Failure Behavior

If player has no `狼牙燕翎` before selecting a branch:

```text
1. Dialogue explains that 狼牙燕翎 is required.
2. Set qqzj_protagonist_apprenticeship_langya_yanling_missing.
3. Do not set branch selected flags.
4. Do not consume anything.
5. Allow retry after player obtains the token.
```

If branch was already selected before TPR-049:

```text
1. If token exists, consume it once.
2. If token is missing, mark legacy waived and continue.
3. Repeated interaction must not consume or waive again.
```

## Recommended Implementation Shape

Add helper-style local functions inside `jshyl_qqzj_quest.lua`:

```text
has_langya_yanling()
resolve_apprenticeship_token_cost_for_new_branch(branch)
migrate_apprenticeship_token_cost_for_existing_branch()
```

Suggested logic:

```text
local langyaYanlingItemId = 206

if costResolved then
  return true
end

if selectedBranchAlreadyExistsBeforePrompt then
  if HaveItem(langyaYanlingItemId) then
    AddItemWithoutHint(langyaYanlingItemId, -1)
    set consumed
  else
    set legacy waived
  end
  set cost resolved
  return true
end

if HaveItem(langyaYanlingItemId) ~= true then
  set missing
  show dialogue
  return false
end

AddItemWithoutHint(langyaYanlingItemId, -1)
set consumed
set cost resolved
return true
```

Do not call `AddItemWithoutHint(206, -1)` unless either:

```text
HaveItem(206) == true
```

or the code is explicitly preserving an older state and has chosen to waive instead of remove.

## Acceptance Criteria

TPR-049 should be accepted when:

```text
1. New branch selection requires HaveItem(206).
2. If the token is missing, branch choice is not locked and can be retried.
3. If the token exists, exactly one 狼牙燕翎 is removed with AddItemWithoutHint(206, -1).
4. Consumption is idempotent through save/load.
5. Old saves with branch already selected consume once if possible.
6. Old saves with branch already selected but no token are legacy-waived and not blocked.
7. Repeated interaction never removes a second token.
8. No skill grants, stat changes, battles, scene edits, companion changes, or config edits occur.
```

## Recommended TPR-049 Prompt

```text
Proceed with TPR-049: consume 狼牙燕翎 once for apprenticeship branch.

Read:
docs/tpr_extraction/TPR_048_APPRENTICESHIP_LANGYA_YANLING_CONSUMPTION_PLAN.md
docs/tpr_extraction/extractions/zhujuqinqing_apprenticeship.md

Allowed:
- Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- config edits
- scene edits
- skill grants
- stat changes
- battles
- companions
- engine C#

Requirements:
1. Consume 狼牙燕翎 item id 206 exactly once when apprenticeship branch selection is finalized.
2. Before new branch selection locks, require HaveItem(206).
3. If missing:
   - show missing-token dialogue
   - set qqzj_protagonist_apprenticeship_langya_yanling_missing
   - do not lock branch selection
   - allow retry later
4. If present:
   - call AddItemWithoutHint(206, -1)
   - set qqzj_protagonist_apprenticeship_langya_yanling_consumed
   - set qqzj_protagonist_apprenticeship_langya_yanling_cost_resolved
5. Preserve old saves:
   - if branch was already selected before this feature and cost is unresolved, consume once if HaveItem(206)
   - if old save lacks item 206, set qqzj_protagonist_apprenticeship_langya_yanling_legacy_waived and cost_resolved
6. Repeated interaction must not consume more than once.
7. Do not grant skills or stats.
8. Do not start battles or edit scenes.
9. Update docs/backlog.

Done when:
- token consumption is idempotent
- missing-token path is retryable
- old-save selected branches are safe
- no other gameplay effects are added
```
