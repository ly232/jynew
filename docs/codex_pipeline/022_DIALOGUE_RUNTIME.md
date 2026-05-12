# 022_DIALOGUE_RUNTIME.md

## Goal

Create a Lua dialogue helper layer that uses the existing Talk/UI APIs.

## File

```text
Assets/Mods/jshyl/Lua/runtime/dialogue_runtime.lua
```

## Runtime API

```lua
JSHYL.QQZJ.Dialogue.say(speaker_id, text)
JSHYL.QQZJ.Dialogue.choice(prompt, choices)
JSHYL.QQZJ.Dialogue.run(dialogue_id)
```

## Dialogue Data

Store dialogue data as Lua tables:

```text
Assets/Mods/jshyl/Lua/data/dialogues/
```

Example:

```lua
JSHYL = JSHYL or {}
JSHYL.QQZJ = JSHYL.QQZJ or {}
JSHYL.QQZJ.Data = JSHYL.QQZJ.Data or {}
JSHYL.QQZJ.Data.Dialogues = JSHYL.QQZJ.Data.Dialogues or {}

JSHYL.QQZJ.Data.Dialogues["dlg_xajh_001"] = {
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
Assets/Mods/jshyl/BuildSource/heads/
```

PNG format.
