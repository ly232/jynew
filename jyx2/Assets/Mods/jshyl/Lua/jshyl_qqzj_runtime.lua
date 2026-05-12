-- Shared runtime namespace for the Qingqingzijin campaign inside jshyl.
-- This file intentionally avoids generic globals; everything lives under JSHYL.QQZJ.

JSHYL = JSHYL or {}
JSHYL.QQZJ = JSHYL.QQZJ or {}
JSHYL.QQZJ.Runtime = JSHYL.QQZJ.Runtime or {}

function JSHYL.QQZJ.Runtime.EnsureNamespace()
    JSHYL.QQZJ.Flags = JSHYL.QQZJ.Flags or {}
    JSHYL.QQZJ.Dialogue = JSHYL.QQZJ.Dialogue or {}
    JSHYL.QQZJ.Scene = JSHYL.QQZJ.Scene or {}
    JSHYL.QQZJ.Quest = JSHYL.QQZJ.Quest or {}
    JSHYL.QQZJ.Routes = JSHYL.QQZJ.Routes or {}
end

JSHYL.QQZJ.Runtime.EnsureNamespace()
