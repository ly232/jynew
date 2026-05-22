# TPR-046: Apprenticeship Skill Config Strategy

## Scope

Planning only. This document audits `SkillConfig.lua` and proposes how to introduce the five missing `主角剧情：拜师` martial arts.

No config, Lua quest, scene, Unity asset, gameplay, or engine files are changed by TPR-046.

## Source Skills

The apprenticeship branches require these exact source skills:

| branch id | mentor | exact skill | 系别 |
|---:|---|---|---|
| `1` | 阿碧 | 七弦无形剑 | 暗毒 |
| `2` | 邓百川 | 回风舞柳剑 | 御剑 |
| `3` | 包不同 | 如影随形腿 | 指腿 |
| `4` | 风波恶 | 飞沙走石刀 | 兵器 |
| `5` | 公冶干 | 大风云飞掌 | 拳掌 |

## Current SkillConfig Audit

Inspected:

```text
Assets/Mods/jshyl/Configs/Lua/SkillConfig.lua
```

Current exact-skill status:

| exact skill | exists now? | id |
|---|---|---:|
| 七弦无形剑 | no | n/a |
| 回风舞柳剑 | no | n/a |
| 如影随形腿 | no | n/a |
| 飞沙走石刀 | no | n/a |
| 大风云飞掌 | no | n/a |

Current highest id:

```text
205 独孤九剑
```

Nearby but non-exact existing skills:

| existing skill | id | why not use as final source reward |
|---|---:|---|
| 持瑶琴 | `83` | Thematically close to 阿碧/琴, but not the exact source name 七弦无形剑. |
| 回峰落雁剑 | `46` | Similar-looking sword name, but not 回风舞柳剑. |
| 慕容剑法 | `51` | Family-flavored, but not any source apprenticeship branch. |
| 狂风刀法 | `64` | Wind-themed刀法, but not 飞沙走石刀. |
| 混元掌 | `7` | Generic掌法 placeholder, not 大风云飞掌. |
| 逍遥掌 | `10` | Family/逍遥-flavored掌法, not 大风云飞掌. |
| 暗器 | `97` | Generic暗器 utility, not 七弦无形剑. |
| 独孤九剑 | `205` | Existing high-tier jshyl skill, too strong and source-inaccurate for apprenticeship. |

Conclusion:

```text
All five exact source skills are missing. Do not substitute nearby skills for source coverage.
```

## Recommended New Skill IDs

Use the next contiguous ids after `205`:

| new id | skill | branch |
|---:|---|---|
| `206` | 七弦无形剑 | 阿碧 / 暗毒 |
| `207` | 回风舞柳剑 | 邓百川 / 御剑 |
| `208` | 如影随形腿 | 包不同 / 指腿 |
| `209` | 飞沙走石刀 | 风波恶 / 兵器 |
| `210` | 大风云飞掌 | 公冶干 / 拳掌 |

These are skill ids and do not conflict with item ids `206` through `210`, because item and skill configs are separate tables.

## Recommended Initial Behavior

Recommended TPR-047 behavior:

```text
Add conservative placeholder SkillConfig rows for all five exact skill names.
Do not grant them to the player yet.
Do not consume 狼牙燕翎 yet.
Do not mutate stats or skill slots yet.
Do not create battles yet.
```

Why placeholder rows are better than real effects now:

```text
1. Quest reward code needs stable exact ids before it can be implemented safely.
2. Skill-slot washing and 武学常识/stat mutation APIs are still unaudited.
3. Battle display assets can fail loudly if a skill is used before display assets exist.
4. Adding real damage/battle behavior before reward wiring would expand the test surface too much.
```

## Suggested Config Row Strategy

The generated skill table fields are:

```text
Id, Name, DamageType, SkillCoverType, MpCost, Poison, Levels
```

For TPR-047, create rows in `武功.xlsx` and regenerate/update `Configs/Lua/SkillConfig.lua` consistently.

Recommended conservative rows:

| skill | suggested base row | reason |
|---|---|---|
| 七弦无形剑 | copy shape from `持瑶琴` id `83` but rename/id as `206` | Uses an existing music/琴 display-compatible pattern later, and source branch is 阿碧. |
| 回风舞柳剑 | copy shape from `回峰落雁剑` id `46` but rename/id as `207` | Closest existing sword coverage/range pattern. |
| 如影随形腿 | copy a low/mid single-target martial pattern, preferably reviewed from 指腿-like skills if available | Existing table does not expose a clean exact 指腿 category, so keep conservative. |
| 飞沙走石刀 | copy shape from `狂风刀法` id `64` but rename/id as `209` | Closest wind-themed刀法 pattern. |
| 大风云飞掌 | copy shape from `逍遥掌` id `10` or `混元掌` id `7`, then rename/id as `210` | Conservative掌法 pattern, with no new effects. |

Important:

```text
These rows should be present and loadable but not reachable through gameplay until TPR-049/TPR-050+.
```

## Icons, Animations, And Skill Display Assets

Skill config rows alone may be enough to load configs, but battle usage generally needs matching skill display assets under:

```text
Assets/Mods/jshyl/Skills/
```

Observed reusable display assets:

| future skill | likely display source | notes |
|---|---|---|
| 七弦无形剑 | `持瑶琴.asset` | Thematic match for 阿碧/琴. |
| 回风舞柳剑 | `回峰落雁剑.asset` | Sword display approximation. |
| 如影随形腿 | TBD | Needs a specific display-asset audit before actual battle use. |
| 飞沙走石刀 | `狂风刀法.asset` | Wind-themed 刀法 approximation. |
| 大风云飞掌 | `逍遥掌.asset` or `混元掌.asset` | Conservative掌法 approximation. |

Recommended staging:

```text
TPR-047 should add config rows only, unless Unity requires matching display assets merely to load.
If matching display assets are required before battle usage, create or duplicate assets in a later dedicated skill-display slice.
```

Do not wire these skills into combat until every selected skill has a known display asset. Prior battle QA already showed that missing skill display assets can break battle flow.

## Inert Placeholder vs Copied vs Real Effects

| option | recommendation | reason |
|---|---|---|
| Inert placeholders | use for quest/reward planning only if the engine can load them safely | Safest for ids and source names, but fully inert skills may be confusing if accidentally granted. |
| Copied existing skill rows | recommended for TPR-047 | Keeps the rows structurally valid and future battle-compatible while avoiding new mechanics. |
| Real effects | defer | Requires balancing, display assets, skill-slot wash API, stat effects, and battle verification. |

Best compromise:

```text
Add copied, conservative rows in config, but do not grant or use them yet.
```

## Risks

1. `SkillConfig.lua` is generated from `武功.xlsx`; hand-editing generated Lua without matching Excel will drift.
2. Duplicate skill ids or names can break config lookup or reward wiring.
3. New skill names may require matching `Skills/<skill>.asset` display entries before battle usage.
4. If a skill is accidentally granted before display assets exist, battle may fail with missing display configuration.
5. Copying powerful rows like `独孤九剑` would make apprenticeship rewards overpowered and source-inaccurate.
6. Adding real effects now would hide bugs between config, reward, stat, and animation layers.

## Recommended First Skill To Introduce

First manual verification target:

```text
七弦无形剑 id 206
```

Reasons:

```text
1. 阿碧 is the safest first full branch from TPR-045.
2. Existing `持瑶琴` provides a close display/config pattern.
3. It validates the branch-reward path with the least new scene/NPC work.
```

Implementation should still add all five skill rows together so branch ids remain stable and future ShuiGe shelf exclusion logic can reference every exact skill.

## Recommended TPR-047 Implementation Prompt

```text
Proceed with TPR-047: add minimal apprenticeship skill config rows.

Read:
docs/tpr_extraction/TPR_046_APPRENTICESHIP_SKILL_CONFIG_STRATEGY.md
docs/tpr_extraction/extractions/zhujuqinqing_apprenticeship.md

Allowed:
- Assets/Mods/jshyl/Configs/武功.xlsx
- Assets/Mods/jshyl/Configs/Lua/SkillConfig.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- Lua quest edits
- scene edits
- skill grants
- stat changes
- item consumption
- battles
- companions
- engine C#
- skill display assets unless config loading requires them

Requirements:
1. Add exact skill rows:
   - 206 七弦无形剑
   - 207 回风舞柳剑
   - 208 如影随形腿
   - 209 飞沙走石刀
   - 210 大风云飞掌
2. Preserve existing skill ids and rows.
3. Use conservative copied row patterns from existing low/mid skills.
4. Update generated `Configs/Lua/SkillConfig.lua` consistently with `武功.xlsx`.
5. Do not grant these skills anywhere.
6. Do not consume 狼牙燕翎.
7. Do not add stat effects or battle behavior.
8. Update docs/backlog with exact ids.

Done when:
- Skill ids 206-210 load in config.
- No gameplay behavior changes.
- Future TPR-049/TPR-050 can reference exact ids.
```
