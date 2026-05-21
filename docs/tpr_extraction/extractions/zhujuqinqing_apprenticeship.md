# TPR Extraction: 主角剧情 / 拜师

## 1. Selection

Selected section:

```text
page: 主角剧情
section: 拜师
source URL: https://tpr.inkit.cc/tpr5:主角剧情#拜师
```

Why this section:

```text
1. It is the next direct 主角剧情 section after 开局.
2. It continues from already-implemented 燕子坞 opening flags.
3. It is centered in 燕子坞 / 还施水阁 and is not immediately blocked by missing 杭州/开封 maps.
4. It can be represented as quest specs before implementing skill-wash, battle, or study-room mechanics.
5. The first implementation can be very small: one mentor-choice dialogue and persistent route flags.
```

Not selected yet:

```text
家传武艺: requires 拜师 completion and 大哥 skill/reward mechanics.
老爹及大哥: requires later maps such as 燕兴陵 / 龙城祖庙 and larger battles.
杭州/开封 hooks: currently blocked by missing exact city map rows/assets.
```

## 2. Page Record

```yaml
page:
  title: "主角剧情"
  section_title: "拜师"
  url: "https://tpr.inkit.cc/tpr5:主角剧情#拜师"
  category: "story_section"
  route_book: "主角"
  status: "extracted"
  source_revision_or_date: "TPR wiki page last-modified line observed on 2024-11-23; extracted 2026-05-20"
  extraction_date: "2026-05-20"
  extractor: "codex"
```

## 3. Source Scope

Covered source beats:

```text
拜师 step 3:
- Before apprenticeship, original protagonist should remember to learn one martial art.
- Give 狼牙燕翎 to one of 四大家将 or 阿碧.
- Learn one apprenticeship martial art.
- From second playthrough onward, apprenticeship requires battle; victory adds +10 to the selected combat系数.
- After apprenticeship, protagonist second skill slot is washed to the selected martial art.
- Protagonist 武学常识 +50.
- After learning apprenticeship martial art, the top ShuiGe study room becomes available.
- Study-room shelves contain the other four martial arts, excluding the chosen one.
- Taking each shelf martial art washes protagonist fourth skill slot to that martial art.
- If 王语嫣 is present, 王语嫣 also washes her fourth skill slot in sequence.
```

Out of scope for this extraction:

```text
家传武艺
老爹及大哥
later 家族试炼 / 星阵 effects keyed by apprenticeship branch
full implementation of skill-slot washing APIs
full implementation of multi-playthrough battle gating
```

## 4. Structured Quest Spec

```yaml
quests:
  - quest_id: "qqzj_protagonist_apprenticeship_choose_master"
    title: "拜师择艺"
    source_page: "https://tpr.inkit.cc/tpr5:主角剧情#拜师"
    order_index: 1
    prerequisites:
      flags_all:
        - "qqzj_protagonist_opening_family_briefing_completed"
      flags_any:
        - "qqzj_protagonist_opening_family_briefing_tool_reward_claimed"
      flags_none:
        - "qqzj_protagonist_apprenticeship_choose_master_completed"
      items_required:
        - item_id: 206
          item_name: "狼牙燕翎"
          count: 1
      companions_required: []
      routes_required: []
      maps_required:
        - "52_yanziwu"
      books_required: []
    stages:
      - stage_id: "prompt"
        trigger:
          type: "scene_interaction"
          map: "52_yanziwu"
          event_id: 5210
          npc: "阿碧 or 四大家将 mentor representative"
          object: "future jshyl_apprenticeship_master trigger"
        dialogue:
          speakers:
            - "主角"
            - "阿碧 / 四大家将"
          summary: "Explain that 狼牙燕翎 may be presented to choose one family-school apprenticeship route."
          choices:
            - "阿碧: 七弦无形剑 / 暗毒"
            - "邓百川: 回风舞柳剑 / 御剑"
            - "包不同: 如影随形腿 / 指腿"
            - "风波恶: 飞沙走石刀 / 兵器"
            - "公冶干: 大风云飞掌 / 拳掌"
            - "暂不拜师"
        effects:
          flags_set:
            - "qqzj_protagonist_apprenticeship_choose_master_started"
          items_add: []
          items_remove: []
          companions_add: []
          companions_remove: []
          scene_changes: []
          battles: []
        completion:
          flags_set: []
          next_stages:
            - "resolve_choice"
      - stage_id: "resolve_choice"
        trigger:
          type: "dialogue_choice"
          map: "52_yanziwu"
          event_id: 5210
          npc: "selected mentor"
          object: "future jshyl_apprenticeship_master trigger"
        dialogue:
          speakers:
            - "selected mentor"
            - "主角"
          summary: "Confirm selected apprenticeship martial art. If this is a later playthrough, branch to battle before completion."
          choices:
            - "确认"
            - "返回"
        effects:
          flags_set:
            - "qqzj_protagonist_apprenticeship_choice_<branch>"
          items_add: []
          items_remove:
            - item_id: 206
              item_name: "狼牙燕翎"
              count: 1
              required_before_remove: true
          companions_add: []
          companions_remove: []
          scene_changes:
            - "unlock future ShuiGe upper study access flag"
          battles:
            - battle:
                source_description: "2周起拜师需战斗"
                existing_battle_id: null
                battle_name: "apprenticeship mentor test TBD"
                enemies:
                  - "selected mentor or family representatives"
                allies:
                  - "主角"
                map_scene: "TBD"
                victory_flag: "qqzj_protagonist_apprenticeship_choose_master_battle_won"
                fallback_strategy: "first implementation may defer battle until playthrough/week detection is available"
                config_change_needed: true
        completion:
          flags_set:
            - "qqzj_protagonist_apprenticeship_choose_master_completed"
            - "qqzj_protagonist_apprenticeship_study_unlocked"
          next_stages: []

  - quest_id: "qqzj_protagonist_apprenticeship_shuige_study"
    title: "还施水阁书房取艺"
    source_page: "https://tpr.inkit.cc/tpr5:主角剧情#拜师"
    order_index: 2
    prerequisites:
      flags_all:
        - "qqzj_protagonist_apprenticeship_choose_master_completed"
        - "qqzj_protagonist_apprenticeship_study_unlocked"
      flags_any: []
      flags_none: []
      items_required: []
      companions_required: []
      routes_required: []
      maps_required:
        - "52_yanziwu"
      books_required: []
    stages:
      - stage_id: "study_entry"
        trigger:
          type: "scene_interaction"
          map: "52_yanziwu"
          event_id: 5211
          npc: ""
          object: "future jshyl_shuige_upper_study"
        dialogue:
          speakers:
            - "旁白"
          summary: "Allow access to the upper ShuiGe study only after apprenticeship."
          choices: []
        effects:
          flags_set:
            - "qqzj_protagonist_apprenticeship_shuige_study_started"
          items_add: []
          items_remove: []
          companions_add: []
          companions_remove: []
          scene_changes: []
          battles: []
        completion:
          flags_set: []
          next_stages:
            - "shelf_selection"
      - stage_id: "shelf_selection"
        trigger:
          type: "scene_interaction"
          map: "52_yanziwu"
          event_id: 5212
          npc: ""
          object: "future ShuiGe bookshelf trigger(s)"
        dialogue:
          speakers:
            - "旁白"
          summary: "Shelves offer the four unchosen apprenticeship martial arts. Each selected shelf washes protagonist fourth slot; 王语嫣 also washes fourth slot if present."
          choices:
            - "take one available unchosen martial art"
            - "leave"
        effects:
          flags_set:
            - "qqzj_protagonist_apprenticeship_shuige_study_shelf_<branch>_claimed"
          items_add: []
          items_remove: []
          companions_add: []
          companions_remove: []
          scene_changes: []
          battles: []
        completion:
          flags_set:
            - "qqzj_protagonist_apprenticeship_shuige_study_completed"
          next_stages: []
```

## 5. Branch Table

| branch flag suffix | mentor | martial art | 系别 | source effect |
|---|---|---|---|---|
| `abi` | 阿碧 | 七弦无形剑 | 暗毒 | protagonist second slot wash; 武学常识 +50 |
| `dengbaichuan` | 邓百川 | 回风舞柳剑 | 御剑 | protagonist second slot wash; 武学常识 +50 |
| `baobutong` | 包不同 | 如影随形腿 | 指腿 | protagonist second slot wash; 武学常识 +50 |
| `fengboe` | 风波恶 | 飞沙走石刀 | 兵器 | protagonist second slot wash; 武学常识 +50 |
| `gongyegan` | 公冶干 | 大风云飞掌 | 拳掌 | protagonist second slot wash; 武学常识 +50 |

Recommended branch flags:

```text
qqzj_protagonist_apprenticeship_choice_abi
qqzj_protagonist_apprenticeship_choice_dengbaichuan
qqzj_protagonist_apprenticeship_choice_baobutong
qqzj_protagonist_apprenticeship_choice_fengboe
qqzj_protagonist_apprenticeship_choice_gongyegan
```

## 6. Dependencies On Current Implemented Flags

Minimum dependency for first implementation:

```text
qqzj_protagonist_opening_family_briefing_completed
qqzj_protagonist_opening_family_briefing_tool_reward_claimed
```

Why not require 杭州/开封 hooks:

```text
The apprenticeship section does not require entering 杭州 or 开封. It only needs
the opening family briefing/tool flow that grants 狼牙燕翎.
```

Optional stronger dependency, if implementation wants the player to complete
the ShuiGe entry path first:

```text
qqzj_protagonist_opening_shuige_entry_cost_resolved
qqzj_protagonist_opening_shuige_inner_completed
```

Recommendation:

```text
Do not require ShuiGe chest completion for the first apprenticeship slice.
Require only the family briefing/tool reward so the player has 狼牙燕翎.
```

## 7. Map / NPC / Item / Battle Requirements

### Maps

| map | status | requirement |
|---|---|---|
| `52_yanziwu` | exists and is current home map | required |
| ShuiGe upper study | not represented as a true room yet | can be same-scene marker/trigger later |
| 杭州 / 开封 | missing | not required |

### NPCs

| NPC | status | requirement |
|---|---|---|
| 阿碧 | current technical/TPR use exists, but source placement should be reviewed | can serve as first mentor representative |
| 邓百川 | needs role/model/scene review | can be deferred |
| 包不同 | needs role/model/scene review | can be deferred |
| 风波恶 | needs role/model/scene review | can be deferred |
| 公冶干 | needs role/model/scene review | can be deferred |
| 王语嫣 | future companion dependency for study-room wash | defer until companion state system is ready |

### Items

| item | id | status | use |
|---|---:|---|---|
| 狼牙燕翎 | `206` | exists as inert QQZJ/TPR opening item | required and should be removed once on apprenticeship completion |

### Skills / Effects

| effect | status |
|---|---|
| wash protagonist second skill slot | API/config mapping unknown |
| 武学常识 +50 | API known from role stats only in broad terms; exact helper unknown |
| 2周+ battle and 系数 +10 | playthrough/week detection and battle config unknown |
| unlock ShuiGe study | can be flag-only first |
| wash protagonist fourth skill slot from study shelves | API/config mapping unknown |
| 王语嫣 fourth slot wash if present | companion detection and skill-wash API unknown |

### Battles

| battle need | status | note |
|---|---|---|
| 2周起 apprenticeship test | not ready | first extraction records need; implementation should defer or stub until 周目 detection and battle id are planned |

## 8. Rewards / Effects

This section is mostly skill/stat progression rather than item rewards.

| reward/effect | id/config | implementation status |
|---|---|---|
| selected apprenticeship skill | skill ids TBD | requires skill config audit |
| 武学常识 +50 | no item id | requires role-stat API audit |
| selected系数 +10 on later-week battle victory | no item id | requires stat API + 周目 audit |
| ShuiGe study access | flag only | safe first implementation |
| four unchosen study martial arts | skill ids TBD | requires skill config audit |

## 9. Unknowns

1. Exact skill ids/config rows for 七弦无形剑, 回风舞柳剑, 如影随形腿, 飞沙走石刀, 大风云飞掌.
2. Whether these skills already exist in jshyl `SkillConfig` / skill display assets.
3. Exact API for washing protagonist skill slot 2 and slot 4.
4. Exact API for 王语嫣 skill washing and `InTeam` / companion detection in this context.
5. Exact API for adding 武学常识 +50 and selected系数 +10.
6. How to detect 周目 / 2周起.
7. Whether `狼牙燕翎` should be consumed for all branches or only marked used.
8. Whether the first implementation should expose all five choices from one trigger or add five physical NPC triggers.
9. Where to place / bind a ShuiGe upper study marker inside current `52_yanziwu`.
10. Whether first implementation should preserve a route-choice reset/debug path during development.

## 10. Implementation Mapping

```yaml
implementation:
  target_maps:
    - "Assets/Mods/jshyl/Maps/GameMaps/52_yanziwu.unity"
  target_lua_files:
    - "Assets/Mods/jshyl/Lua/5210.lua"
    - "Assets/Mods/jshyl/Lua/5211.lua"
    - "Assets/Mods/jshyl/Lua/5212.lua"
    - "Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua"
  target_quest_handlers:
    - "qqzj_protagonist_apprenticeship_choose_master"
    - "qqzj_protagonist_apprenticeship_shuige_study"
  target_battles:
    - "apprenticeship later-week test battle TBD"
  target_assets:
    - "existing mentor/NPC models only"
  manual_unity_steps:
    - "inspect current 52_yanziwu mentor/NPC trigger availability"
    - "bind one future trigger to 5210 for first implementation"
    - "bind future ShuiGe study marker to 5211/5212 only after scene placement is planned"
  test_plan:
    - "family briefing complete save can trigger apprenticeship prompt"
    - "save without 狼牙燕翎 cannot complete apprenticeship"
    - "choice persists and cannot be changed accidentally"
    - "狼牙燕翎 cannot be consumed twice"
    - "old saves before this feature are not blocked from opening content"
    - "save/load preserves chosen branch and study-unlocked flag"
```

## 11. Recommended Implementation Backlog

| id | task | type | note |
|---|---|---|---|
| `TPR-042` | plan apprenticeship skill/stat API audit | planning | inspect SkillConfig, Role APIs, 周目 APIs before implementing |
| `TPR-043` | implement apprenticeship choice as dialogue/flags only | implementation | first playable slice; no skill wash or battle yet |
| `TPR-044` | implement 狼牙燕翎 consumption idempotency | implementation | may be included in TPR-043 if item removal is simple |
| `TPR-045` | plan ShuiGe upper study marker | planning | scene-binding and shelf strategy |

## 12. Coverage Status

```text
inventory status: extracted for section "主角剧情：拜师"
implementation status: not implemented
verification status: not verified
```
