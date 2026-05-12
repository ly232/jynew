# 999_FINAL_INTEGRATION.md

# Final Integration

## Goal

Tie together all narrative runtime systems and first route content.

## Final Integration Checklist

### Runtime

- [ ] EventBus implemented
- [ ] Reducer implemented
- [ ] WorldFlags implemented
- [ ] QuestRuntime implemented
- [ ] DialogueRuntime implemented
- [ ] BranchResolver implemented
- [ ] Save extension implemented

### Content

- [ ] Main character intro implemented
- [ ] 笑傲江湖 Chapter 1 implemented
- [ ] 笑傲江湖 Chapter 2 implemented
- [ ] 鹿鼎记 Chapter 1 implemented
- [ ] Sidequest structure implemented

### Assets

- [ ] Asset request schema implemented
- [ ] Portrait fallback works
- [ ] NPC fallback works
- [ ] Missing assets do not crash runtime

### Testing

- [ ] Content validation works
- [ ] Smoke test quests work
- [ ] Save/load test works
- [ ] Existing gameplay unaffected

## Final Acceptance Criteria

The expansion framework is complete when:

1. The player can complete intro.
2. The player can trigger at least one route quest.
3. Dialogue branches based on world flags.
4. Battle can be triggered from quest data.
5. Quest completion updates world flags.
6. Save/load restores quest progression.
7. Missing assets use fallbacks.
8. Codex can add future chapters by following the same document pattern.
