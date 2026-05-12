# 201_AI_PORTRAIT_PIPELINE.md

# AI Portrait Pipeline

## Goal

Create standardized prompts and metadata for missing character portraits.

## Portrait Request Fields

```yaml
asset_id:
character_id:
display_name:
gender:
approx_age:
faction:
personality:
visual_traits:
costume:
expression:
style_reference:
negative_prompt:
fallback_asset:
```

## Example

```yaml
asset_id: portrait_ren_yingying_default
character_id: ren_yingying
display_name: 任盈盈
gender: female
approx_age: early twenties
faction: 日月神教
personality:
  - intelligent
  - calm
  - proud
visual_traits:
  - elegant
  - refined
  - mysterious
costume:
  - dark wuxia robes
  - subtle red accents
expression: calm and observant
style_reference: match existing jynew 2D portrait style
negative_prompt:
  - modern clothing
  - photorealistic
  - sci-fi elements
fallback_asset: portrait_generic_female_wuxia
```

## Acceptance Criteria

- Every missing portrait has an asset request.
- Requests are consistent and reusable.
- Runtime can show fallback portraits.
