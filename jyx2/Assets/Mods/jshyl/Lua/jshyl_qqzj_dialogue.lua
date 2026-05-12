-- Dialogue helpers.
-- Wraps jynew dialogue APIs: Talk(...) and ShowYesOrNoSelectPanel(...).

JSHYL = JSHYL or {}
JSHYL.QQZJ = JSHYL.QQZJ or {}
JSHYL.QQZJ.Dialogue = JSHYL.QQZJ.Dialogue or {}

function JSHYL.QQZJ.Dialogue.Talk(roleId, text)
    if type(Talk) == "function" then
        Talk(roleId or 0, text or "")
    end
end

function JSHYL.QQZJ.Dialogue.YesNo(prompt)
    if type(ShowYesOrNoSelectPanel) == "function" then
        return ShowYesOrNoSelectPanel(prompt or "")
    end
    return false
end
