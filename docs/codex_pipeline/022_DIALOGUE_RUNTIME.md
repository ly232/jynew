# 022_DIALOGUE_RUNTIME.md

# Dialogue Runtime

## Goal

Add a data-driven branching dialogue system suitable for a large wuxia RPG.

## Requirements

Dialogue must support:

- speaker
- portrait
- text
- choices
- conditions
- actions
- world flag changes through events
- battle triggers
- quest step completion
- cutscene hooks

## Dialogue Node Schema

```yaml
dialogue_id: DLG_XAJH_001

nodes:
  - id: start
    speaker: lin_pingzhi
    portrait: portrait_lin_pingzhi_young
    text: "少侠，青城派欺人太甚，我林家已无路可退。"
    choices:
      - text: "我帮你查明真相。"
        next: accept_help
        actions:
          - type: EMIT_EVENT
            event_type: QUEST_STEP_COMPLETED
            payload:
              quest_id: xajh_ch1_fuzhou
              step_id: talk_to_lin_pingzhi

      - text: "此事与我无关。"
        next: refuse_help

  - id: accept_help
    speaker: lin_pingzhi
    text: "多谢少侠。"

  - id: refuse_help
    speaker: lin_pingzhi
    text: "既然如此，在下不敢强求。"
```

## Conditional Choices

```yaml
choices:
  - text: "盈盈，你怎么看？"
    conditions:
      all:
        - flag: ren_yingying_joined
          equals: true
    next: ren_yingying_reaction
```

## Runtime Actions

Supported actions:

```text
EMIT_EVENT
START_QUEST
COMPLETE_QUEST_STEP
START_BATTLE
GIVE_ITEM
REMOVE_ITEM
START_CUTSCENE
CHANGE_MAP
ADD_COMPANION
REMOVE_COMPANION
```

## Portrait Strategy

Use existing portraits first.

If missing, create an asset request:

```yaml
asset_request:
  type: portrait
  character_id: lin_pingzhi
  style: wuxia_rpg_portrait
```

## Acceptance Criteria

- Dialogue can load from data.
- Dialogue can branch.
- Choices can be hidden by conditions.
- Dialogue actions can emit narrative events.
- Dialogue can trigger battles and quest advancement.
