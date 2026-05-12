# TPR Extraction: 主角剧情 / 开局

## Page Record

```yaml
page:
  title: "主角剧情"
  section_title: "开局"
  url: "https://tpr.inkit.cc/tpr5:主角剧情"
  category: "story_route"
  route_book: "主角"
  status: "extracted"
  source_revision_or_date: "source page observed from TPR wiki; page line shows tpr5:主角剧情"
  extraction_date: "2026-05-12"
  extractor: "codex"
```

## Source Scope

This extraction covers only the early opening section of `主角剧情`, especially the opening numbered steps and the immediate `燕子坞功能` notes.

Covered source beats:

```text
开局 step 1: new game opening, first rewards, 慕容秋荻, 孟星魂, 二叔/三叔, 杭州/开封 hints, 大哥 return.
开局 step 2: enter 还施水阁, 阿朱/双儿 encounter, room/chest rewards, formal start of journey.
燕子坞功能: 双儿 rest/chests, 阿朱 avatar/model service, 阿碧 medicine/rest service, 侍剑 training, 慕容秋荻明玉丹 service, horses for 群芳谱/队友召唤, special later-week features, companion resting rooms.
```

Out of scope for this extraction:

```text
拜师
家传武艺
老爹及大哥
天赋进阶
慕容套装
家族试炼
华山论剑
惟我华夏
```

## Quest IDs

| quest id | title | purpose |
|---|---|---|
| `qqzj_protagonist_opening_arrival` | 燕子坞开局 | first entry dialogue, starting silver, initial room exit |
| `qqzj_protagonist_opening_qiudi_guard` | 秋荻托付 | 慕容秋荻 grants items and assigns 孟星魂 |
| `qqzj_protagonist_opening_family_briefing` | 二叔三叔江湖简报 | family briefing, key tools, 杭州/开封 hooks |
| `qqzj_protagonist_opening_brother_return` | 大哥归来 | brother dialogue and starter medicine bundle |
| `qqzj_protagonist_opening_shuige_entry` | 初入还施水阁 | 阿朱/双儿 encounter, silver cost |
| `qqzj_protagonist_opening_shuige_rewards` | 水阁宝箱 | room/chest rewards and journey-start completion |
| `qqzj_yanziwu_services` | 燕子坞功能 | reusable home-base services after opening |

## Scene / Map Requirements

| map | role in section | current known target |
|---|---|---|
| 燕子坞 | primary opening/home-base scene | `52_yanziwu` |
| 主角初始房间 | spawn/first dialogue space | likely sub-area or trigger zone inside `52_yanziwu`; manual scene review needed |
| 还施水阁 | right-side entry from 燕子坞大厅 | likely needs object/trigger mapping inside `52_yanziwu`; manual scene review needed |
| 阿朱阿碧中间房间 | special reward room | manual scene review needed |
| 阿碧房间 | four chest rewards | manual scene review needed |
| 旁边房间 | 二叔/三叔 briefing | manual scene review needed |
| 燕子坞出口 | triggers 大哥 return / world access | manual scene review needed |
| 杭州城 | future route hook only | implementation target TBD |
| 开封 | future route hook only | implementation target TBD |
| 琴韵小筑 | later home-base facility | future map/scene target TBD |
| 听香水榭 | later home-base facility | future map/scene target TBD |

## NPCs Involved

| NPC | section role | implementation note |
|---|---|---|
| 主角 | player character | receives rewards, quest flags, and route hooks |
| 慕容秋荻 | opening authority figure | assigns 孟星魂, gives items, later明玉丹 service |
| 孟星魂 | bodyguard/companion | companion implementation deferred until companion system slice |
| 二叔 | family briefing | NPC placement and dialogue trigger needed |
| 三叔 | family briefing | NPC placement and dialogue trigger needed |
| 大哥 / 慕容复 | return event and starter medicines | exact in-game role id/model manual review needed |
| 阿朱 | 还施水阁 encounter/service | avatar/model service deferred |
| 阿碧 | 还施水阁 service | existing validated interaction pattern can guide implementation |
| 双儿 | rest/chest room function | possibly represented by 阿朱 disguise in source; needs manual review |
| 侍剑 | training service | battle slice needed later |
| 十二金钗 | training opponents | battle/config mapping needed later |
| 四大家将 | later-week statue/ghost helper condition | out of first implementation slice unless needed as NPC scenery |
| 黄蓉/王语嫣/东方影 and other companions | home-base resting room references | later companion-room behavior only |

## Dialogue Beats

| beat id | quest id | summary | choices |
|---|---|---|---|
| opening_entry | `qqzj_protagonist_opening_arrival` | new game starts; introductory dialogue completes; protagonist receives starting silver | none |
| qiudi_assignment | `qqzj_protagonist_opening_qiudi_guard` | on exiting initial room, 慕容秋荻 gives travel tools/medicine and assigns 孟星魂 | none initially; companion join may be automatic |
| family_briefing_intro | `qqzj_protagonist_opening_family_briefing` | entering side room plays broad martial-world briefing | none |
| family_briefing_rewards | `qqzj_protagonist_opening_family_briefing` | separate 二叔/三叔 interactions give tools and direct player toward 杭州 and 开封 | no branching expected |
| brother_return | `qqzj_protagonist_opening_brother_return` | leaving outward triggers brother return dialogue and medicine bundle | none |
| shuige_azhu_shuanger | `qqzj_protagonist_opening_shuige_entry` | entering 还施水阁 triggers 阿朱-as-双儿 encounter and silver cost | no choice in source; confirm whether player can be blocked by insufficient silver |
| shuige_center_room | `qqzj_protagonist_opening_shuige_rewards` | player opens center-room reward containers | inventory interaction |
| abi_room_chests | `qqzj_protagonist_opening_shuige_rewards` | player opens four 阿碧-room chests | inventory interaction |
| journey_start | `qqzj_protagonist_opening_shuige_rewards` | after reward sweep, opening is complete and Jianghu journey begins | none |
| home_services | `qqzj_yanziwu_services` | rest, avatar/model, medicine purchase/rest, training,明玉丹, team/status utilities | multiple service choices; implement one service per slice |

## Flags

Use explicit stage flags and idempotency flags.

```text
qqzj_protagonist_opening_arrival_started
qqzj_protagonist_opening_arrival_reward_claimed
qqzj_protagonist_opening_arrival_completed

qqzj_protagonist_opening_qiudi_guard_started
qqzj_protagonist_opening_qiudi_guard_reward_claimed
qqzj_protagonist_opening_qiudi_guard_mengxinghun_assigned
qqzj_protagonist_opening_qiudi_guard_completed

qqzj_protagonist_opening_family_briefing_started
qqzj_protagonist_opening_family_briefing_intro_seen
qqzj_protagonist_opening_family_briefing_tools_claimed
qqzj_protagonist_opening_family_briefing_hangzhou_hook_set
qqzj_protagonist_opening_family_briefing_kaifeng_hook_set
qqzj_protagonist_opening_family_briefing_completed

qqzj_protagonist_opening_brother_return_started
qqzj_protagonist_opening_brother_return_reward_claimed
qqzj_protagonist_opening_brother_return_completed

qqzj_protagonist_opening_shuige_entry_started
qqzj_protagonist_opening_shuige_entry_silver_paid
qqzj_protagonist_opening_shuige_entry_completed

qqzj_protagonist_opening_shuige_rewards_started
qqzj_protagonist_opening_shuige_rewards_center_claimed
qqzj_protagonist_opening_shuige_rewards_abi_chests_claimed
qqzj_protagonist_opening_shuige_rewards_completed

qqzj_yanziwu_services_unlocked
qqzj_yanziwu_services_shijian_training_won
qqzj_yanziwu_services_qiudi_mingyudan_claimed
```

Compatibility note:

```text
Existing Phase 2 flags are unrelated validation flags and should not be treated as TPR opening coverage.
If the existing 阿碧 validation trigger is replaced by TPR 阿碧 service content, preserve/migrate:
qqzj_intro_abi_guidance_started
qqzj_intro_abi_guidance_reward_claimed
qqzj_intro_abi_guidance_sparring_won
qqzj_intro_abi_guidance_completed
```

## Rewards

All rewards must be idempotent. Item ids must be verified against `jshyl` configs before implementation.

| reward source | rewards/items | quantity | target flag | config status |
|---|---|---:|---|---|
| opening entry | 银子 | 10000 | `qqzj_protagonist_opening_arrival_reward_claimed` | money API/config behavior needs review |
| 慕容秋荻 | 司南针 | 1 | `qqzj_protagonist_opening_qiudi_guard_reward_claimed` | item id TBD |
| 慕容秋荻 | 九转熊蛇丸 | 10 | same as above | item id TBD |
| 二叔/三叔 | 狼牙燕翎 | 1 | `qqzj_protagonist_opening_family_briefing_tools_claimed` | item id TBD |
| 二叔/三叔 | 秦皇照骨镜 | 1 | same as above | item id TBD |
| 二叔/三叔 | 洛阳铲 | 1 | same as above | item id TBD |
| 大哥 | 金创药 | 20 | `qqzj_protagonist_opening_brother_return_reward_claimed` | item id TBD |
| 大哥 | 少阳丹 | 20 | same as above | item id TBD |
| 大哥 | 玉真散 | 20 | same as above | item id TBD |
| 大哥 | 人参养荣丸 | 20 | same as above | item id TBD |
| 大哥 | 九转灵宝丸 | 20 | same as above | item id TBD |
| 阿朱/双儿 encounter | 银子 | -3000 | `qqzj_protagonist_opening_shuige_entry_silver_paid` | money removal API needs review |
| center room | 海月清辉 | 1 | `qqzj_protagonist_opening_shuige_rewards_center_claimed` | item id TBD |
| center room | 九霄环佩 | 1 | same as above | item id TBD |
| center room | 天书竹简 | 1 | same as above | item id TBD |
| 阿碧 room chests | 朱颜碧 | 1 | `qqzj_protagonist_opening_shuige_rewards_abi_chests_claimed` | item id TBD |
| 阿碧 room chests | 缀玉华裳 | 1 | same as above | item id TBD |
| 阿碧 room chests | 湖畔舞剑图 | 1 | same as above | item id TBD |
| 阿碧 room chests | 各门派暗器 | 20 each | same as above | exact item list TBD |
| 阿碧 room chests | 九转熊蛇丸 | 20 | same as above | item id TBD |
| 双儿 room chests | 银子 | 30000 each chest | service/chest flags TBD | facility, not core opening completion |
| 慕容秋荻 service | 明玉丹 | 1 | `qqzj_yanziwu_services_qiudi_mingyudan_claimed` | costs 30000 silver; item id TBD |

## Battles

| battle source | description | required now | target flag | notes |
|---|---|---|---|---|
| 侍剑 training | 主角众人 vs 十二金钗 | no, home-base service slice | `qqzj_yanziwu_services_shijian_training_won` | battle id/config mapping TBD; reward/effect: 主角武常 +20 |
| 四大家将 statue / 岳飞像 | later-week ghost helper | no | TBD | only for 2周+ and 14天书 disappearance; defer |

No battle is required for the mandatory early opening quest chain before the home-base service layer.

## Route Dependencies

```yaml
dependencies:
  prior_quests: []
  route_locks: []
  companion_states:
    - "孟星魂 assigned as protector after 慕容秋荻 event"
  item_states:
    - "starting tools from 慕容秋荻 and 二叔/三叔 unlock future route affordances"
  chapter_states:
    - "opening must complete before free Jianghu exploration"
  book_count: 0
  special_conditions:
    - "2周+ 岳飞像 ghost helper is not part of first-week opening implementation"
    - "14天书 condition affects later ghost helper cleanup only"
```

## Unknowns Requiring Manual Review

1. Exact item ids for all named TPR rewards in jshyl config.
2. Money add/remove APIs and whether `AddItem` uses a silver item id or separate currency method.
3. Current `52_yanziwu` scene layout: initial room, side room, 还施水阁, center room, 阿碧 room, exits.
4. Existing NPC role ids/models for 慕容秋荻, 孟星魂, 二叔, 三叔, 大哥/慕容复, 阿朱, 阿碧, 双儿, 侍剑.
5. Whether 孟星魂 should be a real companion immediately or represented as a story flag until companion work is scheduled.
6. Whether 阿朱-as-双儿 costs silver automatically or should use a confirmation prompt if funds are insufficient.
7. Chest implementation strategy: unique trigger per chest vs grouped reward trigger.
8. How to represent `整理物品` from the source.
9. Exact effect/API for 主角武常 +20 after 侍剑 training.
10. Whether existing Phase 2 阿碧 trigger should be moved, replaced, or preserved as a debug/test-only event.

## Implementation Mapping

```yaml
implementation:
  target_maps:
    - "Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity"
  target_lua_files:
    - "Assets/Mods/jshyl/Lua/<new opening event ids>.lua"
    - "Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua"
  target_quest_handlers:
    - "qqzj_protagonist_opening_arrival"
    - "qqzj_protagonist_opening_qiudi_guard"
    - "qqzj_protagonist_opening_family_briefing"
    - "qqzj_protagonist_opening_brother_return"
    - "qqzj_protagonist_opening_shuige_entry"
    - "qqzj_protagonist_opening_shuige_rewards"
    - "qqzj_yanziwu_services"
  target_battles:
    - "侍剑 / 十二金钗 training battle TBD"
  target_assets:
    - "existing NPC prefabs/models only for first implementation pass"
  manual_unity_steps:
    - "inspect and mark trigger locations in 52_yanziwu"
    - "bind new event ids to opening-room, 秋荻, side-room, 大哥 return, 还施水阁, and chest triggers"
    - "save scene and ensure asset bundle labels remain correct"
  test_plan:
    - "new game starts in 52_yanziwu"
    - "opening rewards are claimable exactly once"
    - "孟星魂 assignment flag persists"
    - "杭州/开封 route hint flags persist"
    - "chest rewards cannot duplicate"
    - "save/load preserves all opening flags"
```

## Implementation Checklist

1. Verify item ids for all opening rewards.
2. Verify or create safe event id allocation for opening triggers.
3. Decide first playable slice: likely `qqzj_protagonist_opening_arrival` plus `qqzj_protagonist_opening_qiudi_guard`.
4. Keep each numbered event file as a thin `JSHYL.QQZJ.Quest.Run(...)` dispatcher.
5. Implement reward idempotency flags before calling any reward API.
6. Add one NPC/trigger at a time and Unity smoke-load after each slice.
7. Manually verify no duplicate rewards after repeated interaction.
8. Manually verify save/load after each completed slice.
9. Do not mark this section implemented until all mandatory opening stages are in jshyl.
10. Do not mark this section verified until the full opening chain is playable end to end.

## Coverage Status

```text
inventory status: extracted for section "主角剧情：开局"
implementation status: not implemented
verification status: not verified
```
