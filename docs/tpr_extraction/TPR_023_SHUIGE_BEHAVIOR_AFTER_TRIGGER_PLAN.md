# TPR-023 Plan: 还施水阁 Behavior After 5204 Trigger

## Scope

Planning only. No Lua, scene, config, asset, gameplay, or engine files were
changed.

Inputs reviewed:

```text
docs/tpr_extraction/TPR_021_SHUIGE_TRUE_ENTRY_PLAN.md
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
```

Current baseline:

```text
scene object: jshyl_shuige_entry
event id: 5204
quest id: qqzj_protagonist_opening_shuige_entry
current behavior: dialogue/flags only
current flags:
- qqzj_protagonist_opening_shuige_entry_started
- qqzj_protagonist_opening_shuige_entry_unlocked
- qqzj_protagonist_opening_shuige_entry_completed
```

## 1. Recommended Implementation Model

Recommended next model:

```text
same-scene entry gate -> unlock a Shuige interior zone marker -> defer teleport
```

This means the next smallest slice should keep the player inside
`52_yanziwu`, reuse the dedicated `jshyl_shuige_entry` trigger, and add only a
clear "entry accepted / water-pavilion access opened" state. It should not
create a separate map yet.

Why not teleport first:

```text
1. No separate 还施水阁 map or config row has been verified.
2. The source beat immediately after entry is still tied to 阿朱/双儿,
   payment, and nearby 水阁 rewards, which can be represented inside the
   current 燕子坞 map before a separate room map exists.
3. A premature scene transition would require map config, spawn points,
   return transport, AssetBundle labels, and save/load path testing.
```

Why not stay dialogue-only forever:

```text
TPR-022 already proved the dedicated trigger can exist. The next source-faithful
step should make that trigger change the physical/interactive state of the
燕子坞 scene, even if that state is still minimal.
```

Preferred staged model:

| stage | model | purpose |
|---|---|---|
| TPR-024 | same-scene door/zone unlock | mark ShuiGe as accessible and optionally reveal/enable one placeholder interior marker |
| later | same-scene chest trigger(s) | implement 水阁 rewards after item ids are verified |
| later | optional separate map | only if `52_yanziwu` cannot cleanly hold the interior flow |

## 2. Required Existing APIs

For the next smallest slice:

| need | existing surface | status |
|---|---|---|
| dispatch event 5204 | numbered Lua file calls `JSHYL.QQZJ.Quest.Run(...)` | already used |
| persistent progress | `JSHYL.QQZJ.Flags.GetBool/SetBool` | already used |
| dialogue | `JSHYL.QQZJ.Dialogue.Talk` | already used |
| object state toggle | `JSHYL.QQZJ.Scene.Replace(path, active)` or direct existing jynew scene APIs | needs implementation verification |
| one-time scene binding | `JSHYL.QQZJ.Scene.BindOnce(flagKey, callback)` | available helper, not yet used for Shuige |

Teleport-specific APIs should be deferred. The current scene has a `Leave`
transport object, but using transport behavior for 还施水阁 would require a
verified target map id, spawn/trigger name, return path, and map config row.

## 3. Required Scene Objects Or New Objects

Required for next slice:

```text
existing:
- Level/Triggers/jshyl_shuige_entry

new or verified:
- Level/Triggers/jshyl_shuige_inner_marker
```

Recommended object behavior:

```text
jshyl_shuige_inner_marker should be an interactable same-scene marker, not a
teleport. It can represent the player having stepped into the water pavilion
area and can later dispatch to qqzj_protagonist_opening_shuige_rewards or a
small pre-reward dialogue.
```

If scene editing is allowed in the implementation slice, create the marker under
`Level/Triggers` and leave it disabled or inert until the 5204 entry quest
unlocks it. If object toggling via Lua is not reliable, create it active but
gate all behavior through flags.

Do not reuse:

```text
jshyl_azhu_hint
jshyl_yanzi_treasure
jshyl_shijian_training
jshyl_abi_hint / 10000
```

## 4. New Map / Config Row

No new map/config row should be required for the next slice.

Defer a separate 还施水阁 map until all of these are true:

```text
1. The current same-scene flow is too cramped or visually confusing.
2. A dedicated map asset exists or is explicitly approved for creation.
3. MapConfig / scene asset / AssetBundle label requirements are scoped.
4. Return transport back to 52_yanziwu is specified and tested.
5. Save/load from inside the room map is part of acceptance criteria.
```

Current recommendation:

```text
Keep 还施水阁 behavior inside 52_yanziwu for now.
```

## 5. Dependency On Chest Reward Item IDs

Do not block the next behavior slice on final chest reward item ids.

Reason:

```text
The next smallest source-fidelity step is spatial/progression behavior, not
reward payout. TPR-018 shows most named 水阁 rewards are still missing or
unverified, but the entry state itself can progress safely without granting
items.
```

What can proceed now:

```text
- same-scene entry accepted
- interior marker unlocked
- "整理物品" / preparation dialogue
- flags that make later chest triggers available
```

What must wait:

```text
- 海月清辉
- 九霄环佩
- 天书竹简
- 朱颜碧
- 缀玉华裳
- 湖畔舞剑图
- full dark-weapon bundle
- source-faithful 水阁宝箱 payout
```

## 6. Proposed Quest / Event / Flags

Reuse the current entry quest for entry state:

```text
event id: 5204
event file: Assets/Mods/jshyl/Lua/5204.lua
quest id: qqzj_protagonist_opening_shuige_entry
scene object: jshyl_shuige_entry
```

Add a separate interior marker quest only if a new marker is created:

```text
event id: 5206
event file: Assets/Mods/jshyl/Lua/5206.lua
quest id: qqzj_protagonist_opening_shuige_inner
scene object: jshyl_shuige_inner_marker
```

Recommended new flags:

```text
qqzj_protagonist_opening_shuige_entry_inner_unlocked
qqzj_protagonist_opening_shuige_entry_preparation_seen

qqzj_protagonist_opening_shuige_inner_started
qqzj_protagonist_opening_shuige_inner_dialogue_seen
qqzj_protagonist_opening_shuige_inner_completed
```

Do not add yet:

```text
qqzj_protagonist_opening_shuige_entry_silver_paid
qqzj_protagonist_opening_shuige_rewards_center_claimed
qqzj_protagonist_opening_shuige_rewards_abi_chests_claimed
```

Those belong to the payment/reward slices.

## 7. Risks

| risk | mitigation |
|---|---|
| A same-scene marker may feel like another dialogue stand-in | Pair it with a physical scene object/location change or a clearly placed interior marker |
| Lua object visibility helpers may not match Unity scene hierarchy paths | First implementation should allow active marker + flag-gated behavior if toggling fails |
| Adding another event id can overload opening scene triggers | Use `5206` only for the interior marker and keep `5204` as the entry gate |
| Creating a separate map too early can break MOD launch/save paths | Defer map/config work until there is a proven need |
| Chest rewards are mostly unverified | Keep rewards out of TPR-024; plan an item/config slice first |
| Silver removal remains unverified | Do not charge `-3000` until money API behavior is tested |
| Manual scene placement may be inaccurate | Verify in Unity visually and adjust only `jshyl_shuige_entry` / `jshyl_shuige_inner_marker` |

## 8. Acceptance Criteria

For the recommended next implementation slice:

```text
1. Interacting with jshyl_shuige_entry after the hint opens ShuiGe access state.
2. The quest sets qqzj_protagonist_opening_shuige_entry_inner_unlocked.
3. A same-scene interior marker is present or the existing marker is visibly
   usable for the next stage.
4. Interacting repeatedly with 5204 branches to already-open dialogue.
5. No teleport occurs.
6. No item rewards are granted.
7. No silver is charged.
8. Save/load preserves the entry and interior-unlocked flags.
9. Existing 5200/5201/5202/5203/5205/10000 triggers continue to be bound.
10. Unity start-scene event Lua validation still passes.
```

## Recommended Implementation Prompt

```text
Proceed with TPR-024: unlock same-scene 还施水阁 interior marker.

Read:
docs/tpr_extraction/TPR_023_SHUIGE_BEHAVIOR_AFTER_TRIGGER_PLAN.md
docs/tpr_extraction/extractions/zhujuqinqing_opening.md

Allowed:
- Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity
- Assets/Mods/jshyl/Lua/5204.lua
- Assets/Mods/jshyl/Lua/5206.lua
- Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- config edits
- new maps
- item rewards
- chest rewards
- battles
- companions
- engine C#

Requirements:
1. Keep 5204 as the entry gate.
2. Add or bind one same-scene marker named jshyl_shuige_inner_marker.
3. Use event id 5206 for the marker only if a new interaction is needed.
4. Do not teleport.
5. Do not charge silver.
6. Do not grant rewards.
7. Set:
   - qqzj_protagonist_opening_shuige_entry_inner_unlocked
   - qqzj_protagonist_opening_shuige_entry_preparation_seen
8. If using 5206, add:
   - qqzj_protagonist_opening_shuige_inner_started
   - qqzj_protagonist_opening_shuige_inner_dialogue_seen
   - qqzj_protagonist_opening_shuige_inner_completed
9. Repeated interaction must branch correctly.
10. Update docs/backlog.
```
