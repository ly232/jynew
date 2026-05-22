# TPR-050: Apprenticeship First Branch Reward Plan

## Scope

Planning only. This document designs the first real reward slice for:

```text
阿碧 / 七弦无形剑 / 暗毒
```

No Lua, config, scene, Unity asset, gameplay, or engine files are changed by TPR-050.

## Current State

Already implemented:

```text
TPR-042A: dedicated 5210 apprenticeship interaction.
TPR-044: irreversible five-branch choice flags.
TPR-047: exact apprenticeship skill config rows ids 206-210.
TPR-049: idempotent 狼牙燕翎 id 206 consumption / old-save waiver.
```

Still missing:

```text
selected branch skill grant
second skill slot wash
武学常识 +50
暗毒 or other selected 系数 changes
2周+ battle gate
ShuiGe upper study / unchosen skill shelves
```

## API Evidence

Existing Lua exports:

| API | evidence | meaning |
|---|---|---|
| `LearnMagic2(roleId, magicId, noDisplay)` | `jyx2/Assets/BuildSource/Lua/main.lua` maps it to `luaBridge.LearnMagic2` | Learn a martial art, or raise it if already learned. |
| `SetOneMagic(roleId, magicIndexRole, magicId, level)` | `jyx2/Assets/BuildSource/Lua/main.lua` maps it to `luaBridge.SetOneMagic` | Replace a role skill slot by index. |
| `AddWuchang(roleId, value)` | `jyx2/Assets/BuildSource/Lua/main.lua` maps it to `luaBridge.AddWuchang` | Increase 武学常识. |
| `AddAttackPoison(roleId, value)` | `jyx2/Assets/BuildSource/Lua/main.lua` maps it to `luaBridge.AddAttackPoison` | Increase 功夫带毒. |

Engine-side behavior:

```text
Jyx2LuaBridge.LearnMagic2:
  未学会武功则习得武功,否则武功等级+1

Jyx2LuaBridge.SetOneMagic:
  role.Wugongs[magicIndexRole].Key = magicId
  role.Wugongs[magicIndexRole].Level = level
```

Existing script examples:

```text
Assets/Mods/SAMPLE/Lua/318.lua:
  LearnMagic2(30, 33, 1)

Assets/Mods/SAMPLE/Lua/720.lua:
  LearnMagic2(0, 72, 1)

Assets/Mods/JYX2/Lua/ka289.lua:
  SetOneMagic(36, 0, 60, 100)

Assets/Mods/JYX2/Lua/ka115.lua:
  SetOneMagic(13, 1, 92, 900)
```

Conclusion:

```text
LearnMagic2 is the safest first reward API.
SetOneMagic is likely needed for source-faithful "wash second skill slot", but slot-index semantics should be audited separately before use.
```

## Skill Id 206 Loadability

`七弦无形剑` exists in generated config:

```text
jyx2/Assets/Mods/jshyl/Configs/Lua/SkillConfig.lua
  id 206
  name 七弦无形剑
```

Current row:

```lua
{206,[[七弦无形剑]],0,1,4,0,{{25,3,0,0,0},{50,3,0,0,0},{75,3,0,0,0},{100,4,0,0,0},{125,4,0,0,0},{150,4,0,0,0},{175,5,0,0,0},{200,5,0,0,0},{225,5,0,0,0},{400,6,0,0,0}}},
```

This means the skill is loadable as config data. It does not prove that battle display assets are ready for actual combat usage, so TPR-051 should not force a battle or skill cast.

## Reward Timing Recommendation

Recommended:

```text
Grant 七弦无形剑 through the next repeated 5210 interaction after branch selection and token-cost resolution.
```

Do not grant it inside the same atomic branch-selection block yet.

Reasons:

```text
1. TPR-049 just introduced item consumption; keeping skill reward separate reduces irreversible side effects per interaction.
2. Existing saves that already selected 阿碧 can still claim the reward once.
3. Reward idempotency can be tested independently from token consumption.
4. Later branches can reuse the same "selected branch -> claim reward" pattern.
```

Recommended first behavior:

```text
If 阿碧 branch selected and 狼牙燕翎 cost is consumed or legacy-waived:
  ask whether to receive 七弦无形剑
  if yes, call LearnMagic2(0, 206, 0)
  set reward flags
```

## Stat And Slot Changes

Defer stat changes and skill-slot wash.

Spec items still requiring a smaller audit:

```text
source "second skill slot wash" -> likely SetOneMagic(0, 1, 206, level), but index and level must be verified.
source 武学常识 +50 -> AddWuchang(0, 50), but should be separate and idempotent.
source 暗毒 / selected 系数 -> likely AddAttackPoison for 阿碧 branch, but amount and timing are not yet verified.
```

TPR-051 should not call:

```text
SetOneMagic
AddWuchang
AddAttackPoison
```

## Required Flags

New reward flags for TPR-051:

```text
qqzj_protagonist_apprenticeship_abi_reward_started
qqzj_protagonist_apprenticeship_abi_skill_learned
qqzj_protagonist_apprenticeship_abi_reward_completed
```

Existing dependency flags:

```text
qqzj_protagonist_apprenticeship_branch_selected
qqzj_protagonist_apprenticeship_branch_abi
qqzj_protagonist_apprenticeship_langya_yanling_consumed
qqzj_protagonist_apprenticeship_langya_yanling_legacy_waived
```

Deferred future flags:

```text
qqzj_protagonist_apprenticeship_second_slot_washed
qqzj_protagonist_apprenticeship_wuxuechangshi_applied
qqzj_protagonist_apprenticeship_abi_stat_reward_applied
```

## Old-Save Compatibility

Old-save cases:

| case | recommended behavior |
|---|---|
| Branch not selected | Continue existing branch-selection flow. |
| 阿碧 selected and token consumed | Offer/claim 七弦无形剑 reward once. |
| 阿碧 selected and token legacy-waived | Offer/claim 七弦无形剑 reward once. |
| 阿碧 selected before TPR-049 and token cost unresolved | Let existing TPR-049 cost-resolution logic run first; then reward can be claimed after cost is resolved. |
| Non-阿碧 branch selected | Do not grant 七弦无形剑; show that this branch reward is not implemented yet. |
| Reward flag already set | Show already-learned dialogue and do not call `LearnMagic2` again. |

No reliable generic Lua API was found for "role already has skill id 206". Therefore, reward idempotency should rely on save flags rather than introspecting the role skill list.

## Failure Modes

| failure mode | handling |
|---|---|
| Skill id 206 config missing after a bad config rebuild | Do not implement fallback id; treat as a config regression. |
| Player selected a different branch | No reward grant; preserve branch irreversibility. |
| Token cost not resolved | Resolve via existing TPR-049 logic before reward; do not grant while unpaid/unwaived. |
| Skill display asset missing | Learning can still be granted, but do not force battle/cast in this slice. |
| Repeated interaction | Dialogue only; no second `LearnMagic2` call. |

## Acceptance Criteria For TPR-051

TPR-051 should be accepted when:

```text
1. Only 阿碧 branch can claim 七弦无形剑.
2. The reward requires consumed or legacy-waived 狼牙燕翎.
3. The reward calls LearnMagic2(0, 206, 0) exactly once per save.
4. Reward flags persist across save/load.
5. Repeated interaction does not duplicate the reward.
6. Non-阿碧 branches do not receive 七弦无形剑.
7. No config, scene, battle, companion, stat, or engine changes are made.
```

## Recommended TPR-051 Implementation Prompt

```text
Proceed with TPR-051: implement 阿碧 apprenticeship skill reward only.

Read:
docs/tpr_extraction/TPR_050_APPRENTICESHIP_FIRST_BRANCH_REWARD_PLAN.md
docs/tpr_extraction/extractions/zhujuqinqing_apprenticeship.md

Allowed:
- Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- config edits
- scene edits
- skill-slot wash
- stat changes
- battles
- companions
- engine C#

Requirements:
1. Extend the existing 5210 apprenticeship flow.
2. If 阿碧 branch is selected and 狼牙燕翎 is consumed or legacy-waived, offer the first branch reward.
3. Grant 七弦无形剑 with:
   LearnMagic2(0, 206, 0)
4. Use flags:
   - qqzj_protagonist_apprenticeship_abi_reward_started
   - qqzj_protagonist_apprenticeship_abi_skill_learned
   - qqzj_protagonist_apprenticeship_abi_reward_completed
5. Reward must be idempotent.
6. Non-阿碧 branches should show deferred-reward dialogue and receive no skill.
7. Do not call SetOneMagic, AddWuchang, or AddAttackPoison yet.
8. Update docs/backlog.

Done when:
- 阿碧 branch learns 七弦无形剑 once.
- repeated interaction does not duplicate the grant.
- old saves with 阿碧 branch and resolved/waived token can claim once.
- no unrelated gameplay systems change.
```

