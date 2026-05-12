-- Phase 2A vertical slice: one safe NPC interaction in 52_yanziwu.
--
-- Event dispatch:
-- The scene GameEvent has m_InteractiveEventId = 10000. jshyl's ModSetting
-- uses the normal Lua file pattern, so interacting with that trigger executes
-- this file as Lua/10000.lua.
--
-- Persistent state:
-- JSHYL.QQZJ.Flags wraps jynew's save-backed flag APIs
-- (GetFlagInt/SetFlagInt or jyx2_GetFlagInt/jyx2_SetFlagInt). These values
-- are stored in runtime save key-values, so save/load should preserve them.
--
-- Future expansion:
-- Keep scene scripts thin. Later story content can dispatch into
-- JSHYL.QQZJ.Quest.Run("quest_id") or route-specific modules from here.

local Dialogue = JSHYL.QQZJ.Dialogue
local Flags = JSHYL.QQZJ.Flags

local flagKey = "qqzj_phase2a_abi_intro_ack"

Dialogue.Talk(339, "阿碧：少主，水阁里的书卷已经收好。今日要不要先记下一件小事，试试青青子衿的开局记录？")

if Flags.GetBool(flagKey) then
    Dialogue.Talk(339, "阿碧：这件事已经记在册中。就算存档再读，阿碧也不会忘。")
    Dialogue.Talk(0, "很好，看来燕子坞的记录簿已经能用了。")
    do return end
end

local accepted = Dialogue.YesNo("记录一次青青子衿开局测试标记？")

if accepted then
    Flags.SetBool(flagKey, true)
else
    Flags.SetBool(flagKey, false)
end

if Flags.GetBool(flagKey) then
    Dialogue.Talk(339, "阿碧：已经记下了。下次少主再来，我会换一句话回禀。")
    Dialogue.Talk(0, "先从这一点开始，慢慢把燕子坞的故事铺开。")
else
    Dialogue.Talk(339, "阿碧：那就先不记。少主若改了主意，再来找我便是。")
end

do return end
