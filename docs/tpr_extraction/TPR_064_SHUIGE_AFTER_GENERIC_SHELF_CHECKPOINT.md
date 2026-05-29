# TPR-064: ShuiGe Checkpoint After Generic Shelf

## Scope

Checkpoint only. No gameplay, scene, Lua, config, Unity asset, or engine files are modified by this task.

This checkpoint audits the ShuiGe exploration and study chain after TPR-063 added the generic shelf marker / event `5212`.

## 1. Implemented ShuiGe Exploration Chain

| event id | scene object | quest id | status | behavior |
|---:|---|---|---|---|
| `5204` | `jshyl_shuige_entry` | `qqzj_protagonist_opening_shuige_entry` | implemented | true ShuiGe entry gate; checks and deducts 银两 id `174` x3000 once; unlocks the inner marker; old saves that already unlocked ShuiGe receive a legacy cost waiver |
| `5206` | `jshyl_shuige_inner_marker` | `qqzj_protagonist_opening_shuige_inner` | implemented | dialogue/flags-only inner ShuiGe observation after entry unlock |
| `5207` | `jshyl_shuige_center_chest` | `qqzj_protagonist_opening_shuige_center_chest` | implemented | idempotent center chest reward; grants 海月清辉 id `209` x1 only |
| `5211` | `jshyl_shuige_upper_study_marker` | `qqzj_protagonist_shuige_upper_study_intro` | implemented | dialogue/flags-only upper study intro gated after ShuiGe inner completion and apprenticeship second-slot wash |
| `5212` | `jshyl_shuige_generic_shelf_marker` | `qqzj_protagonist_shuige_generic_shelf` | implemented | dialogue/flags-only generic shelf observation gated after upper study intro |

Adjacent context:

- `5203` remains the 阿朱 ShuiGe entry hint.
- `5210` remains the central apprenticeship interaction and branch reward entry point.
- `5212` is currently a stable shelf entry shell only; it does not yet apply source-faithful study effects.

## 2. Current Quest Ids And Flags

### `qqzj_protagonist_opening_shuige_entry`

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

```text
qqzj_protagonist_opening_shuige_inner_started
qqzj_protagonist_opening_shuige_inner_dialogue_seen
qqzj_protagonist_opening_shuige_inner_completed
```

### `qqzj_protagonist_opening_shuige_center_chest`

```text
qqzj_protagonist_opening_shuige_center_chest_started
qqzj_protagonist_opening_shuige_center_chest_reward_claimed
qqzj_protagonist_opening_shuige_center_chest_completed
```

### `qqzj_protagonist_shuige_upper_study_intro`

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

### `qqzj_protagonist_shuige_generic_shelf`

```text
qqzj_protagonist_shuige_generic_shelf_started
qqzj_protagonist_shuige_generic_shelf_dialogue_seen
qqzj_protagonist_shuige_generic_shelf_completed
```

Gate:

```text
qqzj_protagonist_shuige_upper_study_intro_completed
```

Important compatibility note: `qqzj_protagonist_shuige_generic_shelf_completed` is a browse/completion flag only. Future shelf reward or fourth-slot wash logic must use separate flags so existing saves that browsed the shelf can still receive later source-faithful study effects once.

## 3. Remaining Missing

The ShuiGe exploration shell exists, but the source-complete study mechanics are still missing:

| missing area | status | notes |
|---|---|---|
| shelf rewards / study effects | missing | no shelf reward flags exist yet; the current shelf only observes the bookcase |
| branch-specific shelves | missing | no branch-aware filtering; selected apprenticeship branch is not read by `5212` yet |
| protagonist fourth-slot wash | missing | source-critical next mechanics slice; likely uses `SetOneMagic(0, 3, selectedSkillId, 0)` after a dedicated plan |
| branch-specific stat rewards | missing | universal 武学常识 +50 already exists in apprenticeship; branch-specific +10 系数 remain deferred |
| real interior rooms | missing | ShuiGe is represented with same-scene markers; no teleport, separate room, or real upper interior map exists |
| 王语嫣 handling | missing | extraction mentions 王语嫣 fourth-slot wash if present, but role/team/slot behavior has not been audited |
| shelf completion model | missing | need decide whether one generic shelf can claim one study, multiple unchosen studies, or several future shelf objects |

## 4. Is ShuiGe Playable As Exploration / Study Area?

Yes, as a compact exploration and study shell.

The player can now progress through:

1. ShuiGe entry and silver cost resolution.
2. Inner ShuiGe marker observation.
3. Center chest reward.
4. Upper study intro.
5. Generic shelf observation.

It is not source-complete. The current chain supports navigation, gating, repeat-state branching, and save-backed flags, but it does not yet implement the TPR shelf study reward: unchosen branch martial arts and fourth-slot wash.

## 5. Recommended Next 5 Tasks

| id | task | type | purpose |
|---|---|---|---|
| `TPR-065` | Plan ShuiGe branch-aware shelf rewards and fourth-slot wash | planning | Decide how `5212` reads selected branch, offers unchosen skills, uses `SetOneMagic(0, 3, skillId, 0)`, and preserves old saves. |
| `TPR-066` | Implement the first safe ShuiGe shelf fourth-slot wash slice | implementation | Add one idempotent source-faithful shelf study effect after the branch-aware plan. |
| `TPR-067` | Checkpoint after ShuiGe fourth-slot wash | checkpoint | Audit the protagonist single-pass apprenticeship and ShuiGe study slice after TPR-066. |
| `TPR-068` | Plan branch-specific +10 系数/stat rewards | planning | Decide exact stat APIs and whether the source reward must wait for 2周+ battle victory. |
| `TPR-069` | Audit 王语嫣 shelf wash behavior | planning | Verify role id, team presence checks, and whether companion fourth-slot wash can be implemented safely. |

## 6. Next Task Recommendation

Next task should add study reward mechanics planning, not extract the next TPR section and not improve rooms first.

Reasoning:

- The current ShuiGe chain is already playable enough for continued testing.
- The largest source gap is mechanical: branch-aware shelf study and fourth-slot wash.
- Room/visual improvements can wait because same-scene markers already give a navigable shell.
- New extraction can wait until this active apprenticeship/ShuiGe dependency is less ambiguous.

Highest ROI next task: `TPR-065` planning for `5212` branch-aware shelf reward and protagonist fourth-slot wash.

## Recommended TPR-065 Prompt

```text
Proceed with TPR-065 planning only: ShuiGe branch-aware shelf rewards and fourth-slot wash.

Do not implement gameplay.

Read:
docs/tpr_extraction/TPR_064_SHUIGE_AFTER_GENERIC_SHELF_CHECKPOINT.md
docs/tpr_extraction/TPR_058_APPRENTICESHIP_SLOT_WASH_AUDIT.md
docs/tpr_extraction/TPR_062_GENERIC_SHUIGE_SHELF_PLAN.md
docs/tpr_extraction/extractions/zhujuqinqing_apprenticeship.md
Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
Assets/Mods/jshyl/Configs/Lua/SkillConfig.lua

Task:
Plan the next ShuiGe shelf mechanics slice for event 5212.

Focus:
1. How to read the selected apprenticeship branch.
2. How to exclude the selected branch skill from shelf choices.
3. Whether the generic shelf should offer one choice, multiple choices, or a staged sequence.
4. Safe use of `SetOneMagic(0, 3, selectedSkillId, 0)`.
5. Required flags for idempotency and old-save compatibility.
6. Whether `qqzj_protagonist_shuige_generic_shelf_completed` should remain browse-only.
7. Whether 王语嫣 handling should be deferred.
8. Acceptance criteria.
9. Recommended TPR-066 implementation prompt.

Allowed:
- docs/tpr_extraction/**
- read-only inspection of Assets/Mods/jshyl/Lua/**
- read-only inspection of Assets/Mods/jshyl/Configs/**

Forbidden:
- Lua edits
- scene edits
- config edits
- gameplay changes
- engine edits

Output:
- detailed shelf reward/fourth-slot wash plan
- proposed quest id/event id/flags
- old-save compatibility strategy
- recommended implementation prompt
```

## Coverage Status

`主角剧情：拜师` remains `partially_implemented`.

The route is playable through the first ShuiGe study shell, but not source-complete because branch-specific shelf study, fourth-slot wash, 王语嫣 handling, branch-specific +10 系数, real mentor identities/interactions, later battle gates, and true interior rooms remain unfinished.
