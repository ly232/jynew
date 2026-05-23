# TPR-058: Apprenticeship Slot-Wash Audit

## Scope

Planning only. This audit reviews how jynew/jshyl represents learning, replacing, and washing martial arts for `主角剧情：拜师`.

No Lua, config, scene, Unity asset, gameplay, or engine files are changed by TPR-058.

## Source Requirement

The extracted TPR `拜师` section requires:

```text
After apprenticeship, protagonist second skill slot is washed to the selected apprenticeship martial art.
Later ShuiGe shelves wash protagonist fourth skill slot to each claimed unchosen martial art.
If 王语嫣 is present, her fourth skill slot also follows the ShuiGe shelf wash sequence.
```

The currently implemented 5210 flow already handles:

```text
branch selection
狼牙燕翎 consumption / old-save waiver
first skill reward through LearnMagic2(0, skillId, 0)
universal 武学常识 +50 through AddWuchang(0, 50)
```

It does not yet wash the protagonist second slot.

## Existing APIs

Lua bootstrap exposes two relevant APIs:

| API | source evidence | behavior |
|---|---|---|
| `LearnMagic2(roleId, magicId, noDisplay)` | `Assets/BuildSource/Lua/main.lua` maps it as `luaBridge.LearnMagic2` | Calls `role.LearnMagic(magicId)`. If already learned, skill level increases by 100 up to max. If not learned and skill list has capacity, appends a new `SkillInstance`. |
| `SetOneMagic(roleId, magicIndexRole, magicId, level)` | `Assets/BuildSource/Lua/main.lua` maps it as `luaBridge.SetOneMagic` | Directly writes `role.Wugongs[magicIndexRole].Key = magicId` and `Level = level`, then resets the skill cache. |

Engine-side evidence:

```text
LearnMagic2 -> RoleInstance.LearnMagic
SetOneMagic -> role.Wugongs[magicIndexRole].Key/Level
SkillInstance.GetLevel() -> Level / 100 + 1
```

Important implementation detail:

```text
SetOneMagic rejects indexes >= role.Wugongs.Count.
It can replace an existing slot, but it cannot create a missing slot.
```

## Existing Lua Examples

Examples from existing MOD scripts:

| file | example | implication |
|---|---|---|
| `Assets/Mods/JYX2/Lua/ka115.lua` | `SetOneMagic(13, 1, 92, 900)` | Slot index is zero-based. Index `1` means the second skill slot. |
| `Assets/Mods/JYX2/Lua/ka289.lua` | `SetOneMagic(36, 0, 60, 100)` | Index `0` means first skill slot. Level `100` represents level 2 because `Level / 100 + 1`. |
| `Assets/Mods/SAMPLE/Lua/117.lua` | repeated `LearnMagic2(11, 190, 0)` | Repeating `LearnMagic2` levels an already-known skill rather than targeting a slot. |

No jshyl source currently uses `SetOneMagic` for real gameplay; jshyl only mentions wash behavior in route-data notes and dialogue TODOs.

## Current jshyl Risk

The protagonist row in `Assets/Mods/jshyl/Configs/Lua/CharacterConfig.lua` currently starts with ten skills:

```text
{{1,900},{25,900},{30,900},{57,900},{58,900},{61,900},{87,900},{92,900},{29,900},{205,900}}
```

This matters because `RoleInstance.LearnMagic` refuses to append if `Wugongs.Count >= GameConst.MAX_SKILL_COUNT`.

Therefore:

```text
LearnMagic2(0, selectedSkillId, 0) may be insufficient for a full-skill protagonist if the selected skill is not already present.
SetOneMagic(0, 1, selectedSkillId, level) is likely the source-faithful and more reliable way to satisfy "second slot washed".
```

This does not mean the existing LearnMagic2 rewards must be removed immediately. It means the slot-wash implementation should become the authoritative source-fidelity step, and `LearnMagic2` should be treated as the earlier placeholder/compatibility reward.

## Does LearnMagic2 Already Place A Slot?

No.

`LearnMagic2(0, skillId, 0)` does not accept a slot argument. It either:

```text
levels the skill if already known
appends a new skill if there is capacity
fails if the skill list is full
```

It does not implement "second slot" or "fourth slot" semantics.

## Does TPR Require Exact Slot Wash?

Yes for source fidelity.

The extraction explicitly calls out:

```text
protagonist second skill slot washed to the selected apprenticeship martial art
ShuiGe shelf rewards wash protagonist fourth skill slot
王语嫣 fourth-slot wash when present
```

For current milestone quality, the first-skill `LearnMagic2` reward is an acceptable placeholder only until a targeted slot wash is implemented.

## Slot Index Recommendation

Use zero-based indexes:

| source phrase | `SetOneMagic` index |
|---|---:|
| first slot / 第1格 | `0` |
| second slot / 第2格 | `1` |
| fourth slot / 第4格 | `3` |

For the immediate apprenticeship slot wash:

```lua
SetOneMagic(0, 1, selectedSkillId, 0)
```

This sets the selected apprenticeship martial art in the protagonist second slot at level 1.

Rationale for level `0`:

```text
SkillInstance.GetLevel() returns Level / 100 + 1.
Newly learned skills created by LearnMagic2 start at Level = 0.
The extraction says "learn one apprenticeship martial art" and does not currently prove a higher slot-wash level.
```

Do not use `900` unless the source specifically says the skill should be washed at level 10.

## Risks

1. `SetOneMagic` is destructive. It overwrites whatever is currently in the target slot.
2. If role 0 ever has fewer than two skills, `SetOneMagic(0, 1, ...)` logs an index-out-of-range error and does nothing.
3. The current protagonist starts with ten skills, so the immediate jshyl baseline has a valid second slot, but future fresh-start config edits could change that.
4. `LearnMagic2` can silently fail for new skills if the protagonist is already at max skill count.
5. Running both `LearnMagic2` and `SetOneMagic` can duplicate/level the same skill in unusual save states if the skill already exists elsewhere.
6. Old saves may already have the skill reward flag but not the source-faithful second-slot wash.
7. Future ShuiGe fourth-slot wash must be designed separately because it may need repeated shelf claims and possible 王语嫣 handling.

## Minimal Implementation Strategy

Recommended next implementation should be narrow:

```text
Implement only protagonist second-slot wash for the already selected apprenticeship branch.
```

Use:

```text
SetOneMagic(0, 1, selectedSkillId, 0)
```

Gate after:

```text
selected branch exists
狼牙燕翎 consumed or legacy-waived
selected branch first-skill reward claimed
武学常识 reward claimed or available to claim
```

Add one universal idempotency flag:

```text
qqzj_protagonist_apprenticeship_second_slot_washed
```

Preserve old saves:

```text
If a save already selected a branch and has the matching skill reward claimed, allow the second-slot wash once on repeated 5210 interaction.
```

Do not implement in the same slice:

```text
fourth-slot ShuiGe shelf wash
王语嫣 slot wash
branch-specific +10 系数
2周+ battle gate
additional skills/items/stats
```

## Should Slot Wash Be Deferred?

Do not defer indefinitely.

The current `LearnMagic2` reward is good enough as a vertical-slice placeholder, but it does not satisfy the source's exact slot behavior and may not add the skill at all when the protagonist skill list is full.

However, ShuiGe shelf wash should remain deferred until after the protagonist second-slot wash is verified.

## Acceptance Criteria For Next Implementation

The next implementation slice should be accepted when:

```text
1. A completed apprenticeship branch washes protagonist second slot to the selected skill once.
2. The implementation uses SetOneMagic(0, 1, selectedSkillId, 0).
3. The wash is guarded by qqzj_protagonist_apprenticeship_second_slot_washed.
4. Old saves with branch + skill reward already claimed can receive the wash once.
5. Repeated 5210 interaction does not repeat the wash.
6. Existing skill reward and 武学常识 reward behavior are preserved.
7. No ShuiGe shelf, 王语嫣, battle, branch +10, config, scene, companion, item, or engine work is introduced.
```

## Recommended Next Task

Recommended TPR-058A:

```text
Implement protagonist second-slot apprenticeship wash only.
```

Recommended prompt:

```text
Proceed with TPR-058A: implement apprenticeship second-slot wash.

Read:
docs/tpr_extraction/TPR_058_APPRENTICESHIP_SLOT_WASH_AUDIT.md
docs/tpr_extraction/extractions/zhujuqinqing_apprenticeship.md

Allowed:
- Assets/Mods/jshyl/Lua/jshyl_qqzj_quest.lua
- docs/tpr_extraction/COVERAGE_TRACKER.md
- docs/tpr_extraction/IMPLEMENTATION_BACKLOG.md

Forbidden:
- config edits
- scene edits
- ShuiGe shelf wash
- 王语嫣 slot wash
- branch-specific stat bonuses
- battles
- companions
- items
- engine C#

Requirements:
1. After successful apprenticeship completion for any selected branch, wash protagonist second skill slot to the branch skill:
   SetOneMagic(0, 1, selectedSkillId, 0)
2. Add idempotency flag:
   qqzj_protagonist_apprenticeship_second_slot_washed
3. Gate after token is consumed/waived and selected branch skill reward is claimed.
4. Preserve old-save compatibility for branch-selected saves that already claimed skill reward.
5. Do not implement ShuiGe fourth-slot wash or 王语嫣 wash.
6. Preserve LearnMagic2 and AddWuchang behavior.
7. Update docs/backlog.
```
