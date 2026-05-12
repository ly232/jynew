# 301_EXISTING_SYSTEM_MAPPING.md

# Existing System Mapping

## Goal

Create a map between narrative concepts and existing JYNew systems.

## Mapping Table Template

| Narrative Concept | Existing JYNew System | Adapter Needed | Notes |
|---|---|---|---|
| Quest | TBD | QuestManager | inspect repo |
| Dialogue | TBD | DialogueManager | inspect repo |
| Battle | TBD | IBattleAdapter | inspect repo |
| Inventory | TBD | IInventoryAdapter | inspect repo |
| Map | TBD | IMapAdapter | inspect repo |
| Save | TBD | ISaveAdapter | inspect repo |

## Codex Task

Codex should fill this table by inspecting the repo.

For each existing system, Codex should document:

- file path
- class name
- relevant public methods
- integration risk
- adapter recommendation

## Acceptance Criteria

- All key systems are mapped.
- Narrative runtime has adapter targets.
- No direct hard dependency is introduced unnecessarily.
