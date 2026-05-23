# TPR-059: ShuiGe Study Mechanics Plan

## Scope

Planning only. No gameplay, Lua, config, or scene files are modified by this task.

This plan covers the first ShuiGe study slice for `主角剧情：拜师`, after the validated apprenticeship branch rewards, universal 武学常识 reward, second-slot wash, and Yanziwu worldbuilding pass.

## Source Requirements

The extracted `主角剧情：拜师` section says:

- After the protagonist learns the selected apprenticeship martial art, the upper ShuiGe study room becomes available.
- ShuiGe shelves should expose the four unchosen apprenticeship martial arts.
- Taking a shelf martial art should wash the protagonist's fourth martial slot to that martial art.
- If 王语嫣 is present, her fourth slot should also follow the chosen shelf martial art.

The current implementation already handles:

- irreversible apprenticeship branch selection
- 狼牙燕翎 id `206` consumption or old-save waiver
- first-skill rewards for all five branches
- universal 武学常识 `+50`
- protagonist second-slot wash with `SetOneMagic(0, 1, selectedSkillId, 0)`

## Existing ShuiGe Markers And Event Flow

The current `52_yanziwu` ShuiGe flow is:

| object / event | current purpose | notes |
|---|---|---|
| `jshyl_azhu_hint` / `5203` | ShuiGe entry hint | Dialogue/flags only; no true entry behavior. |
| `jshyl_shuige_entry` / `5204` | true ShuiGe entry gate | Handles `-3000` 银两 cost through `JudgeMoney(3000)` and `AddItemWithoutHint(174, -3000)`, unlocks inner marker, and supports old-save cost waiver. |
| `jshyl_shuige_inner_marker` / `5206` | inner ShuiGe marker | Dialogue/flags only after inner marker unlock. |
| `jshyl_shuige_center_chest` / `5207` | center chest | Grants 海月清辉 id `209` x1 once. |
| `jshyl_shuige_inner_marker_visible` | visual companion marker | Scene visibility support for the inner marker flow. |
| `jshyl_decor_shuige_direction` | decorative direction marker | Non-interactive worldbuilding object only. |

These ids and objects should be preserved. Do not repurpose `5204`, `5206`, or `5207` for study shelves.

## Recommended New Objects

Add a new dedicated upper study entry marker in a future implementation slice:

```text
object: jshyl_shuige_upper_study
event: 5211
lua: Assets/Mods/jshyl/Lua/5211.lua
quest: qqzj_protagonist_apprenticeship_shuige_study_entry
```

This marker should be placed near the existing ShuiGe interior area, visually separate from:

- `jshyl_shuige_entry`
- `jshyl_shuige_inner_marker`
- `jshyl_shuige_center_chest`

The first implementation should keep this marker dialogue/flags-only. It should not grant shelf skills or wash the fourth slot yet.

For a later shelf slice, reserve:

```text
object: jshyl_shuige_study_shelves
event: 5212
lua: Assets/Mods/jshyl/Lua/5212.lua
quest: qqzj_protagonist_apprenticeship_shuige_shelves
```

Start with one aggregate shelf marker. Splitting into four shelf objects can wait until the behavior is verified.

## Relationship With Apprenticeship Completion

The upper study should not open immediately after the intro or branch-choice flags. It should require the real apprenticeship reward chain to be resolved.

Recommended gate for TPR-060:

```text
qqzj_protagonist_opening_shuige_inner_completed
qqzj_protagonist_apprenticeship_second_slot_washed
```

These two flags imply:

- the player has entered the current ShuiGe flow far enough to understand the location
- apprenticeship branch selection, token resolution, first-skill reward, and second-slot wash have already completed

Do not require `qqzj_protagonist_opening_shuige_center_chest_completed`; the center chest is a reward branch, not a study prerequisite.

## Study Behavior Strategy

### TPR-060: Entry Only

TPR-060 should:

- add the upper study marker
- bind event `5211`
- dispatch to `qqzj_protagonist_apprenticeship_shuige_study_entry`
- set persistent entry flags
- explain through dialogue that the upper shelves are now available for later study
- avoid all skill grants, item grants, stat changes, silver deductions, companion behavior, and slot wash

### Later Shelf Slice

TPR-061 should plan shelf behavior before implementation.

Future shelf behavior should:

- read the selected apprenticeship branch
- exclude the selected branch's martial art from shelf choices
- offer the four unchosen branch skills
- use `SetOneMagic(0, 3, skillId, 0)` for protagonist fourth-slot wash
- run idempotently per shelf skill
- defer 王语嫣 handling until her role id, join timing, and skill-slot policy are verified

Do not use `LearnMagic2` alone for shelf study. The source requirement is slot wash, and previous slot-wash audit established `SetOneMagic` as the safer explicit placement API.

## Event Id Reservations

Current occupied ids:

```text
5200 opening chain
5202 silver chest
5203 ShuiGe hint
5204 ShuiGe entry
5205 侍剑 / 十二金钗 training
5206 ShuiGe inner marker
5207 ShuiGe center chest
5210 apprenticeship master
```

Reserve:

```text
5211 upper ShuiGe study entry
5212 upper ShuiGe study shelves
5213-5217 future mentor-specific interactions
```

This keeps the study sequence close to the existing apprenticeship id range without colliding with future per-mentor work.

## Required Flags

TPR-060 entry flags:

```text
qqzj_protagonist_apprenticeship_shuige_study_entry_started
qqzj_protagonist_apprenticeship_shuige_study_entry_unlocked
qqzj_protagonist_apprenticeship_shuige_study_entry_dialogue_seen
qqzj_protagonist_apprenticeship_shuige_study_entry_completed
```

Future shelf flags:

```text
qqzj_protagonist_apprenticeship_shuige_shelves_started
qqzj_protagonist_apprenticeship_shuige_shelf_abi_claimed
qqzj_protagonist_apprenticeship_shuige_shelf_dengbaichuan_claimed
qqzj_protagonist_apprenticeship_shuige_shelf_baobutong_claimed
qqzj_protagonist_apprenticeship_shuige_shelf_fengboe_claimed
qqzj_protagonist_apprenticeship_shuige_shelf_gongyegan_claimed
qqzj_protagonist_apprenticeship_shuige_shelf_<branch>_protagonist_fourth_slot_washed
qqzj_protagonist_apprenticeship_shuige_shelf_<branch>_wangyuyan_fourth_slot_washed
qqzj_protagonist_apprenticeship_shuige_shelves_completed
```

The shelf implementation should not create a claimable shelf for the player's already-selected apprenticeship branch.

## Risks

1. Scene crowding: ShuiGe already has entry, inner marker, and center chest triggers. The upper study marker must be spatially distinct enough that interactions are not confusing.
2. Fourth-slot wash is destructive: `SetOneMagic(0, 3, skillId, 0)` will overwrite an existing slot. It should not be introduced until a separate plan confirms the UX and old-save behavior.
3. Branch exclusion mistakes could let the player re-study the already selected martial art or miss one of the four unchosen skills.
4. 王语嫣 handling is under-specified. Her role id, join state, and slot wash timing should be audited before implementation.
5. Old saves may have completed apprenticeship before the study marker exists. Gate logic must allow those saves to enter the new study flow if `qqzj_protagonist_apprenticeship_second_slot_washed` is already set.
6. Marker visibility should be simple at first. Avoid hidden/reveal logic unless the future scene slice has a clear need; the quest can gate interaction through dialogue and flags.

## Acceptance Criteria For TPR-060

TPR-060 is complete when:

1. `jshyl_shuige_upper_study` exists in `52_yanziwu`.
2. It is bound to event id `5211`.
3. `5211.lua` is a thin dispatcher to `JSHYL.QQZJ.Quest.Run("qqzj_protagonist_apprenticeship_shuige_study_entry")`.
4. The quest is gated after:
   - `qqzj_protagonist_opening_shuige_inner_completed`
   - `qqzj_protagonist_apprenticeship_second_slot_washed`
5. Interaction before prerequisites shows a clear blocked-state dialogue and does not set completion flags.
6. Interaction after prerequisites sets entry flags and branches correctly on repeat interaction.
7. No skill, item, stat, silver, companion, battle, or teleport behavior is added.
8. Save/load preserves the study entry flags.
9. Existing `5204`, `5206`, `5207`, and `5210` behavior is unchanged.

## Recommended TPR-060 Prompt

```text
Proceed with TPR-060: implement first ShuiGe upper study entry marker.

Read:
docs/tpr_extraction/TPR_059_SHUIGE_STUDY_MECHANICS_PLAN.md
docs/tpr_extraction/extractions/zhujuqinqing_apprenticeship.md

Allowed:
- Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
- Assets/Mods/jshyl/Lua/5211.lua
- Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- config edits
- item rewards
- skill grants
- stat changes
- silver deduction
- fourth-slot wash
- battles
- companions
- teleport/new maps
- engine C#

Requirements:
1. Add dedicated interactive marker `jshyl_shuige_upper_study`.
2. Bind it to event id `5211`.
3. Create `5211.lua` as thin dispatcher:
   `JSHYL.QQZJ.Quest.Run("qqzj_protagonist_apprenticeship_shuige_study_entry")`
4. Add named quest `qqzj_protagonist_apprenticeship_shuige_study_entry`.
5. Gate after:
   - `qqzj_protagonist_opening_shuige_inner_completed`
   - `qqzj_protagonist_apprenticeship_second_slot_washed`
6. Dialogue/flags only.
7. Set flags:
   - `qqzj_protagonist_apprenticeship_shuige_study_entry_started`
   - `qqzj_protagonist_apprenticeship_shuige_study_entry_unlocked`
   - `qqzj_protagonist_apprenticeship_shuige_study_entry_dialogue_seen`
   - `qqzj_protagonist_apprenticeship_shuige_study_entry_completed`
8. Repeated interaction should branch correctly.
9. Preserve 5204, 5206, 5207, and 5210 behavior.
10. Do not implement shelves or fourth-slot wash yet.

Done when:
- the upper study marker fires event 5211
- prerequisites gate correctly
- flags persist
- no rewards or slot wash occur
- docs/backlog mark TPR-060 implemented
```
