# TPR-037 Plan: Missing Opening Medicine Item Configs

## Scope

Planning only. No gameplay, Lua, scene, config, asset, battle, companion, or
engine files should change in this task.

Inputs reviewed:

```text
docs/tpr_extraction/TPR_036_OPENING_CHECKPOINT_AFTER_MENGXINGHUN_JOIN.md
docs/tpr_extraction/TPR_018_OPENING_REWARD_ITEM_AUDIT.md
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua
```

## Source Need

The opening extraction still needs these exact medicine names:

| source beat | item | quantity / cost | current status |
|---|---|---:|---|
| 大哥 return reward | `金创药` | x20 | missing |
| 大哥 return reward | `少阳丹` | x20 | missing |
| 大哥 return reward | `人参养荣丸` | x20 | missing |
| 慕容秋荻 service | `明玉丹` | x1, costs 30000 silver | missing |

Already implemented exact medicines:

| item | id | current use |
|---|---:|---|
| `玉真散` | `5` | 大哥 partial reward x20 |
| `九转灵宝丸` | `14` | 大哥 partial reward x20 |
| `九转熊蛇丸` | `16` | 秋荻 reward x10; later ShuiGe x20 candidate |

No other missing medicine names appear in the current opening extraction.

## 1. Current Medicine Ranges / Conventions

The generated config schema defines the relevant fields:

| field | index | use |
|---|---:|---|
| `Id` | 1 | stable item id |
| `Name` | 2 | display name |
| `Desc` | 3 | display description |
| `Skill` | 4 | usually `-1` for medicines |
| `EquipmentType` | 5 | usually `-1` for medicines |
| `ItemType` | 6 | `3` for consumable medicine/food; `0` for key/story items |
| `AddHp` | 7 | restore HP or add HP depending engine behavior |
| `AddMaxHp` | 8 | permanent max HP increase |
| `ChangePoisonLevel` | 9 | negative values reduce poison |
| `AddTili` | 10 | restore stamina |
| `ChangeMPType` | 11 | change internal energy type |
| `AddMp` | 12 | restore MP |
| `AddMaxMp` | 13 | permanent max MP increase |

Existing consumable medicine conventions:

| id range | examples | convention |
|---|---|---|
| `0`-`1` | `康倍特`, `精气丸` | `ItemType = 3`, stamina recovery |
| `2`-`9` | `白岚氏鸡精`, `小还丹`, `玉真散`, `黑玉断续膏` | `ItemType = 3`, HP recovery via `AddHp` |
| `10`-`18` | `金牛运功散`, `人参`, `九转灵宝丸`, `九转熊蛇丸`, `无常丹` | `ItemType = 3`, MP or mixed HP/MP recovery |
| `19`-`20` | `生生造化丹`, `天王保命丹` | `ItemType = 3`, very high HP/MP and poison recovery |
| `21`-`27` | `宝济丸`, `黄连解毒丸`, `朱晴冰蟾` | `ItemType = 3`, poison recovery |
| `28`-`38` | `伏苓首乌丸`, `千年灵芝`, `千年人参`, `通犀地龙丸` | `ItemType = 3`, permanent max stat / anti-poison effects |

Recent QQZJ item rows use:

| id range | examples | convention |
|---|---|---|
| `205`-`209` | `司南针`, `狼牙燕翎`, `海月清辉` | `ItemType = 0`, inert story/key items |

## 2. Recommended New IDs

Use the next contiguous IDs after current QQZJ rows:

| item | recommended id | reason |
|---|---:|---|
| `金创药` | `210` | first missing 大哥 medicine |
| `少阳丹` | `211` | second missing 大哥 medicine |
| `人参养荣丸` | `212` | third missing 大哥 medicine |
| `明玉丹` | `213` | 秋荻 paid/service medicine |

Do not reuse approximate placeholders:

| missing item | do not substitute with | reason |
|---|---|---|
| `金创药` | `小还丹` / `玉真散` | different exact source name |
| `少阳丹` | `九转灵宝丸` | `九转灵宝丸` is already a separate exact reward |
| `人参养荣丸` | `人参` / `千年人参` | item identity differs |
| `明玉丹` | `生生造化丹` / `天王保命丹` | service economy and item identity differ |

## 3. Conservative Type / Effect Strategy

Recommended TPR-038 config rows:

| id | item | ItemType | effect strategy | rationale |
|---:|---|---:|---|---|
| `210` | `金创药` | `3` | usable HP recovery, `AddHp = 50` | common wound medicine, between `小还丹` 30 and `玉洞黑石丹` 60 |
| `211` | `少阳丹` | `3` | usable MP recovery, `AddMp = 50` | starter internal-energy medicine, parallel to `白云熊胆丸` 50 |
| `212` | `人参养荣丸` | `3` | usable mixed recovery, `AddHp = 100`, `AddMp = 100` | tonic-style medicine, comparable to `无常丹` / `镇心理气丸` |
| `213` | `明玉丹` | `0` first, or defer effect | keep inert until paid service is implemented | source says paid service; effect is not specified in current extraction |

Why make `金创药`, `少阳丹`, `人参养荣丸` usable now:

```text
They are direct 大哥 reward medicines. Existing engine conventions already
support simple HP/MP consumables with ItemType = 3, and conservative values
avoid introducing new mechanics.
```

Why keep `明玉丹` inert for now:

```text
The opening extraction only says 慕容秋荻 has a 明玉丹 service costing 30000
silver. The actual effect is not specified in the current extraction. Adding a
powerful real effect before the service and economy are designed could distort
balance and make later correction save-visible.
```

If the user wants strict "medicine must be usable" consistency, an alternative
for `明玉丹` is:

```text
ItemType = 3
AddHp = 0
AddMp = 0
AddMaxHp = 0
AddMaxMp = 0
```

However, that creates a consumable that does nothing, which is worse UX than
marking it as an inert service/key item until the service slice is ready.

## 4. Inert vs Usable Recommendation

| item | recommendation | later follow-up |
|---|---|---|
| `金创药` | usable medicine now | grant through 大哥 reward in a later quest slice |
| `少阳丹` | usable medicine now | grant through 大哥 reward in a later quest slice |
| `人参养荣丸` | usable medicine now | grant through 大哥 reward in a later quest slice |
| `明玉丹` | inert/service item now | define paid service effect before making it usable |

TPR-038 should only add config rows. It should not grant any new medicine yet.

## 5. Risks Of Adding Real Effects Now

| risk | applies to | mitigation |
|---|---|---|
| balance inflation from early x20 medicine rewards | `金创药`, `少阳丹`, `人参养荣丸` | use conservative low/mid values; do not grant until a later idempotent reward slice |
| service economy mismatch | `明玉丹` | keep inert until the 30000-silver service behavior is designed |
| permanent stat changes become hard to unwind in saves | any medicine using `AddMaxHp`/`AddMaxMp` | avoid permanent stat effects in TPR-038 |
| generated Lua and Excel drift | all new config rows | update `物品.xlsx` and generated `Configs/Lua/ItemConfig.lua` together |
| old saves cannot see new items until config reload | all new config rows | expected; do not reference ids in Lua before config task lands |
| item ids collide with future ShuiGe treasure rows | ids `210`-`213` | reserve next ShuiGe batch after `213` |

## 6. Recommended TPR-038 Implementation Prompt

```text
Proceed with TPR-038: add missing opening medicine item config rows.

Read:
docs/tpr_extraction/TPR_037_MISSING_MEDICINE_ITEM_CONFIG_PLAN.md

Allowed:
- Assets/Mods/jshyl/Configs/物品.xlsx
- Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- Lua quest edits
- scene edits
- reward grants
- battles
- companions
- engine C#

Requirements:
1. Add exact item rows:
   - 210 金创药
   - 211 少阳丹
   - 212 人参养荣丸
   - 213 明玉丹
2. Use existing medicine config conventions.
3. Recommended effects:
   - 金创药: ItemType 3, AddHp 50
   - 少阳丹: ItemType 3, AddMp 50
   - 人参养荣丸: ItemType 3, AddHp 100, AddMp 100
   - 明玉丹: ItemType 0 and inert until service behavior is planned
4. Do not grant these items anywhere yet.
5. Do not modify existing item ids.
6. Keep generated ItemConfig.lua consistent with 物品.xlsx.
7. Update docs/backlog to mark TPR-038 implemented.
```

## Later Follow-Up

After TPR-038, the next safe gameplay slice should be:

```text
TPR-039A or equivalent: extend 大哥 reward to grant exact missing medicines
金创药 id 210 x20, 少阳丹 id 211 x20, 人参养荣丸 id 212 x20, guarded by a new
old-save-compatible idempotency flag.
```

Do not implement `明玉丹` service until silver deduction/service economics have
their own plan.
