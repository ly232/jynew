# TPR-032 Checkpoint: Opening After ShuiGe Chest

## Scope

Documentation audit only. No gameplay, Lua, scene, config, asset, battle,
companion, or engine files were changed.

Inputs reviewed:

```text
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
docs/tpr_extraction/COVERAGE_TRACKER.md
docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md
docs/tpr_extraction/TPR_027_SHUIGE_OPENING_COVERAGE_CHECKPOINT.md
docs/tpr_extraction/TPR_030_SHUIGE_CHEST_REWARD_BINDING_PLAN.md
```

## 1. Implemented Quest / Event IDs

TPR opening coverage quests now implemented or partially implemented:

| quest id | event id | source beat | current status |
|---|---:|---|---|
| `qqzj_protagonist_opening_arrival` | `5200` | 燕子坞开局 arrival | playable first opening beat |
| `qqzj_protagonist_opening_qiudi_guard` | `5200` chain | 秋荻托付孟星魂 | dialogue, assignment flag, partial reward |
| `qqzj_protagonist_opening_family_briefing` | `5200` chain | 二叔/三叔 杭州/开封 hooks | narrative hooks only |
| `qqzj_protagonist_opening_brother_return` | `5200` chain | 大哥 return | dialogue plus verified partial reward |
| `qqzj_yanziwu_treasure_silver_chest` | `5202` | 燕子坞 silver chest | named/idempotent reward flow |
| `qqzj_protagonist_opening_shuige_entry_hint` | `5203` | 阿朱 points toward 还施水阁 | dialogue/flags only |
| `qqzj_protagonist_opening_shuige_entry` | `5204` | dedicated 还施水阁 entry | same-scene unlock only |
| `qqzj_protagonist_opening_shuige_inner` | `5206` | first inner ShuiGe marker | dialogue/flags only |
| `qqzj_protagonist_opening_shuige_center_chest` | `5207` | first ShuiGe center chest | grants 海月清辉 once |
| `qqzj_protagonist_opening_shijian_training` | `5205` | 侍剑/十二金钗 training | battle `145` preserved, source fidelity unverified |

Technical validation quest, not TPR coverage:

| quest id | event id | note |
|---|---:|---|
| `qqzj_intro_abi_guidance` | `10000` | Phase 2 vertical slice; excluded from TPR page coverage |

## 2. Implemented Scene Triggers

Claimed opening triggers and scene markers in `52_yanziwu`:

| marker/object | event id | role |
|---|---:|---|
| `jshyl_murong_opening` | `5200` | main opening chain entry |
| `jshyl_shuanger_rest` | `5201` | existing rest/service placeholder, not named QQZJ quest yet |
| `jshyl_yanzi_treasure` | `5202` | existing silver chest |
| `jshyl_azhu_hint` | `5203` | ShuiGe entry hint |
| `jshyl_shuige_entry` | `5204` | dedicated ShuiGe entry trigger |
| `jshyl_shijian_training` | `5205` | training trigger |
| `jshyl_shuige_inner_marker` | `5206` | inner ShuiGe marker after unlock |
| `jshyl_shuige_inner_marker_visible` | n/a | target transform for marker reveal/move |
| `jshyl_shuige_center_chest` | `5207` | first dedicated ShuiGe chest |
| `jshyl_abi_hint` | `10000` | technical validation slice, not TPR coverage |

Existing generic/non-QQZJ scene objects such as `Leave` and `Door` remain
unclaimed for source coverage until a dedicated binding plan assigns them.

## 3. Implemented Rewards

| reward | item id / effect | amount | source beat | idempotency status |
|---|---:|---:|---|---|
| `银两` | `174` | `10000` | opening arrival | quest flag guarded |
| `九转熊蛇丸` | `16` | `10` | 秋荻 reward | `qqzj_protagonist_opening_qiudi_guard_reward_claimed` |
| `玉真散` | `5` | `20` | 大哥 return partial reward | `qqzj_protagonist_opening_brother_return_reward_claimed` |
| `九转灵宝丸` | `14` | `20` | 大哥 return partial reward | same as above |
| `银两` | `174` | `30000` | 燕子坞 treasure chest | `qqzj_yanziwu_treasure_silver_chest_reward_claimed`; legacy `jshyl_yanzi_treasure_taken` migrated |
| `银两` | `174` | `500` | 侍剑 training existing reward | `qqzj_protagonist_opening_shijian_training_reward_claimed` |
| `海月清辉` | `209` | `1` | first ShuiGe center chest | `qqzj_protagonist_opening_shuige_center_chest_reward_claimed` |

The Phase 2 technical slice still grants `小还丹` id `3` x1, but it is not TPR
opening coverage.

## 4. Remaining Missing Rewards / Items

Item config rows now exist but have not yet been granted in opening source
flows:

| item | id | likely source beat |
|---|---:|---|
| `司南针` | `205` | 秋荻 / opening navigation reward |
| `狼牙燕翎` | `206` | 二叔/三叔 tool reward |
| `秦皇照骨镜` | `207` | 二叔/三叔 tool reward |
| `洛阳铲` | `208` | 二叔/三叔 tool reward |

Exact missing config rows still blocking source-faithful rewards:

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
```

Known reward/effect gaps:

```text
秋荻 司南针 has not been granted.
二叔/三叔 tool rewards have not been granted.
大哥 return still lacks 金创药, 少阳丹, 人参养荣丸.
明玉丹 paid/service flow is not implemented.
ShuiGe still lacks -3000 silver deduction.
ShuiGe still lacks full center-room and 阿碧-room chest suites.
侍剑 training still lacks 主角武常 +20.
```

## 5. Remaining Missing Scenes / Maps

Still missing or unverified:

```text
actual 杭州 map unlock/entry
actual 开封 map unlock/entry
true separate 还施水阁 map or richer room layout, if required later
return transport behavior from any future ShuiGe scene
source-faithful ShuiGe room/chest placement beyond the first center chest
阿朱/双儿 encounter refinement
separate physical 二叔/三叔/大哥 interaction triggers
exit/world-map flow verification
```

The current implementation deliberately keeps ShuiGe as same-scene markers in
`52_yanziwu` to avoid new map/config risk while reward and trigger patterns are
still being proven.

## 6. Remaining Missing Companions / NPCs

Companion and character work is still mostly narrative-only:

```text
孟星魂 is assigned by dialogue/flag only; he does not join the party.
二叔, 三叔, and 大哥 are represented through the 5200 opening chain, not separate triggers.
阿朱/阿碧/双儿 service roles need source-faithful trigger and role-id review.
侍剑/十二金钗 training uses existing battle 145, but source fidelity is unverified.
future rest-room companions and route characters are not represented yet.
```

Before real companion joins, verify role ids, models, Join/Leave APIs, party
capacity behavior, save/load persistence, and whether the companion is meant to
be playable immediately or only story-present.

## 7. Coverage Status

`主角剧情：开局` should remain `partially_implemented`.

It should not move to `implemented` or `verified` yet because:

```text
1. Opening source rewards are still incomplete.
2. Some required item configs are still missing.
3. ShuiGe has only one first chest reward, not the full source chest set.
4. ShuiGe entry is same-scene marker flow, not a source-complete room/transport flow.
5. 孟星魂 is not a real companion.
6. 杭州/开封 hooks do not unlock or enter maps.
7. Several NPCs are still chained through one interaction instead of source-faithful scene placement.
8. No end-to-end Unity verification has promoted the page section to verified.
```

The useful improvement after TPR-031 is that the project now has one validated
source-named ShuiGe chest reward pattern using a dedicated trigger and an
idempotent quest flag.

## 8. Recommended Next 5 Tasks

| order | task id | task | type | reason |
|---:|---|---|---|---|
| 1 | `TPR-033` | Plan 秋荻 / 二叔三叔 tool reward integration now that ids `205`-`208` exist | planning | decide exact source grouping and flags before granting more items |
| 2 | `TPR-034` | Implement idempotent opening tool rewards: `司南针`, `狼牙燕翎`, `秦皇照骨镜`, `洛阳铲` | implementation | closes a safe config-now-available reward gap without new maps or companions |
| 3 | `TPR-035` | Plan real 孟星魂 companion join / character content | planning | isolate party-state and save/load risk from reward work |
| 4 | `TPR-036` | Plan remaining ShuiGe item config rows for `九霄环佩`, `天书竹简`, `朱颜碧`, `缀玉华裳`, `湖畔舞剑图`, and 暗器 bundle | planning | unblocks source-faithful ShuiGe chest expansion |
| 5 | `TPR-037` | Plan ShuiGe silver deduction and entry semantics | planning | verify money API and insufficient-funds behavior before charging the player |

## 9. When To Introduce Real Companion / New Character Content

Recommended first companion/new-character task:

```text
TPR-035 planning only: real 孟星魂 companion join / character content.
```

Do this after `TPR-034` tool rewards unless the user explicitly prioritizes
party gameplay over reward completeness. The companion slice should remain
separate because it touches riskier systems than item grants: role config,
party membership, model availability, save/load, and potential party UI state.

Acceptance criteria for `TPR-035` planning:

```text
1. Verify candidate 孟星魂 role id or decide whether a new role row is required.
2. Verify model/avatar availability or choose an existing placeholder.
3. Identify exact Join/Leave API calls used by existing jshyl/jyx2 Lua.
4. Define flags for assigned, joined, and dismissed states.
5. Define save/load and repeated-interaction behavior.
6. Decide whether 孟星魂 joins during 秋荻托付 or after tool rewards.
```
