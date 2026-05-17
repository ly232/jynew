-- Quest dispatcher.
-- Scene event Lua files should call JSHYL.QQZJ.Quest.Run(questId).

JSHYL = JSHYL or {}
JSHYL.QQZJ = JSHYL.QQZJ or {}
JSHYL.QQZJ.Quest = JSHYL.QQZJ.Quest or {}

local Quest = JSHYL.QQZJ.Quest
local QUEST_ID_ABI_GUIDANCE = "qqzj_intro_abi_guidance"
local QUEST_ID_PROTAGONIST_OPENING_ARRIVAL = "qqzj_protagonist_opening_arrival"
local QUEST_ID_PROTAGONIST_OPENING_QIUDI_GUARD = "qqzj_protagonist_opening_qiudi_guard"

local ABI_FLAGS = {
    started = "qqzj_intro_abi_guidance_started",
    rewardClaimed = "qqzj_intro_abi_guidance_reward_claimed",
    sparringWon = "qqzj_intro_abi_guidance_sparring_won",
    completed = "qqzj_intro_abi_guidance_completed",
}

local ABI_LEGACY_FLAGS = {
    acknowledged = "qqzj_phase2a_abi_intro_ack",
    rewardClaimed = "qqzj_phase2b_abi_reward_claimed",
    sparringWon = "qqzj_phase2c_abi_sparring_won",
}

local PROTAGONIST_OPENING_ARRIVAL_FLAGS = {
    started = "qqzj_protagonist_opening_arrival_started",
    rewardClaimed = "qqzj_protagonist_opening_arrival_reward_claimed",
    completed = "qqzj_protagonist_opening_arrival_completed",
}

local PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS = {
    started = "qqzj_protagonist_opening_qiudi_guard_started",
    dialogueSeen = "qqzj_protagonist_opening_qiudi_guard_dialogue_seen",
    mengxinghunAssigned = "qqzj_protagonist_opening_qiudi_guard_mengxinghun_assigned",
    completed = "qqzj_protagonist_opening_qiudi_guard_completed",
}

local PROTAGONIST_OPENING_LEGACY_FLAGS = {
    openingDone = "jshyl_opening_done",
}

local function flags()
    return JSHYL.QQZJ.Flags
end

local function dialogue()
    return JSHYL.QQZJ.Dialogue
end

local function get_flag(key)
    return flags().GetBool(key)
end

local function set_flag(key, value)
    flags().SetBool(key, value)
end

local function migrate_abi_guidance_flags()
    -- Preserve Phase 2A/2B/2C saves by copying legacy progress into the
    -- named quest flags before the quest state machine runs.
    if get_flag(ABI_LEGACY_FLAGS.acknowledged) then
        set_flag(ABI_FLAGS.started, true)
    end
    if get_flag(ABI_LEGACY_FLAGS.rewardClaimed) then
        set_flag(ABI_FLAGS.started, true)
        set_flag(ABI_FLAGS.rewardClaimed, true)
    end
    if get_flag(ABI_LEGACY_FLAGS.sparringWon) then
        set_flag(ABI_FLAGS.started, true)
        set_flag(ABI_FLAGS.rewardClaimed, true)
        set_flag(ABI_FLAGS.sparringWon, true)
        set_flag(ABI_FLAGS.completed, true)
    end
end

local function set_abi_stage(flagKey, value, legacyFlagKey)
    set_flag(flagKey, value)
    if legacyFlagKey then
        set_flag(legacyFlagKey, value)
    end
end

local function migrate_protagonist_opening_arrival_flags()
    -- Preserve saves from the older ad hoc 5200.lua opening event.
    -- If that flag is already set, treat this first TPR subsection as done
    -- and do not grant starter silver again.
    if get_flag(PROTAGONIST_OPENING_LEGACY_FLAGS.openingDone) then
        set_flag(PROTAGONIST_OPENING_ARRIVAL_FLAGS.started, true)
        set_flag(PROTAGONIST_OPENING_ARRIVAL_FLAGS.rewardClaimed, true)
        set_flag(PROTAGONIST_OPENING_ARRIVAL_FLAGS.completed, true)
    end
end

local function run_protagonist_opening_arrival()
    local Dialogue = dialogue()
    local silverItemId = 174 -- 银两. TODO: confirm whether a dedicated money API is preferred.
    local startingSilver = 10000

    migrate_protagonist_opening_arrival_flags()
    set_flag(PROTAGONIST_OPENING_ARRIVAL_FLAGS.started, true)

    if get_flag(PROTAGONIST_OPENING_ARRIVAL_FLAGS.completed) then
        return Quest.Run(QUEST_ID_PROTAGONIST_OPENING_QIUDI_GUARD)
    end

    Dialogue.Talk(336, "慕容秋荻：你既回了燕子坞，先收下这笔盘缠。江湖路远，银两不可短缺。")
    Dialogue.Talk(0, "我明白。先在燕子坞站稳脚跟，再出门见这方江湖。")

    if not get_flag(PROTAGONIST_OPENING_ARRIVAL_FLAGS.rewardClaimed) then
        AddItem(silverItemId, startingSilver)
        set_flag(PROTAGONIST_OPENING_ARRIVAL_FLAGS.rewardClaimed, true)
    end

    -- TODO: Later slices should implement 慕容秋荻托付孟星魂, 杭州/开封 hooks,
    -- and the family briefing. This slice deliberately avoids companions,
    -- route locks, and extra maps.
    set_flag(PROTAGONIST_OPENING_ARRIVAL_FLAGS.completed, true)
    set_flag(PROTAGONIST_OPENING_LEGACY_FLAGS.openingDone, true)

    Dialogue.Talk(336, "慕容秋荻：今日只说到这里。你先熟悉燕子坞，其余安排，我会一步一步交代。")
    return true
end

local function run_protagonist_opening_qiudi_guard()
    local Dialogue = dialogue()

    if not get_flag(PROTAGONIST_OPENING_ARRIVAL_FLAGS.completed) then
        return Quest.Run(QUEST_ID_PROTAGONIST_OPENING_ARRIVAL)
    end

    set_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.started, true)

    if get_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.completed) then
        Dialogue.Talk(336, "慕容秋荻：孟星魂已经领了托付。他暂且暗中照看你，待同行系统安排妥当，再正式随行。")
        Dialogue.Talk(0, "有他在暗处，我心里也踏实些。")
        return true
    end

    Dialogue.Talk(336, "慕容秋荻：你初涉江湖，空有志气还不够。燕子坞之外风浪不小，我会让孟星魂先护着你。")
    Dialogue.Talk(0, "孟星魂？我听说他话不多，剑却极快。")
    Dialogue.Talk(336, "慕容秋荻：正因如此，才适合做你的影子。你照旧自己走路，他只在必要时出手。")
    Dialogue.Talk(335, "孟星魂：少主放心。路上若有人拦，我来出剑。")

    -- TODO: Later slices should verify 司南针/九转熊蛇丸 item ids before
    -- granting 秋荻 rewards. Companion joining is intentionally deferred; this
    -- slice records only the story assignment through save-backed flags.
    set_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.dialogueSeen, true)
    set_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.mengxinghunAssigned, true)
    set_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.completed, true)

    Dialogue.Talk(336, "慕容秋荻：今日只到这里。下一步，再去听二叔三叔说说江湖门户。")
    return true
end

local function run_abi_guidance()
    local Dialogue = dialogue()
    local rewardItemId = 3 -- 小还丹, a small existing starter healing item.
    local rewardCount = 1
    local sparringBattleId = 7 -- 斗胡斐, one low-level enemy on an existing battle map.

    migrate_abi_guidance_flags()
    set_abi_stage(ABI_FLAGS.started, true, nil)

    Dialogue.Talk(339, "阿碧：少主，水阁里的书卷已经收好。今日要不要先记下一件小事，试试青青子衿的开局记录？")

    if get_flag(ABI_FLAGS.rewardClaimed) then
        Dialogue.Talk(339, "阿碧：少主，上回给您的小还丹已经记在册中。存档再读，也不会再重复领取。")
        Dialogue.Talk(0, "很好，这样就不会把燕子坞的账册弄乱。")
    else
        local accepted = Dialogue.YesNo("记录一次青青子衿开局测试标记，并领取一枚小还丹？")

        if accepted then
            set_abi_stage(ABI_FLAGS.started, true, ABI_LEGACY_FLAGS.acknowledged)
            AddItem(rewardItemId, rewardCount)
            set_abi_stage(ABI_FLAGS.rewardClaimed, true, ABI_LEGACY_FLAGS.rewardClaimed)
        else
            set_abi_stage(ABI_FLAGS.started, true, nil)
            set_flag(ABI_LEGACY_FLAGS.acknowledged, false)
        end

        if get_flag(ABI_FLAGS.rewardClaimed) then
            Dialogue.Talk(339, "阿碧：已经记下，也把小还丹交给少主了。下次再来，我只回禀记录状态。")
            Dialogue.Talk(0, "先从这一点开始，慢慢把燕子坞的故事铺开。")
        else
            Dialogue.Talk(339, "阿碧：那就先不记。少主若改了主意，再来找我便是。")
        end
    end

    if get_flag(ABI_FLAGS.sparringWon) or get_flag(ABI_FLAGS.completed) then
        set_abi_stage(ABI_FLAGS.completed, true, nil)
        Dialogue.Talk(339, "阿碧：少主，今日切磋的胜负也已记下，不必重复劳神。")
        return true
    end

    local wantsSparring = Dialogue.YesNo("是否进行一次切磋？")
    if wantsSparring == false then
        Dialogue.Talk(339, "阿碧：那便先歇着。少主想试招时，再来找我。")
        return false
    end

    Dialogue.Talk(339, "阿碧：我请演武场的人点到为止，少主只管放心出招。")

    if TryBattle(sparringBattleId) then
        set_abi_stage(ABI_FLAGS.sparringWon, true, ABI_LEGACY_FLAGS.sparringWon)
        set_abi_stage(ABI_FLAGS.completed, true, nil)
        Dialogue.Talk(339, "阿碧：少主胜了。这一场切磋，我也替您记在册中。")
        return true
    end

    Dialogue.Talk(339, "阿碧：胜败都只是练手。少主若愿意，稍后还能再试。")
    return false
end

Quest.Handlers = Quest.Handlers or {}
Quest.Handlers[QUEST_ID_ABI_GUIDANCE] = run_abi_guidance
Quest.Handlers[QUEST_ID_PROTAGONIST_OPENING_ARRIVAL] = run_protagonist_opening_arrival
Quest.Handlers[QUEST_ID_PROTAGONIST_OPENING_QIUDI_GUARD] = run_protagonist_opening_qiudi_guard

function JSHYL.QQZJ.Quest.Run(questId)
    local handler = JSHYL.QQZJ.Quest.Handlers and JSHYL.QQZJ.Quest.Handlers[questId]
    if type(handler) == "function" then
        return handler()
    end

    local route = JSHYL.QQZJ.Routes and JSHYL.QQZJ.Routes[questId]
    if route and type(route.Run) == "function" then
        return route.Run()
    end

    -- Dispatcher stub for this phase. Real story content will be added later.
    if JSHYL.QQZJ.Dialogue and JSHYL.QQZJ.Dialogue.Talk then
        JSHYL.QQZJ.Dialogue.Talk(0, "青青子衿事件尚未实现：" .. tostring(questId))
    end
    return false
end
