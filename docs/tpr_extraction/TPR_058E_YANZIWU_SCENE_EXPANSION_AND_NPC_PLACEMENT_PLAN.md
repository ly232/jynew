# TPR-058E: Yanziwu Scene Expansion And NPC Placement Plan

## Scope

Planning only. This audit reviews the current `52_yanziwu` scene layout for visual/worldbuilding quality after the visible apprenticeship mentor placeholders and second-slot wash work.

No scene, Lua, config, Unity asset, gameplay, or engine files are changed by this document.

## Source Context

The extracted `主角剧情：开局` and `主角剧情：拜师` beats both assume 燕子坞 is more than a single compact room:

```text
family hall / 慕容秋荻 opening authority
阿朱 / 阿碧 / 双儿 service spaces
还施水阁 entry and inner study area
侍剑 / 十二金钗 training area
四大家将 / 阿碧 apprenticeship area
treasure / chest areas
future docks or outward route toward 杭州 / 开封 hooks
```

The current implementation has many of those functions represented as triggers, but most of them are visually concentrated in a small coordinate band.

## Current Trigger And Placeholder Inventory

Read-only inspection of `Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity` found these active jshyl objects.

| object | event id | position | current role |
|---|---:|---|---|
| `jshyl_murong_opening` | `5200` | `(-13, 5.24, 23.5)` | Opening chain: arrival, 秋荻, 孟星魂, family briefing, brother return. |
| `jshyl_shuanger_rest` | `5201` | `(-20, 6.5, 30)` | 双儿 rest/service placeholder. |
| `jshyl_yanzi_treasure` | `5202` | `(-30, 5.1, 27.4)` | Existing silver chest. |
| `jshyl_azhu_hint` | `5203` | `(-8.8, 6.5, 29)` | 阿朱 / 还施水阁 entry hint. |
| `jshyl_shuige_entry` | `5204` | `(-12.8, 6.5, 33.8)` | Dedicated ShuiGe entry cost/unlock. |
| `jshyl_shijian_training` | `5205` | `(-8.6, 5.5, 40.5)` | 侍剑 training / battle 145 service. |
| `jshyl_shuige_inner_marker` | `5206` | hidden at `(-12.8, -50, 36.3)`, moves to visible marker | ShuiGe inner marker, revealed by unlock flag. |
| `jshyl_shuige_inner_marker_visible` | none | `(-12.8, 6.5, 36.3)` | Target position for marker reveal. |
| `jshyl_shuige_center_chest` | `5207` | `(-10.8, 6.5, 36.3)` | First ShuiGe chest reward: 海月清辉. |
| `jshyl_abi_hint` | `10000` | `(-20, 6.5, 27)` | Phase 2 / 阿碧 validation interaction. |
| `jshyl_apprenticeship_master` | `5210` | `(-18, 6.5, 27)` | Centralized apprenticeship branch interaction. |

Decorative mentor placeholders:

| mentor | object | event id | position | current role |
|---|---|---:|---|---|
| 邓百川 | `jshyl_npc_dengbaichuan_placeholder` | none | `(-21, 5.5, 31)` | Decorative only. |
| 包不同 | `jshyl_npc_baobutong_placeholder` | none | `(-18, 5.5, 31)` | Decorative only. |
| 风波恶 | `jshyl_npc_fengboe_placeholder` | none | `(-15, 5.5, 31)` | Decorative only. |
| 公冶干 | `jshyl_npc_gongyegan_placeholder` | none | `(-12, 5.5, 31)` | Decorative only. |

## Room / Area Count Assessment

From the jshyl content perspective, the scene currently behaves like a compact hub with functional zones rather than a full source-faithful 燕子坞.

Functional areas represented today:

```text
opening/family authority point around 5200
阿碧 / apprenticeship cluster around 10000 and 5210
双儿/rest and treasure cluster around 5201 and 5202
还施水阁 entry / inner marker / center chest around 5204-5207
侍剑 training point around 5205
```

Quality issue:

```text
The scene has enough trigger coverage for vertical slices, but the visual/worldbuilding layout reads sparse and cramped. Most service, mentor, and ShuiGe objects sit within a narrow area near x -21..-8 and z 27..36, with training only slightly farther at z 40.5.
```

This is serviceable for testing but not source-complete for the TPR opening/apprenticeship fantasy.

## Clustering / Odd Placement Risks

### Apprenticeship Cluster

Current cluster:

```text
jshyl_abi_hint: (-20, 6.5, 27)
jshyl_apprenticeship_master: (-18, 6.5, 27)
邓百川 placeholder: (-21, 5.5, 31)
包不同 placeholder: (-18, 5.5, 31)
风波恶 placeholder: (-15, 5.5, 31)
公冶干 placeholder: (-12, 5.5, 31)
```

Issues:

```text
The four 家将 are arranged in a straight row only 3 units apart.
They are visually close to 阿碧 / 5210, but do not yet behave as individual mentors.
The row may look like a lineup instead of an inhabited family hall or training court.
Their y value is 5.5 while nearby interaction triggers often use y 6.5; this may be intentional model footing, but needs visual QA for half-body clipping.
```

### ShuiGe Cluster

Current cluster:

```text
jshyl_shuige_entry: (-12.8, 6.5, 33.8)
jshyl_shuige_inner_marker_visible: (-12.8, 6.5, 36.3)
jshyl_shuige_center_chest: (-10.8, 6.5, 36.3)
```

Issues:

```text
The entry, inner marker, and chest are very close together.
This is safe for slice testing, but it does not yet read as a separate inner ShuiGe room or upper study.
Future 5211 / 5212 study shelf work would crowd this same patch unless it gets its own zone.
```

### Opening / Services

Current cluster:

```text
jshyl_murong_opening: (-13, 5.24, 23.5)
jshyl_azhu_hint: (-8.8, 6.5, 29)
jshyl_shuanger_rest: (-20, 6.5, 30)
jshyl_yanzi_treasure: (-30, 5.1, 27.4)
```

Issues:

```text
The opening authority point, 阿朱 hint, 双儿 service, and silver chest are functionally distinct but not clearly separated into family hall / side room / chest room.
The treasure is much farther left than most other objects, which may be good for separation, but could feel isolated if not visually framed as a chest room.
```

### Training Area

Current training point:

```text
jshyl_shijian_training: (-8.6, 5.5, 40.5)
```

Issues:

```text
Training has the most separation along z, which is good.
It still lacks visible training markers, practice props, or 十二金钗 staging.
Battle 145 is bound through Lua, but the scene does not yet visually communicate a training yard.
```

## Recommended Improved Layout

The safest near-term plan is not to expand the map footprint aggressively. Instead, make a scene-only pass that spreads existing objects into clearer zones while preserving event ids and quest logic.

Recommended zones:

| zone | purpose | suggested objects |
|---|---|---|
| Family hall | Opening chain, 秋荻, 孟星魂 assignment, family briefing, brother return. | Keep `jshyl_murong_opening` in a central/front-hall position; later add decorative family-hall props only if existing assets are safe. |
| Apprenticeship court | 阿碧 and four 家将, centralized 5210 trigger, future per-mentor interactions. | Move four mentor placeholders into a semicircle or two-sided court around `jshyl_apprenticeship_master`, not a straight line. |
| ShuiGe antechamber | 5204 entry, 5206 inner marker, 5207 center chest. | Keep near current ShuiGe area, but space marker and chest farther apart so future shelves can be added. |
| Training yard | 侍剑 / 十二金钗 service. | Keep `jshyl_shijian_training` separated near z 40.5; later add decorative practice markers and optional opponent placeholders. |
| Service rooms | 双儿 rest, 阿朱/阿碧 services, treasure. | Keep service objects visually distinct; avoid clustering them with apprenticeship mentors. |
| Future docks / courtyard | World exit and 杭州/开封 narrative hooks. | Defer until map hook implementation needs a visible outbound route. |

### Specific Scene-Only Placement Cleanup

For TPR-058F, keep all existing event ids and objects, and make only visual placement adjustments:

```text
1. Keep jshyl_apprenticeship_master as the central 5210 interaction.
2. Move the four decorative mentor placeholders from a straight row into a loose semicircle around 5210.
3. Keep every mentor decorative-only: no event ids, colliders beyond prefab defaults, dialogue, Lua, config, or role ids.
4. Leave ShuiGe event ids 5204/5206/5207 intact, but optionally spread marker/chest positions by a few units if visual overlap is confirmed.
5. Do not add new rooms yet unless Unity visual QA confirms existing modular wall/floor assets can be duplicated safely.
```

Suggested mentor staging target:

| object | suggested intent | notes |
|---|---|---|
| `jshyl_npc_dengbaichuan_placeholder` | left/rear advisor position | More reserved, away from 阿碧 trigger. |
| `jshyl_npc_baobutong_placeholder` | left/front disputant position | Slightly forward for personality. |
| `jshyl_npc_fengboe_placeholder` | right/front martial position | Near future training path. |
| `jshyl_npc_gongyegan_placeholder` | right/rear scholar/logistics position | Toward ShuiGe/service side. |

Do not hard-code exact final coordinates in docs before a Unity visual pass. The implementer should adjust in the Scene view and then verify screenshots / movement.

## Additions To Consider

### More Rooms

Recommendation: defer full room expansion.

Reason:

```text
Duplicating architectural modules by hand in YAML is brittle.
Room expansion can break occlusion, collision, nav/player movement, camera framing, or lightmap assumptions.
If expanded, do it in Unity Editor with an immediate smoke test.
```

### Blocked-Off Placeholder Room Markers

Recommendation: safe later, but not first.

Possible markers:

```text
jshyl_room_marker_family_hall
jshyl_room_marker_shuige_upper_study
jshyl_room_marker_service_wing
jshyl_room_marker_docks
```

These can help future layout planning, but visible marker objects may feel artificial unless represented with existing doors/signage.

### Training Area

Recommendation: safe and useful after the mentor cleanup.

Low-risk scene-only additions:

```text
decorative practice dummy / weapon rack if existing prefabs are available
non-interactive training yard markers
spacing around jshyl_shijian_training
```

Defer interactive 十二金钗 NPCs until battle/source fidelity planning.

### ShuiGe Interior Area

Recommendation: plan next after TPR-058F.

The ShuiGe flow is already mechanically represented by 5204/5206/5207. The next visual step should reserve space for:

```text
upper study entry marker
four unchosen martial-art shelf markers
center chest / existing 海月清辉 reward
future 王语嫣 shelf wash behavior
```

### Family Hall

Recommendation: useful, but keep first pass small.

Family hall is where 5200 currently carries too much narrative weight. A later scene-only pass can separate:

```text
慕容秋荻 authority point
二叔 / 三叔 briefing positions
大哥 return staging
孟星魂 guard placement
```

### Docks / Courtyard Props

Recommendation: defer.

杭州 / 开封 hooks currently remain narrative flags because exact maps/assets are missing. Docks/courtyard props should wait until route/map hook planning can define what the exit affordance means.

## What Can Be Done Safely Now

Safe as scene-only edits:

```text
Move decorative mentor placeholders.
Move existing non-critical marker objects a few units for readability.
Reposition invisible/visible ShuiGe marker targets if necessary while preserving flags and event ids.
Add non-interactive decorative props only from already-used safe prefabs, after visual QA.
```

Rules for safety:

```text
Do not change event ids.
Do not change Lua.
Do not add CharacterConfig rows.
Do not add new model assets.
Do not add new interactive triggers in TPR-058F.
Do not make large architectural edits without Unity visual QA.
```

## What Should Be Deferred

Defer until real assets/models or specific source implementation slices exist:

```text
final 家将 CharacterConfig role ids
mentor portraits
source-final mentor models
per-mentor interactions / event ids 5213-5217
ShuiGe upper study shelves / event ids 5211-5212
王语嫣 fourth-slot wash behavior
branch-specific +10 系数 and 2周+ battle gate
family hall expansion with separate 二叔/三叔/大哥/Meng Xinghun actors
new maps or teleport transitions
large room expansion / architectural duplication
```

## Risks Of Expanding Too Aggressively

1. Scene YAML edits can introduce duplicate anchors or broken prefab references.
2. New walls/floors can block the player or camera if colliders are copied without visual QA.
3. Event targets can drift away from visible NPCs if only decorative objects move.
4. Tight trigger placement can make the interaction panel show the wrong event.
5. Over-expansion before final models may require rework when CharacterConfig and portraits are introduced.
6. Added props may need AssetBundle labels or dependencies if they are not already present in the jshyl build path.
7. Large scene changes make regressions harder to bisect; the current MOD benefits from small, reversible slices.

## Recommended TPR-058F Implementation Prompt

```text
Proceed with TPR-058F: scene-only apprenticeship mentor placement cleanup.

Read:
docs/tpr_extraction/TPR_058E_YANZIWU_SCENE_EXPANSION_AND_NPC_PLACEMENT_PLAN.md
docs/tpr_extraction/TPR_058C_VISIBLE_APPRENTICESHIP_NPC_CHECKPOINT.md

Allowed:
- Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- Lua edits
- config edits
- new assets
- new event ids
- new triggers
- gameplay changes
- engine C#

Requirements:
1. Reposition only the four decorative mentor placeholders:
   - jshyl_npc_dengbaichuan_placeholder
   - jshyl_npc_baobutong_placeholder
   - jshyl_npc_fengboe_placeholder
   - jshyl_npc_gongyegan_placeholder
2. Keep them decorative-only.
3. Preserve existing event ids and triggers, especially 5210.
4. Arrange mentors around `jshyl_apprenticeship_master` as a loose court/semicircle instead of a straight row.
5. Do not add rooms, props, CharacterConfig rows, portraits, Lua, or dialogue.
6. Run static scene checks for duplicate YAML anchors and unexpected new 5211-5217 event ids.
7. If Unity can be launched safely, run a batch project load smoke test.
8. Update tracker/backlog to mark TPR-058F implemented.

Done when:
- mentors are visually less clustered
- apprenticeship remains centralized through event 5210
- no gameplay behavior changes
- scene smoke/static checks pass
```

## Acceptance Criteria For TPR-058F

```text
1. Only 52_yanziwu scene placement and docs change.
2. The four mentor placeholder names remain unchanged.
3. No new event ids, Lua files, config rows, or assets are introduced.
4. jshyl_apprenticeship_master remains the only apprenticeship interaction.
5. Static YAML checks pass.
6. Unity visual QA is recommended and batch load smoke test is preferred.
```
