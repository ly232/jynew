# TPR-007 Item Audit: 秋荻 Reward IDs

## Scope

Planning-only verification for the next `主角剧情：开局 / 秋荻托付` reward slice.

Requested items:

```text
司南针
九转熊蛇丸
```

Allowed inspection was limited to existing jshyl Configs and Lua files. No gameplay, config, Lua, scene, or engine files were modified.

## Results

| item | exact existing id | exists in jshyl | evidence | conclusion |
|---|---:|---|---|---|
| 司南针 | not found | no | `rg "司南针\|司南"` found only docs/TODO text, no jshyl config row | missing from current generated jshyl item config |
| 九转熊蛇丸 | 16 | yes | `Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:78` row `{16,[[九转熊蛇丸]],...}` | safe to grant after idempotency guard |

## Evidence

`九转熊蛇丸` exists:

```text
Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:78
{16,[[九转熊蛇丸]],[[逍遥派疗伤圣药，可补满内力]],...}
```

`司南针` does not appear in the allowed jshyl search scope:

```text
rg -n "司南针|司南" jyx2/Assets/Mods/jshyl/Configs jyx2/Assets/Mods/jshyl/Lua
```

Only docs/TODO references were found outside gameplay/config source.

Potential placeholder if a substitute is acceptable:

```text
Assets/Mods/jshyl/Configs/Lua/ItemConfig.lua:244
{182,[[罗盘]],[[可显示目前之坐标与船之位置]],...}
```

`罗盘` is thematically close to a navigation item, but it is not an exact match for `司南针`.

## Missing Item Strategy

Recommended strategy for `司南针`:

```text
Default: defer 司南针 reward until a real item is added or source mapping is approved.
```

Acceptable placeholder strategy only if explicitly approved:

```text
Grant 罗盘 item id 182 as temporary navigation placeholder.
Use dialogue/TODO comment to note that 司南针 is not present in current config.
Keep the reward idempotency flag identical so later replacement does not duplicate rewards.
```

Do not edit config tables during the reward implementation slice unless a later task explicitly allows config work.

## Safe Reward Implementation Plan

Quest:

```text
qqzj_protagonist_opening_qiudi_guard
```

Prerequisite:

```text
qqzj_protagonist_opening_qiudi_guard_completed
```

Reward behavior:

```text
1. If reward flag is unset, grant 九转熊蛇丸 id 16 x10.
2. Do not grant 司南针 unless a follow-up task approves placeholder id 182 or adds a real config item.
3. Set reward flag immediately after granted items are applied.
4. Repeated interaction must show already-claimed dialogue and must not call AddItem again.
5. Save/load must preserve reward flag.
```

Lua sketch:

```lua
if not Flags.GetBool("qqzj_protagonist_opening_qiudi_guard_reward_claimed") then
    AddItem(16, 10)
    -- TODO: 司南针 missing. Optional placeholder: AddItem(182, 1) only if approved.
    Flags.SetBool("qqzj_protagonist_opening_qiudi_guard_reward_claimed", true)
end
```

## Proposed Flags

Use the already extracted reward flag:

```text
qqzj_protagonist_opening_qiudi_guard_reward_claimed
```

Existing related flags:

```text
qqzj_protagonist_opening_qiudi_guard_started
qqzj_protagonist_opening_qiudi_guard_dialogue_seen
qqzj_protagonist_opening_qiudi_guard_mengxinghun_assigned
qqzj_protagonist_opening_qiudi_guard_completed
```

Optional diagnostic flag is not recommended. Keep the reward state simple unless a future migration needs it.

## Recommendation

Implement the next reward slice with only:

```text
九转熊蛇丸 id 16 x10
```

Defer `司南针` or request explicit approval to use `罗盘` id 182 as a placeholder.
