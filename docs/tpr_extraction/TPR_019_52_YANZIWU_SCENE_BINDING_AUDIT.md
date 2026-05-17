# TPR-019 Scene Binding Audit: 52_yanziwu Opening

## Scope

Planning/audit only. No gameplay, Lua, config, scene, asset, battle, companion,
or engine files were changed.

Inputs reviewed:

```text
docs/tpr_extraction/TPR_017_OPENING_COVERAGE_CHECKPOINT.md
docs/tpr_extraction/TPR_018_OPENING_REWARD_ITEM_AUDIT.md
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
Assets/Mods/jshyl/Lua/**
```

Scene file status:

```text
Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity is text YAML.
All currently audited jshyl event bindings are interactive events, not enter events.
```

## 1. Existing Trigger / Event Inventory

| scene object | position | event target | interactive id | use item id | enter id | Lua file | current role |
|---|---|---|---:|---:|---:|---|---|
| `jshyl_murong_opening` | `{-13, 5.24, 23.5}` | 慕容秋荻 prefab/object | 5200 | -1 | -1 | `Lua/5200.lua` | opening chain dispatcher |
| `jshyl_shuanger_rest` | `{-20, 6.5, 30}` | 欧阳克婢女-style prefab/object, used as 双儿 | 5201 | -1 | -1 | `Lua/5201.lua` | 双儿 rest service |
| `jshyl_yanzi_treasure` | `{-30, 5.1, 27.4}` | `三万两宝箱` | 5202 | -1 | -1 | `Lua/5202.lua` | named silver chest dispatcher |
| `jshyl_azhu_hint` | `{-8.8, 6.5, 29}` | 欧阳克婢女-style prefab/object, used as 阿朱 | 5203 | -1 | -1 | `Lua/5203.lua` | 阿朱 杭州/pouch hint |
| `jshyl_abi_hint` | `{-20, 6.5, 27}` | 欧阳克婢女-style prefab/object, used as 阿碧 | 10000 | -1 | -1 | `Lua/10000.lua` | Phase 2 technical 阿碧 guidance slice |
| `jshyl_shijian_training` | `{-8.6, 5.5, 40.5}` | 侍剑 / 程英-style prefab/object | 5205 | -1 | -1 | `Lua/5205.lua` | named 侍剑 training dispatcher |

Scene evidence:

```text
52_yanziwu.unity:2433  m_Name: jshyl_shuanger_rest
52_yanziwu.unity:2467  m_InteractiveEventId: 5201

52_yanziwu.unity:5229  m_Name: jshyl_abi_hint
52_yanziwu.unity:5263  m_InteractiveEventId: 10000

52_yanziwu.unity:6607  m_Name: jshyl_yanzi_treasure
52_yanziwu.unity:6641  m_InteractiveEventId: 5202

52_yanziwu.unity:8104  m_Name: jshyl_azhu_hint
52_yanziwu.unity:8138  m_InteractiveEventId: 5203

52_yanziwu.unity:9239  m_Name: jshyl_murong_opening
52_yanziwu.unity:9273  m_InteractiveEventId: 5200

52_yanziwu.unity:13377 m_Name: jshyl_shijian_training
52_yanziwu.unity:13411 m_InteractiveEventId: 5205
```

## 2. Triggers Already Claimed

| event id | claimed by | status |
|---:|---|---|
| 5200 | `qqzj_protagonist_opening_arrival` chain | claimed; already carries arrival, 秋荻, family briefing, and 大哥 return stand-in chain |
| 5201 | 双儿 rest ad hoc service | claimed; not yet a named QQZJ quest |
| 5202 | `qqzj_yanziwu_treasure_silver_chest` | claimed; named silver chest refactor complete |
| 5203 | 阿朱 hint | claimed but ad hoc; candidate for next small 水阁/阿朱 encounter refactor |
| 5205 | `qqzj_protagonist_opening_shijian_training` | claimed; named training refactor complete |
| 10000 | `qqzj_intro_abi_guidance` | claimed by technical validation slice; should not count as TPR coverage |

Unbound but existing Lua:

```text
Lua/5204.lua exists and contains 阿碧/水阁 hint dialogue, but the current
52_yanziwu scene scan found no object with m_InteractiveEventId: 5204 and no
object name that clearly binds it.
```

## 3. TPR Beats That Can Reuse Existing Triggers

| TPR beat | possible existing trigger | recommendation |
|---|---|---|
| 还施水阁 / 阿朱-双儿 encounter, dialogue-only | `jshyl_azhu_hint` / 5203 | Best no-scene-edit candidate. Refactor 5203 into a thin dispatcher for `qqzj_protagonist_opening_shuige_entry`, but document it as an interactive stand-in rather than true enter trigger. |
| 双儿 rest facility | `jshyl_shuanger_rest` / 5201 | Can be refactored later into a named service quest without scene edits. |
| Existing silver chest | `jshyl_yanzi_treasure` / 5202 | Already refactored; do not overload with full 水阁 rewards. |
| 侍剑 training | `jshyl_shijian_training` / 5205 | Already refactored; source-fidelity/battle details remain separate. |
| 阿碧 service or debug validation replacement | `jshyl_abi_hint` / 10000 | Technically available, but currently reserved for Phase 2 validation. Do not reuse for TPR content until a migration/replacement task is explicit. |

## 4. TPR Beats Requiring Scene Edits

Scene edits are required for source-faithful physical flow:

```text
1. True 还施水阁 entry trigger using m_EnterEventId or an interactable doorway.
2. 阿朱/双儿 forced encounter at the actual 水阁 entry.
3. Center-room chest reward object(s).
4. 阿碧-room four chest objects or four distinct trigger zones.
5. Physical 二叔 and 三叔 NPC interactions.
6. 大哥 return at the outward exit/world-access point.
7. Separate 双儿 room chest variants if the source expects multiple 30000 silver chests.
```

Current scene limitations:

```text
1. No bound event id 5204 was found.
2. No current jshyl object name clearly identifies 还施水阁 entry.
3. All audited jshyl bindings use m_InteractiveEventId, with m_EnterEventId = -1.
4. Existing 5202 is a single silver chest and should not be treated as full
   水阁宝箱 source coverage.
```

## 5. Recommended Next Implementation Slice

Recommended next gameplay slice:

```text
TPR-020A: refactor 5203 阿朱 hint into the first 水阁 entry stand-in.
```

Reason:

```text
5203 is already scene-bound to an 阿朱 interaction and can be changed without
scene edits. It is the smallest safe path toward `qqzj_protagonist_opening_shuige_entry`.
```

Scope recommendation:

```text
1. Convert Lua/5203.lua to a thin dispatcher.
2. Add named quest `qqzj_protagonist_opening_shuige_entry`.
3. Implement dialogue and flags only.
4. Do not charge -3000 silver until money removal behavior is verified.
5. Do not grant 水阁/chest rewards.
6. Keep 5204 reserved for a future true entry trigger or 阿碧-side service after scene edits.
```

Why not use 5204 now:

```text
Lua/5204.lua exists, but the scene does not currently bind event id 5204.
Using it now would require a Unity scene edit, which is outside the next small
no-scene-edit implementation slice.
```

## 6. Proposed Event Id / Quest Id / Flags

No-scene-edit implementation:

```text
event id: 5203
event file: Assets/Mods/jshyl/Lua/5203.lua
scene object: jshyl_azhu_hint
quest id: qqzj_protagonist_opening_shuige_entry
```

Proposed flags:

```text
qqzj_protagonist_opening_shuige_entry_started
qqzj_protagonist_opening_shuige_entry_dialogue_seen
qqzj_protagonist_opening_shuige_entry_silver_cost_deferred
qqzj_protagonist_opening_shuige_entry_completed
```

Future source-faithful scene-edit implementation:

```text
event id: 5204 or a new 52xx id
scene object: new/verified 还施水阁 entry trigger
quest id: qqzj_protagonist_opening_shuige_entry
additional flag: qqzj_protagonist_opening_shuige_entry_silver_paid
```

The same quest id can be reused later if migration logic treats the 5203
stand-in as the same narrative stage. If a future true-entry trigger needs a
separate state, use a suffix such as `_true_entry_bound` rather than duplicating
the reward/progression flags.

## 7. Risks

```text
1. Reusing 5203 is not physically source-faithful; it is 阿朱 interaction, not a
   doorway/enter trigger.
2. Charging -3000 silver through AddItem(174, -3000) is unverified and should be
   deferred or separately tested.
3. Reusing 10000 would blur the Phase 2 technical validation slice with TPR
   coverage; avoid unless a migration task explicitly retires that slice.
4. Full 水阁宝箱 implementation needs both scene edits and item config creation.
5. The scene file references prefab-stripped GameObjects, so some NPC target
   names are inferred from trigger names and prefab/model guids rather than all
   being visible as clear inline names.
6. Existing colliders are non-trigger BoxColliders with interactive events, so
   changing to enter behavior should be done in Unity and verified in play mode.
```

## 8. Manual Unity Verification Steps

For TPR-020A no-scene-edit implementation:

```text
1. Open jshyl and start a new game into 52_yanziwu.
2. Interact with 慕容秋荻 until the current opening chain reaches 大哥 return.
3. Interact with 阿朱 / jshyl_azhu_hint.
4. Confirm the 水阁 entry dialogue appears through 5203.
5. Repeat interaction and confirm already-seen dialogue.
6. Save, reload, and confirm `qqzj_protagonist_opening_shuige_entry_*` flags persist.
7. Confirm no chest rewards are granted.
8. Confirm no silver is charged until the money API decision is made.
```

For future scene-edit implementation:

```text
1. Add or identify a 还施水阁 entry object in Unity.
2. Bind its interactive or enter event to 5204/new 52xx id.
3. Save 52_yanziwu scene.
4. Verify AssetBundle labels / mod packaging remain correct.
5. Enter the area in play mode and confirm the event fires exactly once or
   repeats according to the quest flags.
6. Verify save/load and repeated entry behavior.
```
