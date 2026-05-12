# 301_SCENE_SCRIPTING_CONTRACT.md

## Goal

Standardize scene scripting for the MOD.

## Scene Script Location

```text
Assets/Mods/qingqingzijin/Lua/scenes/
```

Example:

```text
fuzhou.lua
```

## Required Structure

```lua
function Start()
  QQZJ.Scene = QQZJ.Scene or {}
  QQZJ.Scene.init_fuzhou()
end
```

## Recommended Pattern

```lua
QQZJ.Scene = QQZJ.Scene or {}

function QQZJ.Scene.init_fuzhou()
  if QQZJ.WorldFlags.is_true("qqzj_xajh_ch1_completed") then
    jyx2_ReplaceSceneObject("", "NPC/LinPingzhi", "")
  else
    jyx2_ReplaceSceneObject("", "NPC/LinPingzhi", "1")
  end

  scene_api.BindEvent("NPC/LinPingzhi", "fuzhou.TalkLinPingzhi")
end

function TalkLinPingzhi()
  QQZJ.QuestRuntime.run("xajh_ch1_001")
end
```

## Function-Level Calling

Follow the function-level Lua call pattern:

```lua
scene_api.BindEvent("NPC/Nanxian", "wumingshangu.TalkNanXian")
```

## Acceptance Criteria

- Scene script has `Start()`.
- Scene script binds events.
- Scene script rehydrates dynamic objects from flags.
