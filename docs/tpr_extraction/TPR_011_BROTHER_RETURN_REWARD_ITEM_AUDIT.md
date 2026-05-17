# TPR-011 Audit: 大哥 Return Reward Item IDs

## Scope

Planning/audit only. No gameplay, Lua, config, scene, map, battle, companion, or
engine behavior was changed.

Source beat:

```text
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
大哥 return reward bundle:
- 金创药 x20
- 少阳丹 x20
- 玉真散 x20
- 人参养荣丸 x20
- 九转灵宝丸 x20
```

Files inspected read-only:

```text
Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua
Assets/Mods/jshyl/Configs/物品.xlsx
Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
docs/tpr_extraction/TPR_010_OPENING_REMAINDER_PLAN.md
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
```

Notes:

```text
The generated Lua item table provides line-level evidence. A read-only zipped
XML string scan of 物品.xlsx did not reveal additional exact matches for the
missing names. openpyxl is not installed in this environment, so the Excel file
was not parsed as structured rows.
```

## 1. Exact Item IDs Found

| source reward | requested quantity | exact item id | status |
|---|---:|---:|---|
| 玉真散 | 20 | 5 | found |
| 九转灵宝丸 | 20 | 14 | found |
| 金创药 | 20 | n/a | missing |
| 少阳丹 | 20 | n/a | missing |
| 人参养荣丸 | 20 | n/a | missing |

## 2. Source Evidence

Extraction source:

```text
docs/tpr_extraction/extractions/zhujuqinqing_opening.md:166
| 大哥 | 金创药 | 20 | `qqzj_protagonist_opening_brother_return_reward_claimed` | item id TBD |

docs/tpr_extraction/extractions/zhujuqinqing_opening.md:167
| 大哥 | 少阳丹 | 20 | same as above | item id TBD |

docs/tpr_extraction/extractions/zhujuqinqing_opening.md:168
| 大哥 | 玉真散 | 20 | same as above | item id TBD |

docs/tpr_extraction/extractions/zhujuqinqing_opening.md:169
| 大哥 | 人参养荣丸 | 20 | same as above | item id TBD |

docs/tpr_extraction/extractions/zhujuqinqing_opening.md:170
| 大哥 | 九转灵宝丸 | 20 | same as above | item id TBD |
```

Verified item rows:

```text
Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:67
{5,[[玉真散]],[[华山派所有，可恢复些许生命]],...}

Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:76
{14,[[九转灵宝丸]],[[全真教所有，可恢复内力]],...}
```

Current gameplay guard:

```text
Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua:227
-- Dialogue-only slice. Do not grant 玉真散、九转灵宝丸, or any other

Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua:228
-- 大哥 reward until the remaining item ids have been audited.
```

## 3. Missing Items

No exact match was found in `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua` or
the read-only Excel package string scan for:

```text
金创药
金創藥
少阳丹
少陽丹
人参养荣丸
人參養榮丸
```

Related but not exact existing medicine candidates include:

```text
小还丹 id 3
玉洞黑石丹 id 4
玉真散 id 5
三黄宝腊丹 id 6
九转灵宝丸 id 14
九转熊蛇丸 id 16
```

Do not silently substitute these for the missing TPR rewards unless a later task
explicitly approves a placeholder strategy.

## 4. Safe Reward Implementation Plan

Recommended next implementation if exact-source fidelity is required:

```text
Defer 大哥 reward grant until missing item ids are added to config or approved
placeholder substitutions are selected.
```

Recommended next implementation if a partial reward is acceptable:

```text
TPR-011A can grant only the verified exact items:
- AddItem(5, 20)  -- 玉真散
- AddItem(14, 20) -- 九转灵宝丸
```

Idempotency:

```text
1. Gate reward after qqzj_protagonist_opening_brother_return_completed.
2. If reward flag is already true, show already-claimed dialogue and grant nothing.
3. If reward flag is false, grant the approved item list and then set the reward flag.
4. Preserve save compatibility by never granting from dialogue completion alone.
```

Suggested helper-local reward table for implementation:

```lua
local brotherReturnRewards = {
    { itemId = 5, count = 20, name = "玉真散" },
    { itemId = 14, count = 20, name = "九转灵宝丸" },
}
```

If missing items are added later, append exact rows to the reward table in a
separate config-enabled task.

## 5. Proposed Reward Flag

Use the existing planned flag:

```text
qqzj_protagonist_opening_brother_return_reward_claimed
```

Current TPR-010A intentionally does not set this flag.

If partial rewards are granted first, the flag should mean:

```text
The currently approved 大哥 reward bundle for this MOD version has been claimed.
```

If exact rewards are required later, do not reuse the same flag for two different
reward definitions without a migration plan. Use either:

```text
qqzj_protagonist_opening_brother_return_reward_claimed
qqzj_protagonist_opening_brother_return_reward_v2_claimed
```

or a small migration function that detects old partial-claim saves and grants
only newly added missing items.

## 6. Deferred Rewards

Defer unless explicitly approved:

```text
金创药 x20
少阳丹 x20
人参养荣丸 x20
```

Reason:

```text
Exact item ids are missing from current jshyl item config. Placeholder
substitution would be design behavior, not an item-id audit result.
```

Safe recommendation:

```text
Proceed next with either:
1. TPR-011A exact-partial reward: grant 玉真散 id 5 x20 and 九转灵宝丸 id 14 x20 only.
2. TPR-011B config-enabled item creation: add the missing medicines first, then grant the full source bundle.
```
