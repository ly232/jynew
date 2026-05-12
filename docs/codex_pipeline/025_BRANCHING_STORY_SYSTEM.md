# 025_BRANCHING_STORY_SYSTEM.md

# Branching Story System

## Goal

Support large-scale mutually exclusive and conditional route branching.

## Branch Types

```text
MainRoute
BookRoute
CompanionRoute
RomanceRoute
FactionRoute
HiddenRoute
EndingRoute
```

## Route Definition Schema

```yaml
route_id: xajh_righteous
title: 笑傲江湖正线

requirements:
  all:
    - flag: xajh_ch1_completed
      equals: true

locks:
  - xajh_dark

unlocks:
  - xajh_ch2_hengshan
```

## Branch Evaluation

BranchResolver should evaluate:

- requirements
- locks
- prerequisites
- hidden conditions
- companion availability
- ending eligibility

## Conflict Rules

When a route is selected:

1. Emit `ROUTE_SELECTED`.
2. Lock incompatible routes.
3. Update world flags.
4. Refresh available quests.

## Example

```yaml
route_id: xajh_dark
requirements:
  all:
    - flag: lin_pingzhi_darkened
      equals: true
    - flag: yue_lingshan_dead
      equals: true
locks:
  - xajh_righteous
```

## Acceptance Criteria

- Selecting one route locks incompatible routes.
- Hidden routes unlock only when conditions are satisfied.
- Quest availability updates after branch changes.
