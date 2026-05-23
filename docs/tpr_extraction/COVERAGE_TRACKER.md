# TPR Coverage Tracker

## Purpose

Track extraction, implementation, and verification coverage for the complete TPR wiki inside jshyl.

## Coverage Rule

A page counts as TPR coverage only when its extracted content has been implemented and verified against that page.

The Phase 2 vertical slice (`qqzj_intro_abi_guidance`) is technical validation only and does not count as coverage for any TPR wiki page.

## Status Values

```text
not_inventoried
inventoried
extracted
implemented
verified
```

## Summary

| metric | count | notes |
|---|---:|---|
| Wiki pages reported by TPR start page | 86 | must be reconciled in inventory pass |
| Pages currently inventoried | 49 | seeded from visible start page, sitemap entries, and extracted page sections |
| Pages extracted | 0 | no full TPR page extraction yet |
| Page sections extracted | 2 | `主角剧情：开局`; `主角剧情：拜师` |
| Page sections partially implemented | 2 | opening quests plus `qqzj_protagonist_apprenticeship_intro` |
| Pages implemented | 0 | Phase 2 slice excluded from TPR coverage |
| Pages verified | 0 | no TPR page verified end to end yet |

## Reference Slice

| item | value |
|---|---|
| technical quest id | `qqzj_intro_abi_guidance` |
| source type | local validation slice |
| TPR page coverage | none |
| event file | `Assets/Mods/jshyl/Lua/10000.lua` |
| reward pattern | `小还丹` idempotency flag |
| battle pattern | optional `TryBattle(7)` victory flag |
| save/load pattern | save-backed flags via `JSHYL.QQZJ.Flags` |

## Page Coverage Table

| page title | page url | category | route/book | status | extraction record | implementation commits | verification evidence | notes |
|---|---|---|---|---|---|---|---|---|
| 金书红颜录5 青青子衿 | https://tpr.inkit.cc/start | index | global | inventoried | none | none | none | navigation hub only |
| 主角剧情 | https://tpr.inkit.cc/tpr5:主角剧情 | story_route | 主角 | inventoried | partial section extraction only | none | none | full page not extracted |
| 主角剧情：开局 | https://tpr.inkit.cc/tpr5:主角剧情#开局 | story_section | 主角 | partially_implemented | docs/tpr_extraction/extractions/zhujuqinqing_opening.md; docs/tpr_extraction/TPR_017_OPENING_COVERAGE_CHECKPOINT.md; docs/tpr_extraction/TPR_018_OPENING_REWARD_ITEM_AUDIT.md; docs/tpr_extraction/TPR_019_52_YANZIWU_SCENE_BINDING_AUDIT.md; docs/tpr_extraction/TPR_021_SHUIGE_TRUE_ENTRY_PLAN.md; docs/tpr_extraction/TPR_023_SHUIGE_BEHAVIOR_AFTER_TRIGGER_PLAN.md; docs/tpr_extraction/TPR_025_SHUIGE_INNER_MARKER_INTERACTION_PLAN.md; docs/tpr_extraction/TPR_027_SHUIGE_OPENING_COVERAGE_CHECKPOINT.md; docs/tpr_extraction/TPR_028_MISSING_ITEM_CONFIG_STRATEGY.md; docs/tpr_extraction/TPR_030_SHUIGE_CHEST_REWARD_BINDING_PLAN.md; docs/tpr_extraction/TPR_032_OPENING_CHECKPOINT_AFTER_SHUIGE_CHEST.md; docs/tpr_extraction/TPR_033_OPENING_TOOL_REWARD_PLAN.md; docs/tpr_extraction/TPR_035_MENGXINGHUN_COMPANION_JOIN_PLAN.md; docs/tpr_extraction/TPR_036_OPENING_CHECKPOINT_AFTER_MENGXINGHUN_JOIN.md; docs/tpr_extraction/TPR_037_MISSING_MEDICINE_ITEM_CONFIG_PLAN.md; docs/tpr_extraction/TPR_039_SHUIGE_SILVER_DEDUCTION_PLAN.md; docs/tpr_extraction/TPR_039A_MONEY_ITEM_API_AUDIT.md; docs/tpr_extraction/TPR_040_HANGZHOU_KAIFENG_MAP_HOOK_PLAN.md | Phase 3C, TPR-006, TPR-008, TPR-009A, TPR-010A, TPR-012, TPR-014, TPR-016, TPR-020, TPR-022, TPR-024, TPR-026, TPR-031, TPR-034, TPR-035A implementation commits; TPR-017 checkpoint; TPR-018 item audit; TPR-019 scene audit; TPR-021 true-entry plan; TPR-023 post-entry behavior plan; TPR-025 inner marker interaction plan; TPR-027 ShuiGe/opening checkpoint; TPR-028 item config strategy; TPR-029 item config implementation; TPR-030 ShuiGe chest binding plan; TPR-032 post-ShuiGe-chest checkpoint; TPR-033 opening tool reward plan; TPR-035 孟星魂 companion join plan; TPR-036 post-join checkpoint; TPR-037 missing medicine config plan; TPR-038 medicine item config implementation; TPR-039 ShuiGe silver deduction plan; TPR-039A money item API audit; TPR-039B ShuiGe silver deduction implementation; TPR-040 杭州/开封 map hook plan | none | implemented subsections: arrival, 秋荻托付/孟星魂 assignment flag, 孟星魂 role id 335 real companion join, verified 九转熊蛇丸 reward, inert 司南针 id 205 reward, 二叔/三叔 narrative hooks and inert tool rewards 狼牙燕翎 id 206 / 秦皇照骨镜 id 207 / 洛阳铲 id 208, 大哥 return dialogue plus verified partial reward, 还施水阁 entry hint via 5203, dedicated 还施水阁 entry trigger via 5204 with -3000 银两 cost and old-save waiver, same-scene 还施水阁 inner marker unlock and 5206 interaction, dedicated ShuiGe center chest 5207 granting 海月清辉 id 209 x1 once, 侍剑 training architecture refactor with battle 145, existing 燕子坞 silver chest refactor; medicine item configs now exist for 金创药 id 210, 少阳丹 id 211, 人参养荣丸 id 212, 明玉丹 id 213 but are not granted yet; 杭州/开封 remain narrative flags only because no exact jshyl map rows/assets exist; true teleport/room entry, source-faithful full 水阁宝箱, remaining item configs, and map hooks remain incomplete |
| 主角剧情：拜师 | https://tpr.inkit.cc/tpr5:主角剧情#拜师 | story_section | 主角 | partially_implemented | docs/tpr_extraction/extractions/zhujuqinqing_apprenticeship.md; docs/tpr_extraction/TPR_042_APPRENTICESHIP_FIRST_SLICE_PLAN.md; docs/tpr_extraction/TPR_043_APPRENTICESHIP_BRANCH_CHOICE_DESIGN.md; docs/tpr_extraction/TPR_045_APPRENTICESHIP_CHECKPOINT_AFTER_BRANCH_SELECTION.md; docs/tpr_extraction/TPR_046_APPRENTICESHIP_SKILL_CONFIG_STRATEGY.md; docs/tpr_extraction/TPR_048_APPRENTICESHIP_LANGYA_YANLING_CONSUMPTION_PLAN.md; docs/tpr_extraction/TPR_050_APPRENTICESHIP_FIRST_BRANCH_REWARD_PLAN.md; docs/tpr_extraction/TPR_052_APPRENTICESHIP_AFTER_ABI_REWARD_CHECKPOINT.md; docs/tpr_extraction/TPR_053_REMAINING_APPRENTICESHIP_BRANCH_REWARD_PLAN.md; docs/tpr_extraction/TPR_055_APPRENTICESHIP_AFTER_ALL_BRANCH_REWARDS_CHECKPOINT.md; docs/tpr_extraction/TPR_056_APPRENTICESHIP_STAT_REWARD_STRATEGY.md | TPR-041 extraction commit; TPR-042 first-slice planning commit; TPR-042A implementation commit; TPR-043 branch-choice planning commit; TPR-044 branch-choice flags implementation commit; TPR-045 checkpoint commit; TPR-046 skill config planning commit; TPR-047 skill config implementation commit; TPR-048 consumption planning commit; TPR-049 token consumption implementation commit; TPR-050 first branch reward planning commit; TPR-051 阿碧 skill reward implementation commit; TPR-052 checkpoint/meta housekeeping commit; TPR-053 remaining branch reward planning commit; TPR-054 remaining branch reward implementation commit; TPR-055 checkpoint commit; TPR-056 stat reward planning commit; TPR-057 武学常识 implementation commit | none | implemented subsection: dedicated `jshyl_apprenticeship_master` trigger / event 5210 introduces apprenticeship dialogue, irreversible branch-choice flags, idempotent 狼牙燕翎 id 206 consumption/old-save waiver, first-skill rewards for all five branches through LearnMagic2, and universal 武学常识 +50 through AddWuchang(0, 50) once; tracked Unity `.meta` sidecar for 5210.lua; slot wash, branch-specific +10 系数, battle gate, and ShuiGe study remain unimplemented |
| 越女剑 | https://tpr.inkit.cc/tpr5:越女剑 | book_route | 越女剑 | inventoried | none | none | none | prototype exists but not source-verified |
| 逍遥御风 | https://tpr.inkit.cc/tpr5:逍遥御风 | route_chapter | 天龙八部 | inventoried | none | none | none | user-requested future line |
| 侠客行 | https://tpr.inkit.cc/tpr5:侠客行 | book_route | 侠客行 | inventoried | none | none | none | user-requested future dependency |

## Verification Evidence Template

For each verified page, record:

```text
page:
commit(s):
Unity version:
test date:
start save/new game:
maps entered:
events triggered:
rewards checked:
battles checked:
save/load checked:
known gaps:
```

## Workflow Gate

Do not advance a page to `verified` unless:

1. The page inventory row is complete.
2. The quest extraction is complete.
3. The implementation backlog item is closed.
4. Unity can load jshyl.
5. Relevant triggers execute without Lua/runtime errors.
6. Rewards are idempotent.
7. Battles return to the correct scene.
8. Save/load preserves page flags.
