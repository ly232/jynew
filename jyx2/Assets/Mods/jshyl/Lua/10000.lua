-- Phase 2B vertical slice: one safe NPC interaction and starter reward in 52_yanziwu.
--
-- Event dispatch:
-- The scene GameEvent has m_InteractiveEventId = 10000. jshyl's ModSetting
-- uses the normal Lua file pattern, so interacting with that trigger executes
-- this file as Lua/10000.lua.
--
-- Persistent state:
-- JSHYL.QQZJ.Flags wraps jynew's save-backed flag APIs
-- (GetFlagInt/SetFlagInt or jyx2_GetFlagInt/jyx2_SetFlagInt). These values
-- are stored in runtime save key-values, so save/load should preserve both
-- the dialogue acknowledgement and reward claim state.
--
-- Reward:
-- AddItem(...) is jynew's existing inventory API. The separate reward flag
-- prevents this script from granting the same item more than once.
--
-- Future expansion:
-- Keep scene scripts thin. Later story content can dispatch into
-- JSHYL.QQZJ.Quest.Run("quest_id") or route-specific modules from here.

local Dialogue = JSHYL.QQZJ.Dialogue
local Flags = JSHYL.QQZJ.Flags

local flagKey = "qqzj_phase2a_abi_intro_ack"
local rewardFlagKey = "qqzj_phase2b_abi_reward_claimed"
local rewardItemId = 3 -- 小还丹, a small existing starter healing item.
local rewardCount = 1

Dialogue.Talk(339, "阿碧：少主，水阁里的书卷已经收好。今日要不要先记下一件小事，试试青青子衿的开局记录？")

if Flags.GetBool(rewardFlagKey) then
    Dialogue.Talk(339, "阿碧：少主，上回给您的小还丹已经记在册中。存档再读，也不会再重复领取。")
    Dialogue.Talk(0, "很好，这样就不会把燕子坞的账册弄乱。")
    do return end
end

local accepted = Dialogue.YesNo("记录一次青青子衿开局测试标记，并领取一枚小还丹？")

if accepted then
    Flags.SetBool(flagKey, true)
    AddItem(rewardItemId, rewardCount)
    Flags.SetBool(rewardFlagKey, true)
else
    Flags.SetBool(flagKey, false)
end

if Flags.GetBool(rewardFlagKey) then
    Dialogue.Talk(339, "阿碧：已经记下，也把小还丹交给少主了。下次再来，我只回禀记录状态。")
    Dialogue.Talk(0, "先从这一点开始，慢慢把燕子坞的故事铺开。")
else
    Dialogue.Talk(339, "阿碧：那就先不记。少主若改了主意，再来找我便是。")
end

do return end
