# 021_WORLD_FLAGS_SYSTEM.md

## Goal

Implement a Lua wrapper around existing game flags.

## File

```text
Assets/Mods/qingqingzijin/Lua/runtime/world_flags.lua
```

## Why

The manual describes RPG state as map triggers + flags + ModifyEvent + saved game state.

Therefore QQZJ world flags should be backed by existing save-compatible APIs whenever possible.

## Namespace

```lua
QQZJ = QQZJ or {}
QQZJ.WorldFlags = QQZJ.WorldFlags or {}
```

## API

```lua
QQZJ.WorldFlags.get(key)
QQZJ.WorldFlags.set(key, value)
QQZJ.WorldFlags.is_true(key)
QQZJ.WorldFlags.require_all(keys)
QQZJ.WorldFlags.require_any(keys)
QQZJ.WorldFlags.require_none(keys)
```

## Backing Store

Prefer existing save-backed functions:

```lua
SetFlagInt(key, value)
GetFlagInt(key)
```

If `GetFlagInt` is unavailable, maintain fallback in-memory table but document that persistence is incomplete.

## Flag Naming

Use stable English IDs:

```text
qqzj_intro_completed
qqzj_xajh_ch1_started
qqzj_xajh_ch1_completed
qqzj_lin_pingzhi_joined
qqzj_ren_yingying_joined
```
