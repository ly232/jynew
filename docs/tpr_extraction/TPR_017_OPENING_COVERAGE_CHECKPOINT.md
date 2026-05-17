# TPR-017 Coverage Checkpoint: 主角剧情：开局

## Scope

Documentation checkpoint only. No gameplay, Lua, config, scene, asset, battle,
or engine files were changed.

Inputs reviewed:

```text
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
docs/tpr_extraction/TPR_013_OPENING_CHAIN_AUDIT.md
docs/tpr_extraction/TPR_015_5202_TREASURE_FLOW_AUDIT.md
docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md
docs/tpr_extraction/COVERAGE_TRACKER.md
```

## 1. Now Implemented

The following opening pieces are represented in jshyl with named QQZJ quest
state or thin event dispatchers:

| beat | implementation status | notes |
|---|---|---|
| 燕子坞 arrival | implemented | `qqzj_protagonist_opening_arrival` plays the opening setup and grants 银两 id 174 x10000 once. |
| 秋荻托付 / 孟星魂 assignment | implemented as dialogue + flags | `qqzj_protagonist_opening_qiudi_guard` sets 孟星魂 assignment state but does not add a companion. |
| 秋荻 verified reward | implemented exact partial reward | 九转熊蛇丸 id 16 x10 is granted once; 司南针 is intentionally deferred. |
| 二叔/三叔 briefing hooks | implemented as narrative hooks | 杭州 and 开封 hook flags are set, but maps/tools are not unlocked. |
| 大哥 return | implemented as dialogue + partial reward | Dialogue is playable; 玉真散 id 5 x20 and 九转灵宝丸 id 14 x20 are granted once. |
| 侍剑 training trigger | implemented as architecture refactor | `5205.lua` dispatches to `qqzj_protagonist_opening_shijian_training`, preserving battle 145 and the existing 银两 id 174 x500 reward. |
| Existing 燕子坞 silver chest | implemented as architecture refactor | `5202.lua` dispatches to `qqzj_yanziwu_treasure_silver_chest`, preserving 银两 id 174 x30000 and legacy flag migration. |

## 2. Partially Implemented

These beats have some playable representation but are not source-complete:

| area | partial state | missing for source fidelity |
|---|---|---|
| 秋荻托付 | assignment/reward flags exist | real 孟星魂 companion join and exact 司南针 item are missing. |
| 二叔/三叔 | route hooks are flags only | physical 二叔/三叔 NPCs, tool rewards, and actual 杭州/开封 route unlock behavior are missing. |
| 大哥 return | dialogue and two verified medicines exist | three listed medicines are missing and the event is not yet bound to a physical exit/return trigger. |
| 侍剑 / 十二金钗 training | battle 145 and idempotent reward are preserved | source fidelity of battle 145 and 主角武常 +20 effect are unverified. |
| 燕子坞 chest | one existing silver chest is named and idempotent | this is not full 水阁宝箱 or 还施水阁 reward coverage. |

## 3. Blocked By Item ID Verification

The next reward-faithful slices need exact item ids or an explicit placeholder
decision before implementation:

| source beat | unresolved items |
|---|---|
| 秋荻托付 | 司南针 |
| 二叔/三叔 | 狼牙燕翎, 秦皇照骨镜, 洛阳铲 |
| 大哥 return | 金创药, 少阳丹, 人参养荣丸 |
| 还施水阁 center room | 海月清辉, 九霄环佩, 天书竹简 |
| 阿碧 room chests | 朱颜碧, 缀玉华裳, 湖畔舞剑图, 各门派暗器 list |
| 慕容秋荻 service | 明玉丹 |

Already verified and implemented:

```text
九转熊蛇丸 id 16
玉真散 id 5
九转灵宝丸 id 14
银两 id 174
```

## 4. Blocked By Scene Edits

The following source-faithful beats need scene trigger placement or binding in
`52_yanziwu` before they should be implemented as gameplay:

```text
1. Physical 二叔 and 三叔 interactions.
2. 大哥 return at the correct exit/world-access point.
3. 还施水阁 entry trigger.
4. 阿朱/双儿 forced encounter at 还施水阁.
5. Center-room reward containers.
6. 阿碧-room four chest triggers.
7. Properly placed 双儿 rest/chest room facilities.
```

Lua-only stand-ins can continue to use existing dispatch chains, but they should
remain marked partial until the physical scene flow matches the source.

## 5. Blocked By Map / Config Availability

| dependency | current blocker |
|---|---|
| 杭州 | Hook flag exists, but map/config availability and transition target are unverified. |
| 开封 | Hook flag exists, but map/config availability and transition target are unverified. |
| 还施水阁 | Treated as an area inside `52_yanziwu`; exact scene objects/triggers still need Unity inspection. |
| 侍剑 training battle | Battle id 145 exists and runs from current Lua, but enemy/source fidelity remains unverified. |
| Money cost behavior | Future -3000 silver cost needs API verification before implementing `qqzj_protagonist_opening_shuige_entry`. |

## 6. Recommended Next 3 Tasks

### 1. TPR-018: Item Audit For 还施水阁 And Family Tools

Planning/read-only task.

Verify exact item ids for:

```text
司南针
狼牙燕翎
秦皇照骨镜
洛阳铲
金创药
少阳丹
人参养荣丸
海月清辉
九霄环佩
天书竹简
朱颜碧
缀玉华裳
湖畔舞剑图
明玉丹
```

Acceptance criteria:

```text
1. Each item is marked found or missing.
2. Evidence points to config file/row.
3. Missing items have a recommended placeholder/create/defer strategy.
4. No gameplay files are modified.
```

### 2. TPR-019: Scene Binding Audit For 52_yanziwu Opening

Planning/read-only task unless explicitly expanded.

Audit existing scene/event bindings for:

```text
还施水阁 entry
center-room chest
阿碧-room chests
双儿 rest/chest room
二叔/三叔 positions
大哥 return / exit trigger
```

Acceptance criteria:

```text
1. Existing event ids are listed.
2. Missing required triggers are listed.
3. Recommended event ids and Lua files are proposed.
4. Required Unity manual steps are documented.
```

### 3. TPR-020: Implement 还施水阁 Entry As The Next Small Gameplay Slice

Gameplay task after TPR-018 and TPR-019.

Recommended quest id:

```text
qqzj_protagonist_opening_shuige_entry
```

Proposed flags:

```text
qqzj_protagonist_opening_shuige_entry_started
qqzj_protagonist_opening_shuige_entry_dialogue_seen
qqzj_protagonist_opening_shuige_entry_silver_paid
qqzj_protagonist_opening_shuige_entry_completed
```

Acceptance criteria:

```text
1. Uses a thin event dispatcher.
2. Runs the 阿朱/双儿 entry dialogue.
3. Charges or defers the -3000 silver cost based on verified money API behavior.
4. Repeated interaction branches correctly.
5. Save/load preserves all flags.
6. Does not implement chest rewards yet.
```

## 7. Coverage Status Recommendation

`主角剧情：开局` should remain `partially_implemented`.

It should not move to `implemented` because mandatory source beats are still
missing or only represented as partial stand-ins:

```text
1. 还施水阁 entry is not implemented.
2. 水阁/阿碧 room source chest rewards are not implemented.
3. Several source reward item ids remain unresolved.
4. 杭州/开封 hooks do not yet unlock real route/map behavior.
5. 孟星魂 is not a real companion.
6. 侍剑 training battle/source effect still needs verification.
7. No end-to-end Unity verification has been recorded for the full opening chain.
```

The tracker currently has only page-level and section-level statuses. Keep the
section status as `partially_implemented`, and continue recording finer-grained
progress through individual TPR backlog rows until all mandatory opening beats
are implemented and verified.
