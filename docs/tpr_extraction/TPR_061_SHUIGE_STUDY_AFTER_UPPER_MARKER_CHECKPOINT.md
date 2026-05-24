# TPR-061: ShuiGe Study Checkpoint After Upper Study Marker

## Scope

Checkpoint only. No gameplay, scene, Lua, config, or engine files are modified by this task.

This checkpoint audits ShuiGe study state after TPR-060 added the upper study marker and dialogue-only intro quest.

## 1. Implemented ShuiGe Event Ids

| event id | scene object | quest id | status | behavior |
|---:|---|---|---|---|
| `5204` | `jshyl_shuige_entry` | `qqzj_protagonist_opening_shuige_entry` | implemented | true ShuiGe entry gate; checks/deducts 银两 id `174` x3000 once; unlocks inner marker; preserves old saves through legacy cost waiver |
| `5206` | `jshyl_shuige_inner_marker` | `qqzj_protagonist_opening_shuige_inner` | implemented | dialogue/flags-only ShuiGe inner marker after entry unlock |
| `5207` | `jshyl_shuige_center_chest` | `qqzj_protagonist_opening_shuige_center_chest` | implemented | grants 海月清辉 id `209` x1 once; no other chest payload |
| `5211` | `jshyl_shuige_upper_study_marker` | `qqzj_protagonist_shuige_upper_study_intro` | implemented | dialogue/flags-only upper study intro gated after ShuiGe inner completion and apprenticeship second-slot wash |

Adjacent context:

- `5203` remains the earlier 阿朱 ShuiGe entry hint.
- `5210` remains the central apprenticeship master interaction.
- `5212` is still unused and reserved for shelf mechanics.

## 2. Implemented Quest Ids And Flags

### `qqzj_protagonist_opening_shuige_entry`

Flags:

```text
qqzj_protagonist_opening_shuige_entry_started
qqzj_protagonist_opening_shuige_entry_unlocked
qqzj_protagonist_opening_shuige_inner_marker_unlocked
qqzj_protagonist_opening_shuige_entry_insufficient_silver
qqzj_protagonist_opening_shuige_entry_paid
qqzj_protagonist_opening_shuige_entry_legacy_cost_waived
qqzj_protagonist_opening_shuige_entry_cost_resolved
qqzj_protagonist_opening_shuige_entry_completed
```

### `qqzj_protagonist_opening_shuige_inner`

Flags:

```text
qqzj_protagonist_opening_shuige_inner_started
qqzj_protagonist_opening_shuige_inner_dialogue_seen
qqzj_protagonist_opening_shuige_inner_completed
```

### `qqzj_protagonist_opening_shuige_center_chest`

Flags:

```text
qqzj_protagonist_opening_shuige_center_chest_started
qqzj_protagonist_opening_shuige_center_chest_reward_claimed
qqzj_protagonist_opening_shuige_center_chest_completed
```

### `qqzj_protagonist_shuige_upper_study_intro`

Flags:

```text
qqzj_protagonist_shuige_upper_study_intro_started
qqzj_protagonist_shuige_upper_study_intro_dialogue_seen
qqzj_protagonist_shuige_upper_study_intro_completed
```

Gate:

```text
qqzj_protagonist_opening_shuige_inner_completed
qqzj_protagonist_apprenticeship_second_slot_washed
```

This gate is correct for the first study-intro slice because it requires both ShuiGe access and a completed apprenticeship slot-wash baseline.

## 3. Remaining Shelf Mechanics

The source-complete ShuiGe study flow still needs:

1. A `5212` shelf interaction entry point.
2. A way to read the irreversible apprenticeship branch choice.
3. A way to offer only the four unchosen branch martial arts.
4. A protagonist fourth-slot wash using `SetOneMagic(0, 3, selectedShelfSkillId, 0)`.
5. Idempotent per-shelf/per-branch flags.
6. Repeat dialogue once all eligible shelf studies are claimed.
7. A deferred decision for 王语嫣 fourth-slot wash if she is present.

No additional item rewards are required for the shelf mechanic. The reward/effect is the fourth-slot martial-art wash.

## 4. Recommended 5212 Shelf Shape

Use one generic shelf marker first.

Recommended object/event/quest:

```text
object: jshyl_shuige_study_shelves
event: 5212
lua: Assets/Mods/jshyl/Lua/5212.lua
quest: qqzj_protagonist_shuige_study_shelves
```

Rationale:

- A single generic shelf keeps the scene edit small and avoids four or five clustered trigger boxes.
- The branch exclusion logic belongs in Lua, not in scene object duplication.
- One marker is easier to verify for idempotency and old-save behavior.
- Multiple shelf props can be added later as visual-only or interaction-specific refinements after the core logic is stable.

Do not use branch-specific shelf event ids yet. They create more scene binding work before the branching logic is verified.

Do not delay `5212` entirely. The prerequisite chain is now stable enough to plan the shelf behavior. The actual implementation should still happen after a dedicated plan.

## 5. Required Rewards / Effects

No items, stats, companions, or battles are required.

The future `5212` effect should be:

```text
SetOneMagic(0, 3, selectedShelfSkillId, 0)
```

Skill mapping:

| branch key | skill id | skill name |
|---|---:|---|
| `abi` | `206` | 七弦无形剑 |
| `dengbaichuan` | `207` | 回风舞柳剑 |
| `baobutong` | `208` | 如影随形腿 |
| `fengboe` | `209` | 飞沙走石刀 |
| `gongyegan` | `210` | 大风云飞掌 |

The selected apprenticeship branch should be excluded from shelf choices. For example, if the player chose `abi`, shelves should only offer skills `207`-`210`.

## 6. Recommended Next 5 Tasks

| id | task | type | purpose |
|---|---|---|---|
| `TPR-062` | Plan ShuiGe shelf mechanics | planning | Decide exact 5212 flags, branch exclusion, old-save behavior, and fourth-slot wash UX before gameplay changes. |
| `TPR-063` | Implement generic 5212 shelf marker and dialogue-only shelf browse | implementation | Add one shelf marker and quest shell without slot wash, if the plan wants another safety slice. |
| `TPR-064` | Implement protagonist fourth-slot shelf wash | implementation | Apply `SetOneMagic(0, 3, skillId, 0)` once per eligible shelf choice. |
| `TPR-065` | Audit 王语嫣 role/team/slot behavior | planning | Verify role id, presence rules, and whether source-faithful companion fourth-slot wash can be safe. |
| `TPR-066` | Plan mentor identity pipeline | planning | Return to final CharacterConfig/portrait/model strategy for 邓百川、包不同、风波恶、公冶干. |

Highest ROI next task: `TPR-062`, because the shelf logic is now the source-critical missing part of the ShuiGe study chain.

## 7. Recommended TPR-062 Prompt

```text
Proceed with TPR-062 planning only: ShuiGe shelf mechanics.

Do not implement gameplay.

Read:
docs/tpr_extraction/TPR_061_SHUIGE_STUDY_AFTER_UPPER_MARKER_CHECKPOINT.md
docs/tpr_extraction/TPR_059_SHUIGE_STUDY_MECHANICS_PLAN.md
docs/tpr_extraction/extractions/zhujuqinqing_apprenticeship.md
Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
Assets/Mods/jshyl/Configs/Lua/SkillConfig.lua

Task:
Plan the 5212 ShuiGe shelf mechanic.

Focus:
1. One generic shelf marker vs multiple shelf markers.
2. Exact quest id and flags.
3. How to read selected apprenticeship branch.
4. How to exclude the selected branch skill from shelf choices.
5. Whether to implement dialogue-only browse first or include fourth-slot wash immediately.
6. Safe use of `SetOneMagic(0, 3, skillId, 0)`.
7. Idempotency and old-save compatibility.
8. Whether 王语嫣 handling should remain deferred.
9. Acceptance criteria.
10. Recommended implementation prompt.

Allowed:
- docs/tpr_extraction/**
- read-only inspection of Lua/configs

Forbidden:
- Assets/Mods/**
- Unity scene files
- Lua edits
- config edits
- gameplay changes
- engine files

Output:
- detailed shelf implementation plan
- proposed event id / quest id / flags
- recommended TPR-063 prompt
```

## 8. Coverage Status

`主角剧情：拜师` remains `partially_implemented`.

The apprenticeship route is now playable through:

- intro
- branch choice
- 狼牙燕翎 consumption
- first-skill reward
- second-slot wash
- 武学常识 +50
- upper ShuiGe study intro

It is not source-complete because `5212` shelves, protagonist fourth-slot study wash, 王语嫣 handling, branch-specific +10 系数, later-week battle, and final mentor identity assets/interactions remain unfinished.
