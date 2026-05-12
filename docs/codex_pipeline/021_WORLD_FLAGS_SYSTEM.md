# 021_WORLD_FLAGS_SYSTEM.md

# World Flags System

## Goal

Implement a global queryable registry for narrative state.

World flags are the primary way that quests, dialogues, NPC spawns, and route locks communicate.

## Flag Types

Support at least:

```text
bool
int
string
enum-like string
```

## Examples

```yaml
lin_pingzhi_met: true
lin_pingzhi_joined: false
ren_yingying_affection: 35
current_xajh_route: righteous
bixie_sword_manual_obtained: true
```

## Categories

### Character Flags

```text
character.met
character.joined
character.alive
character.location
character.affection
character.route_state
```

### Route Flags

```text
route.started
route.locked
route.completed
route.selected
```

### Item Flags

```text
item.obtained
manual.learned
weapon.obtained
```

### Global Flags

```text
chapter.completed
ending.unlocked
world.phase
```

## Query Schema

Quest and dialogue data should express conditions as data:

```yaml
conditions:
  all:
    - flag: lin_pingzhi_met
      equals: true
    - flag: xajh_ch1_completed
      equals: true
  none:
    - flag: xajh_dark_route_locked
      equals: true
```

## C# API

Suggested API:

```csharp
bool GetBool(string key);
int GetInt(string key);
string GetString(string key);

void SetBool(string key, bool value);
void SetInt(string key, int value);
void SetString(string key, string value);

bool Evaluate(NarrativeCondition condition);
```

## Debugging Tool

Codex should add a simple debug view or log utility that prints:

- all flags
- changed flags
- flags changed by latest event

## Acceptance Criteria

- Flags can be set by reducer.
- Dialogue can query flags.
- Quest requirements can query flags.
- Flags persist in save files.
