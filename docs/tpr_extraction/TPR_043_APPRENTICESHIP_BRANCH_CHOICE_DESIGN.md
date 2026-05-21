# TPR-043: Apprenticeship Branch Choice Design

## Scope

Planning only. This document designs the five-branch `主角剧情：拜师` choice system after the TPR-042A intro trigger.

No gameplay, Lua, config, scene, or engine files are changed by TPR-043.

## Source Branches

From `docs/tpr_extraction/extractions/zhujuqinqing_apprenticeship.md`, the apprenticeship branches are:

| branch key | mentor | martial art | 系别 | source reward/effect |
|---|---|---|---|---|
| `abi` | 阿碧 | 七弦无形剑 | 暗毒 | protagonist second skill slot wash; 武学常识 +50 |
| `dengbaichuan` | 邓百川 | 回风舞柳剑 | 御剑 | protagonist second skill slot wash; 武学常识 +50 |
| `baobutong` | 包不同 | 如影随形腿 | 指腿 | protagonist second skill slot wash; 武学常识 +50 |
| `fengboe` | 风波恶 | 飞沙走石刀 | 兵器 | protagonist second skill slot wash; 武学常识 +50 |
| `gongyegan` | 公冶干 | 大风云飞掌 | 拳掌 | protagonist second skill slot wash; 武学常识 +50 |

Later-week source behavior:

```text
From 2周 onward, apprenticeship requires a battle. Victory adds +10 to the selected combat coefficient.
```

Post-choice source behavior:

```text
The top ShuiGe study room unlocks after apprenticeship. Its shelves offer the four unchosen martial arts.
```

## Current Implementation Context

Already implemented:

```text
event: 5210
scene trigger: jshyl_apprenticeship_master
quest id: qqzj_protagonist_apprenticeship_intro
flags:
  qqzj_protagonist_apprenticeship_intro_started
  qqzj_protagonist_apprenticeship_intro_dialogue_seen
  qqzj_protagonist_apprenticeship_intro_completed
```

Existing gate:

```text
qqzj_protagonist_opening_family_briefing_tool_reward_claimed
```

Recommended branch-choice gate:

```text
qqzj_protagonist_apprenticeship_intro_completed
qqzj_protagonist_opening_family_briefing_tool_reward_claimed
```

## Required Item Audit

| item | id | source evidence | status | branch-choice use |
|---|---:|---|---|---|
| 狼牙燕翎 | 206 | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua` row `{206,[[狼牙燕翎]],...}` | exists | required story token |

Recommended item behavior:

```text
TPR-044 should not consume 狼牙燕翎 yet.
```

Reason:

```text
The next safe branch-choice slice can lock a save-backed branch flag without mutating inventory.
Actual item consumption should wait until either:
1. the exact skill rewards exist, or
2. an explicit idempotent item-consumption slice is approved.
```

When consumption is implemented later:

```text
Use AddItemWithoutHint(206, -1) or AddItem(206, -1) only after confirming inventory-count behavior.
Guard with qqzj_protagonist_apprenticeship_langya_yanling_consumed.
Never consume again on repeated interaction or old saves where a branch is already selected.
```

## Skill Id Audit

Searched:

```text
Assets/Mods/jshyl/Configs/Lua/SkillConfig.lua
```

Exact source martial arts found:

| skill | exact id | status |
|---|---:|---|
| 七弦无形剑 | n/a | missing |
| 回风舞柳剑 | n/a | missing |
| 如影随形腿 | n/a | missing |
| 飞沙走石刀 | n/a | missing |
| 大风云飞掌 | n/a | missing |

Nearby or reusable existing skills:

| existing skill | id | note |
|---|---:|---|
| 持瑶琴 | 83 | thematically close to 阿碧/琴, but not source-exact |
| 回峰落雁剑 | 46 | name is close to 回风舞柳剑 but not exact |
| 慕容剑法 | 51 | family-flavored sword skill but not source-exact |
| 西瓜刀法 | 62 | low-level刀法 placeholder only |
| 狂风刀法 | 64 | wind-themed刀法 placeholder only |
| 混元掌 | 7 | low-to-mid掌法 placeholder only |
| 逍遥掌 | 10 | family/逍遥-flavored掌法 placeholder only |
| 暗器 | 97 | generic暗器 utility skill |
| 独孤九剑 | 205 | existing jshyl-added high-tier skill; not appropriate for apprenticeship branch placeholders |

Conclusion:

```text
No branch can be source-faithfully implemented as a real skill reward yet.
All five branches can be implemented now only as dialogue/flag stubs.
```

Recommended future skill ids if exact config rows are added:

| proposed id | skill |
|---:|---|
| 206 | 七弦无形剑 |
| 207 | 回风舞柳剑 |
| 208 | 如影随形腿 |
| 209 | 飞沙走石刀 |
| 210 | 大风云飞掌 |

These ids are the next contiguous skill ids after current `SkillConfig.lua` max id `205`. They do not conflict with item ids because item and skill tables are separate.

## Required Rewards / Stats

Source-required effects after a real final branch:

```text
1. Consume or spend 狼牙燕翎.
2. Learn or wash protagonist second skill slot to selected martial art.
3. Add 武学常识 +50.
4. From 2周 onward, run a mentor test battle.
5. On later-week battle victory, add +10 to the selected branch coefficient.
6. Unlock ShuiGe upper-study access.
```

Current readiness:

| effect | readiness | blocker |
|---|---|---|
| branch flag | ready | none |
| branch irreversible lock | ready | design decision only |
| consume 狼牙燕翎 | technically possible later | should be idempotent and delayed until real reward exists |
| selected exact skill reward | blocked | exact skills missing from `SkillConfig.lua` |
| protagonist second-slot wash | blocked | API/slot semantics need audit |
| 武学常识 +50 | blocked | safe stat mutation API needs audit |
| selected coefficient +10 | blocked | stat API and 2周 detection need audit |
| 2周+ battle | blocked | battle id/config and playthrough detection missing |
| ShuiGe upper-study unlock | ready as flag only | scene marker/shelf implementation not planned yet |

## Branch Implementation Readiness

| branch | can implement now? | safe now | blocked real effects |
|---|---|---|---|
| 阿碧 / 七弦无形剑 | yes, as flag-only | choose/lock `abi` branch | exact skill id, second-slot wash, 暗毒 +10, battle |
| 邓百川 / 回风舞柳剑 | yes, as flag-only | choose/lock `dengbaichuan` branch | exact skill id, second-slot wash, 御剑 +10, battle |
| 包不同 / 如影随形腿 | yes, as flag-only | choose/lock `baobutong` branch | exact skill id, second-slot wash, 指腿 +10, battle |
| 风波恶 / 飞沙走石刀 | yes, as flag-only | choose/lock `fengboe` branch | exact skill id, second-slot wash, 兵器 +10, battle |
| 公冶干 / 大风云飞掌 | yes, as flag-only | choose/lock `gongyegan` branch | exact skill id, second-slot wash, 拳掌 +10, battle |

## Recommended Design

Use the existing `5210.lua` trigger and add a second quest state under the same event chain:

```text
quest id: qqzj_protagonist_apprenticeship_choose_master
event id: 5210
scene trigger: jshyl_apprenticeship_master
```

Behavior:

```text
1. If intro is not completed, run qqzj_protagonist_apprenticeship_intro.
2. If a branch is already selected, show the selected branch and return true.
3. Otherwise ask whether to choose a mentor now.
4. Offer a sequence of yes/no prompts, one branch at a time, because the current QQZJ helper only exposes YesNo.
5. On selection, ask for final confirmation.
6. Set exactly one branch flag.
7. Set selected branch key via an int/string-like flag convention.
8. Mark branch choice completed.
9. Do not consume item or grant skill/stat rewards yet.
```

Because `JSHYL.QQZJ.Flags` currently exposes integer and boolean helpers, represent the selected branch as an integer:

| value | branch |
|---:|---|
| 0 | none |
| 1 | `abi` |
| 2 | `dengbaichuan` |
| 3 | `baobutong` |
| 4 | `fengboe` |
| 5 | `gongyegan` |

## Proposed Flags

Quest stage flags:

```text
qqzj_protagonist_apprenticeship_choose_master_started
qqzj_protagonist_apprenticeship_choose_master_prompt_seen
qqzj_protagonist_apprenticeship_choose_master_confirmed
qqzj_protagonist_apprenticeship_choose_master_completed
```

Selection flags:

```text
qqzj_protagonist_apprenticeship_selected_branch_id
qqzj_protagonist_apprenticeship_choice_abi
qqzj_protagonist_apprenticeship_choice_dengbaichuan
qqzj_protagonist_apprenticeship_choice_baobutong
qqzj_protagonist_apprenticeship_choice_fengboe
qqzj_protagonist_apprenticeship_choice_gongyegan
```

Deferred effect flags:

```text
qqzj_protagonist_apprenticeship_langya_yanling_consumed
qqzj_protagonist_apprenticeship_skill_reward_applied
qqzj_protagonist_apprenticeship_wuxuechangshi_applied
qqzj_protagonist_apprenticeship_coefficient_reward_applied
qqzj_protagonist_apprenticeship_study_unlocked
```

TPR-044 should set only:

```text
qqzj_protagonist_apprenticeship_choose_master_started
qqzj_protagonist_apprenticeship_choose_master_prompt_seen
qqzj_protagonist_apprenticeship_choose_master_confirmed
qqzj_protagonist_apprenticeship_choose_master_completed
qqzj_protagonist_apprenticeship_selected_branch_id
exactly one qqzj_protagonist_apprenticeship_choice_* flag
```

## Irreversibility

Branch choice should be irreversible after final confirmation.

Rationale:

```text
The branch affects later family progression, ShuiGe study shelf exclusions, and future skill/stat rewards. Allowing changes would make downstream quest state ambiguous.
```

Safe UX:

```text
1. Show all five choices as sequential confirmation prompts.
2. Before locking, display a final irreversible warning.
3. If confirmed, set the branch flags.
4. On later interactions, display the selected mentor and martial art without offering a reset.
```

No debug reset should be included in player-facing Lua.

## Recommended First Implementable Branch

Recommended first branch to validate manually:

```text
阿碧 / 七弦无形剑 / 暗毒
```

Why:

```text
1. The existing 5210 trigger is placed near the 阿碧 interaction area.
2. 阿碧 is already represented in current dialogue with role id 339.
3. It requires no new NPC scene placement.
4. It is source-valid because the extraction says 狼牙燕翎 can be given to 阿碧 or 四大家将.
5. It can validate irreversible selection flags before adding exact skill config rows.
```

The implementation should still offer all five branch labels, but manual verification should start with 阿碧.

## Missing Id Audit

Missing exact skill ids:

```text
七弦无形剑
回风舞柳剑
如影随形腿
飞沙走石刀
大风云飞掌
```

Missing or unaudited APIs:

```text
inventory count check for 狼牙燕翎
safe one-time item consumption for non-money item id 206
protagonist skill slot wash
王语嫣 skill slot wash
武学常识 +50 mutation
branch coefficient +10 mutation
2周/playthrough detection
mentor battle id/config
ShuiGe upper-study marker and shelf exclusion logic
```

Available ids:

```text
狼牙燕翎 item id 206
```

Available event/scene:

```text
event id 5210
scene trigger jshyl_apprenticeship_master
```

## Acceptance Criteria For Branch Choice Slice

TPR-044 should be accepted when:

```text
1. Event 5210 continues to fire from jshyl_apprenticeship_master.
2. Intro still works for old saves that have not seen it.
3. After intro completion, player can review the five mentor options.
4. Player can decline without locking a branch.
5. Player can select exactly one branch after final confirmation.
6. Selected branch persists through save/load.
7. Repeated interaction reports the locked branch and does not offer another selection.
8. No 狼牙燕翎 item is consumed yet.
9. No skill, stat, battle, companion, scene, map, or config changes occur.
10. Coverage/backlog mark branch choice as partially implemented, with real rewards deferred.
```

## Recommended TPR-044 Prompt

```text
Proceed with TPR-044: implement apprenticeship branch choice flags only.

Read:
- docs/tpr_extraction/TPR_043_APPRENTICESHIP_BRANCH_CHOICE_DESIGN.md
- docs/tpr_extraction/extractions/zhujuqinqing_apprenticeship.md

Allowed:
- Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- config edits
- scene edits
- item consumption
- skill changes
- stat changes
- battles
- companions
- new maps
- engine C#

Requirements:
1. Extend event 5210 flow through `qqzj_protagonist_apprenticeship_intro`.
2. Add named quest:
   qqzj_protagonist_apprenticeship_choose_master
3. Gate after:
   qqzj_protagonist_apprenticeship_intro_completed
   qqzj_protagonist_opening_family_briefing_tool_reward_claimed
4. Offer five branch labels:
   - 阿碧 / 七弦无形剑 / 暗毒
   - 邓百川 / 回风舞柳剑 / 御剑
   - 包不同 / 如影随形腿 / 指腿
   - 风波恶 / 飞沙走石刀 / 兵器
   - 公冶干 / 大风云飞掌 / 拳掌
5. Use sequential YesNo prompts if no menu helper exists.
6. Add irreversible final confirmation.
7. Set:
   - qqzj_protagonist_apprenticeship_choose_master_started
   - qqzj_protagonist_apprenticeship_choose_master_prompt_seen
   - qqzj_protagonist_apprenticeship_choose_master_confirmed
   - qqzj_protagonist_apprenticeship_choose_master_completed
   - qqzj_protagonist_apprenticeship_selected_branch_id
   - exactly one qqzj_protagonist_apprenticeship_choice_* flag
8. Do not consume 狼牙燕翎 id 206.
9. Do not grant or wash skills.
10. Do not add 武学常识 or combat coefficients.
11. Repeated interaction should report the selected branch and not allow reselection.

Done when:
- one branch can be locked exactly once
- selection persists after save/load
- repeated interaction is stable
- no items/skills/stats/battles/companions/configs/scenes are changed
- docs/backlog mark TPR-044 implemented
```
