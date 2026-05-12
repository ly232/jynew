# 500_MAIN_CHARACTER_ROUTE.md

# Main Character Route

## Goal

Implement the player protagonist's central progression route.

## Narrative Role

The main character route acts as the spine that connects all book routes and companion routes.

## Core Flags

```yaml
intro_completed: false
protagonist_identity_revealed: false
first_companion_joined: false
jianghu_phase: 0
```

## Quest Chain

```text
MC_001_INTRO
MC_002_FIRST_JIANGHU_ENTRY
MC_003_FIRST_ROUTE_UNLOCK
MC_004_ROUTE_CONVERGENCE
MC_005_FINAL_ALIGNMENT
```

## Quest Example

```yaml
quest_id: mc_001_intro
title: 初入江湖
category: MainStory

steps:
  - step_id: opening_dialogue
    type: DIALOGUE
    dialogue_id: DLG_MC_INTRO_001

  - step_id: receive_starting_items
    type: GIVE_ITEM
    items:
      - basic_sword
      - minor_healing_pill

completion:
  emit_events:
    - event_type: SET_FLAG
      payload:
        flag: intro_completed
        value: true
```

## Acceptance Criteria

- Intro can be completed.
- Intro unlocks early route quests.
- Main route state persists.
