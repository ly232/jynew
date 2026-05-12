# 010_ARCHITECTURE_OVERVIEW.md

# Architecture Overview

## Objective

Add a narrative runtime layer to `jynew` that can support a 金书红颜录5《青青子衿》-style branching RPG without replacing the existing Unity project.

The key principle is:

> Keep the existing game systems. Add a new orchestration layer above them.

## Layered Architecture

```text
Existing JYNew Runtime
    ↑
Narrative Runtime Adapter
    ↑
Quest / Dialogue / Event Runtime
    ↑
Structured Narrative Data
    ↑
Guide / 攻略 Extraction
```

## Existing Runtime Layer

The existing Unity project likely already contains systems for:

- maps
- characters
- combat
- items
- martial arts
- UI
- save/load
- prefabs
- scenes

Codex should inspect the repo and reuse these whenever possible.

## New Narrative Runtime Layer

Add these systems:

```text
NarrativeEventBus
NarrativeReducer
WorldFlagRegistry
QuestManager
DialogueManager
BranchResolver
NarrativeSaveSerializer
AssetRequestRegistry
```

## Why Event Sourcing

Large wuxia route games have many hidden dependencies:

- whether a character has joined
- whether a character has died
- whether a route is locked
- whether a manual was obtained
- whether a faction was offended
- whether a romance branch is available

Direct mutation becomes hard to debug.

Instead:

```text
Quest emits event
Reducer updates world state
Runtime queries world state
```

## High-Level Data Flow

```text
Player action
    ↓
Quest trigger
    ↓
Quest step execution
    ↓
Dialogue / battle / item / cutscene
    ↓
Narrative events
    ↓
World flags update
    ↓
Branch availability changes
```

## Directory Plan

```text
Assets/Narrative/
    Events/
    Quests/
    Dialogues/
    Cutscenes/
    Routes/
    WorldFlags/
    AssetRequests/
```

## Non-Goals

Do not implement the entire 金书红颜录5 content in one pass.

Do not rewrite combat.

Do not rewrite the whole save system.

Do not hardcode route logic inside random MonoBehaviours.

## Acceptance Criteria

After this architecture is implemented:

- quests can start based on map/NPC/item triggers
- dialogue can branch based on world flags
- narrative events can update world flags
- save/load restores narrative progression
- route locks are deterministic
