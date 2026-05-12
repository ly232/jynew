# TPR Page Inventory

## Purpose

Track every TPR wiki page as an implementation unit for eventual full jshyl coverage.

The TPR start page states the wiki has 86 pages. This inventory is currently seeded from the visible start page and sitemap entries and must be expanded until all 86 pages have structured rows.

## Status Values

```text
not_inventoried
inventoried
extracted
implemented
verified
```

## Required Columns

Every row must include:

```text
page title
page url
category
route/book
status
dependencies
target maps
target Lua files
target battles
rewards/items
flags
notes
```

## Inventory Table

| page title | page url | category | route/book | status | dependencies | target maps | target Lua files | target battles | rewards/items | flags | notes |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 金书红颜录5 青青子衿 | https://tpr.inkit.cc/start | index | global | inventoried | none | TBD | TBD | TBD | TBD | TBD | start page and navigation hub; not gameplay coverage |
| 主角剧情 | https://tpr.inkit.cc/tpr5:主角剧情 | story_route | 主角 | inventoried | none | 52_yanziwu, TBD | TBD | TBD | TBD | TBD | full page still not fully extracted; opening section has separate extracted row |
| 主角剧情：开局 | https://tpr.inkit.cc/tpr5:主角剧情#开局 | story_section | 主角 | extracted | none | 52_yanziwu, 杭州城 hook, 开封 hook, TBD | opening event ids TBD, jshyl_qqzj_quest.lua | 侍剑/十二金钗 training TBD | 银子, 司南针, 九转熊蛇丸, 狼牙燕翎, 秦皇照骨镜, 洛阳铲, starter medicines, 水阁 chest rewards | qqzj_protagonist_opening_*; qqzj_yanziwu_services_* | extracted in docs/tpr_extraction/extractions/zhujuqinqing_opening.md; not implemented |
| 飞狐外传 / 雪山飞狐 | https://tpr.inkit.cc/tpr5:飞雪 | book_route | 飞雪 | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | start page groups 飞狐外传 and 雪山飞狐 |
| 程灵素线 | https://tpr.inkit.cc/tpr5:程灵素线 | route_branch | 飞雪 | inventoried | 飞雪 | TBD | TBD | TBD | TBD | TBD | sidebar label: 灵素 |
| 楚倾眉线 | https://tpr.inkit.cc/tpr5:楚倾眉线 | route_branch | 飞雪 | inventoried | 飞雪 | TBD | TBD | TBD | TBD | TBD | sidebar label: 楚袁 |
| 连城诀 | https://tpr.inkit.cc/tpr5:连城诀 | book_route | 连城诀 | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | current version page; older version pages also listed |
| 天龙八部 | https://tpr.inkit.cc/tpr5:天龙八部 | book_route | 天龙八部 | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | parent page for multiple 天龙 arcs |
| 大理风云 | https://tpr.inkit.cc/tpr5:大理风云 | route_chapter | 天龙八部 | inventoried | 天龙八部 | TBD | TBD | TBD | TBD | TBD | sitemap route chapter |
| 五凤驸马 | https://tpr.inkit.cc/tpr5:五凤驸马 | route_chapter | 天龙八部 | inventoried | 天龙八部 | TBD | TBD | TBD | TBD | TBD | sitemap route chapter |
| 逍遥御风 | https://tpr.inkit.cc/tpr5:逍遥御风 | route_chapter | 天龙八部 | inventoried | 天龙八部 | TBD | TBD | TBD | TBD | TBD | user previously referenced 万仙大会/Aqing content here |
| 雁北天戈 | https://tpr.inkit.cc/tpr5:雁北天戈 | route_chapter | 天龙八部 | inventoried | 天龙八部 | TBD | TBD | TBD | TBD | TBD | sitemap route chapter |
| 射雕英雄传 | https://tpr.inkit.cc/tpr5:射雕英雄传 | book_route | 射雕英雄传 | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | main book route |
| 白马啸西风 | https://tpr.inkit.cc/tpr5:白马啸西风 | book_route | 白马啸西风 | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | main book route |
| 鹿鼎记 | https://tpr.inkit.cc/tpr5:鹿鼎记 | book_route | 鹿鼎记 | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | parent page for 神龙/天地 branches |
| 神龙教线 | https://tpr.inkit.cc/tpr5:神龙教线 | route_branch | 鹿鼎记 | inventoried | 鹿鼎记 | TBD | TBD | TBD | TBD | TBD | start/sidebar branch |
| 天地会线 | https://tpr.inkit.cc/tpr5:天地会线 | route_branch | 鹿鼎记 | inventoried | 鹿鼎记 | TBD | TBD | TBD | TBD | TBD | start/sidebar branch |
| 笑傲江湖 | https://tpr.inkit.cc/tpr5:笑傲江湖 | book_route | 笑傲江湖 | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | parent page for 日月/五岳 branches |
| 日月线 | https://tpr.inkit.cc/tpr5:日月线 | route_branch | 笑傲江湖 | inventoried | 笑傲江湖 | TBD | TBD | TBD | TBD | TBD | start/sidebar branch |
| 万岳朝宗 | https://tpr.inkit.cc/tpr5:万岳朝宗 | route_branch | 笑傲江湖 | inventoried | 笑傲江湖 | TBD | TBD | TBD | TBD | TBD | sidebar label: 五岳 |
| 书剑恩仇录 | https://tpr.inkit.cc/tpr5:书剑恩仇录 | book_route | 书剑恩仇录 | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | parent page for 青桐/沅芷 branches |
| 霍青桐、喀丝丽线 | https://tpr.inkit.cc/tpr5:霍青桐、喀丝丽线 | route_branch | 书剑恩仇录 | inventoried | 书剑恩仇录 | TBD | TBD | TBD | TBD | TBD | sidebar label: 青桐 |
| 李沅芷、骆冰线 | https://tpr.inkit.cc/tpr5:李沅芷、骆冰线 | route_branch | 书剑恩仇录 | inventoried | 书剑恩仇录 | TBD | TBD | TBD | TBD | TBD | sidebar label: 沅芷 |
| 神雕侠侣 | https://tpr.inkit.cc/tpr5:神雕侠侣 | book_route | 神雕侠侣 | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | user previously referenced 阿青觉醒 dependencies |
| 侠客行 | https://tpr.inkit.cc/tpr5:侠客行 | book_route | 侠客行 | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | user previously referenced 侠客岛/Aqing finale dependencies |
| 倚天屠龙记 | https://tpr.inkit.cc/tpr5:倚天屠龙记 | book_route | 倚天屠龙记 | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | parent page for 武当/圣火/蒙古 |
| 武当风云 | https://tpr.inkit.cc/tpr5:武当风云 | route_branch | 倚天屠龙记 | inventoried | 倚天屠龙记 | TBD | TBD | TBD | TBD | TBD | start/sidebar branch |
| 光明圣火 | https://tpr.inkit.cc/tpr5:光明圣火 | route_branch | 倚天屠龙记 | inventoried | 倚天屠龙记 | TBD | TBD | TBD | TBD | TBD | start page labels 圣火/明教 |
| 蒙古秘史 | https://tpr.inkit.cc/tpr5:蒙古秘史 | route_branch | 倚天屠龙记 | inventoried | 倚天屠龙记 | TBD | TBD | TBD | TBD | TBD | start/sidebar branch |
| 碧血剑 | https://tpr.inkit.cc/tpr5:碧血剑 | book_route | 碧血剑 | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | current version page |
| 鸳鸯刀 | https://tpr.inkit.cc/tpr5:鸳鸯刀 | book_route | 鸳鸯刀 | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | current version page |
| 越女剑 | https://tpr.inkit.cc/tpr5:越女剑 | book_route | 越女剑 | inventoried | TBD | 昆仑仙境, TBD | TBD | TBD | TBD | TBD | current jshyl 阿青 prototype is not yet TPR-complete coverage |
| 重要支线 | https://tpr.inkit.cc/tpr5:重要支线 | reference_quests | global | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | sidequest dependency source |
| 场景探索/TIPs | https://tpr.inkit.cc/tpr5:场景探索 | reference_maps | global | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | map and exploration data |
| 店铺卖货 | https://tpr.inkit.cc/tpr5:店铺卖货 | reference_items | global | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | shop/economy reference |
| 麒麟星落 | https://tpr.inkit.cc/tpr5:麒麟星落 | reference_system | global | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | system/reference page |
| 轻功、内功、特技 | https://tpr.inkit.cc/tpr5:轻功、内功、特技 | reference_skills | global | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | skill/item extraction source |
| 武功获取整理 | https://tpr.inkit.cc/tpr5:武功获取 | reference_skills | global | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | skill rewards and dependencies |
| 大绝合成 | https://tpr.inkit.cc/tpr5:大绝 | reference_skills | global | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | skill synthesis reference |
| 装备获取整理 | https://tpr.inkit.cc/tpr5:装备获取 | reference_items | global | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | equipment reward source |
| 套装获取整理 | https://tpr.inkit.cc/tpr5:套装获取 | reference_items | global | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | set equipment source |
| 天赋整理 | https://tpr.inkit.cc/tpr5:天赋整理 | reference_system | global | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | character progression reference |
| 称号整理 | https://tpr.inkit.cc/tpr5:称号整理 | reference_system | global | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | title system reference |
| 洗武功整理 | https://tpr.inkit.cc/tpr5:洗武功整理 | reference_skills | global | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | skill overwrite rules |
| 主角相关 | https://tpr.inkit.cc/tpr5:主角相关 | reference_character | 主角 | inventoried | 主角剧情 | TBD | TBD | TBD | TBD | TBD | protagonist rules |
| 卡片解锁、队友收集 | https://tpr.inkit.cc/tpr5:卡片解锁、队友收集 | reference_companions | global | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | start page says pending edit |
| 地图 | https://tpr.inkit.cc/tpr5:地图 | reference_maps | global | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | map index/reference |
| 战报 | https://tpr.inkit.cc/tpr5:战报 | reference_other | global | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | likely non-gameplay reference |
| 称号考究 | https://tpr.inkit.cc/tpr5:称号考究 | reference_lore | global | inventoried | TBD | TBD | TBD | TBD | TBD | TBD | lore/reference |

## Pages Still To Inventory

The sitemap also exposes versioned/archival pages and namespaces that may or may not become implementation units. They remain `not_inventoried` until a future pass decides how to treat them:

```text
tpr5:bak
tpr5:data
tpr5:other
tpr5:test
tpr5:碧血剑(5.44e)
tpr5:碧血剑(5.51b)
tpr5:碧血剑5.5剧情预告
tpr5:笑傲江湖(5.44e)
tpr5:笑傲江湖(5.51b)
tpr5:连城诀(5.44e)
tpr5:连城诀(5.52j)
tpr5:鸳鸯刀(5.44e)
tpr5:鸳鸯刀(5.52j)
tpr5:修订笔记
tpr5:路线查看器
wiki namespace pages
讨论板 namespace pages
```

Future inventory work must reconcile this list with the wiki's 86-page count.
