# Repository Overview

This repo extends jynew into a large-scale branching wuxia CRPG based on 金书红颜录5《青青子衿》.

# Architecture Priority

Always follow:
1. docs/codex_pipeline/010_ARCHITECTURE_OVERVIEW.md
2. Runtime system docs
3. Integration docs
4. Story docs

# Important Rules

- Never rewrite unrelated systems.
- Never replace existing combat architecture unless instructed.
- Preserve save compatibility.
- Prefer data-driven quest implementation.

# Narrative Runtime

The project uses:
- Event sourcing
- World flags
- Narrative reducers
- Branch resolvers

# Content Pipeline

Story content is defined in:
Assets/Narrative/

Quest files are YAML-driven.

# Forbidden

Do not:
- rewrite rendering
- refactor unrelated systems
- rename existing prefabs globally

# Required Before Completion

Before finishing any task:
- project compiles
- no save compatibility break
- acceptance criteria satisfied
