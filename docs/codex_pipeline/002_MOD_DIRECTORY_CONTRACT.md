# 002_MOD_DIRECTORY_CONTRACT.md

## Goal

Define the exact MOD directory layout Codex must follow.

## Required Built-In Directories

```text
Assets/Mods/jshyl/
    BuildSource/
    Configs/
    Lua/
    Maps/
        BattlesMaps/
        GameMaps/
    ModAssets/
    Skills/
    ModSetting.asset
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
Lua/jshyl_main.lua
Lua/jshyl_qqzj_runtime.lua
Lua/jshyl_qqzj_flags.lua
Lua/jshyl_qqzj_dialogue.lua
Lua/jshyl_qqzj_scene_api.lua
Lua/jshyl_qqzj_routes.lua
Lua/jshyl_qqzj_quest.lua
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

Do not place generated MOD resources in random project locations. Do not create or expand `Assets/Mods/qingqingzijin`; it is deprecated/disabled and not the MOD root. All new MOD content must live under:

```text
Assets/Mods/jshyl/
```

unless explicitly reusing existing base assets.

## Prompt To Codex

```text
Read:
AGENTS.md
docs/codex_pipeline/002_MOD_DIRECTORY_CONTRACT.md

Task:
Create the required directory skeleton for Assets/Mods/jshyl if missing.

Allowed:
Assets/Mods/jshyl/**

Forbidden:
Assets/BuildSource/**
Assets/Scripts/**
ProjectSettings/**

Do not add runtime logic yet.
```
