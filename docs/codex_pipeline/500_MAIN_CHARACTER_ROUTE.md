# 500_MAIN_CHARACTER_ROUTE.md

## Goal

Implement the opening/player-introduction route.

## Recommended First Slice

Quest chain:

```text
main_intro_001
main_intro_002
main_intro_003
```

## Required Flags

```text
qqzj_global_intro_started
qqzj_global_intro_completed
qqzj_player_first_weapon_selected
qqzj_player_first_companion_met
```

## Required Content

```text
Lua/data/quests/main_intro.lua
Lua/data/dialogues/main_intro.lua
Lua/quests/main_intro_handlers.lua
Lua/scenes/intro_start.lua
```

## Runtime Requirements

- Use `QQZJ.QuestRuntime`.
- Use `QQZJ.Dialogue`.
- Use `QQZJ.WorldFlags`.
- Use existing scene trigger APIs.
