# 001_REPO_AND_MOD_SETUP.md

## Goal

Prepare the repo for a MOD-first implementation.

## Manual-Derived Constraints

- Use the `release` branch for MOD development intended for distribution.
- Use Unity `2020.3.32f1`.
- Create MODs through the Unity menu `MOD开发者 / 工具集`.
- Recommended MOD ID: `qingqingzijin`.

## Required Repo State

```text
branch: release
Unity: 2020.3.32f1
MOD path: Assets/Mods/qingqingzijin/
```

## Required ModSettings

Verify:

```text
Assets/Mods/qingqingzijin/ModSettings.asset
```

Recommended metadata:

```text
MOD ID: qingqingzijin
MOD name: 金书红颜录5 青青子衿
```

## Prompt To Codex

```text
Read AGENTS.md and docs/codex_pipeline/001_REPO_AND_MOD_SETUP.md.

Analyze the repo only. Do not modify code.

Confirm:
1. Unity version found in ProjectSettings
2. whether Assets/Mods/qingqingzijin exists
3. whether ModSettings.asset exists
4. missing required MOD directories
5. setup gaps

Output a setup checklist.
```

## Acceptance Criteria

- Codex produces a checklist.
- No unrelated files are modified.
