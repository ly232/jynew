-- Quest dispatcher.
-- Scene event Lua files should call JSHYL.QQZJ.Quest.Run(questId).

JSHYL = JSHYL or {}
JSHYL.QQZJ = JSHYL.QQZJ or {}
JSHYL.QQZJ.Quest = JSHYL.QQZJ.Quest or {}

local Quest = JSHYL.QQZJ.Quest
local QUEST_ID_ABI_GUIDANCE = "qqzj_intro_abi_guidance"
local QUEST_ID_PROTAGONIST_OPENING_ARRIVAL = "qqzj_protagonist_opening_arrival"
local QUEST_ID_PROTAGONIST_OPENING_QIUDI_GUARD = "qqzj_protagonist_opening_qiudi_guard"
local QUEST_ID_PROTAGONIST_OPENING_FAMILY_BRIEFING = "qqzj_protagonist_opening_family_briefing"
local QUEST_ID_PROTAGONIST_OPENING_BROTHER_RETURN = "qqzj_protagonist_opening_brother_return"
local QUEST_ID_PROTAGONIST_OPENING_SHUIGE_ENTRY_HINT = "qqzj_protagonist_opening_shuige_entry_hint"
local QUEST_ID_PROTAGONIST_OPENING_SHUIGE_ENTRY = "qqzj_protagonist_opening_shuige_entry"
local QUEST_ID_PROTAGONIST_OPENING_SHIJIAN_TRAINING = "qqzj_protagonist_opening_shijian_training"
local QUEST_ID_YANZIWU_TREASURE_SILVER_CHEST = "qqzj_yanziwu_treasure_silver_chest"

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
    rewardClaimed = "qqzj_protagonist_opening_qiudi_guard_reward_claimed",
    completed = "qqzj_protagonist_opening_qiudi_guard_completed",
}

local PROTAGONIST_OPENING_FAMILY_BRIEFING_FLAGS = {
    started = "qqzj_protagonist_opening_family_briefing_started",
    dialogueSeen = "qqzj_protagonist_opening_family_briefing_dialogue_seen",
    hangzhouHookUnlocked = "qqzj_protagonist_opening_family_briefing_hangzhou_hook_unlocked",
    kaifengHookUnlocked = "qqzj_protagonist_opening_family_briefing_kaifeng_hook_unlocked",
    completed = "qqzj_protagonist_opening_family_briefing_completed",
}

local PROTAGONIST_OPENING_BROTHER_RETURN_FLAGS = {
    started = "qqzj_protagonist_opening_brother_return_started",
    dialogueSeen = "qqzj_protagonist_opening_brother_return_dialogue_seen",
    rewardClaimed = "qqzj_protagonist_opening_brother_return_reward_claimed",
    completed = "qqzj_protagonist_opening_brother_return_completed",
}

local PROTAGONIST_OPENING_SHUIGE_ENTRY_HINT_FLAGS = {
    started = "qqzj_protagonist_opening_shuige_entry_hint_started",
    dialogueSeen = "qqzj_protagonist_opening_shuige_entry_hint_dialogue_seen",
    completed = "qqzj_protagonist_opening_shuige_entry_hint_completed",
}

local PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS = {
    started = "qqzj_protagonist_opening_shuige_entry_started",
    unlocked = "qqzj_protagonist_opening_shuige_entry_unlocked",
    innerMarkerUnlocked = "qqzj_protagonist_opening_shuige_inner_marker_unlocked",
    completed = "qqzj_protagonist_opening_shuige_entry_completed",
}

local PROTAGONIST_OPENING_SHIJIAN_TRAINING_FLAGS = {
    started = "qqzj_protagonist_opening_shijian_training_started",
    battleWon = "qqzj_protagonist_opening_shijian_training_battle_won",
    rewardClaimed = "qqzj_protagonist_opening_shijian_training_reward_claimed",
    completed = "qqzj_protagonist_opening_shijian_training_completed",
}

local YANZIWU_TREASURE_SILVER_CHEST_FLAGS = {
    started = "qqzj_yanziwu_treasure_silver_chest_started",
    rewardClaimed = "qqzj_yanziwu_treasure_silver_chest_reward_claimed",
    completed = "qqzj_yanziwu_treasure_silver_chest_completed",
}

local PROTAGONIST_OPENING_LEGACY_FLAGS = {
    openingDone = "jshyl_opening_done",
}

local YANZIWU_TREASURE_LEGACY_FLAGS = {
    treasureTaken = "jshyl_yanzi_treasure_taken",
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

local function get_flag_int(key)
    return flags().GetInt(key, 0)
end

local function set_flag_int(key, value)
    flags().SetInt(key, value)
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
    local bearSnakePillItemId = 16 -- 九转熊蛇丸, verified in TPR-007 item audit.
    local bearSnakePillCount = 10

    if not get_flag(PROTAGONIST_OPENING_ARRIVAL_FLAGS.completed) then
        return Quest.Run(QUEST_ID_PROTAGONIST_OPENING_ARRIVAL)
    end

    set_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.started, true)

    if get_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.completed) then
        return Quest.Run(QUEST_ID_PROTAGONIST_OPENING_FAMILY_BRIEFING)
    end

    Dialogue.Talk(336, "慕容秋荻：你初涉江湖，空有志气还不够。燕子坞之外风浪不小，我会让孟星魂先护着你。")
    Dialogue.Talk(0, "孟星魂？我听说他话不多，剑却极快。")
    Dialogue.Talk(336, "慕容秋荻：正因如此，才适合做你的影子。你照旧自己走路，他只在必要时出手。")
    Dialogue.Talk(335, "孟星魂：少主放心。路上若有人拦，我来出剑。")

    if not get_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.rewardClaimed) then
        AddItem(bearSnakePillItemId, bearSnakePillCount)
        set_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.rewardClaimed, true)
    end

    -- TODO: 司南针 is unresolved in current jshyl config. Do not grant it until
    -- a real item is added or a placeholder such as 罗盘 id 182 is approved.
    -- Companion joining is intentionally deferred; this slice records only the
    -- story assignment through save-backed flags.
    set_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.dialogueSeen, true)
    set_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.mengxinghunAssigned, true)
    set_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.completed, true)

    Dialogue.Talk(336, "慕容秋荻：这十枚九转熊蛇丸先带在身边。今日只到这里，下一步，再去听二叔三叔说说江湖门户。")
    return true
end

local function run_protagonist_opening_family_briefing()
    local Dialogue = dialogue()

    if not get_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.completed) then
        return Quest.Run(QUEST_ID_PROTAGONIST_OPENING_QIUDI_GUARD)
    end

    set_flag(PROTAGONIST_OPENING_FAMILY_BRIEFING_FLAGS.started, true)

    if get_flag(PROTAGONIST_OPENING_FAMILY_BRIEFING_FLAGS.completed) then
        return Quest.Run(QUEST_ID_PROTAGONIST_OPENING_BROTHER_RETURN)
    end

    Dialogue.Talk(336, "慕容秋荻：孟星魂的事已定。接下来，二叔三叔会替你说明外头的门路。")
    Dialogue.Talk(336, "慕容秋荻：杭州牵着南下的线，开封连着中原的局。你先记住这两个名字，不必急着启程。")
    Dialogue.Talk(0, "杭州、开封。我记下了。等门户与路线都安排妥当，再按他们的指点行事。")

    -- These are narrative hook flags only. They intentionally do not unlock
    -- actual map travel, grant route tools, add companions, or edit configs.
    set_flag(PROTAGONIST_OPENING_FAMILY_BRIEFING_FLAGS.dialogueSeen, true)
    set_flag(PROTAGONIST_OPENING_FAMILY_BRIEFING_FLAGS.hangzhouHookUnlocked, true)
    set_flag(PROTAGONIST_OPENING_FAMILY_BRIEFING_FLAGS.kaifengHookUnlocked, true)
    set_flag(PROTAGONIST_OPENING_FAMILY_BRIEFING_FLAGS.completed, true)

    Dialogue.Talk(336, "慕容秋荻：今日只作铺垫。待二叔三叔的实位与杭州、开封地图补齐，再让你真正出门。")
    return true
end

local function run_protagonist_opening_brother_return()
    local Dialogue = dialogue()
    local brotherReturnRewards = {
        { itemId = 5, count = 20, name = "玉真散" },
        { itemId = 14, count = 20, name = "九转灵宝丸" },
    }

    if not get_flag(PROTAGONIST_OPENING_FAMILY_BRIEFING_FLAGS.completed) then
        return Quest.Run(QUEST_ID_PROTAGONIST_OPENING_FAMILY_BRIEFING)
    end

    set_flag(PROTAGONIST_OPENING_BROTHER_RETURN_FLAGS.started, true)

    if get_flag(PROTAGONIST_OPENING_BROTHER_RETURN_FLAGS.completed) then
        if get_flag(PROTAGONIST_OPENING_BROTHER_RETURN_FLAGS.rewardClaimed) then
            Dialogue.Talk(336, "慕容秋荻：大哥备下的玉真散与九转灵宝丸已经交给你了，账册不会重复支取。")
            Dialogue.Talk(0, "我会妥善收着。其余药材等条目补齐后再说。")
        else
            Dialogue.Talk(336, "慕容秋荻：大哥归来的事已经说过。现已核准两味药材，可以先支给你。")
            for _, reward in ipairs(brotherReturnRewards) do
                AddItem(reward.itemId, reward.count)
            end
            set_flag(PROTAGONIST_OPENING_BROTHER_RETURN_FLAGS.rewardClaimed, true)
            Dialogue.Talk(336, "慕容秋荻：玉真散二十份、九转灵宝丸二十份，先带在身边。")
        end
        return true
    end

    Dialogue.Talk(336, "慕容秋荻：二叔三叔刚把外头的门户说完，大哥也该回府了。")
    Dialogue.Talk(336, "慕容秋荻：他替你备了几味伤药与内息丹药，其中玉真散与九转灵宝丸已经对上账册。")
    Dialogue.Talk(0, "那就先领这两味。其余药材等核完再补，免得错拿。")

    for _, reward in ipairs(brotherReturnRewards) do
        AddItem(reward.itemId, reward.count)
    end
    set_flag(PROTAGONIST_OPENING_BROTHER_RETURN_FLAGS.rewardClaimed, true)

    -- TODO: 金创药、少阳丹、人参养荣丸 are missing from current jshyl item
    -- config. Do not grant substitutes until exact items or approved
    -- placeholders are added in a config-enabled task.
    set_flag(PROTAGONIST_OPENING_BROTHER_RETURN_FLAGS.dialogueSeen, true)
    set_flag(PROTAGONIST_OPENING_BROTHER_RETURN_FLAGS.completed, true)

    Dialogue.Talk(336, "慕容秋荻：玉真散二十份、九转灵宝丸二十份，已经交给你。其余三味药暂且记缺。")
    return true
end

local function run_protagonist_opening_shuige_entry_hint()
    local Dialogue = dialogue()

    if not get_flag(PROTAGONIST_OPENING_BROTHER_RETURN_FLAGS.completed) then
        Dialogue.Talk(338, "阿朱：少主，水阁里的事不急。先去听秋荻姑娘把大哥归来的安排说完。")
        Dialogue.Talk(0, "也好。等府里的开局安排理清，我再来问你水阁。")
        return false
    end

    set_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_HINT_FLAGS.started, true)

    if get_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_HINT_FLAGS.completed) then
        Dialogue.Talk(338, "阿朱：少主，水阁入口、双儿相迎、三千两规矩，我都已经说过了。真正入阁还要等场景机关补齐。")
        Dialogue.Talk(0, "我记得。现在先当作行前提示，不动水阁宝箱。")
        return true
    end

    Dialogue.Talk(338, "阿朱：少主若要正式启程，按规矩该先入还施水阁。双儿会在水阁口迎你，替你整理随身物件。")
    Dialogue.Talk(338, "阿朱：旧例还要支出三千两银子，才算过了入阁这一关。眼下水阁入口机关尚未实装，我先把规矩说清。")
    Dialogue.Talk(0, "也就是说，今日只记下还施水阁的入口提示，不收银两，也不开宝箱。")
    Dialogue.Talk(338, "阿朱：正是。等真正的水阁入口和宝箱位置绑定好，再让少主按原流程入阁。")

    -- TODO: Implement true 还施水阁 scene-entry behavior on a real entry
    -- trigger later. That future slice should verify the -3000 silver API,
    -- handle 阿朱/双儿 entry flow, and keep 水阁宝箱 rewards separate.
    set_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_HINT_FLAGS.dialogueSeen, true)
    set_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_HINT_FLAGS.completed, true)
    return true
end

local function run_protagonist_opening_shuige_entry()
    local Dialogue = dialogue()
    local innerMarkerFlag = PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS.innerMarkerUnlocked

    if not get_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_HINT_FLAGS.completed) then
        Dialogue.Talk(337, "双儿：少主，还施水阁入口已经收拾出来了，只是阿朱姐姐还没有把入阁规矩交代清楚。")
        Dialogue.Talk(0, "那我先去问阿朱。水阁入口等规矩说清后再进。")
        return false
    end

    set_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS.started, true)

    if get_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS.completed) then
        if not get_flag(innerMarkerFlag) then
            set_flag(innerMarkerFlag, true)
            if type(jyx2_FixMapObject) == "function" then
                jyx2_FixMapObject(innerMarkerFlag, "1")
            elseif JSHYL.QQZJ.Scene and JSHYL.QQZJ.Scene.Replace then
                JSHYL.QQZJ.Scene.Replace("Triggers/jshyl_shuige_inner_marker", true)
            end
        end
        Dialogue.Talk(337, "双儿：少主，水阁入口已经记下。今日仍只作入阁确认，不动宝箱，也不收银两。")
        Dialogue.Talk(0, "明白。等真正的水阁房间和宝箱流程补齐，再按旧例办理。")
        return true
    end

    Dialogue.Talk(337, "双儿：少主，这里便是还施水阁入口。阿朱姐姐说过，入阁前要先整理随身物件，旧例还要支出三千两。")
    Dialogue.Talk(0, "今日先确认入口。银两、宝箱和真正入阁移动，都等机关补齐后再办。")
    Dialogue.Talk(337, "双儿：我会把入口记录在册。少主下次再来，便知道水阁从这里进。")

    -- TODO: Future slice should implement actual teleport/room-entry behavior,
    -- verify the -3000 silver flow, and keep 水阁宝箱 rewards in a separate
    -- idempotent quest bound from the inner marker.
    set_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS.unlocked, true)
    set_flag(innerMarkerFlag, true)
    if type(jyx2_FixMapObject) == "function" then
        jyx2_FixMapObject(innerMarkerFlag, "1")
    elseif JSHYL.QQZJ.Scene and JSHYL.QQZJ.Scene.Replace then
        JSHYL.QQZJ.Scene.Replace("Triggers/jshyl_shuige_inner_marker", true)
    end
    set_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS.completed, true)
    return true
end

local function run_protagonist_opening_shijian_training()
    local Dialogue = dialogue()
    local trainingBattleId = 145
    local rewardItemId = 174 -- 银两, preserving existing 5205.lua reward.
    local rewardCount = 500

    set_flag(PROTAGONIST_OPENING_SHIJIAN_TRAINING_FLAGS.started, true)

    if get_flag(PROTAGONIST_OPENING_SHIJIAN_TRAINING_FLAGS.completed) then
        Dialogue.Talk(340, "侍剑：少主，十二金钗演武已经记下。今日不必重复支取赏银。")
        return true
    end

    Dialogue.Talk(340, "侍剑：少主，十二金钗已经列阵。此战只为演武，不伤性命。是否现在开始？")
    if Dialogue.YesNo("挑战十二金钗演武？") == false then
        Dialogue.Talk(340, "侍剑：那我让她们候着。少主想练时再来。")
        return false
    end

    if TryBattle(trainingBattleId) == false then
        Dialogue.Talk(340, "侍剑：先歇一歇也好。演武可随时再来。")
        return false
    end

    set_flag(PROTAGONIST_OPENING_SHIJIAN_TRAINING_FLAGS.battleWon, true)
    Dialogue.Talk(340, "侍剑：少主今日进退有度。之后去杭州，也算有了几分底气。")

    if not get_flag(PROTAGONIST_OPENING_SHIJIAN_TRAINING_FLAGS.rewardClaimed) then
        AddItem(rewardItemId, rewardCount)
        set_flag(PROTAGONIST_OPENING_SHIJIAN_TRAINING_FLAGS.rewardClaimed, true)
    end

    -- TODO: Source mentions 主角武常 +20 after 侍剑 training. The safe stat
    -- mutation API is still unresolved, so this refactor preserves only the
    -- existing battle 145 and 银两 id 174 x500 behavior.
    set_flag(PROTAGONIST_OPENING_SHIJIAN_TRAINING_FLAGS.completed, true)
    return true
end

local function migrate_yanziwu_treasure_silver_chest_flags()
    if get_flag_int(YANZIWU_TREASURE_LEGACY_FLAGS.treasureTaken) == 1 then
        set_flag(YANZIWU_TREASURE_SILVER_CHEST_FLAGS.rewardClaimed, true)
        set_flag(YANZIWU_TREASURE_SILVER_CHEST_FLAGS.completed, true)
    end
end

local function run_yanziwu_treasure_silver_chest()
    local silverItemId = 174
    local silverCount = 30000

    migrate_yanziwu_treasure_silver_chest_flags()
    set_flag(YANZIWU_TREASURE_SILVER_CHEST_FLAGS.started, true)

    if get_flag(YANZIWU_TREASURE_SILVER_CHEST_FLAGS.rewardClaimed) then
        ShowMessage("宝箱已经空了。")
        return true
    end

    AddItem(silverItemId, silverCount)
    set_flag(YANZIWU_TREASURE_SILVER_CHEST_FLAGS.rewardClaimed, true)
    set_flag(YANZIWU_TREASURE_SILVER_CHEST_FLAGS.completed, true)
    set_flag_int(YANZIWU_TREASURE_LEGACY_FLAGS.treasureTaken, 1)

    -- Preserve the original 5202 chest behavior while moving reward state into
    -- named QQZJ flags. This is only the existing silver chest, not full
    -- 还施水阁 / 水阁宝箱 source coverage.
    ModifyEvent(-2, -2, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2)
    ShowMessage("获得银两三万。")
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
Quest.Handlers[QUEST_ID_PROTAGONIST_OPENING_FAMILY_BRIEFING] = run_protagonist_opening_family_briefing
Quest.Handlers[QUEST_ID_PROTAGONIST_OPENING_BROTHER_RETURN] = run_protagonist_opening_brother_return
Quest.Handlers[QUEST_ID_PROTAGONIST_OPENING_SHUIGE_ENTRY_HINT] = run_protagonist_opening_shuige_entry_hint
Quest.Handlers[QUEST_ID_PROTAGONIST_OPENING_SHUIGE_ENTRY] = run_protagonist_opening_shuige_entry
Quest.Handlers[QUEST_ID_PROTAGONIST_OPENING_SHIJIAN_TRAINING] = run_protagonist_opening_shijian_training
Quest.Handlers[QUEST_ID_YANZIWU_TREASURE_SILVER_CHEST] = run_yanziwu_treasure_silver_chest

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
