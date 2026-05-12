# 100_CONTENT_PIPELINE.md

## Goal

Convert wiki攻略 into MOD-ready Lua/config/map content.

## Pipeline

```text
Wiki walkthrough
  ↓
Canonical event list
  ↓
Quest Lua data
  ↓
Dialogue Lua data
  ↓
Scene trigger script
  ↓
Configs Excel rows
  ↓
Map/Battle assets
```

## Output Per Chapter

Each chapter should produce:

```text
Lua/data/quests/{route}_{chapter}.lua
Lua/data/dialogues/{route}_{chapter}.lua
Lua/scenes/{scene}.lua
Lua/quests/{route}_{chapter}_handlers.lua
Configs changes
Asset requests
```

## Content Extraction Template

For each攻略 step, extract:

```text
location
trigger type
preconditions
dialogue
battle
items
companions
flags set
flags checked
map changes
route locks
next quest
```

## Quest Data Rule

Do not encode long quest logic directly in scene scripts.

Scene scripts should call:

```lua
QQZJ.QuestRuntime.run("quest_id")
```

## Scene Script Rule

Scene scripts are for map binding and trigger entry points.

Example:

```lua
function Start()
  QQZJ.Scene.init_fuzhou()
end

function TalkLinPingzhi()
  QQZJ.QuestRuntime.run("xajh_ch1_001")
end
```
