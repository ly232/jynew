# TPR-058H: Yanziwu Worldbuilding Checkpoint

## Scope

Documentation-only checkpoint after TPR-058F and TPR-058G.

No gameplay, Lua, config, Unity scene, Unity asset, or engine files are changed by this checkpoint.

## Visible NPC / Placeholder State

Current visible character-facing objects in `52_yanziwu` include:

| object | role | status |
|---|---|---|
| `jshyl_apprenticeship_master` | Central apprenticeship interaction point, event `5210`. | Active quest trigger; still the only apprenticeship interaction. |
| `jshyl_abi_hint` | Existing 阿碧 validation / guidance interaction, event `10000`. | Active legacy vertical-slice interaction. |
| `jshyl_npc_dengbaichuan_placeholder` | 邓百川 visual mentor placeholder. | Decorative only; repositioned into mentor court. |
| `jshyl_npc_baobutong_placeholder` | 包不同 visual mentor placeholder. | Decorative only; repositioned into mentor court. |
| `jshyl_npc_fengboe_placeholder` | 风波恶 visual mentor placeholder. | Decorative only; repositioned into mentor court. |
| `jshyl_npc_gongyegan_placeholder` | 公冶干 visual mentor placeholder. | Decorative only; repositioned into mentor court. |
| `jshyl_murong_opening` | Opening / 秋荻 / family-chain interaction, event `5200`. | Active quest trigger; not source-final as a full family hall. |
| `jshyl_shuanger_rest` | 双儿 rest/service placeholder, event `5201`. | Active service trigger. |
| `jshyl_azhu_hint` | 阿朱 / ShuiGe hint, event `5203`. | Active quest trigger. |
| `jshyl_shijian_training` | 侍剑 training, event `5205`. | Active service/battle trigger. |

TPR-058F improved the four 家将 placeholders from a straight row into a looser non-interactive mentor court around `jshyl_apprenticeship_master`.

## Decorative Spatial Markers Now Present

TPR-058G added scene-only reused-prefab decorations. They are non-interactive and have no event ids.

| object | suggested area | status |
|---|---|---|
| `jshyl_decor_family_hall_entrance` | Family hall / opening authority area. | Decorative marker only. |
| `jshyl_decor_shuige_direction` | ShuiGe direction / antechamber hint. | Decorative marker only. |
| `jshyl_decor_servant_storage_marker` | Servant/storage/chest side area. | Decorative marker only. |
| `jshyl_decor_training_area_planter` | Training yard ambience near 侍剑 service. | Decorative marker only. |

These additions improve perceived area separation without adding rooms, triggers, scripts, configs, models, or new assets.

## Still Incomplete

### Real Rooms

Still incomplete.

The scene now suggests more zones, but it does not yet have source-complete separate rooms for:

```text
family hall
阿朱 / 阿碧 / 双儿 service rooms
servant/storage/chest room
ShuiGe inner room / upper study
training yard
docks / exit courtyard
```

Large room expansion should remain deferred until it can be done in Unity Editor with collision, camera, and movement checks.

### Real Mentor Models

Still incomplete.

The four 家将 are still placeholder visuals. Missing:

```text
final model choices
stable CharacterConfig role ids
portraits
speaker mapping
source-appropriate appearance
```

### Mentor Interactions

Still incomplete.

The source-facing branch logic remains centralized through event `5210`. This is useful for compatibility, but source-complete mentor interactions would need planned event ids, likely after role ids and portraits are stable.

### ShuiGe Interior

Still incomplete.

Current ShuiGe flow has:

```text
5204 entry / cost
5206 inner marker
5207 center chest
```

It still lacks:

```text
upper study marker
shelf interactions for unchosen apprenticeship skills
fourth-slot wash behavior
optional 王语嫣 fourth-slot handling
visual book/shelf structure
```

### Family Hall

Partially suggested, not complete.

`jshyl_murong_opening` still carries too much story weight through one trigger. Future source-complete work should separate:

```text
慕容秋荻 authority point
二叔 / 三叔 briefing positions
大哥 return staging
孟星魂 guard position
```

### Storage / Chests

Partially suggested, not complete.

The existing silver chest and ShuiGe center chest work as vertical slices. Remaining storage/chest work includes:

```text
full ShuiGe chest payload
阿碧-room chests
双儿 room chests / service chests
source-faithful item ids and idempotency flags
visual chest distribution by room
```

### Training Ground

Partially suggested, not complete.

`jshyl_shijian_training` and the planter marker make the area easier to read, but source-complete training still needs:

```text
clear practice-yard layout
visible 侍剑 / 十二金钗 staging
battle fidelity audit for battle 145
武常 +20 source behavior if not already handled
```

## Visual Acceptability For Continued Testing

`52_yanziwu` is now visually acceptable for continued gameplay testing.

Reason:

```text
Core quest/service triggers are still preserved.
The mentor placeholders are less clustered.
The scene now has visual hints for family hall, ShuiGe, storage, and training areas.
No new mechanics were introduced by the worldbuilding pass.
Unity batch-load smoke tests passed in TPR-058F and TPR-058G.
```

It is not source-complete or shippable as a final 燕子坞. It is good enough as a working hub while returning to mechanics and source coverage.

## Highest-ROI Next Task

Highest ROI:

```text
return to ShuiGe study mechanics
```

Why:

```text
The apprenticeship core now has branch selection, token consumption, skill rewards, +50 武学常识, and second-slot wash.
The scene has enough visual scaffolding to support the next mechanic slice.
ShuiGe study shelves are explicitly required by the extracted 拜师 section and unlock the remaining fourth-slot wash behavior.
```

Real mentor CharacterConfig/model work matters, but it is asset-heavy and less directly tied to the next source-critical gameplay gap.

## Recommended Next 5 Tasks

1. `TPR-059`: plan ShuiGe upper study marker and shelf scene binding.
2. `TPR-060`: implement first ShuiGe study entry marker as scene + dialogue/flags only.
3. `TPR-061`: plan ShuiGe shelf mechanics for unchosen apprenticeship skills and fourth-slot wash.
4. `TPR-062`: plan real mentor CharacterConfig rows / portraits / final model pipeline.
5. `TPR-063`: plan mentor-specific interactions after role ids and portraits are stable.

## Coverage Status

Keep `主角剧情：拜师` as:

```text
partially_implemented
```

The worldbuilding milestone improves testability and readability, but it does not complete source-critical ShuiGe study, mentor identity, branch-specific battle/stat, or fourth-slot wash behavior.
