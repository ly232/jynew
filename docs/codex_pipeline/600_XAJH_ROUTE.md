# 600_XAJH_ROUTE.md

# 笑傲江湖 Route Overview

## Goal

Implement 笑傲江湖 as a route family with multiple branches.

## Route Themes

- 福威镖局旧案
- 华山派 conflict
- 林平之 revenge arc
- 任盈盈 companion arc
- 正邪路线分歧

## Route Flags

```yaml
xajh_started: false
xajh_ch1_completed: false
lin_pingzhi_met: false
lin_pingzhi_joined: false
lin_pingzhi_darkened: false
yue_lingshan_met: false
yue_lingshan_alive: true
ren_yingying_met: false
ren_yingying_joined: false
xajh_route: none
```

## Branches

```text
xajh_righteous
xajh_dark
xajh_renyingying
xajh_linpingzhi_revenge
```

## Chapter Files

```text
601_XAJH_CH1_FUZHOU.md
602_XAJH_CH2_HENGSHAN.md
```

## Acceptance Criteria

- Route has explicit flags.
- Branches are locked/unlocked by data.
- Quest files can be implemented independently.
