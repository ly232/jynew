# 602_XAJH_CH2_HENGSHAN.md

# 笑傲江湖 Chapter 2 — 衡山风波

## Scope

Implement the second 笑傲江湖 chapter.

## Required Prior Chapter

```yaml
xajh_ch1_completed: true
```

## New Flags

```yaml
xajh_ch2_started: false
yue_lingshan_met: false
hengshan_incident_resolved: false
xajh_ch2_completed: false
```

## Quest

```yaml
quest_id: xajh_ch2_hengshan
title: 衡山风波
category: RouteStory
route: xajh

requirements:
  all:
    - flag: xajh_ch1_completed
      equals: true

trigger:
  type: MAP_ENTER
  map_id: hengshan

steps:
  - step_id: meet_huashan_party
    type: DIALOGUE
    dialogue_id: DLG_XAJH_HENGSHAN_001

  - step_id: faction_conflict
    type: BATTLE
    battle_id: BTL_XAJH_HENGSHAN_001

  - step_id: route_hint_dialogue
    type: DIALOGUE
    dialogue_id: DLG_XAJH_HENGSHAN_002

completion:
  emit_events:
    - event_type: SET_FLAG
      payload:
        flag: xajh_ch2_completed
        value: true
```

## Branch Hints

This chapter should foreshadow:

- Huashan politics
- Lin Pingzhi's revenge
- future 任盈盈 route

## Acceptance Criteria

- Hengshan quest unlocks only after Chapter 1.
- Dialogue can reference Lin Pingzhi state.
- Quest sets `xajh_ch2_completed`.
