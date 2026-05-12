# 001_REPO_AND_MOD_SETUP.md

## Goal

Prepare the repo for a MOD-first implementation.

## Manual-Derived Constraints

- Use the `release` branch for MOD development intended for distribution.
- Use Unity `2020.3.32f1`.
- Create MODs through the Unity menu `MOD开发者 / 工具集`.
- MOD ID: `jshyl`.
- Campaign/content namespace: `qingqingzijin` / `QQZJ`, implemented under `JSHYL.QQZJ`.

## Required Repo State

```text
branch: release
Unity: 2020.3.32f1
MOD path: Assets/Mods/jshyl/
```

## Required ModSetting

Verify:

```text
Assets/Mods/jshyl/ModSetting.asset
```

Recommended metadata:

```text
MOD ID: jshyl
MOD name: 金书红颜录5 如画江山
Campaign namespace: qingqingzijin / QQZJ (`JSHYL.QQZJ`)
```

Recommended `PreloadedLua` baseline:

```text
jshyl_main
jshyl_qqzj_runtime
jshyl_qqzj_flags
jshyl_qqzj_dialogue
jshyl_qqzj_scene_api
jshyl_qqzj_routes
jshyl_qqzj_quest
```

Do not create or expand `Assets/Mods/qingqingzijin`; that path is deprecated/disabled and should not be treated as a selectable standalone MOD.

## Prompt To Codex

```text
Read AGENTS.md and docs/codex_pipeline/001_REPO_AND_MOD_SETUP.md.

Analyze the repo only. Do not modify code.

Confirm:
1. Unity version found in ProjectSettings
2. whether Assets/Mods/jshyl exists
3. whether ModSetting.asset exists
4. missing required MOD directories
5. setup gaps

Output a setup checklist.
```

## Acceptance Criteria

- Codex produces a checklist.
- No unrelated files are modified.
