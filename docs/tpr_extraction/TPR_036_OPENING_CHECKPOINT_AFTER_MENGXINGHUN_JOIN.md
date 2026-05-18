# TPR-036 Checkpoint: Opening After Meng Xinghun Join

## Scope

Documentation audit only. No gameplay, Lua, scene, config, asset, battle,
companion, or engine files were changed.

Inputs reviewed:

```text
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
docs/tpr_extraction/COVERAGE_TRACKER.md
docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md
docs/tpr_extraction/TPR_032_OPENING_CHECKPOINT_AFTER_SHUIGE_CHEST.md
docs/tpr_extraction/TPR_035_MENGXINGHUN_COMPANION_JOIN_PLAN.md
```

## 1. Implemented Quest IDs

Current TPR opening quest coverage:

| quest id | source beat | status |
|---|---|---|
| `qqzj_protagonist_opening_arrival` | new game / 燕子坞 arrival | implemented |
| `qqzj_protagonist_opening_qiudi_guard` | 秋荻托付 / rewards / assignment | implemented, source-partial |
| `qqzj_protagonist_opening_mengxinghun_join` | 孟星魂 real companion join | implemented |
| `qqzj_protagonist_opening_family_briefing` | 二叔/三叔 hooks for 杭州/开封 | implemented, hooks only |
| `qqzj_protagonist_opening_brother_return` | 大哥 return | implemented, partial reward only |
| `qqzj_yanziwu_treasure_silver_chest` | existing 燕子坞 silver chest | implemented |
| `qqzj_protagonist_opening_shuige_entry_hint` | 阿朱 hints toward 还施水阁 | implemented, dialogue only |
| `qqzj_protagonist_opening_shuige_entry` | dedicated 还施水阁 entry trigger | implemented, unlock only |
| `qqzj_protagonist_opening_shuige_inner` | inner ShuiGe marker interaction | implemented, dialogue only |
| `qqzj_protagonist_opening_shuige_center_chest` | first ShuiGe chest | implemented, one reward only |
| `qqzj_protagonist_opening_shijian_training` | 侍剑/十二金钗 training | implemented architecture, source fidelity unverified |

Technical validation quest, still not TPR coverage:

| quest id | note |
|---|---|
| `qqzj_intro_abi_guidance` | Phase 2 local validation slice only |

## 2. Implemented Event IDs

| event id | Lua file | current QQZJ use |
|---:|---|---|
| `5200` | `Assets/Mods/jshyl/Lua/5200.lua` | opening chain: arrival -> 秋荻 -> 孟星魂 join -> family briefing -> 大哥 return |
| `5201` | `Assets/Mods/jshyl/Lua/5201.lua` | 双儿 rest/service placeholder, not named QQZJ quest yet |
| `5202` | `Assets/Mods/jshyl/Lua/5202.lua` | named 燕子坞 silver chest |
| `5203` | `Assets/Mods/jshyl/Lua/5203.lua` | 还施水阁 entry hint |
| `5204` | `Assets/Mods/jshyl/Lua/5204.lua` | dedicated 还施水阁 entry trigger |
| `5205` | `Assets/Mods/jshyl/Lua/5205.lua` | 侍剑 training / battle `145` |
| `5206` | `Assets/Mods/jshyl/Lua/5206.lua` | inner ShuiGe marker |
| `5207` | `Assets/Mods/jshyl/Lua/5207.lua` | ShuiGe center chest |
| `10000` | `Assets/Mods/jshyl/Lua/10000.lua` | technical 阿碧 validation slice |

## 3. Implemented Scene Triggers

Claimed triggers/markers in `52_yanziwu`:

| scene object | event id | role |
|---|---:|---|
| `jshyl_murong_opening` | `5200` | main opening chain |
| `jshyl_shuanger_rest` | `5201` | rest/service placeholder |
| `jshyl_yanzi_treasure` | `5202` | silver chest |
| `jshyl_azhu_hint` | `5203` | ShuiGe hint |
| `jshyl_shuige_entry` | `5204` | ShuiGe entry trigger |
| `jshyl_shijian_training` | `5205` | training trigger |
| `jshyl_shuige_inner_marker` | `5206` | inner ShuiGe marker |
| `jshyl_shuige_inner_marker_visible` | n/a | target transform for marker reveal/move |
| `jshyl_shuige_center_chest` | `5207` | first ShuiGe chest |
| `jshyl_abi_hint` | `10000` | technical validation slice |

Unclaimed or not source-complete:

```text
Leave / Door world-map flow
separate 二叔 / 三叔 / 大哥 physical triggers
true 阿朱 / 双儿 ShuiGe encounter trigger
additional ShuiGe chest triggers
杭州 / 开封 route triggers
```

## 4. Implemented Rewards / Items

| source beat | item / effect | id | amount | status |
|---|---|---:|---:|---|
| opening arrival | `银两` | `174` | `10000` | idempotent |
| 秋荻 reward | `九转熊蛇丸` | `16` | `10` | idempotent |
| 秋荻 tool | `司南针` | `205` | `1` | inert, idempotent |
| 二叔/三叔 tools | `狼牙燕翎` | `206` | `1` | inert, idempotent |
| 二叔/三叔 tools | `秦皇照骨镜` | `207` | `1` | inert, idempotent |
| 二叔/三叔 tools | `洛阳铲` | `208` | `1` | inert, idempotent |
| 大哥 partial reward | `玉真散` | `5` | `20` | idempotent |
| 大哥 partial reward | `九转灵宝丸` | `14` | `20` | idempotent |
| 燕子坞 silver chest | `银两` | `174` | `30000` | idempotent, legacy flag migrated |
| 侍剑 training | `银两` | `174` | `500` | idempotent |
| ShuiGe center chest | `海月清辉` | `209` | `1` | idempotent |

Still missing from the source opening rewards:

```text
金创药
少阳丹
人参养荣丸
明玉丹
九霄环佩
天书竹简
朱颜碧
缀玉华裳
湖畔舞剑图
source-faithful 各门派暗器 bundle
ShuiGe -3000 silver deduction
侍剑 training 武常 +20 effect
```

## 5. Implemented Companion Joins

Implemented:

| companion | role id | quest | join API | status |
|---|---:|---|---|---|
| `孟星魂` | `335` | `qqzj_protagonist_opening_mengxinghun_join` | `InTeam(335)`, `TeamIsFull()`, `Join(335)` | implemented |

Behavior now covered:

```text
already in team -> branch dialogue and mark complete
team full -> dialogue, no completion, retry later
successful join -> Join(335), mark complete
```

Still unverified in Unity:

```text
party/status UI portrait for Pic 35
model display from Models/孟星魂.asset in all relevant contexts
save/load of actual teammate state after Join(335)
full-team retry path in a real save
```

Not implemented:

```text
Leave(335)
custom leave story id
custom portrait/head art
custom model/prefab generation
companion rest-room behavior
```

## 6. Remaining Opening Blockers

### Source Reward / Item Blockers

```text
大哥 reward still lacks 金创药, 少阳丹, 人参养荣丸.
秋荻 明玉丹 paid/service flow is absent.
ShuiGe lacks 九霄环佩, 天书竹简, 朱颜碧, 缀玉华裳, 湖畔舞剑图, and 暗器 bundle.
侍剑 training lacks 武常 +20.
```

### ShuiGe Blockers

```text
No -3000 silver deduction.
No true 阿朱-as-双儿 encounter implementation.
No source-complete ShuiGe room/chest suite.
No separate ShuiGe scene or source-faithful room layout.
Current ShuiGe is same-scene marker flow only.
```

### Map / Route Blockers

```text
杭州 hook is narrative flag only; no actual map unlock/entry.
开封 hook is narrative flag only; no actual map unlock/entry.
World-map exit/route flow remains unverified for source opening.
```

### Scene / NPC Blockers

```text
二叔, 三叔, and 大哥 are still represented through the 5200 chain.
Separate physical NPC triggers are not implemented.
阿朱/双儿 source encounter and service identity need review.
5201 双儿 service is not yet folded into named QQZJ quest architecture.
```

### Verification Blockers

```text
No Unity end-to-end verification after TPR-035A is recorded here.
Lua syntax was not independently checked by shell because no Lua interpreter is available.
Party UI, portrait, model, save/load, and full-team behavior need manual or automated Unity testing.
```

## 7. Coverage Status

`主角剧情：开局` remains `partially_implemented`.

It should not move to `implemented` because:

```text
1. The opening reward list is still incomplete.
2. ShuiGe has only the first chest reward and no source-complete entry flow.
3. 杭州/开封 are still narrative hooks only.
4. Several NPCs are not physically separated into source-faithful triggers.
5. Source service flows such as 明玉丹, 双儿 rest/chests, and 阿朱/阿碧 services are incomplete.
6. Unity verification after the real companion join is not yet recorded.
```

The meaningful progress after TPR-035A is that the opening now includes the
first real source companion join, rather than only a story assignment flag.

## 8. Recommended Next 5 Tasks

| order | task id | task | type | why next |
|---:|---|---|---|---|
| 1 | `TPR-037` | Plan missing medicine item config rows for 大哥 / 秋荻 service | planning | unblocks `金创药`, `少阳丹`, `人参养荣丸`, `明玉丹` without touching gameplay first |
| 2 | `TPR-038` | Add minimal inert medicine item config rows | implementation | enables source-faithful 大哥 and 明玉丹 reward/service slices |
| 3 | `TPR-039` | Plan ShuiGe silver deduction and source entry semantics | planning | defines `-3000` behavior and insufficient-funds handling before charging |
| 4 | `TPR-040` | Plan 杭州 / 开封 map hook implementation | planning | turns existing narrative flags into real route affordances safely |
| 5 | `TPR-041` | Extract the next TPR page/section | extraction | avoids overfitting the opening before the broader route graph advances |

## 9. Required Topic Placement

| topic | recommended task |
|---|---|
| missing medicine item configs | `TPR-037` planning, then `TPR-038` implementation |
| silver deduction | `TPR-039` planning |
| map hooks | `TPR-040` planning |
| real scene entry | after `TPR-039`; likely a follow-up `TPR-042` for source ShuiGe entry behavior |
| next TPR page extraction | `TPR-041` |

## Notes For Next Slices

Do not add more source mechanics directly to `5200` until there is a clear
reason. The chain now covers arrival, rewards, companion join, family hooks, and
大哥 return. Future source-faithful NPC separation should introduce dedicated
scene bindings rather than continuing to grow the 5200 interaction.
