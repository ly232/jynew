# TPR-027 Checkpoint: ShuiGe + Opening Coverage

## Scope

Documentation audit only. No gameplay, Lua, scene, config, asset, battle,
companion, or engine files were changed.

Inputs reviewed:

```text
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
docs/tpr_extraction/COVERAGE_TRACKER.md
docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md
docs/tpr_extraction/TPR_023_SHUIGE_BEHAVIOR_AFTER_TRIGGER_PLAN.md
docs/tpr_extraction/TPR_025_SHUIGE_INNER_MARKER_INTERACTION_PLAN.md
Assets/Mods/jshyl/Lua/*.lua event dispatchers
Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
```

## 1. Implemented Quest IDs

TPR coverage quests currently implemented:

| quest id | source beat | event id / source | coverage status |
|---|---|---|---|
| `qqzj_protagonist_opening_arrival` | 燕子坞开局 arrival | `5200` | partial, playable |
| `qqzj_protagonist_opening_qiudi_guard` | 秋荻托付孟星魂 | `5200` chain | partial, no real companion join |
| `qqzj_protagonist_opening_family_briefing` | 二叔/三叔 杭州/开封 hooks | `5200` chain | narrative hooks only |
| `qqzj_protagonist_opening_brother_return` | 大哥 return | `5200` chain | partial reward only |
| `qqzj_protagonist_opening_shuige_entry_hint` | 阿朱 points toward 还施水阁 | `5203` | dialogue/flags only |
| `qqzj_protagonist_opening_shuige_entry` | dedicated 还施水阁 entry | `5204` | same-scene unlock only |
| `qqzj_protagonist_opening_shuige_inner` | first inner ShuiGe marker | `5206` | dialogue/flags only |
| `qqzj_protagonist_opening_shijian_training` | 侍剑/十二金钗 training service | `5205` | architecture refactor, battle `145` preserved |
| `qqzj_yanziwu_treasure_silver_chest` | existing 燕子坞 silver chest | `5202` | named/idempotent, not full 水阁宝箱 |

Technical validation quest, not TPR coverage:

| quest id | event id | note |
|---|---|---|
| `qqzj_intro_abi_guidance` | `10000` | Phase 2 vertical slice only; do not count as TPR page coverage |

## 2. Existing Event IDs And Bindings

| event id | Lua file | scene object / binding | current behavior |
|---:|---|---|---|
| `5200` | `Assets/Mods/jshyl/Lua/5200.lua` | `jshyl_murong_opening` | dispatches opening chain starting at arrival |
| `5201` | `Assets/Mods/jshyl/Lua/5201.lua` | `jshyl_shuanger_rest` | 双儿 rest/service flow; not yet named QQZJ quest |
| `5202` | `Assets/Mods/jshyl/Lua/5202.lua` | `jshyl_yanzi_treasure` | silver chest, idempotent `银两` id `174` x30000 |
| `5203` | `Assets/Mods/jshyl/Lua/5203.lua` | `jshyl_azhu_hint` | ShuiGe entry hint after 大哥 return |
| `5204` | `Assets/Mods/jshyl/Lua/5204.lua` | `jshyl_shuige_entry` | true entry gate; unlocks inner marker flag/state |
| `5205` | `Assets/Mods/jshyl/Lua/5205.lua` | `jshyl_shijian_training` | named 侍剑 training flow; preserves battle `145` |
| `5206` | `Assets/Mods/jshyl/Lua/5206.lua` | `jshyl_shuige_inner_marker` | inner ShuiGe dialogue marker |
| `10000` | `Assets/Mods/jshyl/Lua/10000.lua` | `jshyl_abi_hint` | Phase 2 阿碧 technical validation slice |

There are also generic scene triggers with `m_InteractiveEventId: -1`; they are
not claimed by current QQZJ opening coverage.

## 3. Existing Scene Markers / Triggers

Claimed jshyl markers in `52_yanziwu`:

| marker/object | event id | role |
|---|---:|---|
| `jshyl_murong_opening` | `5200` | opening chain entry point |
| `jshyl_shuanger_rest` | `5201` | rest/service placeholder |
| `jshyl_yanzi_treasure` | `5202` | existing silver chest |
| `jshyl_azhu_hint` | `5203` | ShuiGe hint |
| `jshyl_shuige_entry` | `5204` | dedicated ShuiGe entry trigger |
| `jshyl_shijian_training` | `5205` | training trigger |
| `jshyl_shuige_inner_marker` | `5206` | inner ShuiGe marker after unlock |
| `jshyl_shuige_inner_marker_visible` | n/a | target transform used when the marker is revealed/moved |
| `jshyl_abi_hint` | `10000` | non-TPR technical validation slice |

Existing non-QQZJ objects such as `Leave` and `Door` remain available for later
review, but they should not be repurposed without a dedicated scene-binding
plan.

## 4. Remaining Blockers

### Missing Items

Exact verified items already used:

| item | id | current usage |
|---|---:|---|
| `玉真散` | `5` | 大哥 partial reward x20 |
| `九转灵宝丸` | `14` | 大哥 partial reward x20 |
| `九转熊蛇丸` | `16` | 秋荻 reward x10; safe later for ShuiGe rewards |
| `银两` | `174` | arrival reward and silver chest |

Missing exact item configs still block source-faithful rewards:

```text
司南针
金创药
少阳丹
人参养荣丸
明玉丹
狼牙燕翎
秦皇照骨镜
洛阳铲
海月清辉
九霄环佩
天书竹简
朱颜碧
缀玉华裳
湖畔舞剑图
```

Approximate placeholders found in earlier audits, but not approved as
source-faithful replacements:

```text
罗盘 id 182 -> possible 司南针 placeholder
铁铲 id 195 -> possible 洛阳铲 placeholder
暗器 ids 96-105 -> primitives for future "各门派暗器" reward design
```

### Missing Maps / Map Config Availability

Current opening work remains inside:

```text
Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
```

Still unimplemented or unverified:

```text
杭州 route hook actual map unlock/entry
开封 route hook actual map unlock/entry
separate 还施水阁 map or room scene, if later needed
return transport behavior from any future ShuiGe map
```

The current recommendation is still to keep ShuiGe inside `52_yanziwu` until
item rewards and chest bindings are stable.

### Scene Edits

Scene edits still required for source-complete opening:

```text
real ShuiGe chest/reward trigger placement
possible separate 阿朱/双儿 encounter trigger refinement
possible physical 二叔/三叔/大哥 trigger separation
possible route-exit trigger review for 杭州/开封
```

No further scene edit should happen before deciding the missing item/config
strategy, unless the user explicitly prioritizes spatial polish over rewards.

### Companions

`qqzj_protagonist_opening_qiudi_guard_mengxinghun_assigned` records the story
assignment, but 孟星魂 is not yet a real companion.

Companion work remains blocked by:

```text
role id/model verification
join/remove API verification
party state save/load test
decision whether the bodyguard should be playable or only story-present
```

### Battles

The only opening battle currently attached to a TPR-adjacent flow is:

```text
battle id: 145
quest: qqzj_protagonist_opening_shijian_training
```

Remaining battle blockers:

```text
source fidelity of battle 145 as 十二金钗 needs verification
source effect 主角武常 +20 is TODO
no new ShuiGe/opening battles are planned yet
```

## 5. Coverage Status

`主角剧情：开局` must remain `partially_implemented`.

Reasons:

```text
1. ShuiGe flow currently reaches hint -> entry -> inner marker, but no silver
   deduction, no chest payout, and no source-complete room/reward sweep exists.
2. Several source rewards still lack exact item configs.
3. 孟星魂 is assigned only by flag/dialogue, not as an actual companion.
4. 二叔/三叔/大哥 are currently part of a chained interaction rather than
   source-faithful separate scene interactions.
5. 杭州/开封 hooks are flags only; no map unlock or route transition exists.
6. 侍剑 training is refactored and playable, but source fidelity and 武常 +20
   effect remain unverified.
7. No Unity end-to-end verification has advanced this page section to verified.
```

## 6. Recommended Next 3 Tasks

| order | task id | task | type | why next |
|---:|---|---|---|---|
| 1 | `TPR-028` | Plan exact item/config strategy for remaining opening and ShuiGe rewards | planning | unblock source-faithful rewards without touching gameplay first |
| 2 | `TPR-029` | Add minimal exact item config rows for approved missing opening/ShuiGe rewards | implementation | first safe place to introduce new items after ids/schema are planned |
| 3 | `TPR-030` | Plan ShuiGe chest/reward trigger grouping and idempotency flags | planning | prepare real chest rewards once exact item ids exist |

## 7. When To Introduce New Items, Chest Rewards, Companions

Recommended sequencing:

```text
New items:
  Begin with TPR-028 planning, then TPR-029 implementation.

Real chest rewards:
  Begin after TPR-029 item rows exist and are validated. The first reward slice
  should be a small ShuiGe chest group, not every chest in one pass.

Companion joins:
  Defer until after ShuiGe rewards are stable. 孟星魂 is already represented by
  a save-backed assignment flag, so the real Join/Leave API can be isolated in
  a later companion-specific vertical slice.
```

Acceptance criteria for the next item/config planning task:

```text
1. Decide whether to create exact new item rows or use approved placeholders.
2. Reserve stable ids for missing opening/ShuiGe items.
3. Identify required config files and generated Lua outputs.
4. Define rollback-safe, idempotent reward flags for future chest payouts.
5. Keep all gameplay/Lua/scene files untouched during planning.
```
