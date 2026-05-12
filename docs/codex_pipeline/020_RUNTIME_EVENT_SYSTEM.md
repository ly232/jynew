# 020_RUNTIME_EVENT_SYSTEM.md

# Runtime Event System

## Goal

Implement a narrative event system that records every meaningful narrative mutation as an event.

## Core Types

Codex should implement or adapt these C# concepts:

```csharp
NarrativeEvent
NarrativeEventBus
NarrativeEventStore
NarrativeReducer
NarrativeEventType
NarrativeEventPayload
```

## Event Shape

Use a serializable structure similar to:

```yaml
event_id: EVT_000001
source_id: quest_xajh_ch1_001
event_type: CHARACTER_JOINED
timestamp: 123456
payload:
  character_id: lin_pingzhi
```

## Required Event Types

### Quest Events

```text
QUEST_STARTED
QUEST_STEP_COMPLETED
QUEST_COMPLETED
QUEST_FAILED
QUEST_LOCKED
```

### Character Events

```text
CHARACTER_JOINED
CHARACTER_LEFT
CHARACTER_DIED
CHARACTER_RELATION_CHANGED
CHARACTER_LOCATION_CHANGED
```

### Inventory Events

```text
ITEM_OBTAINED
ITEM_REMOVED
MARTIAL_ART_LEARNED
WEAPON_OBTAINED
```

### Route Events

```text
ROUTE_SELECTED
ROUTE_LOCKED
ROUTE_UNLOCKED
ENDING_UNLOCKED
```

### Cutscene Events

```text
CUTSCENE_STARTED
CUTSCENE_COMPLETED
```

## Event Bus Requirements

The event bus must:

- emit events
- allow listeners to subscribe by type
- store emitted events
- replay events into reducers
- expose debug logs
- support save serialization

## Reducer Requirements

Reducers must update:

- world flags
- quest states
- route states
- character availability
- ending eligibility

## Suggested Implementation Steps for Codex

1. Search existing project for event/message systems.
2. If one exists, wrap it with a narrative-specific adapter.
3. If none exists, create a small standalone narrative event bus.
4. Add unit tests or editor validation methods.
5. Add debug output for event history.

## Acceptance Criteria

- A quest can emit `QUEST_STARTED`.
- A character join event can set a world flag.
- Event history can be serialized.
- Replaying events rebuilds the same world flags.
