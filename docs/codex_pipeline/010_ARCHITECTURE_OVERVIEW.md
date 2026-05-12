# 010_ARCHITECTURE_OVERVIEW.md

## Updated Architecture

The expansion should be implemented as a MOD-contained, Lua-first narrative layer.

## Architecture Layers

### Layer 1 — Existing 群侠传启动 Platform

Existing platform provides:

- Unity runtime
- base assets
- map loading
- config loading
- battle system
- save system
- Lua VM / xLua bridge
- MOD loading and AssetBundle system

Do not replace these.

### Layer 2 — Qingqingzijin MOD Layer

Located at:

```text
Assets/Mods/jshyl/
```

Contains:

- Lua narrative runtime
- Config tables
- Game maps
- Battle maps
- BuildSource resources
- portraits
- generated assets
- dialogue/quest data

### Layer 3 — Narrative DSL Layer

Stored as Lua tables or config files under:

```text
Assets/Mods/jshyl/Lua/data/
```

The DSL describes:

- quests
- dialogue
- branches
- route locks
- rewards
- map triggers
- battles

## Important Change From Earlier Plan

Do not create a C# `NarrativeEventBus` as the default.

Instead implement:

```lua
JSHYL.QQZJ.EventBus
JSHYL.QQZJ.WorldFlags
JSHYL.QQZJ.QuestRuntime
JSHYL.QQZJ.DialogueRuntime
JSHYL.QQZJ.BranchResolver
```

## Optional Engine Fork Path

If a required feature cannot be implemented in Lua/configs, create a separate task for engine modification.

C# work must be treated as platform contribution, not normal MOD content.

## Main Runtime Flow

```text
Player enters map
  ↓
Scene BindScript Start() runs
  ↓
Lua scene script initializes dynamic objects and triggers
  ↓
Player interacts with trigger
  ↓
Lua quest function executes
  ↓
JSHYL.QQZJ runtime checks flags and quest state
  ↓
Dialogue / battle / reward / map mutation occurs
  ↓
SetFlagInt + ModifyEvent + JSHYL.QQZJ state are updated
  ↓
Save persists state through existing game mechanisms
```
