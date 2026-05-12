# 025_BRANCHING_STORY_SYSTEM.md

## Goal

Represent large 金书红颜录-style branching in Lua data and flags.

## File

```text
Assets/Mods/jshyl/Lua/runtime/branch_resolver.lua
```

## Route Data

```lua
JSHYL = JSHYL or {}
JSHYL.QQZJ = JSHYL.QQZJ or {}
JSHYL.QQZJ.Data = JSHYL.QQZJ.Data or {}
JSHYL.QQZJ.Data.Routes = JSHYL.QQZJ.Data.Routes or {}

JSHYL.QQZJ.Data.Routes["xajh_righteous"] = {
  requirements = {
    all = { "qqzj_xajh_ch1_completed" },
    none = { "qqzj_xajh_dark_locked" }
  },
  locks = { "xajh_dark" }
}
```

## API

```lua
JSHYL.QQZJ.BranchResolver.can_enter(route_id)
JSHYL.QQZJ.BranchResolver.select(route_id)
JSHYL.QQZJ.BranchResolver.lock(route_id)
JSHYL.QQZJ.BranchResolver.is_locked(route_id)
```

## State Backing

Use flags:

```text
qqzj_route_xajh_righteous_selected
qqzj_route_xajh_dark_locked
```
