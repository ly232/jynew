# 400_STORY_GLOBAL_TIMELINE.md

# Story Global Timeline

## Goal

Define the macro structure of the 金书红颜录5《青青子衿》-style expansion.

## Major Route Families

```text
Main Character Route
十四天书 Routes
Companion Routes
Faction Routes
Romance / Relationship Routes
Hidden Endings
Important Sidequests
```

## Runtime Phases

```text
Phase 0: Intro / Character Creation
Phase 1: Early Jianghu
Phase 2: Route Selection Opens
Phase 3: Major Faction Conflicts
Phase 4: Book Route Convergence
Phase 5: Final Route Locks
Phase 6: Ending Resolution
```

## Global World Flags

```yaml
intro_completed: false
jianghu_phase: 0
all_books_completed: false
final_route_locked: false
ending_route_selected: none
```

## Progression Principle

The player should feel free to explore, but the runtime should track route locks explicitly.

## Acceptance Criteria

- Global phases exist.
- Routes can declare required phase.
- Endings can evaluate global completion.
