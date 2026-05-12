# 302_PREFAB_REUSE.md

# Prefab Reuse Strategy

## Goal

Reuse existing JYNew art and prefabs before requesting new assets.

## Reuse Rules

1. Exact character prefab if available.
2. Same faction generic prefab.
3. Similar weapon-style prefab.
4. Generic wuxia NPC prefab.
5. Placeholder.
6. Asset request.

## Prefab Mapping Schema

```yaml
character_id: lin_pingzhi
preferred_prefab: prefab_lin_pingzhi
fallback_prefabs:
  - prefab_generic_young_swordsman
  - prefab_generic_male_wuxia
asset_request_if_missing: avatar_lin_pingzhi_young
```

## Codex Task

Codex should create or update:

```text
Assets/Narrative/AssetRequests/prefab_mapping.yaml
```

## Acceptance Criteria

- Missing prefabs do not crash quests.
- Major characters have explicit mappings.
- Minor NPCs can use generic prefabs.
