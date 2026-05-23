# TPR-058A: Visible Apprenticeship Masters Audit

## Scope

Planning only. This audit checks whether the five apprenticeship mentors for `主角剧情：拜师` already exist as visible characters in jshyl and how they should be introduced.

No scene, config, Lua, Unity asset, gameplay, or engine files are changed by TPR-058A.

## Target Mentors

From the extracted `拜师` section:

| branch id | mentor | skill | current gameplay status |
|---|---|---|---|
| `abi` | 阿碧 | 七弦无形剑 | implemented through the shared 5210 quest flow |
| `dengbaichuan` | 邓百川 | 回风舞柳剑 | implemented as branch metadata only |
| `baobutong` | 包不同 | 如影随形腿 | implemented as branch metadata only |
| `fengboe` | 风波恶 | 飞沙走石刀 | implemented as branch metadata only |
| `gongyegan` | 公冶干 | 大风云飞掌 | implemented as branch metadata only |

## CharacterConfig Audit

Current exact matches in `Assets/Mods/jshyl/Configs/Lua/CharacterConfig.lua`:

| mentor | existing id | evidence | notes |
|---|---:|---|---|
| 阿碧 | `339` | row `{339,...[[阿碧]]...}` | Exists and is already used by apprenticeship dialogue. |
| 邓百川 | none | no exact match | Missing as a role config. |
| 包不同 | none | no exact match | Missing as a role config. |
| 风波恶 | none | no exact match | Missing as a role config. |
| 公冶干 | none | no exact match | Missing as a role config. |

Nearby jshyl opening role ids:

```text
335 孟星魂
336 慕容秋荻
337 双儿
338 阿朱
339 阿碧
```

Recommendation for a later config slice:

```text
Add the four missing 家将 as new jshyl role ids after the current custom range, rather than reusing unrelated roles.
```

Do not add those rows in the visible-NPC scene slice unless dialogue portraits or team/battle participation require real role ids immediately.

## Model / Prefab Asset Audit

Existing exact jshyl model assets:

| mentor | existing model asset | notes |
|---|---|---|
| 阿碧 | `Assets/Mods/jshyl/Models/阿碧.asset` | Exists; references prefab GUID `01718cd6141eba74dbd25951c5a0f317`, the same visible model used by 阿朱/阿碧-style maid assets. |
| 邓百川 | none | No exact jshyl model asset found. |
| 包不同 | none | No exact jshyl model asset found. |
| 风波恶 | none | No exact jshyl model asset found. |
| 公冶干 | none | No exact jshyl model asset found. |

Useful existing jshyl/base visual candidates for placeholders:

```text
Assets/Mods/jshyl/Models/慕容秋荻.asset
Assets/Mods/jshyl/Models/孟星魂.asset
Assets/Mods/jshyl/Models/明教弟子.asset
Assets/Mods/jshyl/Models/何足道.asset
Assets/Mods/jshyl/Models/卓不凡.asset
Assets/BuildSource/ModelCharacters/BattleNpc/Murongfu.prefab
Assets/BuildSource/ModelCharacters/BattleNpc/Tubiweng.prefab
Assets/BuildSource/ModelCharacters/BattleNpc/Hetaichong.prefab
Assets/BuildSource/ModelCharacters/BattleNpc/Tangwenliang.prefab
```

Best-practice note:

```text
Future exact 家将 model assets should live under Assets/Mods/jshyl/Models.
Avoid creating new dependencies on Assets/Mods/JYX2 scene/prefab assets unless the jshyl packaging pipeline already includes them.
```

## 52_yanziwu Scene Presence

Current relevant scene objects in `Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity`:

| object | position | event id | visible target | notes |
|---|---|---:|---|---|
| `jshyl_abi_hint` | `(-20, 6.5, 27)` | `10000` | prefab target fileID `589146516` | Uses 阿碧-style visible target. |
| `jshyl_apprenticeship_master` | `(-18, 6.5, 27)` | `5210` | same prefab target fileID `589146516` | Current shared apprenticeship trigger. |
| `jshyl_azhu_hint` | `(-8.8, 6.5, 29)` | `5203` | prefab target fileID `215320552` | Existing 阿朱/ShuiGe hint trigger. |
| `jshyl_murong_opening` | `(-13, 5.24, 23.5)` | `5200` | prefab target fileID `1429533778` | Existing 慕容秋荻 chain. |
| `jshyl_shijian_training` | `(-8.6, 5.5, 40.5)` | `5205` | prefab target fileID `311040537` | Existing 侍剑 / 十二金钗 training. |

Scene evidence:

```text
No objects named 邓百川, 包不同, 风波恶, 公冶干, or their jshyl_* equivalents exist in 52_yanziwu.
阿碧 exists visually only through current 阿碧-style trigger targets, not as five separate mentor stations.
```

## Existing Trigger / Event Bindings

Current apprenticeship binding:

```text
event id: 5210
scene object: jshyl_apprenticeship_master
Lua file: Assets/Mods/jshyl/Lua/5210.lua
quest: qqzj_protagonist_apprenticeship_intro
behavior: shared branch selection, token consumption, skill rewards, 武学常识 reward
```

No separate per-mentor event bindings exist yet.

Previously documented future ids:

```text
5211: future ShuiGe upper study marker
5212: future ShuiGe study shelf trigger(s)
```

Because of that reservation, avoid using `5211` and `5212` for visible masters unless the ShuiGe plan is deliberately renumbered.

## Recommended NPC Placement

Goal:

```text
Make the five apprenticeship choices visually legible without crowding the existing opening interactions.
```

Recommended same-room cluster near the current apprenticeship area:

| mentor | proposed object | proposed position | purpose |
|---|---|---|---|
| 阿碧 | keep/reuse `jshyl_apprenticeship_master` or create `jshyl_master_abi` | around `(-18, 6.5, 27)` | Existing branch host; should remain near 阿碧 hint. |
| 邓百川 | `jshyl_master_dengbaichuan` | `(-21, 6.5, 31)` | Left/back of 阿碧, enough spacing for collider. |
| 包不同 | `jshyl_master_baobutong` | `(-18, 6.5, 31)` | Center/back. |
| 风波恶 | `jshyl_master_fengboe` | `(-15, 6.5, 31)` | Right/back. |
| 公冶干 | `jshyl_master_gongyegan` | `(-12, 6.5, 31)` | Far right, still inside the same room. |

Adjust in Unity visually before saving because the YAML coordinates alone do not prove walkability or camera framing.

## Decorative First Or Interactive Immediately?

Recommended approach:

```text
Add visible decorative NPCs first, keep interaction centralized on existing 5210.
```

Why:

```text
1. Four mentors do not yet have CharacterConfig rows.
2. Four mentors do not yet have exact jshyl model assets.
3. The branch-choice logic already works through the single 5210 flow.
4. Per-mentor interaction would require more Lua branches, event files, dialogue speaker ids, and save-compatibility choices.
5. A decorative-first pass lets Unity verify placement, scale, z/y alignment, collision, and visibility before gameplay is split across five triggers.
```

After decorative NPCs are visually stable, a second slice can make them interactive.

## Event ID Strategy

Avoid immediate use:

```text
5211
5212
```

Reason:

```text
They are already documented as future ShuiGe study ids.
```

Recommended per-mentor ids if/when interactive mentors are added:

| mentor | proposed event id | proposed Lua file | quest id |
|---|---:|---|---|
| 阿碧 | `5213` | `5213.lua` | `qqzj_protagonist_apprenticeship_master_abi` |
| 邓百川 | `5214` | `5214.lua` | `qqzj_protagonist_apprenticeship_master_dengbaichuan` |
| 包不同 | `5215` | `5215.lua` | `qqzj_protagonist_apprenticeship_master_baobutong` |
| 风波恶 | `5216` | `5216.lua` | `qqzj_protagonist_apprenticeship_master_fengboe` |
| 公冶干 | `5217` | `5217.lua` | `qqzj_protagonist_apprenticeship_master_gongyegan` |

Alternative:

```text
Keep all five objects bound to 5210 and let the central quest remain the only interaction path.
```

This is safest if the next slice is only visual/decorative.

## Risks

1. Adding visible NPCs by scene YAML alone can misalign y/z placement and cause half-body clipping. Use Unity scene view for placement.
2. Reusing the same 阿碧/阿朱 prefab for all five mentors will be visually confusing.
3. Creating exact role ids before portraits/models are ready can leave dialogue portraits wrong or placeholder-heavy.
4. Splitting the branch choice into per-mentor event ids can break old-save expectations if 5210 branching is removed instead of preserved.
5. `5211` and `5212` are already reserved in docs for ShuiGe study; using them for mentors creates avoidable future churn.
6. Decorative scene objects still require scene save and AssetBundle/Mod build handling, even with no Lua/config edits.
7. If decorative objects have colliders but no event component, they may block movement or confuse interaction prompts.

## Recommended Next Implementation Prompt

Recommended TPR-058B:

```text
Proceed with TPR-058B: add decorative visible apprenticeship masters.

Read:
docs/tpr_extraction/TPR_058A_VISIBLE_APPRENTICESHIP_MASTERS_AUDIT.md
docs/tpr_extraction/extractions/zhujuqinqing_apprenticeship.md

Allowed:
- Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- Lua edits
- config edits
- new role ids
- new event files
- battles
- companions
- item/skill/stat changes
- engine C#

Requirements:
1. Add visible decorative scene objects for 邓百川, 包不同, 风波恶, 公冶干 near the existing `jshyl_apprenticeship_master` area.
2. Preserve the existing `jshyl_apprenticeship_master` event 5210 as the only active apprenticeship interaction.
3. Do not bind new mentor event ids yet.
4. Use existing safe jshyl/base visual placeholders and document exact prefab/model choices.
5. Avoid movement-blocking colliders unless needed for visuals.
6. Verify in Unity that all five mentors are visible, upright, not half-clipped, not overlapping, and do not block player movement.
7. Update docs/backlog.
```

Later interactive prompt:

```text
After decorative placement is verified, plan/implement per-mentor interactions with event ids 5213-5217, preserving 5210 compatibility.
```
