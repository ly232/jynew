-- JSHYL QQZJ campaign Lua entrypoint.
-- Add this file to ModSetting.asset / PreloadedLua before the other jshyl_qqzj_* files.

JSHYL = JSHYL or {}
JSHYL.QQZJ = JSHYL.QQZJ or {}

JSHYL.QQZJ.ModId = "jshyl"
JSHYL.QQZJ.CampaignId = "qingqingzijin"
JSHYL.QQZJ.Version = "phase_1a_refactor"

function JSHYL.QQZJ.Init()
    JSHYL.QQZJ.Runtime = JSHYL.QQZJ.Runtime or {}
    JSHYL.QQZJ.Flags = JSHYL.QQZJ.Flags or {}
    JSHYL.QQZJ.Dialogue = JSHYL.QQZJ.Dialogue or {}
    JSHYL.QQZJ.Scene = JSHYL.QQZJ.Scene or {}
    JSHYL.QQZJ.Quest = JSHYL.QQZJ.Quest or {}
    JSHYL.QQZJ.Routes = JSHYL.QQZJ.Routes or {}
end

JSHYL.QQZJ.Init()
