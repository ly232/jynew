# 003_ASSETBUNDLE_CONTRACT.md

## Goal

Ensure the MOD follows the official AssetBundle packaging model.

## Required Output Files

A distributed MOD should produce three files:

```text
jshyl_mod
jshyl_maps
jshyl.xml
```

## Required AssetBundle Labels

All non-scene MOD resources:

```text
jshyl_mod
```

All scene assets:

```text
jshyl_maps
```

Labels must be lowercase.

## Scene vs Resource Split

```text
Maps/GameMaps/*.unity      -> jshyl_maps
Maps/BattlesMaps/*.unity   -> jshyl_maps
Everything else            -> jshyl_mod
```

## Dependency Rule

Prefer references to assets already in `base_assets`, especially project-level `Assets/BuildSource`.

This reduces MOD package size.

If an asset is new and specific to this MOD, place it under `Assets/Mods/jshyl/`.

## No Cross-MOD References

Do not reference assets from another MOD's AssetBundle.

If copying from another MOD:

1. copy the asset into `Assets/Mods/jshyl/`
2. remove external bundle dependency
3. relabel to `jshyl_mod` or `jshyl_maps`

## Prompt To Codex

```text
Read:
AGENTS.md
docs/codex_pipeline/003_ASSETBUNDLE_CONTRACT.md

Task:
Inspect Assets/Mods/jshyl and produce an AssetBundle labeling checklist.
Do not modify files yet.

Check:
1. scenes should be jshyl_maps
2. non-scenes should be jshyl_mod
3. no obvious cross-MOD references
4. generated assets are inside jshyl

Output only the checklist.
```
