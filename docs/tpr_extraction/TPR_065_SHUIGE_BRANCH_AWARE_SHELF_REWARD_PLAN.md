# TPR-065: ShuiGe Branch-Aware Shelf Reward Plan

## Scope

Planning only. No gameplay, Lua, scene, config, Unity asset, or engine files are modified by this task.

This plan defines how the existing `5212` generic ShuiGe shelf should become the first source-faithful study reward after apprenticeship.

## 1. Source Requirements

The extracted `主角剧情：拜师` source says that after apprenticeship:

```text
1. The protagonist learns one selected apprenticeship martial art.
2. The protagonist second martial slot is washed to the selected martial art.
3. 武学常识 +50 is granted.
4. The upper ShuiGe study becomes available.
5. ShuiGe shelves contain the other four martial arts, excluding the chosen route.
6. Taking each shelf martial art washes the protagonist fourth martial slot to that shelf art.
7. If 王语嫣 is present, 王语嫣 also washes her fourth martial slot in sequence.
```

Already implemented before this plan:

| source requirement | current status |
|---|---|
| selected branch | implemented through irreversible branch flags |
| 狼牙燕翎 consumption | implemented/idempotent with old-save waiver |
| first selected skill reward | implemented for all five branches through `LearnMagic2` |
| protagonist second slot wash | implemented through `SetOneMagic(0, 1, selectedSkillId, 0)` |
| 武学常识 +50 | implemented through `AddWuchang(0, 50)` |
| upper ShuiGe study entry | implemented through event `5211` |
| generic shelf marker | implemented through event `5212`, currently dialogue/flags only |

Not implemented yet:

```text
branch-aware shelf choices
protagonist fourth-slot shelf wash
per-shelf claim flags
王语嫣 fourth-slot handling
```

## 2. Branch Dependency

Shelf rewards must depend on the selected apprenticeship branch.

The chosen branch skill should be excluded because that skill was already learned and washed into the protagonist second slot during apprenticeship.

Example:

```text
selected branch: abi
selected skill: 七弦无形剑 id 206
available shelf skills: 回风舞柳剑 207, 如影随形腿 208, 飞沙走石刀 209, 大风云飞掌 210
```

The current quest Lua already has `get_apprenticeship_selected_branch()` and `PROTAGONIST_APPRENTICESHIP_BRANCHES`, so TPR-066 can reuse the established branch model instead of introducing new route state.

## 3. Recommended Reward Model

Use one generic shelf interaction, but make it branch-aware.

Recommended first mechanics slice:

```text
event id: 5212
quest id: qqzj_protagonist_shuige_generic_shelf
scene object: jshyl_shuige_generic_shelf_marker
```

Within that quest:

1. Gate after `qqzj_protagonist_shuige_upper_study_intro_completed`.
2. Read selected apprenticeship branch.
3. Build the list of unchosen branches.
4. Offer shelf study choices through dialogue.
5. On first selected shelf study, wash protagonist fourth slot to that skill.
6. Mark that branch's shelf reward claimed.
7. Preserve the existing browse flags as browse-only compatibility state.

Do not split into five physical shelf event ids yet.

Rationale:

- The existing `5212` marker is already placed and validated as a shelf entry point.
- Branch filtering is safer in Lua than scene object duplication.
- One interaction avoids several overlapping shelf colliders.
- Future visual shelf props can be added later without changing quest ids or save flags.

## 4. Fourth Skill Slot API

Use:

```lua
SetOneMagic(0, 3, selectedSkillId, 0)
```

Reasoning:

- Existing implementation uses `SetOneMagic(0, 1, selectedSkillId, 0)` for the protagonist second martial slot.
- Existing comments establish slot indexes are zero-based.
- Therefore index `3` corresponds to the fourth martial slot.
- The final `0` matches current pattern and means level 0 / level 1 entry state in existing code.

TPR-066 should not change any other slots.

## 5. Skill Ids

Current skill ids `206`-`210` are sufficient for the first shelf mechanics slice.

Evidence from `Assets/Mods/jshyl/Configs/Lua/SkillConfig.lua`:

| branch key | mentor | skill id | skill name | use in shelf |
|---|---|---:|---|---|
| `abi` | 阿碧 | `206` | 七弦无形剑 | available only if player did not choose 阿碧 |
| `dengbaichuan` | 邓百川 | `207` | 回风舞柳剑 | available only if player did not choose 邓百川 |
| `baobutong` | 包不同 | `208` | 如影随形腿 | available only if player did not choose 包不同 |
| `fengboe` | 风波恶 | `209` | 飞沙走石刀 | available only if player did not choose 风波恶 |
| `gongyegan` | 公冶干 | `210` | 大风云飞掌 | available only if player did not choose 公冶干 |

No new skills or config rows are needed for TPR-066.

## 6. Required Flags

Preserve existing browse flags:

```text
qqzj_protagonist_shuige_generic_shelf_started
qqzj_protagonist_shuige_generic_shelf_dialogue_seen
qqzj_protagonist_shuige_generic_shelf_completed
```

Add per-branch shelf claim flags:

```text
qqzj_protagonist_shuige_shelf_abi_claimed
qqzj_protagonist_shuige_shelf_dengbaichuan_claimed
qqzj_protagonist_shuige_shelf_baobutong_claimed
qqzj_protagonist_shuige_shelf_fengboe_claimed
qqzj_protagonist_shuige_shelf_gongyegan_claimed
```

Add a generic latest-wash flag for diagnostics / simple repeat state:

```text
qqzj_protagonist_shuige_fourth_slot_washed
```

Optional but recommended for old-save and debugging clarity:

```text
qqzj_protagonist_shuige_last_shelf_skill_id
qqzj_protagonist_shuige_last_shelf_branch_id
```

Do not use `qqzj_protagonist_shuige_generic_shelf_completed` as a reward flag. It was introduced as a dialogue-only browse flag in TPR-063.

## 7. Completion Semantics

Recommended for TPR-066:

```text
Allow exactly one shelf martial art to be claimed per interaction.
Allow future repeat interactions to claim additional unchosen shelf arts.
When all four unchosen shelf arts are claimed, show a completion dialogue.
```

Why not one generic reward only:

- Source says shelves contain the other four martial arts.
- A single generic reward would collapse four source rewards into one and create a migration headache later.

Why not branch-specific scene objects yet:

- Current marker is already sufficient.
- Physical branch shelves are visual polish, not needed for source-faithful logic.

Why not dialogue-only placeholder again:

- TPR-063 already provided the safe dialogue-only shell.
- The next high-value slice should implement the actual study effect.

## 8. Old-Save Compatibility

Old saves may be in several states:

| old-save state | TPR-066 behavior |
|---|---|
| has not completed `5211` upper study intro | block shelf study and ask player to complete upper study intro |
| completed `5211`, never browsed `5212` | allow shelf study normally |
| completed TPR-063 browse-only `5212` | allow shelf study normally; browse flag does not count as reward |
| selected branch before normalized branch id existed | reuse `get_apprenticeship_selected_branch()` normalization |
| branch selected but second-slot wash missing | block shelf study and direct player back to apprenticeship flow |
| already claimed one shelf branch | do not repeat that branch; offer remaining unclaimed branches |
| all four unchosen shelves claimed | show completion dialogue and do not wash again |

Do not infer claimed rewards from `qqzj_protagonist_shuige_generic_shelf_completed`.

## 9. Risks

| risk | impact | mitigation |
|---|---|---|
| wrong slot index | overwrites the wrong martial slot | use proven zero-based convention; only index `3` for fourth slot |
| overwriting player-customized fourth slot | expected by source but can surprise testers | dialogue should clearly confirm study before applying wash |
| multiple claims overwrite fourth slot repeatedly | source allows taking shelf arts, but only one active fourth slot can be visible at a time | one claim per interaction; clear dialogue; per-branch idempotency |
| branch state missing | shelf cannot know which skill to exclude | gate on selected branch and second-slot wash |
| 王语嫣 not handled | source incomplete | explicitly defer to a later 王语嫣 audit |
| skill display/effects incomplete | battle/runtime errors if skills are used later | use already configured ids 206-210; verify in Unity after TPR-066 |

## 10. Implementation Recommendation

Implement branch-specific shelf rewards through the existing generic shelf quest.

Recommended TPR-066 behavior:

1. Keep `5212.lua` as the same thin dispatcher.
2. Extend `run_protagonist_shuige_generic_shelf()`.
3. Gate after:

```text
qqzj_protagonist_shuige_upper_study_intro_completed
qqzj_protagonist_apprenticeship_second_slot_washed
```

4. Read selected branch.
5. Offer unchosen, unclaimed branch skills.
6. On confirmation, call:

```lua
SetOneMagic(0, 3, shelfSkillId, 0)
```

7. Set the relevant per-branch shelf claim flag.
8. Set diagnostic latest-wash flags.
9. Preserve existing browse flags.
10. Defer 王语嫣 handling.

## 11. Acceptance Criteria For TPR-066

TPR-066 is complete when:

1. Existing `5212` shelf still gates after upper study intro.
2. Shelf study is blocked if no apprenticeship branch is selected.
3. The selected apprenticeship branch skill is excluded from shelf choices.
4. The player can choose one unclaimed shelf skill.
5. Confirming the choice calls `SetOneMagic(0, 3, skillId, 0)`.
6. The matching `qqzj_protagonist_shuige_shelf_<branch>_claimed` flag is set.
7. Repeated interaction cannot re-claim the same shelf skill.
8. Existing TPR-063 browse-only saves can claim shelf rewards normally.
9. No new scene, config, item, battle, companion, or engine changes are made.
10. 王语嫣 handling remains explicitly deferred.

## Recommended TPR-066 Prompt

```text
Proceed with TPR-066: implement ShuiGe branch-aware shelf fourth-slot wash.

Read:
docs/tpr_extraction/TPR_065_SHUIGE_BRANCH_AWARE_SHELF_REWARD_PLAN.md
docs/tpr_extraction/extractions/zhujuqinqing_apprenticeship.md

Allowed:
- Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- scene edits
- config edits
- new skills
- new items
- stat changes
- battles
- companions
- 王语嫣 handling
- engine C#

Requirements:
1. Extend existing quest:
   qqzj_protagonist_shuige_generic_shelf
2. Preserve event id:
   5212
3. Gate after:
   - qqzj_protagonist_shuige_upper_study_intro_completed
   - qqzj_protagonist_apprenticeship_second_slot_washed
4. Read selected apprenticeship branch using existing branch state.
5. Offer only unchosen branch skills:
   - abi -> 206 七弦无形剑
   - dengbaichuan -> 207 回风舞柳剑
   - baobutong -> 208 如影随形腿
   - fengboe -> 209 飞沙走石刀
   - gongyegan -> 210 大风云飞掌
6. Exclude the selected apprenticeship branch skill.
7. On confirmed shelf study, wash protagonist fourth martial slot:
   SetOneMagic(0, 3, shelfSkillId, 0)
8. Add per-branch claim flags:
   - qqzj_protagonist_shuige_shelf_abi_claimed
   - qqzj_protagonist_shuige_shelf_dengbaichuan_claimed
   - qqzj_protagonist_shuige_shelf_baobutong_claimed
   - qqzj_protagonist_shuige_shelf_fengboe_claimed
   - qqzj_protagonist_shuige_shelf_gongyegan_claimed
9. Add diagnostic flags:
   - qqzj_protagonist_shuige_fourth_slot_washed
   - qqzj_protagonist_shuige_last_shelf_skill_id
   - qqzj_protagonist_shuige_last_shelf_branch_id
10. Preserve TPR-063 browse flags as browse-only compatibility state.
11. One interaction should claim at most one shelf skill.
12. Repeated interaction should offer remaining unclaimed shelf skills or show all-claimed dialogue.
13. Do not implement 王语嫣 fourth-slot wash yet.
14. Update docs/backlog.

Done when:
- one unchosen shelf skill can wash protagonist fourth slot
- claimed shelf skills are idempotent
- old TPR-063 saves can still claim rewards
- selected branch skill is never offered from shelves
- no scene/config/engine changes are made
```

## Coverage Status

`主角剧情：拜师` remains `partially_implemented`.

After TPR-066, the route can become mechanically closer to source-complete for protagonist ShuiGe study, but it will still lack 王语嫣 handling, branch-specific +10 系数, later-week battle gate, final mentor identities, mentor-specific interactions, and true ShuiGe interior rooms.
