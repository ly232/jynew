# TPR-021 Plan: True 还施水阁 Entry

## Scope

Planning only. No Lua, scene, config, asset, battle, companion, or engine files
were changed.

Inputs reviewed:

```text
docs/tpr_extraction/TPR_019_52_YANZIWU_SCENE_BINDING_AUDIT.md
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
docs/tpr_extraction/TPR_018_OPENING_REWARD_ITEM_AUDIT.md
Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
Assets/Mods/jshyl/Lua/**
Assets/Mods/jshyl/Configs/**
```

## 1. Existing 还施水阁 Object / Area

No clearly named `还施水阁`, `水阁`, or `shuige` scene object was found in
`52_yanziwu.unity`.

Relevant scene evidence:

```text
52_yanziwu.unity:6987  m_Name: Leave
52_yanziwu.unity:7220  m_Name: Door
52_yanziwu.unity:8104  m_Name: jshyl_azhu_hint
52_yanziwu.unity:8138  m_InteractiveEventId: 5203
52_yanziwu.unity:19937 m_Name: Triggers
```

There are several generic numeric objects with `m_InteractiveEventId: -1`, and
there is a static `Door` group, but the YAML alone does not prove that any of
them is the intended 还施水阁 entrance. These should be inspected visually in
Unity before reuse.

Conclusion:

```text
The scene has door/trigger infrastructure, but no source-faithful 还施水阁 entry
binding exists yet.
```

## 2. Existing Trigger Reuse

Current claimed bindings:

| scene object | event id | current role | reuse decision |
|---|---:|---|---|
| `jshyl_murong_opening` | 5200 | opening chain | do not reuse |
| `jshyl_shuanger_rest` | 5201 | 双儿 rest service | do not reuse |
| `jshyl_yanzi_treasure` | 5202 | silver chest | do not reuse |
| `jshyl_azhu_hint` | 5203 | 还施水阁 hint stand-in | keep as hint only |
| `jshyl_shijian_training` | 5205 | 侍剑 training | do not reuse |
| `jshyl_abi_hint` | 10000 | Phase 2 validation slice | do not reuse |

`5204.lua` exists, but no scene object is currently bound to event id `5204`.
This makes `5204` the best reserved id for a future true entry trigger.

Recommendation:

```text
Do not repurpose an existing claimed trigger. Add one dedicated entry trigger
under the scene's Triggers root.
```

## 3. Proposed New Trigger

Recommended object:

```text
object name: jshyl_shuige_entry
parent: Triggers
event id: 5204
event file: Assets/Mods/jshyl/Lua/5204.lua
```

Placement:

```text
Place it at the visually confirmed 还施水阁 doorway or threshold in Unity.
If the current map does not have a readable threshold, place it as a temporary
interactive marker near the 阿朱/阿碧 water-pavilion hint area and document that
the final spatial placement still needs map art/layout work.
```

The existing `5204.lua` ad hoc 阿碧 line should be converted to a thin quest
dispatcher during implementation, with the replacement documented.

## 4. Entry Behavior Type

Use a dialogue gate first.

Reasoning:

```text
1. No separate 还施水阁 map has been verified.
2. Existing opening triggers in 52_yanziwu use m_InteractiveEventId, not
   m_EnterEventId.
3. TPR source fidelity needs the entry encounter before 水阁 chest rewards.
4. Silver removal and full chest rewards still need separate verification/config
   work.
```

Recommended first scene-edit slice:

```text
interactive trigger -> dialogue gate -> set entry flags -> repeat-state branch
```

Do not implement these yet in the first true-entry slice:

```text
teleport
door unlock
object visibility change
-3000 silver charge
水阁宝箱 rewards
```

These can be layered later after the entry trigger itself is verified.

## 5. Required Flags

Existing hint flags stay intact:

```text
qqzj_protagonist_opening_shuige_entry_hint_started
qqzj_protagonist_opening_shuige_entry_hint_dialogue_seen
qqzj_protagonist_opening_shuige_entry_hint_completed
```

New true-entry flags:

```text
qqzj_protagonist_opening_shuige_entry_started
qqzj_protagonist_opening_shuige_entry_dialogue_seen
qqzj_protagonist_opening_shuige_entry_silver_cost_deferred
qqzj_protagonist_opening_shuige_entry_completed
```

Future source-faithful cost flag:

```text
qqzj_protagonist_opening_shuige_entry_silver_paid
```

Gate:

```text
Require qqzj_protagonist_opening_brother_return_completed.
Prefer also checking qqzj_protagonist_opening_shuige_entry_hint_completed when
the player has seen the 5203 hint, but do not hard-block old saves if the true
entry is added later and the broader opening chain is already complete.
```

## 6. Required Lua Quest Id

```text
quest id: qqzj_protagonist_opening_shuige_entry
event file: Assets/Mods/jshyl/Lua/5204.lua
dispatcher: JSHYL.QQZJ.Quest.Run("qqzj_protagonist_opening_shuige_entry")
quest helper: Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
```

This should remain separate from the existing hint quest:

```text
qqzj_protagonist_opening_shuige_entry_hint
```

## 7. AssetBundle / Scene Save Implications

The implementation slice will modify:

```text
Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
```

Implications:

```text
1. The scene must be edited and saved in Unity, not by guessing large YAML
   changes by hand.
2. The new trigger should reuse the same GameEvent component pattern as existing
   jshyl triggers.
3. The scene is already part of the jshyl map asset set; adding a GameObject to
   the scene should not require a new external AssetBundle label.
4. If a new prefab/model/visual marker is introduced later, that asset must live
   under Assets/Mods/jshyl and be included in the MOD packaging model.
5. A simple invisible/interactable trigger is preferred for the first slice to
   keep AssetBundle impact limited to the saved scene.
```

## 8. Manual Unity Verification Steps

For the next implementation:

```text
1. Open Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity in Unity.
2. Visually identify the intended 还施水阁 doorway/threshold.
3. Add or duplicate a small existing jshyl GameEvent trigger.
4. Name it jshyl_shuige_entry.
5. Set m_InteractiveEventId to 5204.
6. Keep m_EnterEventId at -1 for the first slice unless playmode testing proves
   enter-trigger behavior is needed.
7. Save the scene.
8. Start jshyl, reach the opening state after 大哥 return / 阿朱 hint.
9. Interact with jshyl_shuige_entry.
10. Confirm the new entry dialogue appears.
11. Repeat interaction and confirm the already-entered branch.
12. Save/load and confirm the entry flags persist.
13. Confirm no silver is charged and no 水阁宝箱 rewards are granted.
```

## 9. Risks

| risk | mitigation |
|---|---|
| Scene YAML does not reveal exact spatial intent | Place the trigger visually in Unity and review in play mode |
| Accidentally reusing a claimed trigger blurs quest responsibilities | Use a new object `jshyl_shuige_entry` and event id `5204` |
| `m_EnterEventId` may fire unexpectedly or repeatedly | Use `m_InteractiveEventId` for the first slice |
| Replacing old `5204.lua` changes ad hoc 阿碧 text | Convert it to a dispatcher and document the replacement |
| Trigger collider could block movement | Duplicate an existing working jshyl interactive trigger pattern and verify movement |
| Full source fidelity still requires money and item work | Defer `silver_paid` and 水阁宝箱 rewards to later audited slices |
| Scene save can create noisy Unity diffs | Restrict the edit to one trigger object and review `git diff` carefully |

## 10. Recommended Implementation Prompt

```text
Proceed with TPR-022: implement true 还施水阁 entry trigger.

Read:
docs/tpr_extraction/TPR_021_SHUIGE_TRUE_ENTRY_PLAN.md
docs/tpr_extraction/extractions/zhujuqinqing_opening.md

Allowed:
- Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
- Assets/Mods/jshyl/Lua/5204.lua
- Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- config edits
- new maps
- new items
- battles
- companions
- engine C#

Requirements:
1. Add one dedicated scene trigger named jshyl_shuige_entry under Triggers.
2. Bind it to interactive event id 5204.
3. Convert 5204.lua into a thin dispatcher:
   JSHYL.QQZJ.Quest.Run("qqzj_protagonist_opening_shuige_entry")
4. Add quest qqzj_protagonist_opening_shuige_entry.
5. Gate after qqzj_protagonist_opening_brother_return_completed, with optional
   compatibility for saves that already completed the 5203 hint.
6. Set flags:
   - qqzj_protagonist_opening_shuige_entry_started
   - qqzj_protagonist_opening_shuige_entry_dialogue_seen
   - qqzj_protagonist_opening_shuige_entry_silver_cost_deferred
   - qqzj_protagonist_opening_shuige_entry_completed
7. Do not charge silver.
8. Do not grant chest rewards.
9. Repeated interaction must branch correctly.
10. Update docs/backlog after implementation.
```
