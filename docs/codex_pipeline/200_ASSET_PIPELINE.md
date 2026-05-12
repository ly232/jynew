# 200_ASSET_PIPELINE.md

## Goal

Manage existing and generated assets under the MOD packaging model.

## Reuse First

Prefer assets already in base assets:

```text
Assets/BuildSource/
```

This creates near-zero package-size cost.

## New Assets

Place MOD-specific assets under:

```text
Assets/Mods/jshyl/BuildSource/
Assets/Mods/jshyl/ModAssets/
Assets/Mods/jshyl/Skills/
```

## Portraits

Use:

```text
Assets/Mods/jshyl/BuildSource/heads/
```

Format:

```text
png
```

## Music / Sound

Use:

```text
Assets/Mods/jshyl/BuildSource/Musics/
Assets/Mods/jshyl/BuildSource/sound/
```

Music should use mp3 container format when following manual conventions.

## NPC Models

Use:

```text
Assets/Mods/jshyl/ModAssets/
```

Configs should reference model keys consistently.

## AI Asset Request Format

```yaml
asset_id: portrait_mu_wanqing_001
type: portrait
output_path: Assets/Mods/jshyl/BuildSource/heads/
format: png
style: wuxia 3D RPG portrait consistent with 群侠传启动
character:
  name: 木婉清
  age: 18
  traits:
    - cold
    - elegant
    - black veil
```
