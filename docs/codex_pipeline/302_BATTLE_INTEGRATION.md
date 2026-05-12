# 302_BATTLE_INTEGRATION.md

## Goal

Standardize how story quests invoke battles.

## Static Battle

Use config table battle IDs:

```lua
TryBattle(10001)
```

The battle must exist in:

```text
Assets/Mods/jshyl/Configs/战斗.xlsx
```

## Dynamic Battle

Use existing dynamic battle pattern:

```lua
local battleConfig = CS.Jyx2Configs.Jyx2ConfigBattle()
battleConfig.Id = 9999
battleConfig.MapScene = "Jyx2Battle_0"
battleConfig.Exp = 400
battleConfig.Music = 22
battleConfig.TeamMates = 0
battleConfig.AutoTeamMates = -1

if TryBattleWithConfig(battleConfig) == false then
  Dead()
end
```

## Battle Map Assets

Battle scenes live under:

```text
Assets/Mods/jshyl/Maps/BattlesMaps/
```

and must be labeled:

```text
jshyl_maps
```
