# TPR Implementation Backlog

## Purpose

Track implementation work generated from TPR page extraction.

Do not add gameplay tasks here unless they came from an inventoried/extracted page or from a technical prerequisite needed for page coverage.

## Current Baseline

Validated technical pattern:

```text
quest id: qqzj_intro_abi_guidance
event file: Assets/Mods/jshyl/Lua/10000.lua
quest helper: JSHYL.QQZJ.Quest
reward pattern: AddItem guarded by reward flag
battle pattern: TryBattle guarded by victory/completion flags
```

This is not TPR coverage.

## Backlog Status Values

```text
planned
ready
in_progress
blocked
implemented
verified
deferred
```

## Backlog Table

| id | source page | source url | type | status | dependencies | target maps | target Lua files | target battles | rewards/items | flags | notes |
|---|---|---|---|---|---|---|---|---|---|---|---|
| TPR-000 | PAGE_INVENTORY | https://tpr.inkit.cc/start?idx=tpr5 | inventory | ready | none | n/a | n/a | n/a | n/a | n/a | reconcile visible sitemap rows with reported 86-page wiki count |
| TPR-001 | 主角剧情：开局 | https://tpr.inkit.cc/tpr5:主角剧情#开局 | extraction | implemented | TPR-000 recommended | 52_yanziwu, 杭州城 hook, 开封 hook | opening event ids TBD, jshyl_qqzj_quest.lua | 侍剑/十二金钗 training TBD | opening rewards extracted | qqzj_protagonist_opening_* | extraction doc created; gameplay not implemented |
| TPR-005 | 主角剧情：开局 | https://tpr.inkit.cc/tpr5:主角剧情#开局 | implementation | in_progress | TPR-001 | 52_yanziwu | 5200.lua, jshyl_qqzj_quest.lua, opening event ids TBD | defer 侍剑 battle unless selected | first slice grants 银两 id 174 x10000 | qqzj_protagonist_opening_arrival_*; qqzj_protagonist_opening_qiudi_guard_* | Phase 3C implements arrival only; 慕容秋荻 guard assignment remains next |
| TPR-006 | 主角剧情：开局 / 秋荻托付 | https://tpr.inkit.cc/tpr5:主角剧情#开局 | implementation | implemented | TPR-005 arrival completed | 52_yanziwu | 5200.lua, jshyl_qqzj_quest.lua | none | deferred 司南针/九转熊蛇丸 until item ids verified | qqzj_protagonist_opening_qiudi_guard_* | dialogue + 孟星魂 assigned flag implemented; no companion Join |
| TPR-007 | 主角剧情：开局 / 秋荻奖励 item audit | https://tpr.inkit.cc/tpr5:主角剧情#开局 | planning | implemented | TPR-006 | n/a | n/a | none | 九转熊蛇丸 id 16 verified; 司南针 missing; possible 罗盘 id 182 placeholder if approved | qqzj_protagonist_opening_qiudi_guard_reward_claimed | planning-only audit created in `TPR_007_QIUDI_REWARD_ITEM_AUDIT.md` |
| TPR-008 | 主角剧情：开局 / 秋荻 verified reward | https://tpr.inkit.cc/tpr5:主角剧情#开局 | implementation | implemented | TPR-007 | 52_yanziwu | jshyl_qqzj_quest.lua | none | 九转熊蛇丸 id 16 x10; 司南针 not granted | qqzj_protagonist_opening_qiudi_guard_reward_claimed | reward idempotency implemented; save-backed flag prevents duplicates |
| TPR-002 | 越女剑 | https://tpr.inkit.cc/tpr5:越女剑 | extraction | planned | TPR-000 | 昆仑仙境, TBD | TBD | TBD | 阿青 rewards TBD | TBD | current prototype must be compared against source page before marking coverage |
| TPR-003 | 逍遥御风 | https://tpr.inkit.cc/tpr5:逍遥御风 | extraction | planned | 天龙八部 dependency mapping | TBD | TBD | TBD | TBD | TBD | user previously requested 阿青/卓不凡 related storyline |
| TPR-004 | 侠客行 | https://tpr.inkit.cc/tpr5:侠客行 | extraction | planned | 越女剑/神雕 dependencies TBD | TBD | TBD | TBD | TBD | TBD | user previously referenced 侠客岛/Aqing finale |

## Page Implementation Template

For each page:

```text
1. inventory row complete
2. extraction schema filled
3. dependency graph reviewed
4. smallest playable slice selected
5. target maps and Lua files named
6. reward idempotency flags defined
7. battle victory flags defined
8. Unity manual steps listed
9. implementation committed
10. verification notes added to COVERAGE_TRACKER.md
```

## Technical Backlog

| id | need | status | notes |
|---|---|---|---|
| TECH-001 | Create page extraction files per TPR page | planned | likely one markdown or yaml file per page under this directory in a future phase |
| TECH-002 | Decide how to represent cross-page dependency graph | planned | could be markdown tables first, then generated graph later |
| TECH-003 | Build repeatable Unity verification checklist per page | planned | must include save/load and no duplicate rewards |

## Rules

1. Keep each implementation slice small.
2. Prefer existing maps, battles, items, models, and helpers.
3. Do not modify engine C# for content coverage.
4. Do not mark `implemented` until files exist.
5. Do not mark `verified` until Unity behavior is confirmed.
