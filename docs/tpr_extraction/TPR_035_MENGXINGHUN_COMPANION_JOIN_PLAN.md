# TPR-035 Plan: Meng Xinghun Companion Join

## Scope

Planning only. No gameplay, Lua, scene, config, asset, battle, companion, or
engine files should change in this task.

Inputs reviewed:

```text
docs/tpr_extraction/TPR_032_OPENING_CHECKPOINT_AFTER_SHUIGE_CHEST.md
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
Assets/Mods/jshyl/Configs/Lua/CharacterConfig.lua
Assets/Mods/jshyl/Lua/70.lua
Assets/Mods/jyx2/Lua/*.lua join/leave examples
Assets/Mods/jshyl/Models/孟星魂.asset
```

## 1. Existing CharacterConfig Status

`孟星魂` already exists in jshyl character config:

```text
Assets/Mods/jshyl/Configs/Lua/CharacterConfig.lua:381
{335,35,7,[[孟星魂]],0,18,7800,360,-1,-1,1,260,80,70,76,0,0,0,10,42,95,18,20,20,62,56,0,0,80,{{61,700},{57,500}},{-1},nil},
```

Important fields from the generated schema:

| field | value | note |
|---|---:|---|
| `Id` | `335` | recommended companion role id |
| `Pic` | `35` | existing portrait/head id reference |
| `Name` | `孟星魂` | exact source character name |
| `Sexual` | `0` | male |
| `Level` | `18` | already above starter level |
| `MaxHp` | `360` | moderate opening bodyguard durability |
| `MaxMp` | `260` | moderate |
| `Attack` | `80` | competent guard |
| `Qinggong` | `70` | mobile |
| `Defence` | `76` | moderate |
| `Skills` | `{{61,700},{57,500}}` | existing sword-oriented skill setup |
| `Items` | `{-1}` | no starting inventory payload |
| `LeaveStoryId` | `nil` | no leave event configured |

Conclusion: no new character id is needed for the first companion-join slice.
Use role id `335`.

## 2. If Missing In Another Environment

If a future branch lacks this row, reserve the same id:

```text
recommended id: 335
```

Reason: current jshyl content already references `335` in dialogue and model
assets. Reusing this id avoids breaking save flags, dialogue, and future scene
bindings.

## 3. Required Config Rows

For TPR-035A implementation of companion join, no config edits should be
required.

Existing required rows/assets:

| requirement | current state |
|---|---|
| `CharacterConfig` row | exists as id `335` |
| role name | `孟星魂` |
| skills | already present |
| leave story | absent; acceptable for first join slice if no leave behavior is added |
| model scriptable asset | `Assets/Mods/jshyl/Models/孟星魂.asset` exists |

Config changes that should be deferred:

```text
custom LeaveStoryId
stat tuning
new skills or equipment
custom portrait id
custom generated model/prefab
```

## 4. Portrait / Head Asset

`CharacterConfig.Pic` is `35`, so the role currently reuses an existing portrait
id.

Observed jshyl custom head assets:

```text
Assets/Mods/jshyl/BuildSource/head/320.png
Assets/Mods/jshyl/BuildSource/heads/.gitkeep
```

There is no custom `335.png` head asset in jshyl right now. That is acceptable
for the first join slice if base portrait id `35` resolves from existing
packaged/base content.

Recommended first implementation:

```text
do not add a new portrait
use existing Pic 35
verify in Unity party UI after Join(335)
```

If portrait rendering is wrong or missing, make a later asset-only task:

```text
TPR-035B: add or generate custom 孟星魂 portrait/head asset under
Assets/Mods/jshyl/BuildSource/heads/ or the repo's verified head path.
```

Note: historical docs require `BuildSource/heads/`, but this MOD also contains
legacy `BuildSource/head/320.png`. Do not add new head art until the current
ModSettings/head bundle convention is rechecked.

## 5. Model / Prefab Strategy

`Assets/Mods/jshyl/Models/孟星魂.asset` exists and points to a Unity view GUID:

```text
m_Name: "孟星魂"
View.m_AssetGUID: 9e507379e592bca47af0dd51b06b2928
```

Recommended first implementation:

```text
reuse existing Models/孟星魂.asset
do not create or generate a new model
do not edit prefab/model references
```

Fallback if the model is visually wrong:

1. Use the existing model as a placeholder for join/system validation.
2. File a later model-polish task to choose a better existing model or generate
   a new asset.
3. Do not block the companion join API slice on model polish.

## 6. Existing Join / Leave APIs

Observed existing Lua API patterns:

| API | observed source | purpose |
|---|---|---|
| `InTeam(roleId)` | `Assets/Mods/jshyl/Lua/70.lua`; many `jyx2` scripts | test whether role is already in party |
| `TeamIsFull()` | `Assets/Mods/jyx2/Lua/ka304.lua`; `ka476.lua` | prevent joining when party is full |
| `Join(roleId)` | `Assets/Mods/jshyl/Lua/70.lua`; many `jyx2` scripts | add role to player party |
| `Leave(roleId)` | many `jyx2` leave scripts | remove role from party |
| `AskJoin()` | base `jyx2` recruitment scripts | optional player choice, not required for mandatory bodyguard |
| `AllLeave()` | base `jyx2` scripts | mass party removal; not needed |

For 孟星魂, use:

```lua
if InTeam(335) == false then
    if TeamIsFull() then
        -- defer join
    else
        Join(335)
    end
end
```

Do not call `Leave(335)` in the first slice.

## 7. Quest / Event / Flags

Recommended quest id:

```text
qqzj_protagonist_opening_mengxinghun_join
```

Recommended event id:

```text
none new; invoke through existing 5200 opening chain
```

Reason: the source beat is a direct continuation of 秋荻托付. A separate quest
handler gives party-state flags their own boundary while preserving the existing
single opening interaction path.

Recommended flags:

```text
qqzj_protagonist_opening_mengxinghun_join_started
qqzj_protagonist_opening_mengxinghun_join_attempted
qqzj_protagonist_opening_mengxinghun_joined
qqzj_protagonist_opening_mengxinghun_join_team_full_deferred
qqzj_protagonist_opening_mengxinghun_join_completed
```

Existing assignment flag to preserve:

```text
qqzj_protagonist_opening_qiudi_guard_mengxinghun_assigned
```

Compatibility rule:

```text
if qiudi_guard_mengxinghun_assigned is true and InTeam(335) is false and
join_completed is false, repeated 5200 interaction should still attempt or
offer the join.
```

If `InTeam(335)` is already true, set `joined` and `completed` without calling
`Join(335)` again.

## 8. Attach To 秋荻 Quest Or Separate Quest?

Recommended implementation model:

```text
Create a separate quest handler:
qqzj_protagonist_opening_mengxinghun_join

Call it from the existing 5200 opening chain after:
qqzj_protagonist_opening_qiudi_guard_completed
```

Gate it after:

```text
qqzj_protagonist_opening_qiudi_guard_completed
qqzj_protagonist_opening_qiudi_guard_mengxinghun_assigned
```

Recommended ordering:

```text
arrival -> qiudi_guard -> mengxinghun_join -> family_briefing -> brother_return
```

Why not put all logic directly in `qqzj_protagonist_opening_qiudi_guard`:

```text
The guard quest already handles dialogue, medicine reward, tool reward, and
assignment flags. Party join state has different risks: team-full handling,
InTeam checks, save/load behavior, and possible later leave behavior. A
separate handler keeps that risk isolated while still using event 5200.
```

Recommended player choice:

```text
automatic join, not AskJoin
```

Reason: source framing is 秋荻 assigning a bodyguard, not a voluntary tavern
recruitment. If the team is full, show a deferred dialogue and retry on later
interaction.

## 9. Save / Load Risks

| risk | mitigation |
|---|---|
| Existing saves already completed 秋荻 before this slice | check `qiudi_guard_mengxinghun_assigned`; allow repeated 5200 interaction to run join quest |
| Party already includes role `335` from debug/old save | if `InTeam(335)` is true, set joined/completed flags without duplicate `Join` |
| Party is full | set `team_full_deferred`; do not set completed; allow retry |
| Role config is changed later | avoid new config edits in first slice; use existing role id 335 |
| Portrait/head missing | treat as visual QA issue; do not block join logic |
| Model/prefab visually wrong | use existing `Models/孟星魂.asset` first; defer polish |
| No leave story configured | do not implement leave behavior until a later companion management slice |
| 5200 chain advances past join | insert join quest between guard and briefing so old saves still get a retry point |

## 10. Acceptance Criteria

For the next implementation slice:

```text
1. Role id 335 joins the party exactly once after 秋荻 guard assignment.
2. If role 335 is already in team, flags are reconciled without duplicate join.
3. If team is full, the quest explains that 孟星魂 will wait and can be retried.
4. Existing saves with qiudi_guard completed can still get 孟星魂 on repeated 5200 interaction.
5. Save/load preserves joined/completed/deferred flags.
6. Family briefing and later opening chain still continue after join completion.
7. No config, scene, asset, battle, map, item, or engine changes are made.
8. No `Leave(335)` behavior is introduced.
```

Manual Unity verification:

```text
1. Start jshyl and trigger the 5200 opening chain.
2. Complete 秋荻 guard assignment.
3. Verify 孟星魂 joins the party through Join(335).
4. Open party/status UI and verify role name/avatar/model does not hard-error.
5. Save and reload.
6. Trigger 5200 again and verify no duplicate join or repeated reward loop.
7. If practical, test a full-team save and verify the deferred path can retry.
```

## Recommended Next Prompt

```text
Proceed with TPR-035A: implement 孟星魂 companion join.

Read:
docs/tpr_extraction/TPR_035_MENGXINGHUN_COMPANION_JOIN_PLAN.md

Allowed:
- Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- config edits
- scene edits
- asset edits
- new maps
- battles
- item rewards
- engine C#

Requirements:
1. Add named quest qqzj_protagonist_opening_mengxinghun_join.
2. Use existing role id 335.
3. Invoke it from the existing 5200 opening chain after qiudi guard completion and before family briefing.
4. Use InTeam(335), TeamIsFull(), and Join(335).
5. Add flags:
   - qqzj_protagonist_opening_mengxinghun_join_started
   - qqzj_protagonist_opening_mengxinghun_join_attempted
   - qqzj_protagonist_opening_mengxinghun_joined
   - qqzj_protagonist_opening_mengxinghun_join_team_full_deferred
   - qqzj_protagonist_opening_mengxinghun_join_completed
6. Preserve old-save compatibility for completed qiudi guard saves.
7. Do not implement leave behavior.
8. Preserve all prior rewards and opening progression.
```
