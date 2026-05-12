# 800_SIDEQUESTS.md

# Sidequests

## Goal

Provide a reusable structure for important sidequests.

## Sidequest Types

```text
Companion recruitment
Martial art manual
Weapon acquisition
Faction reputation
Hidden romance condition
Optional boss
```

## Sidequest Schema

```yaml
quest_id: side_manual_bixie
title: 辟邪剑谱线索
category: SideQuest

requirements:
  all:
    - flag: xajh_ch1_completed
      equals: true

steps:
  - step_id: find_clue
    type: DIALOGUE
    dialogue_id: DLG_SIDE_BIXIE_001

rewards:
  items:
    - clue_bixie_manual
```

## Acceptance Criteria

- Sidequests can depend on route flags.
- Sidequests can unlock hidden conditions.
- Sidequests can be completed independently.
