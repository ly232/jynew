# TPR-053: Remaining Apprenticeship Branch Reward Plan

## Scope

Planning only. This document designs the first-skill reward slice for the four remaining `主角剧情：拜师` branches:

```text
邓百川 -> 回风舞柳剑 id 207
包不同 -> 如影随形腿 id 208
风波恶 -> 飞沙走石刀 id 209
公冶干 -> 大风云飞掌 id 210
```

No Lua, config, scene, Unity asset, gameplay, or engine files are changed by TPR-053.

## Current Baseline

Implemented before this plan:

```text
TPR-042A: event 5210 apprenticeship intro.
TPR-044: irreversible five-branch choice flags.
TPR-047: skill config rows 206-210.
TPR-049: 狼牙燕翎 id 206 token consumption / legacy waiver.
TPR-051: 阿碧 branch learns 七弦无形剑 id 206 once.
TPR-052: checkpoint and 5210.lua.meta housekeeping.
```

Current public flow:

```text
5210.lua -> JSHYL.QQZJ.Quest.Run("qqzj_protagonist_apprenticeship_intro")
```

The implementation is still deliberately inside the existing intro flow. No new event id is needed for first-skill branch rewards.

## Skill Config Audit

All remaining branch skill ids exist in:

```text
jyx2/Assets/Mods/jshyl/Configs/Lua/SkillConfig.lua
```

Rows:

```text
207 回风舞柳剑
208 如影随形腿
209 飞沙走石刀
210 大风云飞掌
```

These rows are loadable as config data. As with 七弦无形剑, this does not prove battle display safety, so TPR-054 should not force combat or skill casting.

## Should These Mirror 阿碧?

Yes.

Recommended first reward behavior:

```text
LearnMagic2(0, skillId, 0)
```

per selected branch, exactly once.

Rationale:

```text
1. It matches the validated 阿碧 reward pattern.
2. It keeps the first real reward surface limited to "learn selected skill".
3. It gives old saves a straightforward claim path after token resolution.
4. It avoids combining reward, slot wash, stats, and battle into one risky change.
```

## Branch Reward Matrix

| branch key | mentor | skill id | skill | reward API | reward flag |
|---|---|---:|---|---|---|
| `dengbaichuan` | 邓百川 | `207` | 回风舞柳剑 | `LearnMagic2(0, 207, 0)` | `qqzj_protagonist_apprenticeship_branch_dengbaichuan_skill_reward_claimed` |
| `baobutong` | 包不同 | `208` | 如影随形腿 | `LearnMagic2(0, 208, 0)` | `qqzj_protagonist_apprenticeship_branch_baobutong_skill_reward_claimed` |
| `fengboe` | 风波恶 | `209` | 飞沙走石刀 | `LearnMagic2(0, 209, 0)` | `qqzj_protagonist_apprenticeship_branch_fengboe_skill_reward_claimed` |
| `gongyegan` | 公冶干 | `210` | 大风云飞掌 | `LearnMagic2(0, 210, 0)` | `qqzj_protagonist_apprenticeship_branch_gongyegan_skill_reward_claimed` |

Existing 阿碧 flag, already implemented:

```text
qqzj_protagonist_apprenticeship_branch_abi_skill_reward_claimed
```

## Additional Rewards

Do not add additional rewards in TPR-054.

| reward type | recommendation | reason |
|---|---|---|
| Stats | defer | 武学常识 +50 and selected 系数 need a separate stat API mapping and idempotency plan. |
| Items | do not add | The source apprenticeship reward is the selected martial art, not additional inventory. |
| Companions | do not add | Apprenticeship does not imply adding 邓百川、包不同、风波恶、公冶干 as companions. |
| Battles | defer | 2周+ battle gate needs playthrough detection, battle config, and victory/reward sequencing. |
| Slot wash | defer | Source-faithful second-slot wash needs `SetOneMagic` slot-index/level verification. |

## Old-Save Compatibility

TPR-054 should support these save states:

| save state | expected behavior |
|---|---|
| No branch selected | Continue existing branch-selection flow. |
| Remaining branch selected and token consumed | Grant that branch skill once. |
| Remaining branch selected and token legacy-waived | Grant that branch skill once. |
| Remaining branch selected but token unresolved | Let existing token-resolution logic run first; grant only after consumed or waived. |
| Reward flag already set | Show already-learned dialogue and do not call `LearnMagic2` again. |
| 阿碧 branch selected | Preserve existing TPR-051 behavior. |

Do not attempt to inspect whether the player already knows the skill. No reliable generic "has skill" Lua API has been validated; idempotency should be save-flag based.

## Risks

1. Battle display assets for ids `207` through `210` may still be incomplete. TPR-054 must not force battle or skill use.
2. `LearnMagic2` raises a skill level if already known, so missing reward flags could duplicate value. Separate per-branch flags are mandatory.
3. The current non-阿碧 branch mentors use placeholder `mentorRoleId = 0`; reward dialogue should avoid relying on distinct NPC portraits until scene/NPC work exists.
4. Implementing all four together touches the same branch-selection reward logic; keep the code generic to avoid duplicating divergent reward paths.
5. The branch choice is irreversible. Do not offer a way to switch branches while adding rewards.

## Can All Four Be Implemented Together?

Yes, if TPR-054 stays limited to first-skill rewards only.

Why it is safe:

```text
1. All four skill rows already exist.
2. The validated 阿碧 behavior can be generalized.
3. All four rewards share the same preconditions:
   - branch selected
   - 狼牙燕翎 consumed or legacy-waived
   - branch reward flag not yet set
4. No scene, config, battle, companion, item, stat, or engine changes are needed.
```

Preferred implementation strategy:

```text
Implement all four together through a branch reward table/helper.
```

Avoid one-branch-at-a-time unless TPR-054 discovers an unexpected missing skill row or runtime issue. One generic helper reduces copy/paste risk and brings every branch to the same baseline state.

## Recommended Helper Shape

Extend the existing branch table or add a reward table with:

```text
branch key
skill id
skill name
reward flag
```

Then call a generic helper after token resolution:

```text
if selectedBranch and apprenticeship_token_cost_resolved() then
  claim_selected_apprenticeship_skill_reward(Dialogue, selectedBranch)
end
```

The helper should:

```text
1. Look up reward data for selectedBranch.key.
2. If no reward data exists, return without side effect.
3. If reward flag already set, show already-learned dialogue and return.
4. Call LearnMagic2(0, skillId, 0).
5. Set reward flag.
6. Show concise reward dialogue.
```

TPR-054 may fold 阿碧 into this generic helper if behavior remains compatible and the existing 阿碧 reward flag is preserved.

## Acceptance Criteria For TPR-054

TPR-054 should be accepted when:

```text
1. 邓百川 branch grants 回风舞柳剑 id 207 once.
2. 包不同 branch grants 如影随形腿 id 208 once.
3. 风波恶 branch grants 飞沙走石刀 id 209 once.
4. 公冶干 branch grants 大风云飞掌 id 210 once.
5. 阿碧 branch still grants 七弦无形剑 id 206 once with the existing flag.
6. Rewards require token consumed or legacy-waived state.
7. Repeated interaction does not call LearnMagic2 again for any branch.
8. No stats, slot wash, battles, companions, item rewards, scene edits, config edits, or engine changes are introduced.
9. Docs/backlog mark TPR-054 implemented.
```

## Recommended TPR-054 Implementation Prompt

```text
Proceed with TPR-054: implement remaining apprenticeship first-skill rewards.

Read:
docs/tpr_extraction/TPR_053_REMAINING_APPRENTICESHIP_BRANCH_REWARD_PLAN.md
docs/tpr_extraction/TPR_052_APPRENTICESHIP_AFTER_ABI_REWARD_CHECKPOINT.md

Allowed:
- Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- config edits
- scene edits
- stat changes
- slot wash logic
- battles
- companions
- item rewards
- engine C#

Requirements:
1. Preserve 阿碧 reward behavior and flag:
   qqzj_protagonist_apprenticeship_branch_abi_skill_reward_claimed
2. Add first-skill rewards for:
   - dengbaichuan -> LearnMagic2(0, 207, 0)
   - baobutong -> LearnMagic2(0, 208, 0)
   - fengboe -> LearnMagic2(0, 209, 0)
   - gongyegan -> LearnMagic2(0, 210, 0)
3. Add idempotency flags:
   - qqzj_protagonist_apprenticeship_branch_dengbaichuan_skill_reward_claimed
   - qqzj_protagonist_apprenticeship_branch_baobutong_skill_reward_claimed
   - qqzj_protagonist_apprenticeship_branch_fengboe_skill_reward_claimed
   - qqzj_protagonist_apprenticeship_branch_gongyegan_skill_reward_claimed
4. Require branch selected and token cost consumed or legacy-waived.
5. Repeated interaction must not duplicate rewards.
6. Do not implement stats, second-slot wash, battles, companions, or ShuiGe study.
7. Update docs/backlog.

Done when:
- all five branches have exactly one first-skill reward path
- old saves with selected branch and resolved/waived token can claim once
- no unrelated systems are modified
```

