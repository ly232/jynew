# 701_LDJ_CH1_YANGZHOU.md

# 鹿鼎记 Chapter 1 — 扬州初遇

## Scope

Implement the first 鹿鼎记 chapter.

## Requirements

```yaml
intro_completed: true
```

## New Flags

```yaml
ldj_started: false
wei_xiaobao_met: false
ldj_yangzhou_completed: false
```

## Quest

```yaml
quest_id: ldj_ch1_yangzhou
title: 扬州初遇
category: RouteStory
route: ldj

requirements:
  all:
    - flag: intro_completed
      equals: true

trigger:
  type: MAP_ENTER
  map_id: yangzhou

steps:
  - step_id: meet_wei_xiaobao
    type: DIALOGUE
    dialogue_id: DLG_LDJ_YANGZHOU_001

  - step_id: tavern_conflict
    type: BATTLE
    battle_id: BTL_LDJ_TAVERN_001

  - step_id: post_conflict
    type: DIALOGUE
    dialogue_id: DLG_LDJ_YANGZHOU_002

completion:
  emit_events:
    - event_type: SET_FLAG
      payload:
        flag: wei_xiaobao_met
        value: true
    - event_type: SET_FLAG
      payload:
        flag: ldj_yangzhou_completed
        value: true
```

## Tone

鹿鼎记 route should allow more comedic dialogue than 笑傲江湖 route.

## Acceptance Criteria

- Yangzhou triggers quest.
- Wei Xiaobao appears.
- Battle completes.
- Route flags are set.
