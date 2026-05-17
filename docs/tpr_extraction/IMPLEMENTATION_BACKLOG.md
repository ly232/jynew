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
| TPR-009 | 主角剧情：开局 / 二叔三叔 briefing hooks | https://tpr.inkit.cc/tpr5:主角剧情#开局 | planning | implemented | TPR-008 | 52_yanziwu now; 杭州/开封 maps missing | reuse 5200.lua + jshyl_qqzj_quest.lua for TPR-009A; future 5206/5207 if NPCs added | none | defer 狼牙燕翎/秦皇照骨镜/洛阳铲 until item ids verified | qqzj_protagonist_opening_family_briefing_* | planning doc created; safe slice selected as dialogue/flags-only hooks, no real maps |
| TPR-009A | 主角剧情：开局 / 二叔三叔 narrative hooks | https://tpr.inkit.cc/tpr5:主角剧情#开局 | implementation | implemented | TPR-009, qiudi guard completed | 52_yanziwu only | jshyl_qqzj_quest.lua via existing 5200.lua dispatch | none | none; route tools deferred | qqzj_protagonist_opening_family_briefing_started; qqzj_protagonist_opening_family_briefing_dialogue_seen; qqzj_protagonist_opening_family_briefing_hangzhou_hook_unlocked; qqzj_protagonist_opening_family_briefing_kaifeng_hook_unlocked; qqzj_protagonist_opening_family_briefing_completed | implemented as narrative-only briefing; no actual 杭州/开封 map unlocks |
| TPR-010 | 主角剧情：开局 / remaining opening plan | https://tpr.inkit.cc/tpr5:主角剧情#开局 | planning | implemented | TPR-009A | 52_yanziwu; 水阁/chest/exit object verification needed | recommend TPR-010A via existing 5200.lua; future 5204/5205/scene-bound events TBD | 5205 currently uses battle 145; defer source coverage until verified | 大哥 reward ids partially unresolved; 玉真散 id 5 and 九转灵宝丸 id 14 are verified candidates | qqzj_protagonist_opening_brother_return_*; qqzj_protagonist_opening_shuige_*; qqzj_yanziwu_services_shijian_training_* | planning doc created in `TPR_010_OPENING_REMAINDER_PLAN.md`; next safe slice is 大哥 return dialogue-only |
| TPR-010A | 主角剧情：开局 / 大哥 return dialogue | https://tpr.inkit.cc/tpr5:主角剧情#开局 | implementation | implemented | TPR-010, family briefing completed | 52_yanziwu only | jshyl_qqzj_quest.lua via existing 5200.lua dispatch | none | none; 大哥 medicines deferred | qqzj_protagonist_opening_brother_return_started; qqzj_protagonist_opening_brother_return_dialogue_seen; qqzj_protagonist_opening_brother_return_completed | implemented as dialogue-only; reward_claimed intentionally remains unset until item audit |
| TPR-011 | 主角剧情：开局 / 大哥 reward item audit | https://tpr.inkit.cc/tpr5:主角剧情#开局 | planning | implemented | TPR-010A | n/a | n/a | none | 玉真散 id 5 and 九转灵宝丸 id 14 verified; 金创药/少阳丹/人参养荣丸 missing | qqzj_protagonist_opening_brother_return_reward_claimed | audit doc created in `TPR_011_BROTHER_RETURN_REWARD_ITEM_AUDIT.md`; recommend exact-partial reward only if approved |
| TPR-012 | 主角剧情：开局 / 大哥 verified partial reward | https://tpr.inkit.cc/tpr5:主角剧情#开局 | implementation | implemented | TPR-011, brother return dialogue completed | 52_yanziwu only | jshyl_qqzj_quest.lua via existing 5200.lua dispatch | none | 玉真散 id 5 x20; 九转灵宝丸 id 14 x20; 金创药/少阳丹/人参养荣丸 deferred | qqzj_protagonist_opening_brother_return_reward_claimed | reward is idempotent; existing TPR-010A saves can claim on repeated interaction |
| TPR-013 | 主角剧情：开局 / chain consolidation audit | https://tpr.inkit.cc/tpr5:主角剧情#开局 | planning | implemented | TPR-012 | 52_yanziwu | recommend next Lua-only refactor: 5205.lua + jshyl_qqzj_quest.lua | battle 145 exists but source fidelity unverified | no new rewards; preserve existing 银两 id 174 x500 if refactoring 5205 | qqzj_yanziwu_services_shijian_training_* | audit doc created in `TPR_013_OPENING_CHAIN_AUDIT.md`; 5200 remains thin but should not absorb more opening content |
| TPR-014 | 主角剧情：开局 / 侍剑 training refactor | https://tpr.inkit.cc/tpr5:主角剧情#开局 | implementation | implemented | TPR-013 | 52_yanziwu / jshyl_shijian_training | 5205.lua, jshyl_qqzj_quest.lua | battle 145 preserved; source fidelity unverified | existing 银两 id 174 x500 reward preserved and made idempotent | qqzj_protagonist_opening_shijian_training_started; qqzj_protagonist_opening_shijian_training_battle_won; qqzj_protagonist_opening_shijian_training_reward_claimed; qqzj_protagonist_opening_shijian_training_completed | 5205 is now a thin dispatcher; TODO remains for 主角武常 +20 API |
| TPR-015 | 主角剧情：开局 / 5202 treasure flow audit | https://tpr.inkit.cc/tpr5:主角剧情#开局 | planning | implemented | TPR-014 | 52_yanziwu / jshyl_yanzi_treasure | recommend next Lua-only refactor: 5202.lua + jshyl_qqzj_quest.lua | none | existing 银两 id 174 x30000 only; source 水阁/chest rewards unresolved | qqzj_yanziwu_treasure_silver_chest_* plus legacy jshyl_yanzi_treasure_taken | audit doc created in `TPR_015_5202_TREASURE_FLOW_AUDIT.md`; do not mark as full 水阁宝箱 coverage |
| TPR-016 | 主角剧情：开局 / 5202 silver chest refactor | https://tpr.inkit.cc/tpr5:主角剧情#开局 | implementation | implemented | TPR-015 | 52_yanziwu / jshyl_yanzi_treasure | 5202.lua, jshyl_qqzj_quest.lua | none | existing 银两 id 174 x30000 preserved; no new chest content | qqzj_yanziwu_treasure_silver_chest_started; qqzj_yanziwu_treasure_silver_chest_reward_claimed; qqzj_yanziwu_treasure_silver_chest_completed; legacy jshyl_yanzi_treasure_taken | 5202 is now a thin dispatcher; legacy flag migration prevents duplicate silver in old saves; not full 水阁宝箱 coverage |
| TPR-017 | 主角剧情：开局 / coverage checkpoint | https://tpr.inkit.cc/tpr5:主角剧情#开局 | planning | implemented | TPR-016 | 52_yanziwu; 杭州/开封/水阁 availability still unverified | n/a | battle 145 source fidelity still unverified | item audit still needed for family tools, missing medicines, 水阁 rewards, 明玉丹 | n/a | checkpoint doc created in `TPR_017_OPENING_COVERAGE_CHECKPOINT.md`; keep section `partially_implemented`; recommended next tasks: TPR-018 item audit, TPR-019 scene binding audit, TPR-020 还施水阁 entry slice |
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
