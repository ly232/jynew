# TPR-040 Plan: Hangzhou / Kaifeng Opening Map Hooks

## Scope

Planning only. No Lua, scene, config, asset, gameplay, battle, companion, or
engine files should change in this task.

Inputs reviewed:

```text
docs/tpr_extraction/TPR_036_OPENING_CHECKPOINT_AFTER_MENGXINGHUN_JOIN.md
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
Assets/Mods/jshyl/Configs/Lua/MapConfig.lua
Assets/Mods/jshyl/Maps/**
```

## 1. Current Map Availability

`Assets/Mods/jshyl/Configs/Lua/MapConfig.lua` does not contain exact `杭州` or
`开封` map rows.

Current relevant jshyl map rows:

| id | name | scene | note |
|---:|---|---|---|
| `0` | `燕子坞` | `52_yanziwu` | `START:0` row |
| `52` | `燕子坞` | `52_yanziwu` | normal map row |
| `1000` | `大地图` | `1000_daditu` | world map row |
| `4` | `昆仑仙境` | `04_kunlunxianjing` | reused story map |
| `67` | `昆仑山洞` | `67_shandong` | reused story map |
| `70` | `小虾米居` | `70_xiaoxiamiju` | placeholder/home candidate |

Current jshyl `Maps/GameMaps` assets:

```text
00_mochuanlinju.unity
04_kunlunxianjing.unity
1000_daditu.unity
52_yanziwu.unity
67_shandong.unity
70_xiaoxiamiju.unity
```

No `hangzhou`, `kaifeng`, `杭州`, or `开封` scene asset is present in jshyl.

The base `JYX2` and `SAMPLE` map lists inspected during this planning pass also
do not expose exact `杭州` / `开封` map rows or obvious exact scene names. They
have many reusable inns, towns, temples, and faction maps, but no source-faithful
杭州/开封 location by name.

## 2. Representation Options

| option | recommendation | reason |
|---|---|---|
| add placeholder map config rows now | defer | rows without matching scene assets are launch/runtime risk |
| reuse existing jshyl maps as fake 杭州/开封 | defer except for a clearly-labeled prototype | mislabels source locations and creates future migration burden |
| defer until map creation/copy slice | recommended for true maps | avoids broken MapConfig / AssetBundle references |
| narrative flags only | recommended immediate state | already implemented and safe |
| add world-map marker/route UI now | defer | needs scene edits and a target map id/asset first |

Planning conclusion:

```text
Keep 杭州/开封 as narrative route hooks until each has a real or explicitly
placeholder scene asset under Assets/Mods/jshyl/Maps/GameMaps.
```

## 3. Required Scene / Map Assets

For a real hook implementation, each destination needs:

| requirement | 杭州 | 开封 |
|---|---|---|
| map scene under `Assets/Mods/jshyl/Maps/GameMaps/` | required | required |
| `MapConfig.lua` row / Excel source row | required | required |
| `TransportToMap` return to `1000` or prior scene | required | required |
| entry condition strategy | required | required |
| world map route/entry affordance | required | required |
| AssetBundle labels / MOD packaging | required | required |
| save/load from inside destination | required | required |

Preferred future scene names:

```text
90_hangzhou
91_kaifeng
```

Preferred future map ids:

```text
90 杭州
91 开封
```

These ids are currently unused in jshyl `MapConfig.lua`, sit outside the copied
base 0-83 range, and leave room for future TPR-specific city maps.

## 4. Required Route / Hook Flags

Existing implemented flags from family briefing:

```text
qqzj_protagonist_opening_family_briefing_hangzhou_hook_unlocked
qqzj_protagonist_opening_family_briefing_kaifeng_hook_unlocked
```

The extraction uses older planned names:

```text
qqzj_protagonist_opening_family_briefing_hangzhou_hook_set
qqzj_protagonist_opening_family_briefing_kaifeng_hook_set
```

Recommendation:

```text
Continue using the implemented `_unlocked` flag names. Do not introduce `_set`
duplicates unless a migration need appears.
```

Future map-hook flags:

```text
qqzj_route_hangzhou_available
qqzj_route_hangzhou_first_entry_completed
qqzj_route_kaifeng_available
qqzj_route_kaifeng_first_entry_completed
```

Future placeholder-prototype flags, if needed:

```text
qqzj_route_hangzhou_placeholder_enabled
qqzj_route_kaifeng_placeholder_enabled
```

Do not set future map-route flags until the destination rows/assets exist.

## 5. Should Hooks Appear After Family Briefing?

Yes.

The current implementation already gates the route hooks through
`qqzj_protagonist_opening_family_briefing`, after:

```text
arrival -> 秋荻 guard -> 孟星魂 join -> family briefing
```

This matches the extraction: 二叔/三叔 briefing gives the opening guidance and
directs the player toward 杭州/开封. Future real map availability should require:

```text
qqzj_protagonist_opening_family_briefing_completed
```

If later source review shows one city should open only after 大哥 return or
ShuiGe, add that later as a route-specific gate; do not overfit now.

## 6. Recommended Next Implementation Slice

Recommended next slice: do not create map rows yet. Implement a dialogue-only
route status/check interaction or planning checkpoint first.

Best next implementation option:

```text
TPR-040A: add a small route-board/status interaction in 52_yanziwu, dialogue
only, using existing scene trigger if one is unclaimed or a later scene-edit
task if not.
```

However, if scene edits are not desired yet, the next safer gameplay slice is:

```text
TPR-041: complete 大哥 medicine rewards now that TPR-038 added item ids.
```

Recommended actual map work sequence:

| step | task | type |
|---:|---|---|
| 1 | decide whether 杭州/开封 need source-faithful custom scenes or acceptable placeholders | planning |
| 2 | create/copy one placeholder city scene under jshyl, starting with 杭州 | scene/config implementation |
| 3 | add MapConfig row for 杭州 only | config implementation |
| 4 | add route/entry trigger from world map or 燕子坞 | scene/Lua implementation |
| 5 | verify enter/exit/save/load | Unity verification |
| 6 | repeat for 开封 after 杭州 pattern is proven | implementation |

Do not add both cities in one first slice.

## 7. Risks

| risk | mitigation |
|---|---|
| MapConfig row references a missing scene | do not add rows until scene asset exists |
| Cross-MOD dependency on JYX2/SAMPLE assets | copy or create under `Assets/Mods/jshyl`, do not reference other MODs at runtime |
| World-map marker missing for new map ids | plan route affordance separately from MapConfig row |
| Save/load breaks if player saves inside placeholder city | include save/load in first city acceptance criteria |
| Placeholder city becomes mistaken for source-faithful 杭州/开封 | use explicit TODO/dialogue labels if a temporary scene is used |
| Existing narrative flags differ from extraction names | standardize on implemented `_unlocked` flags and document the choice |
| Opening flow grows too much in 5200 | future city route interactions should use dedicated event ids, not extend 5200 |

## 8. Acceptance Criteria

For this planning task:

```text
1. Confirm whether 杭州/开封 exist in jshyl MapConfig.
2. Confirm whether matching scene assets exist.
3. Recommend narrative-only hooks until assets exist.
4. Define future ids, scene names, flags, and gate.
5. Avoid gameplay/config/scene changes.
```

For a future first real city implementation:

```text
1. Add one city only, preferably 杭州.
2. Destination scene exists under jshyl.
3. MapConfig row references that scene.
4. Route availability is gated after family briefing.
5. Entry and return both work.
6. Save/load inside the destination works.
7. No cross-MOD runtime dependency is introduced.
8. The hook does not break 52_yanziwu or existing ShuiGe/chest flows.
```

## Recommended Follow-Up Prompt

```text
Proceed with TPR-041 planning only: choose the next post-opening slice.

Read:
docs/tpr_extraction/TPR_040_HANGZHOU_KAIFENG_MAP_HOOK_PLAN.md
docs/tpr_extraction/TPR_036_OPENING_CHECKPOINT_AFTER_MENGXINGHUN_JOIN.md
docs/tpr_extraction/extractions/zhujuqinqing_opening.md

Task:
Choose whether the next implementation should be:
- complete 大哥 medicine rewards,
- add a route-board/status dialogue for 杭州/开封,
- or begin a one-city placeholder map plan.

Do not implement gameplay yet.
```

