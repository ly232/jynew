# 300_JYNEW_INTEGRATION.md

# JYNew Integration

## Goal

Integrate the narrative runtime into the existing Unity project with minimal disruption.

## First Step for Codex

Codex must inspect the repo and identify:

```text
existing character system
existing battle trigger system
existing map/scene system
existing inventory system
existing save system
existing UI/dialogue system
existing data loading pattern
```

## Integration Strategy

Add adapter interfaces:

```csharp
ICharacterAdapter
IBattleAdapter
IInventoryAdapter
IMapAdapter
ISaveAdapter
IDialogueUIAdapter
```

Narrative runtime should depend on adapters, not directly on legacy internals.

## Example Flow

```text
Quest step: START_BATTLE
    ↓
QuestRuntime
    ↓
IBattleAdapter.StartBattle(battleId)
    ↓
Existing JYNew battle system
```

## Directory Recommendation

```text
Assets/Scripts/Narrative/
Assets/Narrative/
```

## Acceptance Criteria

- Narrative runtime can call existing battle system.
- Narrative runtime can grant existing items.
- Narrative runtime can spawn or show existing NPCs.
- Existing gameplay still works.
