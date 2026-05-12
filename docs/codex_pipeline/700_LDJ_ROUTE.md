# 700_LDJ_ROUTE.md

# 鹿鼎记 Route Overview

## Goal

Implement 鹿鼎记 as a politically branching route family.

## Route Themes

- 扬州 opening
- palace infiltration
- 天地会
- 康熙 relationship
- multiple faction allegiance
- comedy and deception

## Route Flags

```yaml
ldj_started: false
ldj_yangzhou_completed: false
wei_xiaobao_met: false
kangxi_met: false
tiandihui_joined: false
palace_access_unlocked: false
ldj_route: none
```

## Branches

```text
ldj_tiandihui
ldj_palace
ldj_kangxi_friendship
ldj_hidden_comedy
```

## Chapter Files

```text
701_LDJ_CH1_YANGZHOU.md
```

## Acceptance Criteria

- 鹿鼎记 route has explicit route state.
- Political branches are represented as flags.
