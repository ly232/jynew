-- Scene helpers.
-- Wraps jynew scene APIs: jyx2_ReplaceSceneObject(...) and flag APIs.

JSHYL = JSHYL or {}
JSHYL.QQZJ = JSHYL.QQZJ or {}
JSHYL.QQZJ.Scene = JSHYL.QQZJ.Scene or {}

local function flag_get_bool(key)
    if JSHYL.QQZJ.Flags and JSHYL.QQZJ.Flags.GetBool then
        return JSHYL.QQZJ.Flags.GetBool(key)
    end
    if type(GetFlagInt) == "function" then
        return GetFlagInt(key) ~= 0
    end
    return false
end

local function flag_set_bool(key, value)
    if JSHYL.QQZJ.Flags and JSHYL.QQZJ.Flags.SetBool then
        JSHYL.QQZJ.Flags.SetBool(key, value)
        return
    end
    if type(SetFlagInt) == "function" then
        SetFlagInt(key, value and 1 or 0)
    end
end

function JSHYL.QQZJ.Scene.Replace(path, active)
    if type(jyx2_ReplaceSceneObject) == "function" then
        jyx2_ReplaceSceneObject("", path, active and "1" or "")
    end
end

function JSHYL.QQZJ.Scene.BindOnce(flagKey, callback)
    if flag_get_bool(flagKey) then
        return false
    end
    if type(callback) == "function" then
        callback()
    end
    flag_set_bool(flagKey, true)
    return true
end
