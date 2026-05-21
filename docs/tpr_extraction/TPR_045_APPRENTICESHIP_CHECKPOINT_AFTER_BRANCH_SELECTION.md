# TPR-045: Apprenticeship Checkpoint After Branch Selection

## Scope

Documentation-only audit after TPR-044.

No gameplay, Lua, config, scene, Unity asset, or engine files are changed by this checkpoint.

## Current Implemented Quest IDs

| quest id | status | notes |
|---|---|---|
| `qqzj_protagonist_apprenticeship_intro` | implemented | Runs from the existing apprenticeship trigger, explains 狼牙燕翎 and the five possible mentor routes. |
| `qqzj_protagonist_apprenticeship_choose_master` | implemented inside the 5210 flow | TPR-044 implemented the branch-choice state as save-backed flags inside the existing intro handler flow rather than a separate public dispatcher id. |
| `qqzj_protagonist_apprenticeship_shuige_study` | not implemented | Still a future study-room/shelf quest from the extraction spec. |

## Current Implemented Event IDs

| event id | scene object / trigger | status | behavior |
|---:|---|---|---|
| `5210` | `jshyl_apprenticeship_master` | implemented | Dialogue intro plus irreversible branch-choice flags. |
| `5211` | future ShuiGe upper study marker | not implemented | Planned for study-room entry. |
| `5212` | future ShuiGe study shelf trigger(s) | not implemented | Planned for unchosen martial art shelf rewards. |

## Existing Branch Flags

TPR-044 now writes:

```text
qqzj_protagonist_apprenticeship_branch_selected
qqzj_protagonist_apprenticeship_selected_branch_id
qqzj_protagonist_apprenticeship_choose_master_started
qqzj_protagonist_apprenticeship_choose_master_prompt_seen
qqzj_protagonist_apprenticeship_choose_master_confirmed
qqzj_protagonist_apprenticeship_choose_master_completed
```

Exactly one of:

```text
qqzj_protagonist_apprenticeship_branch_abi
qqzj_protagonist_apprenticeship_branch_dengbaichuan
qqzj_protagonist_apprenticeship_branch_baobutong
qqzj_protagonist_apprenticeship_branch_fengboe
qqzj_protagonist_apprenticeship_branch_gongyegan
```

Branch id mapping:

| id | branch flag suffix | mentor | martial art | 系别 |
|---:|---|---|---|---|
| `1` | `abi` | 阿碧 | 七弦无形剑 | 暗毒 |
| `2` | `dengbaichuan` | 邓百川 | 回风舞柳剑 | 御剑 |
| `3` | `baobutong` | 包不同 | 如影随形腿 | 指腿 |
| `4` | `fengboe` | 风波恶 | 飞沙走石刀 | 兵器 |
| `5` | `gongyegan` | 公冶干 | 大风云飞掌 | 拳掌 |

The selected branch is intentionally irreversible once confirmed. Repeated interaction reports the locked branch and does not offer reselection.

## Missing Coverage

### Skills

The exact apprenticeship skills are still missing from `SkillConfig.lua`:

```text
七弦无形剑
回风舞柳剑
如影随形腿
飞沙走石刀
大风云飞掌
```

Recommended future ids from TPR-043 remain:

| proposed skill id | skill |
|---:|---|
| `206` | 七弦无形剑 |
| `207` | 回风舞柳剑 |
| `208` | 如影随形腿 |
| `209` | 飞沙走石刀 |
| `210` | 大风云飞掌 |

These are skill ids, not item ids, and therefore do not conflict with item ids 206-210.

### Item Consumption

`狼牙燕翎` exists as item id `206`, but TPR-044 deliberately does not consume it.

Missing item-consumption work:

```text
qqzj_protagonist_apprenticeship_langya_yanling_consumed
inventory count check for item id 206
safe one-time removal of item id 206
old-save behavior when a branch was already selected before consumption existed
```

### Stat Changes

The source calls for:

```text
主角武学常识 +50
2周起战斗胜利后 selected combat 系数 +10
```

Both are still blocked by role-stat API and playthrough/week detection audits.

### Battles

The source says 2周起拜师 requires a battle. No battle is implemented for apprenticeship yet.

Missing battle work:

```text
周目 / 2周 detection
mentor battle design
battle id and 战斗配置
victory flag
selected 系数 +10 after victory
```

### Rewards

No real apprenticeship rewards are implemented yet.

Missing reward work:

```text
selected branch skill reward
second skill slot wash
武学常识 +50
later-week 系数 +10
ShuiGe upper study access
four unchosen shelf skills
王语嫣 fourth-slot wash if present
```

## Coverage Status

`主角剧情：拜师` should remain `partially_implemented`.

Implemented:

```text
1. Extraction/spec.
2. Dedicated scene trigger/event 5210.
3. Intro dialogue.
4. Irreversible five-branch selection flags.
5. Save-backed repeat-state branch.
```

Not implemented:

```text
1. Real skills.
2. 狼牙燕翎 consumption.
3. Skill-slot wash.
4. 武学常识/stat changes.
5. Later-week battle.
6. ShuiGe upper study and shelves.
```

## Recommended Next 5 Tasks

| next id | task | type | why |
|---|---|---|---|
| `TPR-046` | apprenticeship skill config plan | planning | The exact branch skills do not exist, so config design should happen before rewards. |
| `TPR-047` | add minimal apprenticeship skill config rows | implementation | Adds inert/source-named skill ids 206-210 without wiring rewards yet. |
| `TPR-048` | item consumption API and old-save plan | planning | Confirm safe `狼牙燕翎` count check/removal and migration behavior. |
| `TPR-049` | consume `狼牙燕翎` once after branch selection | implementation | First actual branch cost, idempotent and old-save safe. |
| `TPR-050` | first real branch reward plan | planning | Choose one branch and plan skill grant/wash/stat work after exact skills exist. |

## Which Task Should Do What

Add missing skill configs:

```text
TPR-046 planning, then TPR-047 implementation.
```

Consume 狼牙燕翎:

```text
TPR-048 planning, then TPR-049 implementation.
```

Implement the first real branch reward:

```text
TPR-050 planning, then a later implementation after skill ids and consumption are stable.
```

## Safest First Branch To Implement Fully

Recommended first full branch:

```text
阿碧 / 七弦无形剑 / 暗毒
```

Reasons:

```text
1. It is already the visible representative for event 5210.
2. It does not require placing 邓百川、包不同、风波恶、公冶干 as separate scene NPCs yet.
3. It validates the reward pipeline with the least scene risk.
4. It matches the manual-verification recommendation from TPR-043.
```

The first full branch should still preserve the branch-generic data model so later branches can reuse the same reward code.

## Acceptance Criteria For Next Implementation Slice

The next implementation should not jump directly to stat mutation or battle.

TPR-047 should be accepted when:

```text
1. Skill config rows exist for all five source skill names.
2. Existing skill ids and rows are unchanged.
3. Generated SkillConfig.lua is consistent with the Excel config, if generated configs are tracked.
4. No quest grants, item consumption, battles, scene edits, or stat changes occur.
5. Backlog and coverage tracker identify exact skill ids for future reward wiring.
```
