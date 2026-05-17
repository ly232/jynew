# TPR-018 Item Audit: Remaining 主角剧情：开局 Rewards

## Scope

Planning/audit only. No gameplay, Lua, config, scene, asset, battle, companion,
or engine files were changed.

Inputs reviewed:

```text
docs/tpr_extraction/TPR_017_OPENING_COVERAGE_CHECKPOINT.md
docs/tpr_extraction/extractions/zhujuqinqing_opening.md
Assets/Mods/jshyl/Configs/**
Assets/Mods/jshyl/Lua/**
```

Search method:

```text
1. Exact-name search across generated config Lua and existing jshyl Lua.
2. Raw text search across Assets/Mods/jshyl/Configs, including xlsx packages.
3. Near-match search for navigation, shovel, medicine, and thrown-weapon terms.
```

Generated `ItemConfig.lua` is treated as the primary source for implementable
item ids because it is what the mod runtime loads.

## 1. Exact Item IDs Found

| item | id | status | evidence |
|---|---:|---|---|
| 玉真散 | 5 | already implemented for 大哥 partial reward | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:67` |
| 九转灵宝丸 | 14 | already implemented for 大哥 partial reward | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:76` |
| 九转熊蛇丸 | 16 | already implemented for 秋荻 reward; safe for future 水阁 chest quantity | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:78` |
| 银两 | 174 | already implemented for opening and silver chest rewards | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:236` |

Evidence rows:

```text
Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:67
{5,[[玉真散]],[[华山派所有，可恢复些许生命]],...}

Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:76
{14,[[九转灵宝丸]],[[全真教所有，可恢复内力]],...}

Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:78
{16,[[九转熊蛇丸]],[[逍遥派疗伤圣药，可补满内力]],...}

Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:236
{174,[[银两]],[[很好用的东西，甚至能使鬼推磨]],...}
```

## 2. Missing Exact Items

No exact item rows were found in current jshyl generated configs for:

```text
司南针
金创药
少阳丹
人参养荣丸
明玉丹
狼牙燕翎
秦皇照骨镜
洛阳铲
海月清辉
九霄环佩
天书竹简
朱颜碧
缀玉华裳
湖畔舞剑图
```

These were searched across:

```text
Assets/Mods/jshyl/Configs/**
Assets/Mods/jshyl/Lua/**
```

Conclusion:

```text
The exact remaining TPR opening reward items are mostly not represented in the
current jshyl item config. They should not be granted by id until added to config
or explicitly mapped to approved placeholders.
```

## 3. Approximate But Non-Exact Placeholders

These items exist and are thematically close, but they are not exact matches.
Do not use them silently in source-faithful rewards.

| requested item | possible placeholder | placeholder id | evidence | recommendation |
|---|---|---:|---|---|
| 司南针 | 罗盘 | 182 | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:244` | plausible navigation placeholder only if explicitly approved |
| 洛阳铲 | 铁铲 | 195 | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:257` | plausible shovel placeholder only if explicitly approved |
| 金创药 | 小还丹 / 玉洞黑石丹 / 玉真散 | 3 / 4 / 5 | `ItemConfig.lua:65-67` area | do not substitute; medicine identity differs |
| 少阳丹 | 九转灵宝丸 or other MP medicine | 14 | `ItemConfig.lua:76` | do not substitute; already used as exact separate reward |
| 人参养荣丸 | 人参 / 千年人参 | 11 / 34 | `ItemConfig.lua:73`, `ItemConfig.lua:96` | do not substitute; exact pill is missing |
| 明玉丹 | high-tier medicine such as 生生造化丹 / 天王保命丹 | 19 / 20 | `ItemConfig.lua:81-82` area | do not substitute; service economy would change |

Placeholder evidence:

```text
Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:244
{182,[[罗盘]],[[可显示目前之坐标与船之位置]],...}

Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:257
{195,[[铁铲]],[[可用来挖掘东西]],...}

Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:73
{11,[[人参]],[[天然补品，可恢复少许内力]],...}

Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:96
{34,[[千年人参]],[[千年物，提高生命及内力最大值]],...}
```

## 4. Thrown Weapon / 暗器 Availability

The extraction lists `各门派暗器 x20 each` but does not yet specify the exact
暗器 set. Existing jshyl configs do include several thrown weapons:

| item | id | evidence |
|---|---:|---|
| 飞蝗石 | 96 | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:158` |
| 金钱镖 | 97 | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:159` |
| 飞刀 | 98 | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:160` |
| 菩提子 | 99 | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:161` |
| 金蛇锥 | 100 | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:162` |
| 霹雳弹 | 101 | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:163` |
| 毒蒺黎 | 102 | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:164` |
| 玉蜂针 | 103 | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:165` |
| 冰魄银针 | 104 | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:166` |
| 黑血神针 | 105 | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:167` |

Recommendation:

```text
Do not implement the `各门派暗器` chest yet. First decide whether the source
expects all existing thrown weapons, a route-specific subset, or new TPR-specific
items. Once the list is approved, these existing ids are safe primitives.
```

## 5. Rewards Safe To Implement Now

Safe exact rewards using current config ids:

| source beat | item | id | quantity | status |
|---|---|---:|---:|---|
| 阿碧 room chest | 九转熊蛇丸 | 16 | 20 | safe once the chest/event binding is designed |
| 双儿 room chest / existing silver chest variants | 银两 | 174 | 30000 each | safe once each chest has its own idempotency flag |

Already implemented exact/partial rewards:

```text
秋荻: 九转熊蛇丸 id 16 x10
大哥: 玉真散 id 5 x20
大哥: 九转灵宝丸 id 14 x20
opening/chests: 银两 id 174
```

Safe implementation constraint:

```text
Even for exact ids, do not add more rewards until scene binding and idempotency
flags are defined for each physical chest/service.
```

## 6. Rewards That Must Be Deferred

Defer exact-source reward implementation for:

```text
司南针
金创药
少阳丹
人参养荣丸
明玉丹
狼牙燕翎
秦皇照骨镜
洛阳铲
海月清辉
九霄环佩
天书竹简
朱颜碧
缀玉华裳
湖畔舞剑图
各门派暗器 set, until exact list is chosen
```

Reason:

```text
Exact item ids are not present in current generated jshyl item config, or the
source reward is underspecified relative to current item rows.
```

## 7. Will New Item Config Creation Be Required Later?

Yes, for source-faithful coverage.

At minimum, the following exact TPR items need config rows unless an explicit
design decision maps them to placeholders:

```text
司南针
金创药
少阳丹
人参养荣丸
明玉丹
狼牙燕翎
秦皇照骨镜
洛阳铲
海月清辉
九霄环佩
天书竹简
朱颜碧
缀玉华裳
湖畔舞剑图
```

Config-enabled future task should define:

```text
1. Stable new ids in 物品.xlsx.
2. ItemType / EquipmentType / stats / descriptions.
3. Generated Configs/Lua/ItemConfig.lua update through the normal Unity/export flow.
4. Save compatibility plan for any reward flag already claimed before the new rows exist.
```

## 8. Recommended Next Implementation Task

Do not implement new rewards immediately.

Recommended next task:

```text
TPR-019: scene binding audit for 52_yanziwu opening.
```

Why:

```text
The only exact remaining reward that is newly safe is 九转熊蛇丸 id 16 x20 for a
future 阿碧-room chest, plus more 银两 id 174 chest variants. Both need physical
chest/event placement before implementation. The larger reward list requires
config work first.
```

After TPR-019, the safest gameplay slice is still:

```text
TPR-020: qqzj_protagonist_opening_shuige_entry
```

`TPR-020` should implement dialogue/flags and either defer the -3000 silver cost
or use verified money behavior. It should not add 水阁 chest rewards until item
config creation and scene bindings are both ready.
