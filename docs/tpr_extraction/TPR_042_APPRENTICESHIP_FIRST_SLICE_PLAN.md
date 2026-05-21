# TPR-042: 拜师 First Implementation Slice Plan

## Scope

Planning only. This document selects the smallest implementable slice from:

```text
docs/tpr_extraction/extractions/zhujuqinqing_apprenticeship.md
```

No gameplay, Lua, config, scene, or engine files are changed by TPR-042.

## Selected Beat

The first implementable beat should be:

```text
主角剧情：拜师 / 拜师择艺 opening prompt
```

This is the first source beat because the player must present or reference `狼牙燕翎` and choose one apprenticeship route before any later effects can occur.

For the first playable slice, keep it dialogue/flags only:

```text
1. Player reaches a new apprenticeship trigger in 52_yanziwu.
2. Dialogue explains that 狼牙燕翎 can be used to choose a family-school apprenticeship.
3. Player can acknowledge the system and defer the actual branch choice.
4. Save-backed flags record that the apprenticeship prompt has been introduced.
```

Do not implement the actual five-branch skill choice yet. The branch choice depends on skill id/API review and should remain a later task.

## Why This Is The Smallest Safe Slice

This slice avoids the currently unresolved parts of the source:

```text
- no skill-slot washing
- no 武学常识 mutation
- no 2周+ battle gate
- no selected 系数 +10
- no 王语嫣 skill wash
- no ShuiGe upper-study shelf binding
- no item removal yet
```

It still moves real TPR coverage forward because it introduces the 拜师 quest state machine and makes the section playable in a minimal, reversible form.

## Dependencies

### Opening Completion

Require:

```text
qqzj_protagonist_opening_family_briefing_completed
qqzj_protagonist_opening_family_briefing_tool_reward_claimed
```

Reason:

```text
The source says 狼牙燕翎 is handed out through the opening/family setup before apprenticeship. Current jshyl grants 狼牙燕翎 id 206 through the family briefing tool reward flag.
```

Do not require the full opening section to be complete yet:

```text
qqzj_protagonist_opening_brother_return_completed
qqzj_protagonist_opening_shuige_entry_cost_resolved
qqzj_protagonist_opening_shuige_inner_completed
qqzj_protagonist_opening_shuige_center_chest_completed
```

These are useful story progression signals, but they are not necessary for the first dialogue-only apprenticeship prompt.

### ShuiGe Completion

Do not require ShuiGe completion for TPR-042A.

Reason:

```text
The apprenticeship source later unlocks the top ShuiGe study room after the apprenticeship choice. Requiring the current ShuiGe inner/chest flow before the prompt would invert that dependency.
```

Future ShuiGe study slices may require:

```text
qqzj_protagonist_apprenticeship_choose_master_completed
qqzj_protagonist_apprenticeship_study_unlocked
```

### 孟星魂 Join

Do not require:

```text
qqzj_protagonist_opening_mengxinghun_join_completed
```

for the first prompt.

Rationale:

```text
The family briefing chain already gates behind 孟星魂 join in current jshyl, so requiring family briefing completion indirectly means the normal flow has passed the join step. Keeping the direct dependency out reduces save-compatibility risk if the join quest changes later.
```

## Required NPCs

Use one mentor representative at first.

Recommended first NPC:

```text
阿碧
```

Reason:

```text
- 阿碧 already has an existing validated technical trigger (`jshyl_abi_hint` / event 10000).
- The source allows giving 狼牙燕翎 to 阿碧 or one of 四大家将.
- A first dialogue-only prompt can mention that the 四大家将 branches will be formalized later.
```

Do not reuse event 10000 for this source quest. That event remains the Phase 2 technical validation slice and should not be mixed with TPR coverage.

Future NPCs to audit before full branch implementation:

```text
阿碧
邓百川
包不同
风波恶
公冶干
王语嫣
```

## Required Maps / Scenes

Required map:

```text
52_yanziwu
```

Current read-only scene trigger inventory:

| object | event id | current use |
|---|---:|---|
| `jshyl_murong_opening` | 5200 | opening chain |
| `jshyl_shuanger_rest` | 5201 | existing rest/service trigger |
| `jshyl_yanzi_treasure` | 5202 | silver chest |
| `jshyl_azhu_hint` | 5203 | ShuiGe entry hint |
| `jshyl_shuige_entry` | 5204 | true ShuiGe entry trigger |
| `jshyl_shijian_training` | 5205 | 侍剑 training |
| `jshyl_shuige_inner_marker` | 5206 | ShuiGe inner marker |
| `jshyl_shuige_center_chest` | 5207 | ShuiGe center chest reward |
| `jshyl_abi_hint` | 10000 | Phase 2 technical 阿碧 guidance |

Recommendation:

```text
Add one new dedicated scene trigger in a later implementation task:
object: jshyl_apprenticeship_master
event id: 5210
```

No existing trigger should be reused for TPR-042A because all current triggers either already carry opening/ShuiGe behavior or are explicitly technical validation.

## Required Rewards / Items

Required item for source context:

| item | id | status | TPR-042A behavior |
|---|---:|---|---|
| 狼牙燕翎 | 206 | exists in `ItemConfig.lua` | check/prompt only; do not remove yet |

TPR-042A should not remove `狼牙燕翎`.

Reason:

```text
Item removal is a separate idempotency risk. The first implementation should establish quest dispatch and state first; TPR-044 can consume id 206 once item-count/removal behavior is explicitly accepted for this flow.
```

No skill rewards should be granted in TPR-042A.

## Event Strategy

Use a new event file:

```text
Assets/Mods/jshyl/Lua/5210.lua
```

Thin dispatcher:

```lua
JSHYL.QQZJ.Quest.Run("qqzj_protagonist_apprenticeship_intro")
```

Why a separate intro quest instead of immediately using `qqzj_protagonist_apprenticeship_choose_master`:

```text
The extracted `choose_master` quest represents the full branch decision, including item consumption and later study unlock. The first implementation slice should be smaller: introduce the choice system and verify the trigger/flags without committing to one branch.
```

The later branch-choice quest can still be:

```text
qqzj_protagonist_apprenticeship_choose_master
```

## Proposed Quest Id

For TPR-042A:

```text
qqzj_protagonist_apprenticeship_intro
```

Purpose:

```text
Dialogue-only introduction to the apprenticeship system.
```

Later quests:

```text
qqzj_protagonist_apprenticeship_choose_master
qqzj_protagonist_apprenticeship_shuige_study
```

## Proposed Flags

Use:

```text
qqzj_protagonist_apprenticeship_intro_started
qqzj_protagonist_apprenticeship_intro_dialogue_seen
qqzj_protagonist_apprenticeship_intro_tool_checked
qqzj_protagonist_apprenticeship_intro_completed
```

Optional read-only outcome flag:

```text
qqzj_protagonist_apprenticeship_intro_missing_langya_yanling
```

Do not set branch flags in TPR-042A:

```text
qqzj_protagonist_apprenticeship_choice_abi
qqzj_protagonist_apprenticeship_choice_dengbaichuan
qqzj_protagonist_apprenticeship_choice_baobutong
qqzj_protagonist_apprenticeship_choice_fengboe
qqzj_protagonist_apprenticeship_choice_gongyegan
```

Those belong to the later branch-choice implementation.

## Behavior Plan

### If Opening Prerequisites Are Missing

Dialogue:

```text
阿碧 explains that the player should first complete the family briefing and receive the family travel token.
```

Effects:

```text
No flags except possibly `started`.
No item changes.
Return false.
```

### If 狼牙燕翎 Is Missing

Dialogue:

```text
阿碧 notes that the apprenticeship token is not in hand yet.
```

Effects:

```text
set qqzj_protagonist_apprenticeship_intro_missing_langya_yanling
No item changes.
Return false.
```

Implementation note:

```text
If item-count API is not confidently available in the implementation task, skip inventory checking and rely only on `qqzj_protagonist_opening_family_briefing_tool_reward_claimed`. Do not invent item-count helpers.
```

### First Successful Interaction

Dialogue:

```text
阿碧 explains that 狼牙燕翎 can be presented to 阿碧 or the 四大家将 to select one apprenticeship martial art.
```

Effects:

```text
set started
set tool_checked
set dialogue_seen
set completed
```

No item removal.
No skill reward.
No battle.
No companion change.
No scene change.

### Repeated Interaction

Dialogue:

```text
阿碧 reminds the player that apprenticeship selection is unlocked but not implemented yet.
```

Effects:

```text
No duplicate state changes except preserving completed flags.
```

## Slice Classification

| category | included? | note |
|---|---|---|
| dialogue | yes | primary behavior |
| battle | no | 2周+ mentor test deferred |
| companion | no | 王语嫣 and mentor/NPC branch work deferred |
| reward | no | no skill/item/stat rewards yet |
| scene edit | yes, minimal | one new trigger `jshyl_apprenticeship_master` bound to 5210 |
| config edit | no | no skills/items/battles added |
| engine edit | no | never needed for this slice |

## Acceptance Criteria

TPR-042A should be accepted when:

```text
1. A dedicated 52_yanziwu trigger `jshyl_apprenticeship_master` fires event 5210.
2. `5210.lua` is a thin dispatcher to `JSHYL.QQZJ.Quest.Run("qqzj_protagonist_apprenticeship_intro")`.
3. The quest gates after family briefing/tool reward.
4. First successful interaction displays apprenticeship intro dialogue.
5. Flags are saved:
   - qqzj_protagonist_apprenticeship_intro_started
   - qqzj_protagonist_apprenticeship_intro_dialogue_seen
   - qqzj_protagonist_apprenticeship_intro_tool_checked
   - qqzj_protagonist_apprenticeship_intro_completed
6. Repeated interaction branches to already-introduced dialogue.
7. No items are granted or removed.
8. No skills, stats, companions, battles, maps, or configs are changed.
9. Save/load preserves the intro flags.
10. Existing 5200-5207 and 10000 flows still work.
```

## Risks

1. Scene edit risk: adding a new trigger manually to `52_yanziwu.unity` may be fragile. Prefer copying the established object/component pattern from `jshyl_shuige_entry` or `jshyl_shuige_center_chest`.
2. Trigger placement risk: the marker should be near 阿碧/mentor area but not overlap existing `jshyl_abi_hint` or ShuiGe markers.
3. Item-count risk: direct inventory checks may be inconsistent. First implementation can avoid item-count checks and depend only on reward flags.
4. Source fidelity risk: all five mentor choices are not implemented yet. Dialogue must say this is preparation, not a completed apprenticeship.
5. Save compatibility risk: do not consume `狼牙燕翎` until a separate idempotent consumption slice exists.

## Recommended TPR-042A Implementation Prompt

```text
Proceed with TPR-042A: implement 拜师 intro dialogue/flags slice.

Read:
- docs/tpr_extraction/TPR_042_APPRENTICESHIP_FIRST_SLICE_PLAN.md
- docs/tpr_extraction/extractions/zhujuqinqing_apprenticeship.md

Allowed:
- Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
- Assets/Mods/jshyl/Lua/5210.lua
- Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- config edits
- new items
- skill/stat changes
- item removal
- battles
- companions
- new maps
- engine C#

Requirements:
1. Add dedicated interactive trigger:
   jshyl_apprenticeship_master
2. Bind it to event id:
   5210
3. Create `5210.lua` as thin dispatcher:
   JSHYL.QQZJ.Quest.Run("qqzj_protagonist_apprenticeship_intro")
4. Add named quest:
   qqzj_protagonist_apprenticeship_intro
5. Gate after:
   qqzj_protagonist_opening_family_briefing_completed
   qqzj_protagonist_opening_family_briefing_tool_reward_claimed
6. Dialogue/flags only.
7. Set flags:
   - qqzj_protagonist_apprenticeship_intro_started
   - qqzj_protagonist_apprenticeship_intro_dialogue_seen
   - qqzj_protagonist_apprenticeship_intro_tool_checked
   - qqzj_protagonist_apprenticeship_intro_completed
8. Do not consume 狼牙燕翎 id 206.
9. Do not set branch-choice flags.
10. Do not grant skills, stats, items, companions, or battles.
11. Repeated interaction should branch correctly.
12. Preserve all existing 5200-5207 and 10000 behavior.

Done when:
- the new trigger fires event 5210
- intro dialogue appears
- flags persist after save/load
- no gameplay systems beyond dialogue/flags are changed
- docs/backlog mark TPR-042A implemented
```
