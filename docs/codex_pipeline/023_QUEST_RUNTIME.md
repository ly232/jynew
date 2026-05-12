# 023_QUEST_RUNTIME.md

# Quest Runtime

## Goal

Build a data-driven quest runtime that can express branching 金书红颜录-style story content.

## Quest Lifecycle

```text
NotStarted
Available
Active
Completed
Failed
Locked
```

## Quest Schema

```yaml
quest_id: xajh_ch1_fuzhou
title: 福州旧案
category: RouteStory
route: xajh

requirements:
  all:
    - flag: intro_completed
      equals: true

trigger:
  type: NPC_INTERACTION
  map_id: fuzhou
  npc_id: lin_pingzhi

steps:
  - step_id: talk_to_lin_pingzhi
    type: DIALOGUE
    dialogue_id: DLG_XAJH_001

  - step_id: qingcheng_ambush
    type: BATTLE
    battle_id: BTL_XAJH_QINGCHENG_001

  - step_id: receive_clue
    type: REWARD
    rewards:
      items:
        - clue_fuwei_bia局

completion:
  emit_events:
    - event_type: QUEST_COMPLETED
      payload:
        quest_id: xajh_ch1_fuzhou
    - event_type: SET_FLAG
      payload:
        flag: xajh_ch1_completed
        value: true
```

## Trigger Types

Support:

```text
NPC_INTERACTION
MAP_ENTER
ITEM_OBTAINED
BATTLE_COMPLETED
FLAG_CHANGED
CUTSCENE_COMPLETED
```

## Step Types

Support:

```text
DIALOGUE
BATTLE
CUTSCENE
GIVE_ITEM
REMOVE_ITEM
ADD_COMPANION
REMOVE_COMPANION
SET_LOCATION
WAIT_FOR_FLAG
```

## Route Locking

Quest completion may lock incompatible branches.

```yaml
locks:
  - xajh_dark_route
```

## Acceptance Criteria

- Quests load from data.
- Quest steps execute sequentially.
- Quest steps can branch.
- Quest state persists across saves.
- Quest completion emits events.
