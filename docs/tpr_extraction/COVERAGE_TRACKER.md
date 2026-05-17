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
| Pages currently inventoried | 48 | seeded from visible start page and sitemap entries |
| Pages extracted | 0 | no full TPR page extraction yet |
| Page sections extracted | 1 | `主角剧情：开局` only |
| Page sections partially implemented | 1 | `qqzj_protagonist_opening_arrival`, `qqzj_protagonist_opening_qiudi_guard`, `qqzj_protagonist_opening_family_briefing`, and `qqzj_protagonist_opening_brother_return` only |
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
| 主角剧情：开局 | https://tpr.inkit.cc/tpr5:主角剧情#开局 | story_section | 主角 | partially_implemented | docs/tpr_extraction/extractions/zhujuqinqing_opening.md | Phase 3C, TPR-006, TPR-008, TPR-009A, TPR-010A implementation commits | none | implemented subsections: arrival, 秋荻托付/孟星魂 assignment flag, verified 九转熊蛇丸 reward, 二叔/三叔 narrative hooks for 杭州/开封, 大哥 return dialogue-only |
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
