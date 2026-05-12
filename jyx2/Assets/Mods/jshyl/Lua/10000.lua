-- Named quest entry point for the 阿碧 guidance interaction.
--
-- Event dispatch:
-- The scene GameEvent has m_InteractiveEventId = 10000. jshyl's ModSetting
-- uses the normal Lua file pattern, so interacting with that trigger executes
-- this file as Lua/10000.lua.
--
-- Keep scene scripts thin: the named quest owns stage flags, rewards, and
-- battle progression under JSHYL.QQZJ.Quest.

JSHYL.QQZJ.Quest.Run("qqzj_intro_abi_guidance")
do return end
