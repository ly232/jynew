# AGENTS.md

## Project Goal

Build a MOD-contained 金书红颜录5《青青子衿》 expansion for 群侠传启动 / jynew.

## Critical Rule

Prefer MOD-contained Lua/config/map/assets work under:

```text
Assets/Mods/qingqingzijin/
```

Do not add or depend on new C# code unless a task explicitly says engine fork/platform contribution is allowed.

## Architecture Priority

Read in order:

1. docs/codex_pipeline/000_README.md
2. docs/codex_pipeline/004_LUA_RUNTIME_PRINCIPLES.md
3. docs/codex_pipeline/010_ARCHITECTURE_OVERVIEW.md
4. Current task doc

## Forbidden By Default

Do not modify:

```text
Assets/Scripts/**
ProjectSettings/**
Assets/BuildSource/**
Assets/Mods/other_mods/**
```

unless explicitly allowed.

## Required Before Finishing

- Keep work scoped to allowed files.
- Preserve official MOD packaging model.
- Avoid cross-MOD asset dependencies.
- Prefer existing base assets.
- Keep new generated assets under Assets/Mods/qingqingzijin.
