# MANIFEST.md

# Project Identity

Project:
jshyl

Base Engine:
jynew

Project Type:
Narrative-heavy MOD for 群侠传启动

Narrative Source:
金书红颜录5《青青子衿》

Campaign Namespace:
qingqingzijin / QQZJ, implemented as `JSHYL.QQZJ` inside the jshyl MOD

---

# Repository Structure

## Engine Layer

Core jynew engine files.

Generally should remain untouched.

Examples:

* Assets/Scripts/
* engine rendering
* platform systems

---

## MOD Layer

Primary development area. `Assets/Mods/qingqingzijin` is deprecated/disabled and must not be expanded as a standalone MOD.

Location:

Assets/Mods/jshyl/

Contains:

* Lua
* Configs
* Maps
* BuildSource
* ModAssets
* Skills

---

# Documentation Structure

## docs/codex_pipeline/

Contains all AI-oriented implementation specifications.

---

# Core Architecture Docs

## 000_README.md

High-level project overview.

---

## 001_REPO_AND_MOD_SETUP.md

How the MOD should be structured.

---

## 002_MOD_DIRECTORY_CONTRACT.md

Defines required directories and conventions.

---

## 003_ASSETBUNDLE_CONTRACT.md

Defines AssetBundle usage rules.

---

## 004_LUA_RUNTIME_PRINCIPLES.md

Defines Lua runtime architecture.

---

# Runtime Strategy

Primary runtime architecture:

* Lua-driven
* Scene-trigger-driven
* Config-table-driven
* BuildSource override system

Avoid:

* heavy engine rewrites
* large new C# systems

---

# Narrative Structure

Narrative implementation uses:

* scene triggers
* Lua scripts
* SetFlag
* ModifyEvent
* scene_api.BindEvent
* timeline cutscenes

---

# Quest Structure

Each quest chapter should contain:

* Lua scripts
* dialogue definitions
* map triggers
* config references
* optional timelines

---

# Asset Structure

## Reused Assets

Prefer:
Assets/BuildSource/

These are effectively free references via base_assets.

---

## New Assets

Place under:
Assets/Mods/jshyl/

---

# Scene Rules

All scenes:

* must use jshyl_maps
* should avoid cross-mod references
* should be validated in AssetBundle Browser

---

# Lua Architecture

## Lua Library Files

Loaded once globally.

Used for:

* shared utilities
* global helpers under `JSHYL.QQZJ`
* wrappers
* state helpers

---

## Lua Scene Scripts

Executed repeatedly.

Used for:

* scene triggers
* events
* dialogue
* battles

---

# Recommended Development Order

1. MOD setup
2. Lua infrastructure
3. Global helper library
4. Scene trigger framework
5. Dialogue framework
6. Quest flow
7. One playable intro chapter
8. Save validation
9. Branching routes

---

# Important Constraints

Do not:

* break save compatibility
* create cross-mod dependencies
* rewrite engine unnecessarily
* introduce unrelated C# refactors

---

# First Milestone

Goal:

Playable opening chapter:

* entering first map
* interacting with NPCs
* branching dialogue
* one battle
* one timeline cutscene
* save/load validation

