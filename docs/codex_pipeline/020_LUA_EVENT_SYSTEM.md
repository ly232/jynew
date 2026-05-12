# 020_LUA_EVENT_SYSTEM.md

## Goal

Implement a lightweight Lua event bus for narrative orchestration.

## File

```text
Assets/Mods/qingqingzijin/Lua/runtime/event_bus.lua
```

## Namespace

```lua
QQZJ = QQZJ or {}
QQZJ.EventBus = QQZJ.EventBus or {}
```

## Required Features

```lua
QQZJ.EventBus.publish(event_type, payload)
QQZJ.EventBus.subscribe(event_type, handler)
QQZJ.EventBus.replay(events)
```

Keep a simple in-memory event history:

```lua
QQZJ.EventBus.history = {}
```

## Event Shape

```lua
{
  type = "QUEST_STARTED",
  source = "xajh_ch1_001",
  payload = {
    quest_id = "xajh_ch1_001"
  }
}
```

## Required Events

```text
QUEST_STARTED
QUEST_COMPLETED
QUEST_FAILED
ROUTE_LOCKED
CHARACTER_JOINED
CHARACTER_LEFT
ITEM_OBTAINED
BATTLE_STARTED
BATTLE_WON
BATTLE_LOST
DIALOGUE_SHOWN
MAP_OBJECT_CHANGED
```

## Persistence Limitation

This is not the authoritative save store by itself. Important state must also be written into existing game flags using `SetFlagInt` or equivalent existing APIs.

## Prompt To Codex

```text
Read:
AGENTS.md
docs/codex_pipeline/004_LUA_RUNTIME_PRINCIPLES.md
docs/codex_pipeline/020_LUA_EVENT_SYSTEM.md

Task:
Implement QQZJ.EventBus in Lua only.

Allowed:
Assets/Mods/qingqingzijin/Lua/runtime/event_bus.lua
Assets/Mods/qingqingzijin/Lua/main_qingqingzijin.lua

Forbidden:
Assets/Scripts/**
core platform files
```
