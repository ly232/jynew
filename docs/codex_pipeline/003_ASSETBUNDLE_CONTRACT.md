# 003_ASSETBUNDLE_CONTRACT.md

## Goal

Ensure the MOD follows the official AssetBundle packaging model.

## Required Output Files

A distributed MOD should produce three files:

```text
qingqingzijin_mod
qingqingzijin_maps
qingqingzijin.xml
```

## Required AssetBundle Labels

All non-scene MOD resources:

```text
qingqingzijin_mod
```

All scene assets:

```text
qingqingzijin_maps
```

Labels must be lowercase.

## Scene vs Resource Split

```text
Maps/GameMaps/*.unity      -> qingqingzijin_maps
Maps/BattlesMaps/*.unity   -> qingqingzijin_maps
Everything else            -> qingqingzijin_mod
```

## Dependency Rule

Prefer references to assets already in `base_assets`, especially project-level `Assets/BuildSource`.

This reduces MOD package size.

If an asset is new and specific to this MOD, place it under `Assets/Mods/qingqingzijin/`.

## No Cross-MOD References

Do not reference assets from another MOD's AssetBundle.

If copying from another MOD:

1. copy the asset into `Assets/Mods/qingqingzijin/`
2. remove external bundle dependency
3. relabel to `qingqingzijin_mod` or `qingqingzijin_maps`

## Prompt To Codex

```text
Read:
AGENTS.md
docs/codex_pipeline/003_ASSETBUNDLE_CONTRACT.md

Task:
Inspect Assets/Mods/qingqingzijin and produce an AssetBundle labeling checklist.
Do not modify files yet.

Check:
1. scenes should be qingqingzijin_maps
2. non-scenes should be qingqingzijin_mod
3. no obvious cross-MOD references
4. generated assets are inside qingqingzijin

Output only the checklist.
```
