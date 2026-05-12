# 999_CODEX_PROMPT_RECIPES.md

## General Prompt Template

```text
Read:
AGENTS.md
docs/codex_pipeline/<current-doc>.md
docs/codex_pipeline/<dependency-doc>.md

Task:
<one small task only>

Allowed files:
<paths>

Forbidden files:
<paths>

Requirements:
<bullet list>

Done when:
<verification criteria>

Do not modify unrelated systems.
Do not implement future phases.
```

## First Prompt

```text
Read:
AGENTS.md
docs/codex_pipeline/001_REPO_AND_MOD_SETUP.md
docs/codex_pipeline/002_MOD_DIRECTORY_CONTRACT.md
docs/codex_pipeline/003_ASSETBUNDLE_CONTRACT.md
docs/codex_pipeline/004_LUA_RUNTIME_PRINCIPLES.md

Analyze the repo only. Do not modify code.

Output:
1. whether qingqingzijin MOD exists
2. missing directories
3. likely required ModSettings changes
4. AssetBundle labeling risks
5. whether any existing sample MOD can be reused as reference
```

## Runtime Prompt 1

```text
Read:
AGENTS.md
docs/codex_pipeline/004_LUA_RUNTIME_PRINCIPLES.md
docs/codex_pipeline/020_LUA_EVENT_SYSTEM.md

Implement QQZJ.EventBus in Lua only.

Allowed:
Assets/Mods/qingqingzijin/Lua/runtime/event_bus.lua
Assets/Mods/qingqingzijin/Lua/main_qingqingzijin.lua

Forbidden:
Assets/Scripts/**
```

## Runtime Prompt 2

```text
Read:
AGENTS.md
docs/codex_pipeline/021_WORLD_FLAGS_SYSTEM.md

Implement QQZJ.WorldFlags in Lua only.

Allowed:
Assets/Mods/qingqingzijin/Lua/runtime/world_flags.lua
Assets/Mods/qingqingzijin/Lua/main_qingqingzijin.lua

Forbidden:
Assets/Scripts/**
```

## Vertical Slice Prompt

```text
Read:
AGENTS.md
docs/codex_pipeline/023_QUEST_RUNTIME.md
docs/codex_pipeline/301_SCENE_SCRIPTING_CONTRACT.md
docs/codex_pipeline/601_XAJH_CH1_FUZHOU.md

Implement xajh_ch1_001 as a Lua/data vertical slice.

Allowed:
Assets/Mods/qingqingzijin/Lua/data/quests/xajh_ch1.lua
Assets/Mods/qingqingzijin/Lua/data/dialogues/xajh_ch1.lua
Assets/Mods/qingqingzijin/Lua/quests/xajh_ch1_handlers.lua
Assets/Mods/qingqingzijin/Lua/scenes/fuzhou.lua

Forbidden:
Assets/Scripts/**
Assets/BuildSource/**
other MODs
```
