# TPR Quest Extraction Schema

## Purpose

Convert one TPR wiki page into implementation-ready quest records for jshyl.

Each extraction must be page-scoped. Do not mix multiple pages into one task unless the page explicitly says another page is a dependency.

## Page Record

```yaml
page:
  title: ""
  url: ""
  category: ""
  route_book: ""
  status: inventoried
  source_revision_or_date: ""
  extraction_date: ""
  extractor: "codex"
```

## Quest Graph

```yaml
quests:
  - quest_id: "qqzj_<route>_<short_name>"
    title: ""
    source_page: ""
    order_index: 0
    prerequisites:
      flags_all: []
      flags_any: []
      flags_none: []
      items_required: []
      companions_required: []
      routes_required: []
      maps_required: []
      books_required: []
    stages:
      - stage_id: "started"
        trigger:
          type: "scene_interaction"
          map: ""
          event_id: null
          npc: ""
          object: ""
        dialogue:
          speakers: []
          summary: ""
          choices: []
        effects:
          flags_set: []
          items_add: []
          items_remove: []
          companions_add: []
          companions_remove: []
          scene_changes: []
          battles: []
        completion:
          flags_set: []
          next_stages: []
```

## Required Extraction Fields

For every page row and quest:

```text
page title
page url
category
route/book
status
dependencies
target maps
target Lua files
target battles
rewards/items
flags
notes
```

## Flag Naming

Use explicit page/quest-scoped flags:

```text
qqzj_<route_or_book>_<quest_name>_started
qqzj_<route_or_book>_<quest_name>_<stage>_done
qqzj_<route_or_book>_<quest_name>_reward_claimed
qqzj_<route_or_book>_<quest_name>_battle_won
qqzj_<route_or_book>_<quest_name>_completed
```

Use the validated reference quest as the model:

```text
qqzj_intro_abi_guidance_started
qqzj_intro_abi_guidance_reward_claimed
qqzj_intro_abi_guidance_sparring_won
qqzj_intro_abi_guidance_completed
```

## Reward Extraction

Rewards must be idempotent.

For each reward:

```yaml
reward:
  item_id: null
  item_name: ""
  count: 0
  source_text_summary: ""
  claim_flag: "qqzj_<quest>_reward_claimed"
  existing_config_verified: false
  config_change_needed: false
```

Never create new items during extraction. Mark missing items as backlog work.

## Battle Extraction

For each battle:

```yaml
battle:
  source_description: ""
  existing_battle_id: null
  battle_name: ""
  enemies: []
  allies: []
  map_scene: ""
  victory_flag: "qqzj_<quest>_battle_won"
  fallback_strategy: ""
  config_change_needed: false
```

Use existing battles first. If no suitable battle exists, record the need in `IMPLEMENTATION_BACKLOG.md` instead of modifying configs during extraction.

## Dependency Extraction

Record dependencies as structured facts:

```yaml
dependencies:
  prior_quests: []
  route_locks: []
  companion_states: []
  item_states: []
  chapter_states: []
  book_count: null
  special_conditions: []
```

Do not infer hidden dependencies without marking them as assumptions.

## Implementation Mapping

After extraction, each quest should map to:

```yaml
implementation:
  target_maps: []
  target_lua_files: []
  target_quest_handlers: []
  target_battles: []
  target_assets: []
  manual_unity_steps: []
  test_plan: []
```

## Completion Criteria

A page can move from `extracted` to `implemented` only when all extracted mandatory quests are represented in jshyl files.

A page can move to `verified` only after:

```text
Unity loads jshyl
the relevant start/trigger map loads
each required trigger can be executed
rewards cannot be duplicated
optional battles return to scene
completion flags persist after save/load
```
