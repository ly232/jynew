# TPR-062: Generic ShuiGe Shelf Interaction Plan

## Scope

Planning only. No gameplay, scene, Lua, config, or engine files are modified by this task.

This plan defines the first generic ShuiGe shelf interaction after TPR-060 introduced `jshyl_shuige_upper_study_marker` / event `5211`.

## Current State

Implemented ShuiGe study-adjacent events:

| event id | object | quest id | status |
|---:|---|---|---|
| `5204` | `jshyl_shuige_entry` | `qqzj_protagonist_opening_shuige_entry` | implemented |
| `5206` | `jshyl_shuige_inner_marker` | `qqzj_protagonist_opening_shuige_inner` | implemented |
| `5207` | `jshyl_shuige_center_chest` | `qqzj_protagonist_opening_shuige_center_chest` | implemented |
| `5211` | `jshyl_shuige_upper_study_marker` | `qqzj_protagonist_shuige_upper_study_intro` | implemented |

`5212` is unused and should be reserved for the first generic shelf interaction.

## Reserved Ids

Use:

```text
event id: 5212
quest id: qqzj_protagonist_shuige_generic_shelf
event file: Assets/Mods/jshyl/Lua/5212.lua
scene object: jshyl_shuige_generic_shelf_marker
```

Do not use branch-specific event ids for this first shelf slice.

## Marker Placement

Recommended placement:

```text
parent: Triggers
near: jshyl_shuige_upper_study_marker
suggested local position: x -16.8, y 6.5, z 38.3
```

Rationale:

- `jshyl_shuige_upper_study_marker` is already the gate into the upper study area.
- Placing the shelf marker slightly aside from `5211` keeps the interaction discoverable but avoids collider overlap.
- The marker can represent one generic bookcase for now; later visual shelf props can be added around it without changing the quest id.

## Visibility / Unlock Model

The shelf marker should be visible immediately.

Behavior should be gated in Lua, not by scene visibility:

- If `qqzj_protagonist_shuige_upper_study_intro_completed` is false, show a blocked dialogue and return false.
- If completed, show generic shelf dialogue and set shelf intro flags.

Reasoning:

- Immediate visibility makes the study area easier to understand visually.
- Lua gating is simpler and safer than adding another hide/reveal marker flow.
- Old saves that already completed 5211 can use 5212 without needing a scene-object migration.

## First-Slice Effects

TPR-063 should be dialogue/flags only.

It should:

- mention that the shelves hold records of the four unchosen family martial arts
- explain that actual study/slot washing will be handled later
- set persistent browse flags
- branch correctly on repeated interaction

It should not:

- grant skills
- call `SetOneMagic`
- grant items
- change stats
- inspect or branch on selected apprenticeship route
- handle 王语嫣
- start battle
- unlock maps

This creates a stable shelf entry point before source-critical fourth-slot behavior is added.

## Required Flags

Required for TPR-063:

```text
qqzj_protagonist_shuige_generic_shelf_started
qqzj_protagonist_shuige_generic_shelf_dialogue_seen
qqzj_protagonist_shuige_generic_shelf_completed
```

Do not add `future_reward_claimed` in TPR-063.

Recommended future flags for the fourth-slot slice:

```text
qqzj_protagonist_shuige_generic_shelf_reward_claimed
qqzj_protagonist_shuige_generic_shelf_fourth_slot_washed
qqzj_protagonist_shuige_generic_shelf_selected_branch_<branch_key>
```

If later work supports multiple shelf studies, use per-branch flags instead:

```text
qqzj_protagonist_shuige_shelf_abi_claimed
qqzj_protagonist_shuige_shelf_dengbaichuan_claimed
qqzj_protagonist_shuige_shelf_baobutong_claimed
qqzj_protagonist_shuige_shelf_fengboe_claimed
qqzj_protagonist_shuige_shelf_gongyegan_claimed
qqzj_protagonist_shuige_shelf_<branch_key>_fourth_slot_washed
```

## Old-Save Compatibility

For TPR-063:

- Existing saves with `qqzj_protagonist_shuige_upper_study_intro_completed` can use the shelf immediately.
- Existing saves without that flag get blocked dialogue and can complete 5211 first.
- No reward flags are needed because no rewards/effects are applied.

For later reward/wash slices:

- Do not infer completion from `qqzj_protagonist_shuige_generic_shelf_completed`.
- Add a separate reward/wash flag so players who already browsed shelves can still receive future source-faithful effects once.

## Risks Of Later Multiple Shelves

1. Multiple colliders near the upper study area can become hard to select.
2. Branch-specific scene objects may duplicate logic that is safer in Lua.
3. If each shelf has its own event id, old-save migration becomes noisier.
4. A generic shelf marker may not feel source-complete visually, but it is safer for the first mechanics slice.
5. If TPR-063 sets a broad `completed` flag, later code must not treat it as the martial-art reward flag.

Mitigation:

- Keep `completed` as browse-only.
- Use future reward/wash flags for actual fourth-slot effects.
- Add decorative shelf props later if the single marker feels too abstract.

## Acceptance Criteria For TPR-063

TPR-063 should be complete when:

1. `jshyl_shuige_generic_shelf_marker` exists near `jshyl_shuige_upper_study_marker`.
2. It is bound to event id `5212`.
3. `5212.lua` dispatches to:
   `JSHYL.QQZJ.Quest.Run("qqzj_protagonist_shuige_generic_shelf")`
4. The quest gates after:
   `qqzj_protagonist_shuige_upper_study_intro_completed`
5. Before the gate, interaction shows blocked dialogue and sets no completion flag.
6. After the gate, interaction shows generic shelf dialogue and sets:
   - `qqzj_protagonist_shuige_generic_shelf_started`
   - `qqzj_protagonist_shuige_generic_shelf_dialogue_seen`
   - `qqzj_protagonist_shuige_generic_shelf_completed`
7. Repeated interaction branches to already-browsed dialogue.
8. No rewards, stats, skills, items, branch logic, companion behavior, battles, maps, or engine changes are added.
9. Existing `5204`, `5206`, `5207`, `5210`, and `5211` behavior is unchanged.

## Recommended TPR-063 Prompt

```text
Proceed with TPR-063: implement generic ShuiGe shelf marker.

Read:
docs/tpr_extraction/TPR_062_GENERIC_SHUIGE_SHELF_PLAN.md

Allowed:
- Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
- Assets/Mods/jshyl/Lua/5212.lua
- Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- config edits
- skill grants
- stat changes
- shelf rewards
- fourth-slot wash
- branch-specific behavior
- new items
- battles
- companions
- engine C#

Requirements:
1. Add marker/trigger:
   jshyl_shuige_generic_shelf_marker
2. Bind it to event id:
   5212
3. Add `5212.lua` as thin dispatcher:
   JSHYL.QQZJ.Quest.Run("qqzj_protagonist_shuige_generic_shelf")
4. Add named quest:
   qqzj_protagonist_shuige_generic_shelf
5. Gate after:
   qqzj_protagonist_shuige_upper_study_intro_completed
6. Dialogue/flags only.
7. Set flags:
   - qqzj_protagonist_shuige_generic_shelf_started
   - qqzj_protagonist_shuige_generic_shelf_dialogue_seen
   - qqzj_protagonist_shuige_generic_shelf_completed
8. Repeated interaction should branch correctly.
9. Do not implement rewards, stats, skills, branch-specific hooks, or fourth-slot wash.
10. Preserve existing 5204, 5206, 5207, 5210, and 5211.

Done when:
- marker is visible/interactable
- event 5212 fires
- quest gates correctly
- flags persist
- no rewards/stats/skills are granted
- docs/backlog mark TPR-063 implemented
```
