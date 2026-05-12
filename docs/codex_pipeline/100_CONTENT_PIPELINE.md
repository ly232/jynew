# 100_CONTENT_PIPELINE.md

# Content Pipeline

## Goal

Convert wiki-style攻略 into structured, data-driven content.

## Input

Human-readable攻略 pages.

## Output

Structured content files:

```text
Quests/*.yaml
Dialogues/*.yaml
Cutscenes/*.yaml
Routes/*.yaml
AssetRequests/*.yaml
```

## Extraction Process

```text
Read攻略 page
    ↓
Identify route/chapter
    ↓
Extract quest chain
    ↓
Extract requirements
    ↓
Extract triggers
    ↓
Extract rewards
    ↓
Extract route locks
    ↓
Write structured YAML
```

## Canonical Extraction Template

For each攻略 section, extract:

```yaml
source_page:
chapter:
route:
required_prior_events:
trigger_location:
trigger_npc:
quest_steps:
battles:
rewards:
new_flags:
locked_routes:
unlocked_routes:
asset_requests:
```

## Codex Responsibility

Codex should not infer canon freely.

Codex may:

- format extracted content
- generate boilerplate YAML
- generate placeholder dialogue
- create asset request entries

Codex should not:

- invent major plot branches
- alter route dependencies
- ignore hidden requirements

## Acceptance Criteria

- Every chapter has structured quest files.
- Every dialogue has stable IDs.
- Every asset gap is tracked.
- Every route lock is explicit.
