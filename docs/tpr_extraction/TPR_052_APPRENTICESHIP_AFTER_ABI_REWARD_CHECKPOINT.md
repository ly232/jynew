# TPR-052: Apprenticeship Checkpoint After First Skill Reward

## Scope

Housekeeping and documentation-only checkpoint after TPR-051.

Gameplay changes are not part of this checkpoint. The only asset housekeeping item is tracking the Unity-generated sidecar for the already tracked `5210.lua` event file.

## Meta File Housekeeping

Tracked Lua dispatcher:

```text
jyx2/Assets/Mods/jshyl/Lua/5210.lua
```

Unity-generated sidecar now tracked:

```text
jyx2/Assets/Mods/jshyl/Lua/5210.lua.meta
```

Reason:

```text
5210.lua is a tracked Unity asset for the jshyl apprenticeship interaction dispatcher.
The `.meta` contains its stable Unity GUID and should be tracked with the Lua asset.
```

## Implemented Quest IDs

| quest id | status | notes |
|---|---|---|
| `qqzj_protagonist_apprenticeship_intro` | implemented | Runs from event `5210` / `jshyl_apprenticeship_master`; handles intro, branch choice, token accounting, and current first reward. |
| `qqzj_protagonist_apprenticeship_choose_master` | implemented inside intro flow | Persistent irreversible branch-choice state, not a separate public dispatcher id. |
| `qqzj_protagonist_apprenticeship_shuige_study` | not implemented | Future ShuiGe study/shelf flow. |

## Event IDs

| event id | scene object / trigger | status | behavior |
|---:|---|---|---|
| `5210` | `jshyl_apprenticeship_master` | implemented | Dispatches to `qqzj_protagonist_apprenticeship_intro`. |
| `5211` | future ShuiGe upper study marker | not implemented | Deferred. |
| `5212` | future ShuiGe study shelf trigger(s) | not implemented | Deferred. |

## Branch Flags

Common branch state:

```text
qqzj_protagonist_apprenticeship_branch_selected
qqzj_protagonist_apprenticeship_selected_branch_id
qqzj_protagonist_apprenticeship_choose_master_started
qqzj_protagonist_apprenticeship_choose_master_prompt_seen
qqzj_protagonist_apprenticeship_choose_master_confirmed
qqzj_protagonist_apprenticeship_choose_master_completed
```

Exactly one branch flag should be set after selection:

```text
qqzj_protagonist_apprenticeship_branch_abi
qqzj_protagonist_apprenticeship_branch_dengbaichuan
qqzj_protagonist_apprenticeship_branch_baobutong
qqzj_protagonist_apprenticeship_branch_fengboe
qqzj_protagonist_apprenticeship_branch_gongyegan
```

Current branch mapping:

| branch id | branch key | mentor | skill | 系别 | reward status |
|---:|---|---|---|---|---|
| `1` | `abi` | 阿碧 | 七弦无形剑 id `206` | 暗毒 | first skill reward implemented |
| `2` | `dengbaichuan` | 邓百川 | 回风舞柳剑 id `207` | 御剑 | flag-only |
| `3` | `baobutong` | 包不同 | 如影随形腿 id `208` | 指腿 | flag-only |
| `4` | `fengboe` | 风波恶 | 飞沙走石刀 id `209` | 兵器 | flag-only |
| `5` | `gongyegan` | 公冶干 | 大风云飞掌 id `210` | 拳掌 | flag-only |

## Token Consumption

Implemented item:

```text
狼牙燕翎 item id 206
```

Implemented token flags:

```text
qqzj_protagonist_apprenticeship_langya_yanling_consumed
qqzj_protagonist_apprenticeship_langya_yanling_legacy_waived
```

Behavior:

```text
New branch selections require HaveItem(206), then consume exactly one token with AddItemWithoutHint(206, -1).
Old saves that already selected a branch consume one token if available, or receive the legacy waiver if missing.
Repeated interaction does not consume additional tokens.
```

## 阿碧 Skill Reward

Implemented reward:

```text
branch: abi
skill: 七弦无形剑
skill id: 206
API: LearnMagic2(0, 206, 0)
```

Reward flag:

```text
qqzj_protagonist_apprenticeship_branch_abi_skill_reward_claimed
```

Behavior:

```text
If 阿碧 branch is selected and token cost is consumed or legacy-waived, event 5210 grants 七弦无形剑 once.
Repeated interaction shows already-learned dialogue and does not call LearnMagic2 again.
Old saves with 阿碧 selected and token cost resolved can claim the reward once.
```

## Remaining Four Branch Rewards

Still unimplemented:

| branch | skill id | expected first reward |
|---|---:|---|
| 邓百川 / 御剑 | `207` | Learn 回风舞柳剑 once. |
| 包不同 / 指腿 | `208` | Learn 如影随形腿 once. |
| 风波恶 / 兵器 | `209` | Learn 飞沙走石刀 once. |
| 公冶干 / 拳掌 | `210` | Learn 大风云飞掌 once. |

Recommended future pattern:

```text
One generic idempotent branch reward helper keyed by selected branch.
Each branch should have a separate reward flag.
Do not add stats, slot wash, or battle gates in the same slice.
```

## Missing Stat And Slot-Wash Behavior

Still missing from source-faithful apprenticeship:

```text
second skill slot wash to the selected martial art
武学常识 +50
selected 系数 +10 after 2周+ battle victory
2周+ apprenticeship battle gate
ShuiGe upper study access
unchosen martial arts from ShuiGe shelves
王语嫣 fourth-slot wash behavior when present
```

Known APIs from prior audits:

```text
SetOneMagic(roleId, magicIndexRole, magicId, level)
AddWuchang(roleId, value)
AddAttackPoison(roleId, value)
```

These should remain deferred until smaller audits verify exact slot index, level value, stat API mapping for all five branches, and safe battle/display behavior.

## Required Unity Verification

Manual Unity check after this checkpoint:

```text
1. Confirm no untracked `.meta` remains for tracked `5210.lua`.
2. Open jshyl MOD and start/load a save in 52_yanziwu.
3. Interact with `jshyl_apprenticeship_master` / event 5210.
4. Choose 阿碧 branch with 狼牙燕翎 available.
5. Verify 狼牙燕翎 is consumed once.
6. Verify 七弦无形剑 appears as learned for 主角.
7. Save/load and interact again.
8. Verify 七弦无形剑 is not re-granted.
9. Verify choosing other branches in a fresh save remains flag-only and does not grant 七弦无形剑.
```

Known limitation:

```text
This checkpoint does not prove 七弦无形剑 can be safely used in battle. Battle/display verification belongs to a later skill-display or branch-combat slice.
```

## Recommended Next 5 Tasks

| next id | task | type | why |
|---|---|---|---|
| `TPR-053` | Plan remaining four branch rewards | planning | Generalize the TPR-051 pattern without touching stats or slot wash. |
| `TPR-054` | Implement remaining four branch first-skill rewards | implementation | Grants ids 207-210 idempotently for their selected branches. |
| `TPR-055` | Audit second skill slot wash semantics | planning | Source requires slot wash, but `SetOneMagic` index/level semantics need verification. |
| `TPR-056` | Audit apprenticeship stat APIs | planning | Map 武学常识 and five branch 系数 safely before mutation. |
| `TPR-057` | Plan ShuiGe upper study marker | planning | Resumes the deferred 5211/5212 study-room/shelf work after branch rewards are stable. |

## Coverage Status

`主角剧情：拜师` remains:

```text
partially_implemented
```

Reason:

```text
The first real skill reward is now implemented for 阿碧 only, but four branch rewards, stat changes, slot wash, battle gate, and ShuiGe study are still missing.
```

