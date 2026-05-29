# TPR-067: Apprenticeship / ShuiGe Checkpoint After Fourth-Slot Wash

## Scope

Checkpoint only. No gameplay, Lua, scene, config, Unity asset, or engine files are modified by this task.

This checkpoint audits `主角剧情：拜师` and ShuiGe study after TPR-066 added a branch-aware protagonist fourth-slot wash through the existing `5212` generic shelf.

## 1. Implemented End-To-End Apprenticeship Flow

The current playable chain is:

1. Opening/family flow grants `狼牙燕翎` id `206`.
2. `5210` / `jshyl_apprenticeship_master` starts `qqzj_protagonist_apprenticeship_intro`.
3. Player chooses exactly one irreversible apprenticeship branch.
4. `狼牙燕翎` is consumed once with old-save waiver support.
5. Selected branch first-skill reward is granted through `LearnMagic2(0, skillId, 0)`.
6. Protagonist second martial slot is washed through `SetOneMagic(0, 1, selectedSkillId, 0)`.
7. Universal 武学常识 +50 is granted through `AddWuchang(0, 50)`.
8. Repeated `5210` interaction reports the locked branch and does not duplicate token consumption, skill reward, second-slot wash, or 武学常识.

Implemented quest / state owner:

```text
quest id: qqzj_protagonist_apprenticeship_intro
event id: 5210
main object: jshyl_apprenticeship_master
```

Core flags:

```text
qqzj_protagonist_apprenticeship_branch_selected
qqzj_protagonist_apprenticeship_selected_branch_id
qqzj_protagonist_apprenticeship_langya_yanling_consumed
qqzj_protagonist_apprenticeship_langya_yanling_legacy_waived
qqzj_protagonist_apprenticeship_second_slot_washed
qqzj_protagonist_apprenticeship_wuchang_reward_claimed
```

Exactly one branch flag should be true:

```text
qqzj_protagonist_apprenticeship_branch_abi
qqzj_protagonist_apprenticeship_branch_dengbaichuan
qqzj_protagonist_apprenticeship_branch_baobutong
qqzj_protagonist_apprenticeship_branch_fengboe
qqzj_protagonist_apprenticeship_branch_gongyegan
```

## 2. Implemented ShuiGe Study Flow

The current ShuiGe chain is:

| event id | object | quest id | implemented behavior |
|---:|---|---|---|
| `5204` | `jshyl_shuige_entry` | `qqzj_protagonist_opening_shuige_entry` | pays 银两 id `174` x3000 once, or waives cost for old saves that already unlocked ShuiGe |
| `5206` | `jshyl_shuige_inner_marker` | `qqzj_protagonist_opening_shuige_inner` | inner ShuiGe dialogue/flags |
| `5207` | `jshyl_shuige_center_chest` | `qqzj_protagonist_opening_shuige_center_chest` | grants 海月清辉 id `209` x1 once |
| `5211` | `jshyl_shuige_upper_study_marker` | `qqzj_protagonist_shuige_upper_study_intro` | unlocks/records upper study access after ShuiGe inner completion and apprenticeship second-slot wash |
| `5212` | `jshyl_shuige_generic_shelf_marker` | `qqzj_protagonist_shuige_generic_shelf` | first interaction preserves generic shelf browse; later interaction washes protagonist fourth slot once to a deterministic unchosen branch skill |

TPR-066 added these `5212` flags:

```text
qqzj_protagonist_shuige_generic_shelf_fourth_slot_washed
qqzj_protagonist_shuige_generic_shelf_reward_skill_<branch>
qqzj_protagonist_shuige_generic_shelf_reward_skill_id
qqzj_protagonist_shuige_generic_shelf_reward_branch_id
```

Important behavior:

```text
qqzj_protagonist_shuige_generic_shelf_completed remains browse-only compatibility state.
The actual fourth-slot wash is guarded by qqzj_protagonist_shuige_generic_shelf_fourth_slot_washed.
```

## 3. Branch To Second-Slot Mapping

| selected branch | mentor | selected skill id | selected skill | second-slot behavior |
|---|---|---:|---|---|
| `abi` | 阿碧 | `206` | 七弦无形剑 | `SetOneMagic(0, 1, 206, 0)` |
| `dengbaichuan` | 邓百川 | `207` | 回风舞柳剑 | `SetOneMagic(0, 1, 207, 0)` |
| `baobutong` | 包不同 | `208` | 如影随形腿 | `SetOneMagic(0, 1, 208, 0)` |
| `fengboe` | 风波恶 | `209` | 飞沙走石刀 | `SetOneMagic(0, 1, 209, 0)` |
| `gongyegan` | 公冶干 | `210` | 大风云飞掌 | `SetOneMagic(0, 1, 210, 0)` |

## 4. Branch To Fourth-Slot Shelf Reward Mapping

TPR-066 intentionally implements one deterministic shelf reward, not full multi-shelf collection.

It chooses the next branch in canonical order, wrapping around, so the chosen apprenticeship skill is excluded.

| selected branch | excluded skill | shelf reward skill id | shelf reward skill | fourth-slot behavior |
|---|---|---:|---|---|
| `abi` | 七弦无形剑 `206` | `207` | 回风舞柳剑 | `SetOneMagic(0, 3, 207, 0)` |
| `dengbaichuan` | 回风舞柳剑 `207` | `208` | 如影随形腿 | `SetOneMagic(0, 3, 208, 0)` |
| `baobutong` | 如影随形腿 `208` | `209` | 飞沙走石刀 | `SetOneMagic(0, 3, 209, 0)` |
| `fengboe` | 飞沙走石刀 `209` | `210` | 大风云飞掌 | `SetOneMagic(0, 3, 210, 0)` |
| `gongyegan` | 大风云飞掌 `210` | `206` | 七弦无形剑 | `SetOneMagic(0, 3, 206, 0)` |

This is source-aligned as a first shelf reward because it never offers the selected apprenticeship branch skill. It is still not the full source shelf system because the other three unchosen shelf arts are not claimable yet.

## 5. Remaining Missing

Still missing for `主角剧情：拜师` source completeness:

| missing area | status |
|---|---|
| branch-specific +10 stats / 系数 | missing; requires stat API mapping and likely later-week battle dependency |
| real mentor identity / portrait / model work | missing; four mentor placeholders are visual-only and have no final CharacterConfig rows |
| branch-specific shelves | missing; current `5212` gives one deterministic unchosen reward only |
| source-complete ShuiGe rewards | partial; upper study, generic shelf browse, and one fourth-slot reward exist, but not all four unchosen shelf martial arts |
| 王语嫣 shelf wash | missing; role/team/slot handling remains unaudited |
| full room expansion | missing; ShuiGe remains same-scene marker-based, not a real room/interior map |
| 2周+ apprenticeship battle gate | missing; needs playthrough/week detection and battle design |
| per-mentor interactions | missing; `5210` remains centralized |

## 6. Functional Completeness Assessment

`主角剧情：拜师` is now functionally complete as a single-pass protagonist vertical slice:

```text
choose branch
consume token
learn selected skill
wash second slot
gain 武学常识 +50
enter ShuiGe upper study
browse shelf
wash fourth slot once to an unchosen martial art
avoid duplicate rewards after save/load
```

It remains source-incomplete.

Reasons:

```text
the source describes the other four unchosen shelf arts, not only one
王语嫣 companion wash is not implemented
2周+ battle / +10 系数 is not implemented
mentor identities and per-mentor scenes are still placeholders
ShuiGe does not yet have a real interior room
```

Keep status as:

```text
partially_implemented
```

Do not move to `implemented` or `verified` until the missing source mechanics are implemented and Unity-tested.

## 7. Recommended Next 5 Tasks

| id | task | type | why |
|---|---|---|---|
| `TPR-068` | plan branch-specific +10 系数/stat rewards | planning | Highest mechanical gap after slot wash; should map each branch to exact jynew stat APIs before coding. |
| `TPR-069` | audit 王语嫣 ShuiGe shelf wash | planning | Source mentions companion fourth-slot wash, but role/team/slot behavior must be verified first. |
| `TPR-070` | plan real mentor CharacterConfig/portrait/model pipeline | planning | Needed before replacing decorative placeholders with source-complete mentors. |
| `TPR-071` | plan per-mentor interactions | planning | Can make mentor identities playable after the character pipeline is known. |
| `TPR-072` | extract the next TPR section after 拜师 | extraction | Once remaining 拜师 mechanics are planned, continue coverage into the next 主角剧情 subsection. |

## 8. Next Work Recommendation

Next work should be branch-specific +10 stats planning.

Rationale:

```text
1. The protagonist apprenticeship path now has both required slot-wash beats.
2. The remaining most gameplay-relevant source gap is branch-specific 系数 +10.
3. This likely requires careful stat API mapping, so it should be planned before implementation.
4. Real mentor identity work and room expansion are important but less blocking for the mechanical source path.
5. Next TPR extraction should wait until the current 拜师 mechanics have at least one more checkpoint.
```

Recommended next prompt:

```text
Proceed with TPR-068 planning only: apprenticeship branch-specific +10 stat rewards.

Do not implement gameplay.

Read:
docs/tpr_extraction/TPR_067_APPRENTICESHIP_SHUIGE_AFTER_FOURTH_SLOT_WASH_CHECKPOINT.md
docs/tpr_extraction/extractions/zhujuqinqing_apprenticeship.md
Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
Assets/Mods/jshyl/Configs/Lua/CharacterConfig.lua

Task:
Plan how to implement selected-branch +10 系数 rewards after apprenticeship.

Focus:
1. Exact source requirement and whether it depends on 2周+ battle victory.
2. Mapping branches to jynew stat APIs.
3. Existing Lua stat API examples.
4. Whether to implement now or defer until battle/week detection.
5. Required flags and old-save compatibility.
6. Risks.
7. Recommended implementation prompt.

Allowed:
- docs/tpr_extraction/**
- read-only inspection of Lua/configs

Forbidden:
- Lua edits
- config edits
- scene edits
- gameplay changes
- engine edits
```

## Unity Verification Needed

Manual or automated Unity verification should confirm:

```text
1. Complete opening enough to receive 狼牙燕翎.
2. Choose each of the five apprenticeship branches in separate saves.
3. Confirm selected branch first skill and second-slot wash.
4. Complete ShuiGe entry, inner marker, upper study, and generic shelf browse.
5. Interact with 5212 again and confirm fourth slot maps as listed above.
6. Save/load after fourth-slot wash and confirm repeated shelf interaction does not wash again.
7. Confirm no items/stats/battles/companions are added by 5212.
```
