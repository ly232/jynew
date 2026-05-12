-- Flag helpers.
-- Wraps jynew Lua flag APIs: GetFlagInt/SetFlagInt, with jyx2_* fallback names.

JSHYL = JSHYL or {}
JSHYL.QQZJ = JSHYL.QQZJ or {}
JSHYL.QQZJ.Flags = JSHYL.QQZJ.Flags or {}

local function read_flag_int(key)
    if type(GetFlagInt) == "function" then
        return GetFlagInt(key)
    end
    if type(jyx2_GetFlagInt) == "function" then
        return jyx2_GetFlagInt(key)
    end
    return 0
end

local function write_flag_int(key, value)
    if type(SetFlagInt) == "function" then
        SetFlagInt(key, value)
        return
    end
    if type(jyx2_SetFlagInt) == "function" then
        jyx2_SetFlagInt(key, value)
    end
end

function JSHYL.QQZJ.Flags.GetInt(key, defaultValue)
    local value = read_flag_int(key)
    if value == nil then
        return defaultValue or 0
    end
    return value
end

function JSHYL.QQZJ.Flags.SetInt(key, value)
    write_flag_int(key, value or 0)
end

function JSHYL.QQZJ.Flags.GetBool(key)
    return JSHYL.QQZJ.Flags.GetInt(key, 0) ~= 0
end

function JSHYL.QQZJ.Flags.SetBool(key, value)
    JSHYL.QQZJ.Flags.SetInt(key, value and 1 or 0)
end
