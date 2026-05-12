# 300_JYNEW_INTEGRATION.md

## Goal

Integrate the MOD with existing 群侠传启动 mechanics.

## Primary Integration Points

### 1. Configs

Use:

```text
Assets/Mods/qingqingzijin/Configs/
```

Expected tables include:

```text
场景.xlsx
角色.xlsx
战斗.xlsx
物品.xlsx
武功.xlsx
```

### 2. Map BindScript

For scenes, set `BindScript` in `场景.xlsx`.

The bound Lua file should expose:

```lua
function Start()
end
```

### 3. Map Triggers

Scene objects under:

```text
Level/Triggers
```

can bind:

- enter trigger
- interaction trigger
- use-item trigger

### 4. Dynamic Objects

Scene objects under:

```text
Level/Dynamic
```

can be shown or hidden using Lua.

### 5. Battle

Use:

```lua
TryBattle(battleId)
TryBattleWithConfig(battleConfig)
```

### 6. Timeline

Use:

```lua
jyx2_PlayTimelineSimple(...)
jyx2_Wait(...)
```

## Core Rule

Use the existing platform API.

Do not recreate systems that already exist.
