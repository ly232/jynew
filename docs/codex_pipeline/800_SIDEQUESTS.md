# 800_SIDEQUESTS.md

## Goal

Define the sidequest content model.

## Sidequest Principles

Sidequests should be:

- small
- isolated
- flag-driven
- reusable for testing runtime systems

## Sidequest Data

```text
Lua/data/quests/sidequests/
Lua/data/dialogues/sidequests/
Lua/quests/sidequests/
```

## Recommended First Sidequest

```text
side_fuzhou_medicine_001
```

This can test:

- item reward
- dialogue choice
- SetFlagInt
- repeat prevention
