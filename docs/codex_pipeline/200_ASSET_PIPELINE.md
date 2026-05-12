# 200_ASSET_PIPELINE.md

# Asset Pipeline

## Goal

Support missing content through a controlled asset request system.

## Asset Categories

```text
Portrait
Avatar
NPCPrefab
BattleBackground
MapIcon
ItemIcon
CutsceneIllustration
VoicePlaceholder
```

## Asset Resolution Order

1. Existing JYNew asset
2. Existing reusable similar asset
3. Placeholder asset
4. AI-generated asset request
5. Human-created final asset

## Asset Request Schema

```yaml
asset_id: portrait_lin_pingzhi_young
type: Portrait
character_id: lin_pingzhi
priority: high
status: requested

prompt:
  style: wuxia rpg portrait
  description: young Han Chinese swordsman, tragic expression, scholar-warrior bearing
  constraints:
    - no modern clothing
    - consistent with existing jynew art style

fallback:
  use_placeholder: true
```

## Codex Rules

Codex should create asset request files, not binary image assets.

Generated images should be produced by a separate art pipeline.

## Acceptance Criteria

- Missing assets are detected.
- Asset requests are generated.
- Quests can use placeholders.
- Runtime does not break when final art is missing.
