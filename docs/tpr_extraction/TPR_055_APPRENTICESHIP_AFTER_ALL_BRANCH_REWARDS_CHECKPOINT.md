# TPR-055: Apprenticeship Checkpoint After All Branch Rewards

## Scope

Documentation-only checkpoint after TPR-054.

No gameplay, Lua, config, Unity asset, scene, or engine files are changed by this checkpoint.

## Implemented Event IDs

| event id | scene object / trigger | status | behavior |
|---:|---|---|---|
| `5210` | `jshyl_apprenticeship_master` | implemented | Dispatches to `qqzj_protagonist_apprenticeship_intro`; handles intro, branch choice, token accounting, and first-skill reward. |
| `5211` | future ShuiGe upper study marker | not implemented | Deferred. |
| `5212` | future ShuiGe study shelf trigger(s) | not implemented | Deferred. |

## Implemented Quest IDs

| quest id | status | notes |
|---|---|---|
| `qqzj_protagonist_apprenticeship_intro` | implemented | The public 5210 handler. It currently owns intro, branch choice, token consumption/waiver, and selected first-skill reward. |
| `qqzj_protagonist_apprenticeship_choose_master` | implemented inside intro flow | Represented as persistent flags rather than a separate dispatcher id. |
| `qqzj_protagonist_apprenticeship_shuige_study` | not implemented | Study-room entry and shelves are still future work. |

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

Exactly one selected-branch flag:

```text
qqzj_protagonist_apprenticeship_branch_abi
qqzj_protagonist_apprenticeship_branch_dengbaichuan
qqzj_protagonist_apprenticeship_branch_baobutong
qqzj_protagonist_apprenticeship_branch_fengboe
qqzj_protagonist_apprenticeship_branch_gongyegan
```

## Token Consumption

Implemented item:

```text
狼牙燕翎 item id 206
```

Implemented flags:

```text
qqzj_protagonist_apprenticeship_langya_yanling_consumed
qqzj_protagonist_apprenticeship_langya_yanling_legacy_waived
```

Behavior:

```text
New branch selections require one 狼牙燕翎 and consume it with AddItemWithoutHint(206, -1).
Old saves that selected a branch before token consumption existed consume one token if available, otherwise receive the legacy waiver.
Repeated interaction does not consume another token.
```

## Skill Rewards

All five first-skill rewards are now implemented through `LearnMagic2(0, skillId, 0)`.

| branch key | mentor | skill id | skill | reward flag |
|---|---|---:|---|---|
| `abi` | 阿碧 | `206` | 七弦无形剑 | `qqzj_protagonist_apprenticeship_branch_abi_skill_reward_claimed` |
| `dengbaichuan` | 邓百川 | `207` | 回风舞柳剑 | `qqzj_protagonist_apprenticeship_branch_dengbaichuan_skill_reward_claimed` |
| `baobutong` | 包不同 | `208` | 如影随形腿 | `qqzj_protagonist_apprenticeship_branch_baobutong_skill_reward_claimed` |
| `fengboe` | 风波恶 | `209` | 飞沙走石刀 | `qqzj_protagonist_apprenticeship_branch_fengboe_skill_reward_claimed` |
| `gongyegan` | 公冶干 | `210` | 大风云飞掌 | `qqzj_protagonist_apprenticeship_branch_gongyegan_skill_reward_claimed` |

Reward behavior:

```text
The selected branch grants exactly one matching skill after token cost is consumed or legacy-waived.
Repeated interaction branches to already-learned dialogue and does not re-run LearnMagic2.
Other branches remain unavailable because the branch choice is irreversible.
```

## Missing Coverage

### Stats

Still missing:

```text
武学常识 +50
selected 系数 +10 after 2周+ battle victory
```

Known but not yet used:

```text
AddWuchang(roleId, value)
AddAttackPoison(roleId, value)
```

Remaining work:

```text
Map every branch 系别 to the correct jynew stat API.
Plan idempotency flags.
Decide whether 武学常识 +50 happens immediately after skill reward or after slot wash.
```

### Slot Wash

Still missing:

```text
protagonist second skill slot washed to selected apprenticeship martial art
ShuiGe shelves wash protagonist fourth skill slot
王语嫣 fourth-slot wash if present
```

Known but not yet used:

```text
SetOneMagic(roleId, magicIndexRole, magicId, level)
```

Remaining work:

```text
Verify slot index for "second" and "fourth" skill slots.
Verify source-faithful level/experience value.
Define old-save behavior for players who already claimed skill rewards.
```

### Battles

Still missing:

```text
2周起 apprenticeship battle gate
mentor/family test battle configuration
victory flag
selected 系数 +10 after victory
```

Blocked by:

```text
playthrough/week detection audit
battle id/config design
skill display verification if new skills are used in combat
```

### Items

No additional apprenticeship items are implemented or currently planned.

Implemented item use:

```text
狼牙燕翎 id 206 is consumed once as the branch token.
```

The source beat does not require extra inventory rewards at this stage.

### ShuiGe Study Shelves

Still missing:

```text
upper ShuiGe study marker/event
four unchosen martial art shelf rewards
shelf claim flags
fourth-slot wash for protagonist
optional 王语嫣 fourth-slot wash
```

Likely future event ids from extraction:

```text
5211: upper study marker
5212: shelf trigger(s)
```

### Branch-Specific Mechanics

Still missing:

```text
branch-specific 系数 reward behavior
any branch-specific dialogue beyond first-skill reward
branch-specific future route effects, if any later TPR sections depend on the chosen apprenticeship branch
```

## Coverage Status

`主角剧情：拜师` remains:

```text
partially_implemented
```

Reason:

```text
The interaction is playable through intro, branch choice, token consumption, and first selected skill reward, but source-critical stat, slot wash, battle, and ShuiGe study behaviors are still missing.
```

## Is It Playable End-To-End?

Playable as a vertical slice:

```text
Yes. A player can enter the 5210 interaction, choose one branch, spend/waive the token, learn the matching first skill, save/load, and avoid duplicate reward grants.
```

Source-complete:

```text
No. It does not yet satisfy the full TPR 拜师 source because stats, skill-slot wash, 2周+ battle, and ShuiGe study shelves are absent.
```

## Required Unity Verification

Manual verification should cover:

```text
1. Fresh save with 狼牙燕翎 available.
2. Choose each branch in separate saves.
3. Confirm exactly the matching skill is learned.
4. Save/load after each reward.
5. Interact again and confirm no duplicate LearnMagic2 effect.
6. Confirm token is consumed once or legacy-waived only for old branch-selected saves.
7. Confirm no battle starts and no stat/slot changes happen yet.
```

Known limitation:

```text
This checkpoint does not validate battle usage of skills 206-210.
```

## Recommended Next 5 Tasks

| next id | task | type | purpose |
|---|---|---|---|
| `TPR-056` | Apprenticeship stat API and reward plan | planning | Decide exact APIs/flags for 武学常识 +50 and branch 系数 behavior. |
| `TPR-057` | Implement 武学常识 +50 only | implementation | Add the safest source stat reward before branch-specific 系数 or battles. |
| `TPR-058` | Second skill slot wash semantics audit | planning | Verify `SetOneMagic` index/level and old-save handling. |
| `TPR-059` | ShuiGe upper study marker plan | planning | Plan 5211/5212 scene binding and shelf flow after baseline rewards. |
| `TPR-060` | Extract next TPR section after 拜师 | extraction/planning | Prepare 家传武艺 or the next 主角剧情 subsection once core 拜师 follow-up dependencies are clear. |

## Which Next Task Should Do What

Add stats:

```text
TPR-056 should plan stats first.
TPR-057 should implement only 武学常识 +50 if the plan confirms it is safe.
Branch-specific +10 系数 should wait for battle/playthrough planning.
```

Add ShuiGe study mechanics:

```text
TPR-059 should plan the scene/event/shelf structure.
Implementation should wait until slot-wash semantics are clear, because ShuiGe shelves depend on fourth-slot wash behavior.
```

Extract next TPR section:

```text
TPR-060 should extract the next 主角剧情 section after the immediate stat/slot/ShuiGe dependencies are documented, so later work does not outrun the core apprenticeship contract.
```

