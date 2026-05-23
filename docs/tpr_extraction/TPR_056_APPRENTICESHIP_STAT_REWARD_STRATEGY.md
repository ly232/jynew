# TPR-056: Apprenticeship Stat Reward Strategy

## Scope

Planning only. This document designs the stat reward strategy for `主角剧情：拜师` after all five first-skill branch rewards are implemented.

No Lua, config, scene, Unity asset, gameplay, or engine files are changed by TPR-056.

## Source Stat Requirements

The extracted source section requires:

```text
主角武学常识 +50
2周起拜师需战斗，胜利后 selected combat 系数 +10
```

No additional apprenticeship stat rewards were identified in the current extraction.

Specifically, this planning pass found no source requirement here for:

```text
资质 / aptitude
攻击 / attack
道德 / ethics
内功适性 / MPPro
items
companions
```

## Existing API Audit

Lua bootstrap exports from `jyx2/Assets/BuildSource/Lua/main.lua` include:

| API | comment | recommended use for apprenticeship |
|---|---|---|
| `AddWuchang(roleId, value)` | 增加武学常识 | Use for `主角武学常识 +50`. |
| `JudgeWCH(roleId, low, high)` | 判断武学常识 | Optional verification/condition helper, not required for idempotent reward. |
| `AddQuanzhang(roleId, value)` | 增加拳掌 | Possible future branch 系数 reward. |
| `AddYujian(roleId, value)` | 增加御剑 | Possible future branch 系数 reward. |
| `AddShuadao(roleId, value)` | 增加耍刀 | Possible future branch 系数 reward. |
| `AddAnqi(roleId, value)` | 增加暗器 | Possible future branch 系数 reward. |
| `AddQimen(roleId, value)` | 增加奇门 | Possible future branch 系数 reward. |
| `AddAttackPoison(roleId, value)` | 增加功夫带毒 | Possible future 阿碧 / 暗毒 branch reward. |
| `AddAptitude(roleId, value)` | 增加资质 | Do not use for 武学常识. |
| `AddAttack(roleId, value)` | 加攻击力 | Not part of the extracted apprenticeship reward. |
| `AddEthics(value)` | 增加道德 | Not part of the extracted apprenticeship reward. |
| `SetPersonMPPro(roleId, value)` | 设置角色内功适性 | Not part of the extracted apprenticeship reward. |

Engine-side mapping from `Jyx2LuaBridge.cs`:

```text
AddWuchang(roleId, value) -> AddAttr(roleId, "Wuxuechangshi", value, "武学常识")
AddAptitude(roleId, value) -> AddAttr(roleId, "IQ", value, "资质")
```

Config/runtime evidence:

```text
CharacterConfig.lua has fieldIdx.Wuxuechangshi = 25
CharacterConfig.lua has fieldIdx.IQ = 29
RoleInstance has Wuxuechangshi and IQ as separate serialized fields
GameConst maps Wuxuechangshi as property id 21 and IQ/资质 as property id 25
```

Conclusion:

```text
武学常识 maps directly to Wuxuechangshi / AddWuchang.
It is not aptitude/IQ and should not use AddAptitude.
```

## Immediate Stat Reward Strategy

Recommended TPR-057:

```text
Implement only 主角武学常识 +50.
```

Use:

```lua
AddWuchang(0, 50)
```

Gate it after:

```text
selected branch exists
狼牙燕翎 consumed or legacy-waived
selected branch first-skill reward claimed
```

Reason:

```text
The source lists 武学常识 +50 as a universal apprenticeship reward.
It does not depend on which branch was selected.
It is safer than branch-specific 系数 because it has an exact API and no playthrough/battle dependency.
```

Recommended timing:

```text
Immediately after the selected branch first-skill reward is claimed, or on a repeated 5210 interaction if the skill reward was already claimed in an old save.
```

This preserves old-save compatibility.

## Branch-Specific 系数 Strategy

Defer branch-specific `+10` 系数.

Reason:

```text
The extraction says the +10 selected combat 系数 is tied to 2周起 apprenticeship battle victory.
The project has not yet planned playthrough/week detection, the battle id/config, or victory sequencing.
```

Likely future mapping:

| branch key | source 系别 | likely jynew stat API | risk |
|---|---|---|---|
| `abi` | 暗毒 | `AddAttackPoison(0, 10)` | Source says 暗毒; jynew separates `UsePoison`, `Anqi`, and `AttackPoison`, so exact meaning needs verification before implementation. |
| `dengbaichuan` | 御剑 | `AddYujian(0, 10)` | Low risk once battle gate exists. |
| `baobutong` | 指腿 | likely `AddQuanzhang(0, 10)` | jynew has no separate 指腿 field; likely represented by 拳掌, but this needs explicit confirmation. |
| `fengboe` | 兵器 | likely `AddShuadao(0, 10)` or `AddQimen(0, 10)` | Source 兵器 may mean weapon class, but jynew splits 耍刀 and 奇门; needs design. |
| `gongyegan` | 拳掌 | `AddQuanzhang(0, 10)` | Low risk once battle gate exists. |

Do not implement these in TPR-057.

## Risks Of Wrong Mapping

1. `武学常识` and `资质` are separate fields. Using `AddAptitude` would change IQ and fail source fidelity.
2. `暗毒` has no single obvious jynew stat. `AttackPoison`, `UsePoison`, and `Anqi` are different mechanics.
3. `指腿` has no distinct jynew field. Mapping it to `Quanzhang` may be reasonable but should be documented before mutation.
4. `兵器` is ambiguous in jynew because `Shuadao` and `Qimen` both cover weapon-like branches.
5. Branch +10 should not be granted before 2周+ battle logic is implemented, or old saves may get source-inaccurate free stats.
6. Every stat change must be idempotent because `Add*` APIs mutate runtime save data and show popups.

## Required Flags

For TPR-057:

```text
qqzj_protagonist_apprenticeship_wuchang_reward_claimed
```

Future branch/battle flags:

```text
qqzj_protagonist_apprenticeship_branch_stat_reward_claimed
qqzj_protagonist_apprenticeship_branch_abi_stat_reward_claimed
qqzj_protagonist_apprenticeship_branch_dengbaichuan_stat_reward_claimed
qqzj_protagonist_apprenticeship_branch_baobutong_stat_reward_claimed
qqzj_protagonist_apprenticeship_branch_fengboe_stat_reward_claimed
qqzj_protagonist_apprenticeship_branch_gongyegan_stat_reward_claimed
qqzj_protagonist_apprenticeship_battle_won
```

Do not create branch-stat flags until the battle/playthrough plan is ready.

## Old-Save Compatibility

Supported old-save cases for TPR-057:

| save state | behavior |
|---|---|
| Branch selected, token resolved, skill reward claimed, no stat flag | Grant `AddWuchang(0, 50)` once. |
| Branch selected, token resolved, skill reward not yet claimed | Let skill reward path run first; then grant or allow a follow-up interaction to grant 武学常识. |
| Branch selected before token-consumption feature | Existing token migration/waiver runs first; then reward flow can proceed. |
| Stat flag already set | Show already-claimed dialogue and do not call `AddWuchang` again. |

Do not try to infer prior 武学常识 from the current numeric value. The main character can already have high or maxed values in this mod, so save-flag idempotency is safer than stat-threshold inference.

## Recommended Ordering

Use this order:

```text
stats (+50)
↓
checkpoint
↓
slot wash audit
↓
ShuiGe study mechanics
↓
next TPR section
```

Reason:

```text
武学常识 +50 is the smallest source-required mutation left after the first-skill rewards.
A checkpoint after that gives a clean boundary before slot mutation.
Slot wash must be understood before ShuiGe shelves, because shelves also mutate skill slots.
Only then should the work move on to the next TPR section.
```

## Acceptance Criteria For TPR-057

TPR-057 should be accepted when:

```text
1. A selected apprenticeship branch with resolved token and claimed first skill grants 武学常识 +50 once.
2. The reward uses AddWuchang(0, 50).
3. The reward sets qqzj_protagonist_apprenticeship_wuchang_reward_claimed.
4. Repeated interaction does not grant 武学常识 again.
5. Old saves that already claimed first-skill rewards can claim 武学常识 once.
6. No branch-specific +10 系数 is granted.
7. No slot wash, battle, ShuiGe, item, companion, config, scene, or engine changes are introduced.
```

## Recommended TPR-057 Implementation Prompt

```text
Proceed with TPR-057: implement apprenticeship 武学常识 +50 only.

Read:
docs/tpr_extraction/TPR_056_APPRENTICESHIP_STAT_REWARD_STRATEGY.md
docs/tpr_extraction/TPR_055_APPRENTICESHIP_AFTER_ALL_BRANCH_REWARDS_CHECKPOINT.md

Allowed:
- Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- config edits
- scene edits
- slot wash logic
- battles
- companions
- items
- branch-specific 系数 rewards
- engine C#

Requirements:
1. Add universal apprenticeship stat reward:
   AddWuchang(0, 50)
2. Gate after:
   - selected branch exists
   - token consumed or legacy-waived
   - selected branch first-skill reward is claimed
3. Add idempotency flag:
   qqzj_protagonist_apprenticeship_wuchang_reward_claimed
4. Old saves with selected branch and first-skill reward claimed can receive it once.
5. Repeated interaction must not duplicate the stat reward.
6. Do not implement branch +10 系数.
7. Do not implement slot wash, battles, ShuiGe, items, companions, config, scene, or engine changes.
8. Update docs/backlog.

Done when:
- 武学常识 +50 is granted once after apprenticeship first-skill reward.
- repeated interaction does not duplicate it.
- all other source-missing systems remain deferred.
```

