# 000_README.md

# JYNew × 金书红颜录5《青青子衿》 Codex Narrative Pipeline

## Goal

Expand the existing Unity project `jynew` into a large-scale narrative-driven wuxia RPG inspired by the story structure, branching density, and character-route style of 金书红颜录5《青青子衿》.

This document set is designed to be consumed by Codex one file at a time, sequentially.

The goal is not to ask Codex to "make a whole game." The goal is to guide Codex through a controlled, incremental, verifiable expansion of the existing Unity project.

## Core Strategy

Use a data-driven narrative architecture:

```text
攻略 / Story Guide
    ↓
Canonical Quest Graph
    ↓
Quest / Dialogue / Event YAML
    ↓
Narrative Runtime
    ↓
Existing JYNew Unity Systems
```

## Execution Order

Codex should process these files in numeric order.

```text
000_README.md
010_ARCHITECTURE_OVERVIEW.md
020_RUNTIME_EVENT_SYSTEM.md
021_WORLD_FLAGS_SYSTEM.md
022_DIALOGUE_RUNTIME.md
023_QUEST_RUNTIME.md
024_SAVE_SYSTEM.md
025_BRANCHING_STORY_SYSTEM.md
100_CONTENT_PIPELINE.md
200_ASSET_PIPELINE.md
201_AI_PORTRAIT_PIPELINE.md
202_NPC_GENERATION_PIPELINE.md
300_JYNEW_INTEGRATION.md
301_EXISTING_SYSTEM_MAPPING.md
302_PREFAB_REUSE.md
400_STORY_GLOBAL_TIMELINE.md
500_MAIN_CHARACTER_ROUTE.md
600_XAJH_ROUTE.md
601_XAJH_CH1_FUZHOU.md
602_XAJH_CH2_HENGSHAN.md
700_LDJ_ROUTE.md
701_LDJ_CH1_YANGZHOU.md
800_SIDEQUESTS.md
900_TESTING_STRATEGY.md
950_SAVE_COMPATIBILITY.md
999_FINAL_INTEGRATION.md
```

## Rules for Codex

1. Do not rewrite unrelated systems.
2. Prefer adding new narrative runtime systems over modifying legacy gameplay systems.
3. Implement one subsystem or one quest chapter per task.
4. Keep every step compile-safe.
5. Add tests or validation utilities whenever possible.
6. Treat narrative state as data, not hardcoded C# branches.
7. Use existing JYNew assets whenever possible.
8. Only create asset-generation requests when an asset is missing.
9. Preserve save compatibility.
10. Do not invent large amounts of story outside the provided quest specs unless explicitly asked.

## Intended Repository Location

Place these docs under:

```text
docs/codex_pipeline/
```

Narrative data should eventually live under:

```text
Assets/Narrative/
```

## Completion Definition

This pipeline is complete when the project has:

- data-driven quests
- branching dialogue
- persistent world flags
- event-sourced narrative state
- route locking
- reusable asset request workflow
- chapter-by-chapter implementation path
