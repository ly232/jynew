# 400_STORY_GLOBAL_TIMELINE.md

## Goal

Define the high-level story sequencing model for 金书红颜录5《青青子衿》 adaptation.

## High-Level Structure

```text
Intro
  ↓
Early Jianghu Routes
  ↓
Fourteen Book Routes
  ↓
Companion/Relationship Branches
  ↓
Late Global Convergence
  ↓
Ending Selection
```

## Route Categories

```text
main_character_route
xajh_route
ldj_route
tlbb_route
sdxl_route
shediao_route
shendiao_route
yitian_route
bixuejian_route
fei_route
xueshan_route
liancheng_route
shuke_route
yuanyangdao_route
sidequests
```

## Global State Flags

Use prefix:

```text
qqzj_global_
```

Examples:

```text
qqzj_global_intro_completed
qqzj_global_all_books_completed
qqzj_global_final_route_unlocked
```

## Implementation Rule

Do not implement all routes at once.

Start with:

```text
Intro + one short route vertical slice
```

Recommended first vertical slice:

```text
main_intro
xajh_ch1
```
