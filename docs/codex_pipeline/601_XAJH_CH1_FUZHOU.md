# 601_XAJH_CH1_FUZHOU.md

# 笑傲江湖 Chapter 1 — 福州旧案

## Scope

Implement the first 笑傲江湖 quest chapter.

## Required Systems

- QuestRuntime
- DialogueRuntime
- WorldFlags
- EventBus
- BattleAdapter
- InventoryAdapter

## New Flags

```yaml
xajh_started: false
lin_pingzhi_met: false
fuwei_case_started: false
qingcheng_ambush_defeated: false
xajh_ch1_completed: false
```

## Quest

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
  type: MAP_ENTER
  map_id: fuzhou

steps:
  - step_id: meet_lin_pingzhi
    type: DIALOGUE
    dialogue_id: DLG_XAJH_FUZHOU_001

  - step_id: qingcheng_ambush
    type: BATTLE
    battle_id: BTL_XAJH_QINGCHENG_001

  - step_id: post_battle_dialogue
    type: DIALOGUE
    dialogue_id: DLG_XAJH_FUZHOU_002

completion:
  emit_events:
    - event_type: SET_FLAG
      payload:
        flag: xajh_ch1_completed
        value: true
```

## Dialogue Stub

```yaml
dialogue_id: DLG_XAJH_FUZHOU_001
nodes:
  - id: start
    speaker: lin_pingzhi
    text: "少侠，青城派欺人太甚，我林家只怕大祸临头。"
    choices:
      - text: "我随你去看看。"
        next: accept
      - text: "江湖恩怨，与我无关。"
        next: refuse
```

## Battle Stub

```yaml
battle_id: BTL_XAJH_QINGCHENG_001
enemy_group:
  - qingcheng_disciple_001
  - qingcheng_disciple_002
reward:
  exp: 100
```

## Asset Requests

```yaml
- portrait_lin_pingzhi_young
- avatar_qingcheng_disciple
```

## Acceptance Criteria

- Entering Fuzhou after intro triggers the quest.
- Lin Pingzhi dialogue appears.
- Battle starts and completes.
- Quest completion sets `xajh_ch1_completed`.
