local function CountRoutes()
    if JSHYL_StoryIndex == nil or JSHYL_StoryIndex.routes == nil then
        return 0
    end
    return #JSHYL_StoryIndex.routes
end

local function CountImplementedRouteSteps()
    if JSHYL_RouteData == nil then
        return 0
    end

    local count = 0
    for _, route in pairs(JSHYL_RouteData) do
        if route.steps ~= nil then
            count = count + #route.steps
        end
    end
    return count
end

function LuaMod_Init()
    print(string.format("金书红颜录5 如画江山 MOD 初始化：已载入 %d 条路线索引，%d 个详细事件节点。", CountRoutes(), CountImplementedRouteSteps()))
end

function LuaMod_DeInit()
    print("金书红颜录5 如画江山 MOD 析构。")
end
