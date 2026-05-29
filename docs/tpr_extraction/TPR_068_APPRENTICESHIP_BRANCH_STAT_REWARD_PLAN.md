# TPR-068: Apprenticeship Branch-Specific +10 Stat Reward Plan

## Scope

Planning only. This document does not implement gameplay.

The goal is to decide how the source `+10 系数` reward from `主角剧情：拜师` should map onto jynew/jshyl runtime APIs before any Lua mutation is added.

## Source Requirement

The extracted `主角剧情：拜师` section records the branch-specific `+10 系数` as a later-week apprenticeship battle reward:

```text
2周起拜师需战斗，胜利后 selected combat 系数 +10
```

That means the source-faithful timing is:

```text
branch selected
-> 狼牙燕翎 cost resolved
-> first skill reward
-> second-slot wash
-> later-week battle victory
-> branch-specific +10 系数
```

It should not be granted immediately after branch selection, after the first skill reward, or after the ShuiGe fourth-slot wash unless we intentionally choose a simplified non-source-complete prototype.

## Branch Requirements

The current extraction gives this branch table:

| branch id | mentor | skill | source 系数 |
|---|---|---|---|
| `abi` | 阿碧 | 七弦无形剑 | 暗毒 |
| `dengbaichuan` | 邓百川 | 回风舞柳剑 | 御剑 |
| `baobutong` | 包不同 | 如影随形腿 | 指腿 |
| `fengboe` | 风波恶 | 飞沙走石刀 | 兵器 |
| `gongyegan` | 公冶干 | 大风云飞掌 | 拳掌 |

The prompt listed `包不同 / 兵器?`, but the extraction and earlier branch design consistently say `包不同 / 指腿` and `风波恶 / 兵器`. Keep 包不同 as `指腿` unless the source page is re-extracted and proves otherwise.

## Existing Runtime Stat APIs

Read-only API inspection found these relevant Lua bridge helpers:

| API | CharacterConfig field | display meaning | evidence/use |
|---|---|---|---|
| `AddQuanzhang(roleId, value)` | `Quanzhang` | 拳掌 | bridge helper and sample Lua usage |
| `AddYujian(roleId, value)` | `Yujian` | 御剑 | bridge helper |
| `AddShuadao(roleId, value)` | `Shuadao` | 耍刀 | bridge helper |
| `AddQimen(roleId, value)` | `Qimen` | 奇门 | bridge helper |
| `AddAnqi(roleId, value)` | `Anqi` | 暗器 | bridge helper and sample Lua usage |
| `AddAttackPoison(roleId, value)` | `AttackPoison` | 功夫带毒 | bridge helper and sample Lua usage |
| `AddWuchang(roleId, value)` | `Wuxuechangshi` | 武学常识 | already used by TPR-057 |

`CharacterConfig.lua` confirms fields for `Quanzhang`, `Yujian`, `Shuadao`, `Qimen`, `Anqi`, `Wuxuechangshi`, and `AttackPoison`. There is no exact `指腿` field and no exact combined `暗毒` field.

## Proposed Mapping

Use this mapping only after the battle gate exists:

| branch id | source 系数 | proposed API | certainty | notes |
|---|---|---|---|---|
| `abi` | 暗毒 | `AddAttackPoison(0, 10)` | medium | Source says 暗毒. jynew separates 暗器 and 毒; `AttackPoison` is the closest single-stat poison mapping. Do not add both `AddAnqi` and `AddAttackPoison` for one `+10` reward. |
| `dengbaichuan` | 御剑 | `AddYujian(0, 10)` | high | Direct field/API match. |
| `baobutong` | 指腿 | `AddQuanzhang(0, 10)` | medium | No `指腿` field exists. Treat 指腿 as unarmed/拳掌 unless later config research finds a better convention. |
| `fengboe` | 兵器 | `AddShuadao(0, 10)` | medium | Source says generic 兵器, but the branch skill is `飞沙走石刀`; 耍刀 is the safest first-pass weapon mapping. `Qimen` is a possible alternate if source means miscellaneous weapons. |
| `gongyegan` | 拳掌 | `AddQuanzhang(0, 10)` | high | Direct field/API match. |

No branch needs to be permanently deferred, but `abi`, `baobutong`, and `fengboe` should remain documented as approximate mappings.

## Recommended Timing

Recommended source-faithful timing:

1. Add a future later-week apprenticeship battle gate.
2. Set a battle victory flag only after that battle is won.
3. Grant the selected branch `+10 系数` only after the battle victory flag is present.

Do not attach this reward to:

- branch selection
- 狼牙燕翎 consumption
- first skill reward
- second-slot wash
- ShuiGe fourth-slot wash

Those steps already make the current first-pass vertical slice playable, but the `+10 系数` is explicitly tied to a later-week battle in the extraction.

## Required Flags

Recommended future flags:

```text
qqzj_protagonist_apprenticeship_later_week_battle_won
qqzj_protagonist_apprenticeship_branch_stat_reward_claimed
qqzj_protagonist_apprenticeship_branch_<branch_id>_stat_reward_claimed
qqzj_protagonist_apprenticeship_branch_stat_reward_branch_id
qqzj_protagonist_apprenticeship_branch_stat_reward_api
```

Optional diagnostic/defer flags:

```text
qqzj_protagonist_apprenticeship_branch_stat_reward_deferred
qqzj_protagonist_apprenticeship_branch_stat_reward_approximate_mapping
```

Use the global `branch_stat_reward_claimed` flag as the primary idempotency guard. The per-branch flag is useful for debugging and old-save audits.

## Old-Save Compatibility

Old saves may already have:

- a selected branch
- token cost consumed or waived
- first skill reward claimed
- second-slot wash applied
- ShuiGe fourth-slot wash applied

They should not automatically receive `+10 系数` unless the future later-week battle victory flag is also present.

When implemented:

1. If `qqzj_protagonist_apprenticeship_branch_stat_reward_claimed` is true, do nothing.
2. If no branch is selected, do nothing.
3. If the later-week battle victory flag is missing, do nothing and optionally set the defer flag.
4. If the battle victory flag is present, apply the selected branch API once and set all reward flags.

This avoids retroactive free stats for old first-pass saves.

## Risks

- `暗毒` is not a single exact jynew stat. `AddAttackPoison` is a practical poison mapping, not a perfect textual match.
- `指腿` has no exact field. Mapping it to `Quanzhang` follows the unarmed-combat interpretation but may need source validation.
- `兵器` could mean broader weapon proficiency; `Shuadao` is chosen because the branch skill is a 刀法.
- Granting stats before the later-week battle would make the current first-pass slice easier than the source.
- Stat APIs mutate save data immediately and may display stat-gain hints, so idempotency flags must be set in the same quest step.
- If the protagonist is already at a stat cap, the API may clamp internally; still set the reward flag after the one intended grant attempt.

## Recommended TPR-069 Prompt

```text
Proceed with TPR-069: implement dormant battle-gated apprenticeship branch +10 stat reward.

Read:
docs/tpr_extraction/TPR_068_APPRENTICESHIP_BRANCH_STAT_REWARD_PLAN.md
docs/tpr_extraction/extractions/zhujuqinqing_apprenticeship.md

Allowed:
- Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- scene edits
- config edits
- new battles
- battle config edits
- new event ids
- companions
- engine C#

Requirements:
1. Add branch-stat reward helper logic for the selected apprenticeship branch.
2. Gate it behind:
   qqzj_protagonist_apprenticeship_later_week_battle_won
3. Do not create or trigger the later-week battle yet.
4. Because no current flow sets the battle victory flag, normal current gameplay should not receive +10 yet.
5. Use mappings:
   - abi -> AddAttackPoison(0, 10)
   - dengbaichuan -> AddYujian(0, 10)
   - baobutong -> AddQuanzhang(0, 10)
   - fengboe -> AddShuadao(0, 10)
   - gongyegan -> AddQuanzhang(0, 10)
6. Add idempotency flags:
   - qqzj_protagonist_apprenticeship_branch_stat_reward_claimed
   - qqzj_protagonist_apprenticeship_branch_<branch_id>_stat_reward_claimed
   - qqzj_protagonist_apprenticeship_branch_stat_reward_branch_id
   - qqzj_protagonist_apprenticeship_branch_stat_reward_api
7. Preserve all current apprenticeship, ShuiGe, skill reward, second-slot wash, fourth-slot wash, and 武学常识 behavior.

Done when:
- the stat reward code is present but dormant until the future battle victory flag exists
- repeated interactions cannot duplicate +10
- old first-pass saves do not receive free stats
- docs/backlog mark TPR-069 implemented
```

