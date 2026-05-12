# 202_NPC_GENERATION_PIPELINE.md

# NPC Generation Pipeline

## Goal

Support missing NPCs through structured metadata.

## NPC Definition Schema

```yaml
npc_id:
display_name:
faction:
role:
map_id:
default_position:
portrait_asset:
avatar_asset:
dialogue_id:
combat_profile:
availability_conditions:
```

## Example

```yaml
npc_id: qingcheng_disciple_001
display_name: 青城弟子
faction: qingcheng
role: enemy
map_id: fuzhou
portrait_asset: portrait_generic_qingcheng_disciple
avatar_asset: avatar_generic_swordsman
combat_profile: qingcheng_disciple_low
availability_conditions:
  all:
    - flag: xajh_ch1_started
      equals: true
```

## Codex Rules

- Prefer existing enemy prefabs.
- Generate metadata before generating new prefabs.
- Use generic NPCs for low-importance characters.
- Only request unique art for major characters.

## Acceptance Criteria

- Missing NPCs are represented in data.
- NPC spawning respects world flags.
- Generic fallbacks work.
