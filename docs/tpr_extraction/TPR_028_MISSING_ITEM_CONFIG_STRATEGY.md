# TPR-028 Plan: Missing Opening Item Config Strategy

## Scope

Planning only. No config, Lua, scene, gameplay, asset, battle, companion, or
engine files were changed.

Inputs reviewed:

```text
docs/tpr_extraction/TPR_018_OPENING_REWARD_ITEM_AUDIT.md
docs/tpr_extraction/TPR_027_SHUIGE_OPENING_COVERAGE_CHECKPOINT.md
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
Assets/Mods/jshyl/Configs/README.md
Assets/Mods/jshyl/Configs/物品.xlsx
Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua
```

## 1. Add New Items Now Or Defer?

Recommendation:

```text
Add a very small first batch now in TPR-029, then defer the rest.
```

Do not add every missing opening item in one pass. The next implementation
should introduce only exact item rows needed to unblock the already-playable
opening chain and the next ShuiGe reward slice.

Recommended TPR-029 first batch:

| priority | item | reason | gameplay use after item exists |
|---:|---|---|---|
| 1 | `司南针` | previously blocked 秋荻 reward; pure key/navigation item with no combat tuning risk | complete 秋荻 verified reward later |
| 2 | `狼牙燕翎` | family briefing tool reward; pure key item | unblock 二叔/三叔 tool reward later |
| 3 | `秦皇照骨镜` | family briefing tool reward; pure key item | unblock 二叔/三叔 tool reward later |
| 4 | `洛阳铲` | family briefing tool reward; exact item missing; do not silently use `铁铲` placeholder | unblock 二叔/三叔 tool reward later |
| 5 | `海月清辉` | first named ShuiGe center-room reward; likely collectible/equipment-like treasure but can start as inert key item | unblock first ShuiGe chest reward planning |

Defer until later:

```text
明玉丹
金创药
少阳丹
人参养荣丸
九霄环佩
天书竹简
朱颜碧
缀玉华裳
湖畔舞剑图
各门派暗器 exact bundle
```

Why defer these:

```text
1. Medicines require balancing AddHp/AddMp/AddMax/stat effects.
2. 明玉丹 is tied to a paid home-base service, not the next mandatory opening
   chest.
3. ShuiGe has multiple named rewards; adding one first proves the config and
   reward pipeline before filling the whole room.
4. 暗器 requires a source-faithful exact list or an explicit design decision.
```

## 2. Recommended Workflow For Introducing New Items

### Config Row

Primary file:

```text
Assets/Mods/jshyl/Configs/物品.xlsx
```

Generated runtime file:

```text
Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua
```

Do not hand-edit generated Lua. Follow the documented config workflow:

```text
1. Add rows to 物品.xlsx.
2. Regenerate config tables through Unity using the jshyl ModSetting asset's
   "生成配置表" action, or by starting the MOD in Editor if auto-generation runs.
3. Inspect generated ItemConfig.lua for the expected rows.
4. Commit 物品.xlsx and any generated Lua/meta changes produced by the official
   pipeline.
```

Current item table fields:

```text
Id
Name
Desc
Skill
EquipmentType
ItemType
AddHp
AddMaxHp
ChangePoisonLevel
AddTili
ChangeMPType
AddMp
AddMaxMp
Attack
Qinggong
Defence
Heal
UsePoison
DePoison
AntiPoison
Quanzhang
Yujian
Shuadao
Qimen
Anqi
Wuxuechangshi
AddPinde
Zuoyouhubo
AttackPoison
OnlySuitableRole
NeedMPType
ConditionMp
ConditionAttack
ConditionQinggong
ConditionPoison
ConditionHeal
ConditionDePoison
ConditionQuanzhang
ConditionYujian
ConditionShuadao
ConditionQimen
ConditionAnqi
ConditionIQ
NeedExp
NeedCastration
GenerateItemNeedExp
GenerateItemNeedCost
GenerateItems
```

Recommended id reservation:

```text
205-229: TPR opening/core tools and ShuiGe rewards
230-249: TPR opening medicines/services
250-279: future route-specific early reward items
```

Do not reuse:

```text
198: 无用
199: 最后
200-204: existing jshyl custom prototype items
```

### Icon

Current `ItemConfig` has no explicit icon field. For TPR-029, no new icon asset
is required unless Unity UI proves item display depends on convention outside
`ItemConfig`.

If icons are later required:

```text
1. Put any new art under Assets/Mods/jshyl/.
2. Prefer existing base icons first.
3. Document the lookup convention before adding art.
4. Treat icon work as a separate asset pipeline task.
```

### Description

Descriptions should be source-faithful and short. They should explain the
object's story role without inventing mechanics.

Recommended first-batch descriptions:

| item | description |
|---|---|
| `司南针` | `慕容秋荻所赠行路之物，可辨方位。` |
| `狼牙燕翎` | `燕子坞家传暗记，可作江湖行走凭证。` |
| `秦皇照骨镜` | `古镜一面，据说可照见机关与遗迹线索。` |
| `洛阳铲` | `探墓寻物所用器具。` |
| `海月清辉` | `还施水阁所藏清雅珍物。` |

### Effect

Use inert key-item behavior for the first batch:

```text
Skill = -1
EquipmentType = -1
ItemType = 0
all stats/effects = 0
conditions = 0 unless existing inert key item rows use -1
NeedCastration = -1
GenerateItemNeedExp = 0
GenerateItemNeedCost = -1
GenerateItems = ""
```

Reason:

```text
1. These items are currently progression/reward tokens, not combat systems.
2. Inert items avoid balance regressions.
3. Future route logic can check possession/flags without stat side effects.
```

Exception:

```text
明玉丹 should not be inert forever. It belongs to a later paid service and must
get a deliberate medicine effect in a separate balancing task.
```

### Portrait / Art Requirement

No portraits are required for item config rows.

Potential art requirements are limited to item icons if a later UI audit shows
that new item ids display blank or misleading icons. Do not generate item art in
TPR-029.

## 3. Risks Of Adding Items Too Early

| risk | impact | mitigation |
|---|---|---|
| Adding too many rows creates id churn | Later rewards may reference unstable ids | Reserve a small id range and add only the first batch |
| Generated Lua can drift from Excel | Runtime sees different data than source config | Regenerate via Unity and inspect `ItemConfig.lua` |
| Medicine/equipment effects may be wrong | Combat balance and saves become noisy | Keep first batch inert; defer medicines/equipment |
| Placeholder names become permanent | Source-faithful TPR coverage gets muddied | Add exact item names, not `罗盘`/`铁铲` substitutions |
| New icons may be missing | UI may show generic/blank visuals | Accept for first batch, then audit UI before art work |
| Save compatibility with old saves | Existing saves lack new items but flags still persist | Reward scripts must use idempotency flags and grant only after item ids exist |
| Excel generator may reject malformed rows | MOD load/config generation can fail | Copy inert key-item pattern from existing rows like `罗盘` / `铁铲` |

## 4. Minimal First Item To Introduce

The single minimal first item is:

```text
司南针
```

Why:

```text
1. It was the earliest unresolved opening reward.
2. It belongs to the already implemented 秋荻 guard quest.
3. It can be an inert key item, so it has no battle/equipment risk.
4. It proves the Excel -> generated Lua -> reward id flow with one item before
   larger ShuiGe chest payloads are attempted.
```

If TPR-029 must be even smaller than the recommended first batch, add only
`司南针` and reserve ids for the rest in this plan.

## 5. Acceptance Criteria For TPR-029

TPR-029 should be accepted only when:

```text
1. `物品.xlsx` has exact new item row(s), starting with `司南针`.
2. New ids are in the reserved 205+ range and do not overwrite existing rows.
3. Added first-batch items are inert key items unless the prompt explicitly
   approves a medicine/equipment effect.
4. `ItemConfig.lua` is regenerated through the official config pipeline, not
   edited by hand.
5. Generated `ItemConfig.lua` contains the exact item names and ids.
6. jshyl MOD can reach the MOD selection/new-game path without config load
   errors.
7. No Lua reward scripts grant the new items yet unless the TPR-029 prompt
   explicitly expands scope.
8. No scene files, battle files, companion logic, or engine C# are modified.
```

Recommended verification commands/checks after generation:

```text
rg -n "司南针|狼牙燕翎|秦皇照骨镜|洛阳铲|海月清辉" \
  Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua

git diff -- Assets/Mods/jshyl/Configs/物品.xlsx \
  Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua
```

Unity manual verification:

```text
1. Open Unity Editor.
2. Select Assets/Mods/jshyl/ModSetting.asset.
3. Run "生成配置表".
4. Start Play mode, select jshyl, and confirm no config load error appears.
```

## 6. AssetBundle / Pipeline Requirements

Config-only item rows should not require an AssetBundle rebuild by themselves.

Expected pipeline impact:

```text
Excel config changed:
  Yes, `Assets/Mods/jshyl/Configs/物品.xlsx`.

Generated Lua changed:
  Yes, `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua` after generation.

AssetBundle rebuild:
  Not expected for config-only rows.

MOD restart:
  Required/recommended, because config tables are loaded during MOD startup.

New icon/art bundles:
  Deferred; only needed if a later UI audit requires item icons.
```

If later tasks add item icon assets under `BuildSource` or another bundled path,
that asset work may require AssetBundle label review and rebuild. TPR-029 should
avoid that.

## 7. Recommended Implementation Prompt

```text
Proceed with TPR-029: add minimal exact opening item config rows.

Read:
docs/tpr_extraction/TPR_028_MISSING_ITEM_CONFIG_STRATEGY.md
docs/tpr_extraction/TPR_018_OPENING_REWARD_ITEM_AUDIT.md

Allowed:
- Assets/Mods/jshyl/Configs/物品.xlsx
- Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- Lua reward scripts
- scene edits
- battle edits
- companion changes
- engine C#
- generated item icons/art

Requirements:
1. Add exact item rows for the first batch:
   - 司南针
   - 狼牙燕翎
   - 秦皇照骨镜
   - 洛阳铲
   - 海月清辉
2. Use ids starting at 205 and keep them stable.
3. Implement them as inert key items:
   Skill = -1
   EquipmentType = -1
   ItemType = 0
   all stats/effects = 0
4. Do not grant these items yet.
5. Regenerate `Configs/Lua/ItemConfig.lua` through the official config pipeline.
6. Verify generated Lua contains the new item rows.
7. Update docs/backlog to mark TPR-029 implemented.

Done when:
- jshyl config generation succeeds
- new item ids are visible in generated ItemConfig.lua
- no gameplay behavior changes yet
```
