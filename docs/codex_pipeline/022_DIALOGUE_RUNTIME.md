# 022_DIALOGUE_RUNTIME.md

## Goal

Create a Lua dialogue helper layer that uses the existing Talk/UI APIs.

## File

```text
Assets/Mods/qingqingzijin/Lua/runtime/dialogue_runtime.lua
```

## Runtime API

```lua
QQZJ.Dialogue.say(speaker_id, text)
QQZJ.Dialogue.choice(prompt, choices)
QQZJ.Dialogue.run(dialogue_id)
```

## Dialogue Data

Store dialogue data as Lua tables:

```text
Assets/Mods/qingqingzijin/Lua/data/dialogues/
```

Example:

```lua
QQZJ_DATA_DIALOGUES = QQZJ_DATA_DIALOGUES or {}

QQZJ_DATA_DIALOGUES["dlg_xajh_001"] = {
  speaker = 35,
  text = "少侠，你终于来了。",
  choices = {
    {
      text = "我来帮你。",
      next = "dlg_xajh_002",
      set_flags = { qqzj_helped_lin_pingzhi = 1 }
    }
  }
}
```

## Use Existing APIs

Use:

```lua
Talk(...)
ShowYesOrNoSelectPanel(...)
```

Do not build a new Unity UI system.

## Portraits

Portraits should be added under:

```text
Assets/Mods/qingqingzijin/BuildSource/heads/
```

PNG format.
