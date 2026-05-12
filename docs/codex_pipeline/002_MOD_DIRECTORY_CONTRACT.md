# 002_MOD_DIRECTORY_CONTRACT.md

## Goal

Define the exact MOD directory layout Codex must follow.

## Required Built-In Directories

```text
Assets/Mods/qingqingzijin/
    BuildSource/
    Configs/
    Lua/
    Maps/
        BattlesMaps/
        GameMaps/
    ModAssets/
    Skills/
    ModSettings.asset
```

## Directory Responsibilities

### BuildSource

Dynamic runtime resources that can override or extend platform BuildSource resources.

Use for:

```text
BuildSource/heads/
BuildSource/Musics/
BuildSource/sound/
BuildSource/ModelCharacters/
```

### Configs

Excel configuration tables:

```text
角色.xlsx
武功.xlsx
物品.xlsx
场景.xlsx
战斗.xlsx
```

### Lua

MOD scripts:

```text
Lua/main_qingqingzijin.lua
Lua/runtime/
Lua/scenes/
Lua/quests/
Lua/routes/
Lua/data/
```

### Maps

```text
Maps/GameMaps/
Maps/BattlesMaps/
```

### ModAssets

New model prefabs or prefab overrides.

### Skills

New skill display prefabs or overrides.

## Important Rule

Do not place generated MOD resources in random project locations. All new MOD content must live under:

```text
Assets/Mods/qingqingzijin/
```

unless explicitly reusing existing base assets.

## Prompt To Codex

```text
Read:
AGENTS.md
docs/codex_pipeline/002_MOD_DIRECTORY_CONTRACT.md

Task:
Create the required directory skeleton for Assets/Mods/qingqingzijin if missing.

Allowed:
Assets/Mods/qingqingzijin/**

Forbidden:
Assets/BuildSource/**
Assets/Scripts/**
ProjectSettings/**

Do not add runtime logic yet.
```
