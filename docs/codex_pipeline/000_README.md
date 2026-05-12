# JYNew / 群侠传启动 × 金书红颜录5《青青子衿》
# Codex Sequential Prompt Pipeline

## Purpose

This folder contains a sequential, one-file-at-a-time implementation plan for building a large 金书红颜录5《青青子衿》-style MOD on top of the existing `jynew` / 《群侠传，启动！》 project.

## Major Correction After Reading the Developer Manual

Earlier architecture assumed we could freely add C# runtime systems into the Unity project. The developer manual changes the implementation strategy:

- A normal MOD should be developed inside `Assets/Mods/{modId}`.
- MOD logic should primarily use Lua scripts, configuration tables, maps, prefabs, and BuildSource assets.
- MODs cannot rely on newly compiled C# code that is not already included in the host app, because packaged MODs run through the existing platform runtime and Lua VM.
- If C# changes are needed, they should be treated as optional engine/platform contributions, not as the default MOD path.

Therefore this pipeline now uses a **Lua-first, MOD-contained narrative runtime**.

## MOD Identity

Use the existing MOD id and root:

```text
jshyl
```

`qingqingzijin` / `QQZJ` is a campaign/content namespace inside `jshyl`, implemented as `JSHYL.QQZJ`. Do not create or expand `Assets/Mods/qingqingzijin` as a standalone MOD.

All following examples assume:

```text
Assets/Mods/jshyl/
```

## Execution Rule for Codex

Prompt Codex with one MD file at a time, in this order:

1. `001_REPO_AND_MOD_SETUP.md`
2. `002_MOD_DIRECTORY_CONTRACT.md`
3. `003_ASSETBUNDLE_CONTRACT.md`
4. `004_LUA_RUNTIME_PRINCIPLES.md`
5. `010_ARCHITECTURE_OVERVIEW.md`
6. `020_LUA_EVENT_SYSTEM.md`
7. `021_WORLD_FLAGS_SYSTEM.md`
8. `022_DIALOGUE_RUNTIME.md`
9. `023_QUEST_RUNTIME.md`
10. `024_SAVE_AND_STATE.md`
11. `025_BRANCHING_STORY_SYSTEM.md`
12. `100_CONTENT_PIPELINE.md`
13. `200_ASSET_PIPELINE.md`
14. `300_JYNEW_INTEGRATION.md`
15. Story route files

## Global Codex Rules

Codex must:

- Work inside `Assets/Mods/jshyl/` by default.
- Prefer Lua + Configs + Maps + BuildSource over C# changes.
- Avoid modifying platform/core code unless a task explicitly says “engine fork allowed.”
- Preserve the official MOD packaging model.
- Keep all new MOD resources assignable to the correct AssetBundle labels.
- Use existing base assets whenever possible to reduce package size.
