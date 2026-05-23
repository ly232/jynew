# TPR-058C: Visible Apprenticeship NPC Checkpoint

## Scope

Documentation-only checkpoint after TPR-058B.

No gameplay, Lua, config, Unity scene, Unity asset, or engine files are changed by this checkpoint.

## Visible NPC Placeholders Now Present

TPR-058B added four decorative placeholder NPC objects to `52_yanziwu` near the existing `jshyl_apprenticeship_master` / event `5210` apprenticeship flow.

| mentor | scene object | status | notes |
|---|---|---|---|
| 邓百川 | `jshyl_npc_dengbaichuan_placeholder` | visible placeholder | Decorative only; no CharacterConfig row, no portrait, no dialogue speaker id, no trigger. |
| 包不同 | `jshyl_npc_baobutong_placeholder` | visible placeholder | Decorative only; no CharacterConfig row, no portrait, no dialogue speaker id, no trigger. |
| 风波恶 | `jshyl_npc_fengboe_placeholder` | visible placeholder | Decorative only; no CharacterConfig row, no portrait, no dialogue speaker id, no trigger. |
| 公冶干 | `jshyl_npc_gongyegan_placeholder` | visible placeholder | Decorative only; no CharacterConfig row, no portrait, no dialogue speaker id, no trigger. |

阿碧 remains represented by the existing 阿碧-style visible target used by:

```text
jshyl_abi_hint
jshyl_apprenticeship_master
```

## Decorative-Only Status

All four new 家将 objects are decorative only.

They do not add:

```text
event ids
interaction triggers
quest logic
dialogue
new role ids
CharacterConfig rows
portraits
new model assets
companion behavior
battle participation
```

Existing apprenticeship interaction remains centralized through:

```text
event id: 5210
scene object: jshyl_apprenticeship_master
Lua file: Assets/Mods/jshyl/Lua/5210.lua
quest: qqzj_protagonist_apprenticeship_intro
```

## Missing For Source-Complete Mentors

The visual placeholders are not source-complete mentor implementations.

Still missing:

| area | missing work |
|---|---|
| `CharacterConfig` | Exact role rows for 邓百川, 包不同, 风波恶, 公冶干. |
| role ids | Stable jshyl role ids for the four 家将. |
| portraits | Source-appropriate head/portrait assets and dialogue portrait mapping. |
| final models | Proper final model assets under `Assets/Mods/jshyl/Models`, replacing placeholders. |
| event ids | Future per-mentor ids, likely `5213`-`5217`; keep `5211`/`5212` reserved for ShuiGe study. |
| dialogue | Mentor-specific dialogue and branch confirmation text. |
| branch-specific interactions | Optional per-mentor interaction entry points that preserve the old centralized `5210` path. |
| companion behavior | None currently required by the extracted `拜师` beat; only add later if a source section requires it. |
| battles | 2周+ apprenticeship battle gate remains unimplemented. |
| slot wash | Protagonist second-slot wash remains unimplemented. |
| ShuiGe study | Upper study and shelf mechanics remain unimplemented. |

## Apprenticeship Status Assessment

### Logic Complete?

Partially.

Implemented logic:

```text
intro dialogue
irreversible branch-choice flags
狼牙燕翎 id 206 consumption / old-save waiver
first-skill reward for all five branches through LearnMagic2
universal 武学常识 +50 through AddWuchang
idempotent save-backed flags
```

Missing source-critical logic:

```text
protagonist second-slot wash
2周+ battle gate
branch-specific +10 系数 after battle victory
ShuiGe upper study access and shelves
fourth-slot shelf wash for protagonist and optional 王语嫣
```

### Visually Represented?

Partially yes.

The five apprenticeship choices are now more legible because 阿碧 already exists visually and the four 家将 now have visible placeholders in the same scene area.

However, the visual representation is not final:

```text
the four 家将 are placeholders
their models are not source-final
they are not individually interactive
they do not have role ids or portraits
```

### Source Complete?

No.

The section remains `partially_implemented` because both source logic and source-final mentor identity assets are incomplete.

## Recommended Next Priority

Recommended priority:

```text
C. slot wash
```

Reason:

```text
The visual legibility gap has been reduced enough for now.
The next highest source-fidelity risk is that LearnMagic2 does not target the required second slot and may fail to append when the protagonist skill list is full.
The slot-wash path is already audited and does not require new assets, scenes, portraits, or role rows.
```

Priority assessment:

| option | recommendation | reason |
|---|---|---|
| A. real CharacterConfig/model pipeline | Defer | Important, but not needed for current centralized 5210 flow and may require portraits/assets. |
| B. mentor interactions | Defer | Should wait until stable role ids/portraits or a deliberate compatibility plan exists. |
| C. slot wash | Do next | Smallest source-critical gameplay gap after visible placeholders. |
| D. ShuiGe study mechanics | Defer until slot wash | ShuiGe shelves also require slot-wash semantics, especially fourth slot. |
| E. next TPR extraction | Defer | Current `拜师` section still has immediate source-critical gaps. |

## Recommended Next 5 Tasks

1. `TPR-058D`: implement protagonist second-slot apprenticeship wash using `SetOneMagic(0, 1, selectedSkillId, 0)` with idempotency flag `qqzj_protagonist_apprenticeship_second_slot_washed`.
2. `TPR-058E`: checkpoint after second-slot wash, confirming old-save behavior and whether `LearnMagic2` should remain as compatibility reward.
3. `TPR-059`: plan ShuiGe upper study marker and shelf scene binding after second-slot wash is stable.
4. `TPR-060`: plan 家将 CharacterConfig / portrait / final model pipeline for source-final mentor identities.
5. `TPR-061`: plan per-mentor interactions with event ids `5213`-`5217`, preserving the existing centralized `5210` compatibility path.

## Verification Notes From TPR-058B

TPR-058B reported:

```text
static scene checks passed
no new 5211-5217 interactive event ids were introduced
scene YAML had no duplicate anchors
Unity 2020.3.49f1 batch-mode project load exited successfully
```

Manual Unity visual QA is still recommended before finalizing the placeholder placement:

```text
open 52_yanziwu
confirm all four placeholders are visible and upright
confirm no half-body clipping
confirm no overlap with 阿碧 / existing 5210 trigger
confirm player movement is not blocked unexpectedly
confirm only 5210 opens apprenticeship interaction
```
