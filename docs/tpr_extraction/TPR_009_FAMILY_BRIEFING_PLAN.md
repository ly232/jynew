# TPR-009 Plan: 二叔/三叔 Briefing And 杭州/开封 Hooks

## Scope

Planning only. No gameplay, Lua, scene, config, map, or engine files are modified.

Source:

```text
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md
Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
```

Target extraction beat:

```text
qqzj_protagonist_opening_family_briefing
```

## Current Implementation Context

Already implemented:

```text
qqzj_protagonist_opening_arrival
qqzj_protagonist_opening_qiudi_guard
qqzj_protagonist_opening_qiudi_guard_reward_claimed
```

Existing entry point:

```text
event id: 5200
event file: Assets/Mods/jshyl/Lua/5200.lua
scene trigger: jshyl_murong_opening
quest chain entry: JSHYL.QQZJ.Quest.Run("qqzj_protagonist_opening_arrival")
```

## Inspection Findings

### Scene / NPC Availability

Current named jshyl triggers in `52_yanziwu`:

```text
jshyl_shuanger_rest -> event 5201
jshyl_abi_hint -> event 10000
jshyl_yanzi_treasure -> event 5202
jshyl_azhu_hint -> event 5203
jshyl_murong_opening -> event 5200
jshyl_shijian_training -> event 5205
```

No named `二叔` or `三叔` trigger was found in `52_yanziwu`.

Conclusion:

```text
Actual 二叔/三叔 NPC interactions require future scene work.
For the next smallest slice, avoid scene edits and implement only a briefing
handoff/hook stage through the existing 5200 chain.
```

### Map / Config Availability

`Assets/Mods/jshyl/Configs/Lua/MapConfig.lua` currently contains:

```text
燕子坞 / 52_yanziwu
大地图 / 1000_daditu
many base JYX2 maps
```

Search result:

```text
杭州: no map row found
开封: no map row found
```

Conclusion:

```text
杭州/开封 hooks can be represented as story flags now.
Do not implement map travel, route unlocks, or teleport behavior until the
target maps/config rows are added or mapped to approved existing scenes.
```

## 1. Recommended Next Quest ID

```text
qqzj_protagonist_opening_family_briefing
```

This matches the extraction spec and should remain the durable quest id even if the first implementation is only a lightweight handoff.

## 2. Recommended Event ID / File

Recommended for TPR-009A:

```text
reuse event id: 5200
reuse event file: Assets/Mods/jshyl/Lua/5200.lua
```

Reason:

```text
There are no existing 二叔/三叔 scene triggers.
Reusing 5200 keeps scope small and avoids scene edits.
The existing 5200 chain can dispatch:
arrival -> qiudi_guard -> family_briefing
```

Future real NPC implementation:

```text
event id 5206 -> 二叔 briefing trigger
event id 5207 -> 三叔 briefing trigger
```

Do not create these event files until scene triggers/NPC placement are explicitly in scope.

## 3. Required NPC Assumptions

For the next smallest implementation:

```text
No real 二叔/三叔 NPCs are required.
The briefing is represented as a staged story handoff from the existing 慕容秋荻 trigger.
```

For later full implementation:

```text
二叔 and 三叔 need role ids, models, positions, and scene triggers.
The extraction assumes they are in a nearby/side room, but that room mapping is not verified.
```

## 4. Required Map / Config Verification

Already verified:

```text
杭州 is not present as a jshyl map name in MapConfig.lua.
开封 is not present as a jshyl map name in MapConfig.lua.
```

Before travel or route content:

```text
1. Decide whether to add new maps for 杭州/开封.
2. Or map those hooks to existing placeholder/base scenes.
3. Add/update configs only in a task that explicitly allows config edits.
4. Verify world map enter/leave behavior separately.
```

For TPR-009A:

```text
Set hook flags only. Do not enter or unlock maps.
```

## 5. Flags

Recommended flags for TPR-009A:

```text
qqzj_protagonist_opening_family_briefing_started
qqzj_protagonist_opening_family_briefing_intro_seen
qqzj_protagonist_opening_family_briefing_hangzhou_hook_set
qqzj_protagonist_opening_family_briefing_kaifeng_hook_set
qqzj_protagonist_opening_family_briefing_completed
```

Deferred reward/tool flag:

```text
qqzj_protagonist_opening_family_briefing_tools_claimed
```

Do not set the deferred reward/tool flag until item ids are verified and rewards are actually granted.

Prerequisite:

```text
qqzj_protagonist_opening_qiudi_guard_completed
```

Optional prerequisite if reward order should be stricter:

```text
qqzj_protagonist_opening_qiudi_guard_reward_claimed
```

Recommendation:

```text
Require qiudi_guard_completed only. The reward flag may already be claimed in
current flow, but the story handoff should not be blocked if reward migration
logic changes later.
```

## 6. What Can Be Implemented Now Vs Deferred

Can be implemented now:

```text
1. Add a named quest handler for qqzj_protagonist_opening_family_briefing.
2. Chain it after qqzj_protagonist_opening_qiudi_guard completion from event 5200.
3. Show concise briefing dialogue summarizing that 二叔/三叔 will explain the wider Jianghu routes.
4. Set 杭州/开封 hook flags.
5. Mark the briefing stage completed.
6. Repeat interaction branches to already-briefed dialogue.
```

Must be deferred:

```text
1. Real 二叔/三叔 NPC placement.
2. New scene event ids 5206/5207.
3. Tool rewards: 狼牙燕翎, 秦皇照骨镜, 洛阳铲.
4. 杭州/开封 map travel, route unlocks, or teleport behavior.
5. Any config table edits.
```

## 7. Risks

```text
1. Reusing 5200 means the first implementation is a story handoff, not a
   faithful physical side-room 二叔/三叔 interaction.

2. If later scene work adds real 二叔/三叔 triggers, the 5200 briefing handler
   may need to become a pointer/hint instead of the full briefing.

3. 杭州/开封 hook flags could be mistaken for map availability. Document clearly
   that they are narrative hooks only until maps/configs exist.

4. Tool rewards are not safe yet because item ids are still unverified.

5. The current opening chain already uses 5200 for multiple stages. Keep repeat
   dialogue clear so players understand what has already happened.
```

## 8. Acceptance Criteria

For TPR-009A implementation:

```text
1. No scene edits.
2. No config edits.
3. No engine C# changes.
4. No new maps.
5. No new battles.
6. No new companions.
7. 5200.lua remains a thin dispatcher.
8. Existing arrival, qiudi_guard, and abi guidance behavior remains intact.
9. After qqzj_protagonist_opening_qiudi_guard_completed, interacting with 5200
   triggers qqzj_protagonist_opening_family_briefing.
10. The following flags are set and persist:
    - qqzj_protagonist_opening_family_briefing_started
    - qqzj_protagonist_opening_family_briefing_intro_seen
    - qqzj_protagonist_opening_family_briefing_hangzhou_hook_set
    - qqzj_protagonist_opening_family_briefing_kaifeng_hook_set
    - qqzj_protagonist_opening_family_briefing_completed
11. Repeat interaction shows already-briefed dialogue.
12. Unity smoke-load passes.
13. Manual test confirms no Lua errors and no duplicate rewards.
```

## Recommended Next Prompt

```text
Proceed with TPR-009A: implement qqzj_protagonist_opening_family_briefing as a flags/dialogue-only handoff via existing 5200.lua. Do not add maps, NPCs, rewards, companions, or config changes.
```
