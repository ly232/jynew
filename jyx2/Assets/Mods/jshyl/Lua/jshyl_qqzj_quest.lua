-- Quest dispatcher.
-- Scene event Lua files should call JSHYL.QQZJ.Quest.Run(questId).

JSHYL = JSHYL or {}
JSHYL.QQZJ = JSHYL.QQZJ or {}
JSHYL.QQZJ.Quest = JSHYL.QQZJ.Quest or {}

local Quest = JSHYL.QQZJ.Quest
local QUEST_ID_ABI_GUIDANCE = "qqzj_intro_abi_guidance"
local QUEST_ID_PROTAGONIST_OPENING_ARRIVAL = "qqzj_protagonist_opening_arrival"
local QUEST_ID_PROTAGONIST_OPENING_QIUDI_GUARD = "qqzj_protagonist_opening_qiudi_guard"
local QUEST_ID_PROTAGONIST_OPENING_MENGXINGHUN_JOIN = "qqzj_protagonist_opening_mengxinghun_join"
local QUEST_ID_PROTAGONIST_OPENING_FAMILY_BRIEFING = "qqzj_protagonist_opening_family_briefing"
local QUEST_ID_PROTAGONIST_OPENING_BROTHER_RETURN = "qqzj_protagonist_opening_brother_return"
local QUEST_ID_PROTAGONIST_OPENING_SHUIGE_ENTRY_HINT = "qqzj_protagonist_opening_shuige_entry_hint"
local QUEST_ID_PROTAGONIST_OPENING_SHUIGE_ENTRY = "qqzj_protagonist_opening_shuige_entry"
local QUEST_ID_PROTAGONIST_OPENING_SHUIGE_INNER = "qqzj_protagonist_opening_shuige_inner"
local QUEST_ID_PROTAGONIST_OPENING_SHUIGE_CENTER_CHEST = "qqzj_protagonist_opening_shuige_center_chest"
local QUEST_ID_PROTAGONIST_OPENING_SHIJIAN_TRAINING = "qqzj_protagonist_opening_shijian_training"
local QUEST_ID_YANZIWU_TREASURE_SILVER_CHEST = "qqzj_yanziwu_treasure_silver_chest"
local QUEST_ID_PROTAGONIST_APPRENTICESHIP_INTRO = "qqzj_protagonist_apprenticeship_intro"

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
    toolRewardClaimed = "qqzj_protagonist_opening_qiudi_guard_tool_reward_claimed",
    completed = "qqzj_protagonist_opening_qiudi_guard_completed",
}

local PROTAGONIST_OPENING_MENGXINGHUN_JOIN_FLAGS = {
    started = "qqzj_protagonist_opening_mengxinghun_join_started",
    completed = "qqzj_protagonist_opening_mengxinghun_join_completed",
}

local PROTAGONIST_OPENING_FAMILY_BRIEFING_FLAGS = {
    started = "qqzj_protagonist_opening_family_briefing_started",
    dialogueSeen = "qqzj_protagonist_opening_family_briefing_dialogue_seen",
    hangzhouHookUnlocked = "qqzj_protagonist_opening_family_briefing_hangzhou_hook_unlocked",
    kaifengHookUnlocked = "qqzj_protagonist_opening_family_briefing_kaifeng_hook_unlocked",
    toolRewardClaimed = "qqzj_protagonist_opening_family_briefing_tool_reward_claimed",
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
    insufficientSilver = "qqzj_protagonist_opening_shuige_entry_insufficient_silver",
    paid = "qqzj_protagonist_opening_shuige_entry_paid",
    legacyCostWaived = "qqzj_protagonist_opening_shuige_entry_legacy_cost_waived",
    costResolved = "qqzj_protagonist_opening_shuige_entry_cost_resolved",
    completed = "qqzj_protagonist_opening_shuige_entry_completed",
}

local PROTAGONIST_OPENING_SHUIGE_INNER_FLAGS = {
    started = "qqzj_protagonist_opening_shuige_inner_started",
    dialogueSeen = "qqzj_protagonist_opening_shuige_inner_dialogue_seen",
    completed = "qqzj_protagonist_opening_shuige_inner_completed",
}

local PROTAGONIST_OPENING_SHUIGE_CENTER_CHEST_FLAGS = {
    started = "qqzj_protagonist_opening_shuige_center_chest_started",
    rewardClaimed = "qqzj_protagonist_opening_shuige_center_chest_reward_claimed",
    completed = "qqzj_protagonist_opening_shuige_center_chest_completed",
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

local PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS = {
    started = "qqzj_protagonist_apprenticeship_intro_started",
    dialogueSeen = "qqzj_protagonist_apprenticeship_intro_dialogue_seen",
    completed = "qqzj_protagonist_apprenticeship_intro_completed",
    branchSelected = "qqzj_protagonist_apprenticeship_branch_selected",
    selectedBranchId = "qqzj_protagonist_apprenticeship_selected_branch_id",
    chooseMasterStarted = "qqzj_protagonist_apprenticeship_choose_master_started",
    chooseMasterPromptSeen = "qqzj_protagonist_apprenticeship_choose_master_prompt_seen",
    chooseMasterConfirmed = "qqzj_protagonist_apprenticeship_choose_master_confirmed",
    chooseMasterCompleted = "qqzj_protagonist_apprenticeship_choose_master_completed",
    langyaYanlingConsumed = "qqzj_protagonist_apprenticeship_langya_yanling_consumed",
    langyaYanlingLegacyWaived = "qqzj_protagonist_apprenticeship_langya_yanling_legacy_waived",
    branchAbiSkillRewardClaimed = "qqzj_protagonist_apprenticeship_branch_abi_skill_reward_claimed",
    branchDengbaichuanSkillRewardClaimed = "qqzj_protagonist_apprenticeship_branch_dengbaichuan_skill_reward_claimed",
    branchBaobutongSkillRewardClaimed = "qqzj_protagonist_apprenticeship_branch_baobutong_skill_reward_claimed",
    branchFengboeSkillRewardClaimed = "qqzj_protagonist_apprenticeship_branch_fengboe_skill_reward_claimed",
    branchGongyeganSkillRewardClaimed = "qqzj_protagonist_apprenticeship_branch_gongyegan_skill_reward_claimed",
}

local PROTAGONIST_APPRENTICESHIP_BRANCHES = {
    {
        id = 1,
        key = "abi",
        flag = "qqzj_protagonist_apprenticeship_branch_abi",
        mentorRoleId = 339,
        mentorName = "阿碧",
        skillName = "七弦无形剑",
        branchName = "暗毒",
    },
    {
        id = 2,
        key = "dengbaichuan",
        flag = "qqzj_protagonist_apprenticeship_branch_dengbaichuan",
        mentorRoleId = 0,
        mentorName = "邓百川",
        skillName = "回风舞柳剑",
        branchName = "御剑",
    },
    {
        id = 3,
        key = "baobutong",
        flag = "qqzj_protagonist_apprenticeship_branch_baobutong",
        mentorRoleId = 0,
        mentorName = "包不同",
        skillName = "如影随形腿",
        branchName = "指腿",
    },
    {
        id = 4,
        key = "fengboe",
        flag = "qqzj_protagonist_apprenticeship_branch_fengboe",
        mentorRoleId = 0,
        mentorName = "风波恶",
        skillName = "飞沙走石刀",
        branchName = "兵器",
    },
    {
        id = 5,
        key = "gongyegan",
        flag = "qqzj_protagonist_apprenticeship_branch_gongyegan",
        mentorRoleId = 0,
        mentorName = "公冶干",
        skillName = "大风云飞掌",
        branchName = "拳掌",
    },
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
    local compassItemId = 205 -- 司南针, inert TPR opening tool item.

    if not get_flag(PROTAGONIST_OPENING_ARRIVAL_FLAGS.completed) then
        return Quest.Run(QUEST_ID_PROTAGONIST_OPENING_ARRIVAL)
    end

    set_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.started, true)

    if get_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.completed) then
        if not get_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.toolRewardClaimed) then
            AddItem(compassItemId, 1)
            set_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.toolRewardClaimed, true)
            Dialogue.Talk(336, "慕容秋荻：司南针如今也已备好，你既已受托出门，就一并带上。")
        end
        return Quest.Run(QUEST_ID_PROTAGONIST_OPENING_MENGXINGHUN_JOIN)
    end

    Dialogue.Talk(336, "慕容秋荻：你初涉江湖，空有志气还不够。燕子坞之外风浪不小，我会让孟星魂先护着你。")
    Dialogue.Talk(0, "孟星魂？我听说他话不多，剑却极快。")
    Dialogue.Talk(336, "慕容秋荻：正因如此，才适合做你的影子。你照旧自己走路，他只在必要时出手。")
    Dialogue.Talk(335, "孟星魂：少主放心。路上若有人拦，我来出剑。")

    if not get_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.rewardClaimed) then
        AddItem(bearSnakePillItemId, bearSnakePillCount)
        set_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.rewardClaimed, true)
    end

    if not get_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.toolRewardClaimed) then
        AddItem(compassItemId, 1)
        set_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.toolRewardClaimed, true)
    end

    -- Companion joining is intentionally deferred; this slice records only the
    -- story assignment through save-backed flags. 司南针 remains an inert story
    -- tool until route-specific mechanics are implemented.
    set_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.dialogueSeen, true)
    set_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.mengxinghunAssigned, true)
    set_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.completed, true)

    Dialogue.Talk(336, "慕容秋荻：这十枚九转熊蛇丸和司南针先带在身边。今日只到这里，下一步，再去听二叔三叔说说江湖门户。")
    return true
end

local function run_protagonist_opening_mengxinghun_join()
    local Dialogue = dialogue()
    local mengxinghunRoleId = 335

    if not get_flag(PROTAGONIST_OPENING_QIUDI_GUARD_FLAGS.completed) then
        return Quest.Run(QUEST_ID_PROTAGONIST_OPENING_QIUDI_GUARD)
    end

    set_flag(PROTAGONIST_OPENING_MENGXINGHUN_JOIN_FLAGS.started, true)

    if get_flag(PROTAGONIST_OPENING_MENGXINGHUN_JOIN_FLAGS.completed) then
        return Quest.Run(QUEST_ID_PROTAGONIST_OPENING_FAMILY_BRIEFING)
    end

    if InTeam(mengxinghunRoleId) then
        Dialogue.Talk(335, "孟星魂：我已在队中。少主向前走便是。")
        set_flag(PROTAGONIST_OPENING_MENGXINGHUN_JOIN_FLAGS.completed, true)
        return true
    end

    if TeamIsFull() then
        Dialogue.Talk(335, "孟星魂：队伍已满，我暂在暗处随行。少主若要我入队，先空出一个位置。")
        return false
    end

    Dialogue.Talk(335, "孟星魂：秋荻姑娘有命，从今日起，我随少主同行。")
    Join(mengxinghunRoleId)
    set_flag(PROTAGONIST_OPENING_MENGXINGHUN_JOIN_FLAGS.completed, true)
    Dialogue.Talk(0, "有你在，出门确实安心许多。")
    return true
end

local function run_protagonist_opening_family_briefing()
    local Dialogue = dialogue()
    local toolRewards = {
        { itemId = 206, count = 1, name = "狼牙燕翎" },
        { itemId = 207, count = 1, name = "秦皇照骨镜" },
        { itemId = 208, count = 1, name = "洛阳铲" },
    }

    if not get_flag(PROTAGONIST_OPENING_MENGXINGHUN_JOIN_FLAGS.completed) then
        return Quest.Run(QUEST_ID_PROTAGONIST_OPENING_MENGXINGHUN_JOIN)
    end

    set_flag(PROTAGONIST_OPENING_FAMILY_BRIEFING_FLAGS.started, true)

    if get_flag(PROTAGONIST_OPENING_FAMILY_BRIEFING_FLAGS.completed) then
        if not get_flag(PROTAGONIST_OPENING_FAMILY_BRIEFING_FLAGS.toolRewardClaimed) then
            for _, reward in ipairs(toolRewards) do
                AddItem(reward.itemId, reward.count)
            end
            set_flag(PROTAGONIST_OPENING_FAMILY_BRIEFING_FLAGS.toolRewardClaimed, true)
            Dialogue.Talk(336, "慕容秋荻：二叔三叔留下的狼牙燕翎、秦皇照骨镜、洛阳铲，今日补交给你。")
        end
        return Quest.Run(QUEST_ID_PROTAGONIST_OPENING_BROTHER_RETURN)
    end

    Dialogue.Talk(336, "慕容秋荻：孟星魂的事已定。接下来，二叔三叔会替你说明外头的门路。")
    Dialogue.Talk(336, "慕容秋荻：杭州牵着南下的线，开封连着中原的局。你先记住这两个名字，不必急着启程。")
    Dialogue.Talk(0, "杭州、开封。我记下了。等门户与路线都安排妥当，再按他们的指点行事。")

    if not get_flag(PROTAGONIST_OPENING_FAMILY_BRIEFING_FLAGS.toolRewardClaimed) then
        for _, reward in ipairs(toolRewards) do
            AddItem(reward.itemId, reward.count)
        end
        set_flag(PROTAGONIST_OPENING_FAMILY_BRIEFING_FLAGS.toolRewardClaimed, true)
        Dialogue.Talk(336, "慕容秋荻：二叔三叔也给你留了三件行走用物：狼牙燕翎、秦皇照骨镜、洛阳铲。先收着，日后遇到对应门路再细用。")
    end

    -- These are narrative hook flags only. They intentionally do not unlock
    -- actual map travel, add companions, or edit configs. The granted tools are
    -- inert inventory/story items until later route mechanics are specified.
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

local function unlock_shuige_inner_marker(innerMarkerFlag)
    set_flag(innerMarkerFlag, true)
    if type(jyx2_FixMapObject) == "function" then
        jyx2_FixMapObject(innerMarkerFlag, "1")
    elseif JSHYL.QQZJ.Scene and JSHYL.QQZJ.Scene.Replace then
        JSHYL.QQZJ.Scene.Replace("Triggers/jshyl_shuige_inner_marker", true)
    end
end

local function migrate_shuige_entry_cost_flags()
    local flags = PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS

    if get_flag(flags.costResolved) then
        return
    end

    -- TPR-039B adds the -3000 银两 entry cost after earlier slices already
    -- allowed entry/inner/chest progress. Preserve those saves and never
    -- retroactively charge players who passed the old no-cost gate.
    if get_flag(flags.completed)
        or get_flag(flags.innerMarkerUnlocked)
        or get_flag(PROTAGONIST_OPENING_SHUIGE_INNER_FLAGS.completed)
        or get_flag(PROTAGONIST_OPENING_SHUIGE_CENTER_CHEST_FLAGS.rewardClaimed) then
        set_flag(flags.legacyCostWaived, true)
        set_flag(flags.costResolved, true)
    end
end

local function run_protagonist_opening_shuige_entry()
    local Dialogue = dialogue()
    local innerMarkerFlag = PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS.innerMarkerUnlocked
    local silverItemId = 174 -- 银两 / MONEY_ID.
    local silverCost = 3000

    migrate_shuige_entry_cost_flags()
    if not get_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_HINT_FLAGS.completed)
        and not get_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS.costResolved) then
        Dialogue.Talk(337, "双儿：少主，还施水阁入口已经收拾出来了，只是阿朱姐姐还没有把入阁规矩交代清楚。")
        Dialogue.Talk(0, "那我先去问阿朱。水阁入口等规矩说清后再进。")
        return false
    end

    set_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS.started, true)

    if get_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS.completed) then
        if not get_flag(innerMarkerFlag) then
            unlock_shuige_inner_marker(innerMarkerFlag)
        end
        if get_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS.legacyCostWaived) then
            Dialogue.Talk(337, "双儿：少主，水阁入口已经记下。旧时入阁账目已按既有存档免收三千两。")
        else
            Dialogue.Talk(337, "双儿：少主，水阁入口已经记下，三千两入阁银也已结清。")
        end
        Dialogue.Talk(0, "明白。后续水阁房间和宝箱流程，再按旧例逐项办理。")
        return true
    end

    Dialogue.Talk(337, "双儿：少主，这里便是还施水阁入口。阿朱姐姐说过，入阁前要先整理随身物件，旧例还要支出三千两。")
    Dialogue.Talk(0, "既是入阁旧例，就照规矩支取。")

    if not get_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS.costResolved) then
        if JudgeMoney(silverCost) ~= true then
            set_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS.insufficientSilver, true)
            Dialogue.Talk(337, "双儿：少主，账上银两不足三千。等备足银两后，我再替您开启水阁内侧。")
            Dialogue.Talk(0, "也好。银两不足，今日先不入阁。")
            return false
        end

        AddItemWithoutHint(silverItemId, -silverCost)
        set_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS.paid, true)
        set_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS.costResolved, true)
    end

    Dialogue.Talk(337, "双儿：三千两已经入账。我会把入口记录在册，少主下次再来，便知道水阁从这里进。")

    -- TODO: Future slice should implement actual teleport/room-entry behavior
    -- and keep 水阁宝箱 rewards in a separate idempotent quest bound from the
    -- inner marker.
    set_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS.unlocked, true)
    unlock_shuige_inner_marker(innerMarkerFlag)
    set_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS.completed, true)
    return true
end

local function run_protagonist_opening_shuige_inner()
    local Dialogue = dialogue()

    if not get_flag(PROTAGONIST_OPENING_SHUIGE_ENTRY_FLAGS.innerMarkerUnlocked) then
        Dialogue.Talk(337, "双儿：少主，还施水阁内室尚未开出。请先从入口处确认入阁。")
        return false
    end

    set_flag(PROTAGONIST_OPENING_SHUIGE_INNER_FLAGS.started, true)

    if get_flag(PROTAGONIST_OPENING_SHUIGE_INNER_FLAGS.completed) then
        Dialogue.Talk(337, "双儿：少主，水阁内侧已经整理过。今日暂不动箱箧，也不结算三千两银子。")
        Dialogue.Talk(0, "等宝箱与银两流程补齐，再按旧例重开清点。")
        return true
    end

    Dialogue.Talk(337, "双儿：少主，已入还施水阁内侧。我先替您把随身物件重新登记，免得之后出门遗漏。")
    Dialogue.Talk(0, "先记下这一步。宝箱、三千两银子和真正的水阁奖励，都等后续流程补齐。")
    Dialogue.Talk(337, "双儿：是。水阁内侧已整理完毕，之后可在这里接入箱箧与行装奖励。")

    -- TODO: Bind future 水阁宝箱 events from this inner marker stage. Do not
    -- grant chest rewards or deduct silver until exact item ids and money
    -- behavior are verified.
    set_flag(PROTAGONIST_OPENING_SHUIGE_INNER_FLAGS.dialogueSeen, true)
    set_flag(PROTAGONIST_OPENING_SHUIGE_INNER_FLAGS.completed, true)
    return true
end

local function run_protagonist_opening_shuige_center_chest()
    local Dialogue = dialogue()
    local rewardItemId = 209 -- 海月清辉, inert TPR opening item added in TPR-029.
    local rewardCount = 1

    if not get_flag(PROTAGONIST_OPENING_SHUIGE_INNER_FLAGS.completed) then
        Dialogue.Talk(337, "双儿：少主，水阁内侧还没有整理妥当。请先在内侧标记处完成入阁整理。")
        return false
    end

    set_flag(PROTAGONIST_OPENING_SHUIGE_CENTER_CHEST_FLAGS.started, true)

    if get_flag(PROTAGONIST_OPENING_SHUIGE_CENTER_CHEST_FLAGS.rewardClaimed) then
        Dialogue.Talk(337, "双儿：少主，这只水阁箱箧已经清点过，海月清辉也已入账。")
        Dialogue.Talk(0, "好。余下书阁藏品，等之后逐项整理。")
        return true
    end

    Dialogue.Talk(337, "双儿：少主，这里先取一件清雅旧藏，名为海月清辉。")
    AddItem(rewardItemId, rewardCount)
    set_flag(PROTAGONIST_OPENING_SHUIGE_CENTER_CHEST_FLAGS.rewardClaimed, true)
    set_flag(PROTAGONIST_OPENING_SHUIGE_CENTER_CHEST_FLAGS.completed, true)
    Dialogue.Talk(337, "双儿：海月清辉已经登记。其余水阁宝箱、三千两旧例和暗器药材，待后续流程补齐。")
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

local function get_apprenticeship_selected_branch()
    if get_flag(PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.branchSelected) then
        local selectedBranchId = get_flag_int(PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.selectedBranchId)
        for _, branch in ipairs(PROTAGONIST_APPRENTICESHIP_BRANCHES) do
            if selectedBranchId == branch.id or get_flag(branch.flag) then
                return branch
            end
        end
    end

    -- Old or partially written saves may have a branch-specific flag without
    -- the aggregate selected flag. Normalize that state before continuing.
    for _, branch in ipairs(PROTAGONIST_APPRENTICESHIP_BRANCHES) do
        if get_flag(branch.flag) then
            set_flag(PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.branchSelected, true)
            set_flag_int(PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.selectedBranchId, branch.id)
            return branch
        end
    end

    return nil
end

local function show_apprenticeship_selected_branch(Dialogue, branch)
    Dialogue.Talk(339, "阿碧：少主已择定" .. branch.mentorName .. " / " .. branch.skillName .. "一路。此事已入燕子坞册，不再更改。")
    Dialogue.Talk(0, "既已选定，之后狼牙燕翎、洗第二格武功与水阁书房，再按这一支推进。")
end

local APPRENTICESHIP_SKILL_REWARDS = {
    abi = {
        skillId = 206,
        skillName = "七弦无形剑",
        flag = PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.branchAbiSkillRewardClaimed,
    },
    dengbaichuan = {
        skillId = 207,
        skillName = "回风舞柳剑",
        flag = PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.branchDengbaichuanSkillRewardClaimed,
    },
    baobutong = {
        skillId = 208,
        skillName = "如影随形腿",
        flag = PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.branchBaobutongSkillRewardClaimed,
    },
    fengboe = {
        skillId = 209,
        skillName = "飞沙走石刀",
        flag = PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.branchFengboeSkillRewardClaimed,
    },
    gongyegan = {
        skillId = 210,
        skillName = "大风云飞掌",
        flag = PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.branchGongyeganSkillRewardClaimed,
    },
}

local function claim_apprenticeship_skill_reward(Dialogue, branch)
    local reward = APPRENTICESHIP_SKILL_REWARDS[branch.key]
    if reward == nil then
        return false
    end

    if get_flag(reward.flag) then
        Dialogue.Talk(339, "阿碧：少主已记下" .. reward.skillName .. "的入门法门，今日不再重复授艺。")
        return true
    end

    LearnMagic2(0, reward.skillId, 0)
    set_flag(reward.flag, true)
    Dialogue.Talk(339, "阿碧：既已择定" .. branch.mentorName .. "这一支，便先将" .. reward.skillName .. "的入门法门授给少主。")
    Dialogue.Talk(0, "我记下了。第二格洗武功、武学常识和" .. branch.branchName .. "系数，之后再按燕子坞规矩细办。")
    return true
end

local function apprenticeship_token_cost_resolved()
    return get_flag(PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.langyaYanlingConsumed)
        or get_flag(PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.langyaYanlingLegacyWaived)
end

local function consume_langya_yanling()
    local langyaYanlingItemId = 206

    if HaveItem(langyaYanlingItemId) ~= true then
        return false
    end

    AddItemWithoutHint(langyaYanlingItemId, -1)
    set_flag(PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.langyaYanlingConsumed, true)
    return true
end

local function resolve_existing_apprenticeship_token_cost(Dialogue)
    if apprenticeship_token_cost_resolved() then
        return
    end

    if consume_langya_yanling() then
        Dialogue.Talk(339, "阿碧：少主既已择定拜师方向，狼牙燕翎今日补收入册。")
        return
    end

    -- Branch selection existed before token consumption was implemented. Do
    -- not block those saves if the inert token is no longer in inventory.
    set_flag(PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.langyaYanlingLegacyWaived, true)
    Dialogue.Talk(339, "阿碧：少主的拜师方向早已入册。狼牙燕翎旧账今日按既有存档免收。")
end

local function lock_apprenticeship_branch(branch)
    set_flag(PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.branchSelected, true)
    set_flag_int(PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.selectedBranchId, branch.id)
    set_flag(PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.chooseMasterConfirmed, true)
    set_flag(PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.chooseMasterCompleted, true)
    set_flag(branch.flag, true)
end

local function run_protagonist_apprenticeship_branch_choice()
    local Dialogue = dialogue()
    local selectedBranch = get_apprenticeship_selected_branch()

    if selectedBranch then
        resolve_existing_apprenticeship_token_cost(Dialogue)
        show_apprenticeship_selected_branch(Dialogue, selectedBranch)
        if apprenticeship_token_cost_resolved() then
            claim_apprenticeship_skill_reward(Dialogue, selectedBranch)
        end
        return true
    end

    set_flag(PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.chooseMasterStarted, true)
    Dialogue.Talk(339, "阿碧：少主如今可择一位授业之人。择定时会交出狼牙燕翎；今日仍不会改动武功或属性。")

    if Dialogue.YesNo("现在选择拜师分支？") == false then
        Dialogue.Talk(339, "阿碧：少主若还要斟酌，便先不入册。下次再来，仍可重新查看五路。")
        return false
    end

    set_flag(PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.chooseMasterPromptSeen, true)

    for _, branch in ipairs(PROTAGONIST_APPRENTICESHIP_BRANCHES) do
        local prompt = "选择" .. branch.mentorName .. " / " .. branch.skillName .. " / " .. branch.branchName .. "？"
        if Dialogue.YesNo(prompt) then
            Dialogue.Talk(339, "阿碧：若选" .. branch.mentorName .. "这一支，日后便以" .. branch.skillName .. "为拜师方向。")
            if Dialogue.YesNo("确定选择" .. branch.mentorName .. "路线？此选择不可更改。") then
                if not consume_langya_yanling() then
                    Dialogue.Talk(339, "阿碧：少主身上没有狼牙燕翎，不能将拜师方向写入燕子坞册。")
                    Dialogue.Talk(0, "那我先取回狼牙燕翎，再来正式择师。")
                    return false
                end

                lock_apprenticeship_branch(branch)
                Dialogue.Talk(339, "阿碧：狼牙燕翎已收入册，也已经记下拜师方向。")
                show_apprenticeship_selected_branch(Dialogue, branch)
                if apprenticeship_token_cost_resolved() then
                    claim_apprenticeship_skill_reward(Dialogue, branch)
                end
                return true
            end

            Dialogue.Talk(339, "阿碧：那这一支先不定。少主可继续看后面的几路。")
        end
    end

    Dialogue.Talk(339, "阿碧：五路都未入册。少主想清楚后，再来择定拜师方向。")
    return false
end

local function run_protagonist_apprenticeship_intro()
    local Dialogue = dialogue()

    set_flag(PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.started, true)

    if not get_flag(PROTAGONIST_OPENING_FAMILY_BRIEFING_FLAGS.toolRewardClaimed) then
        Dialogue.Talk(339, "阿碧：少主若要拜师择艺，须先收下二叔三叔留下的狼牙燕翎。")
        Dialogue.Talk(0, "我先去把燕子坞开局的交代听完，再来问拜师的事。")
        return false
    end

    if get_flag(PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.completed) then
        return run_protagonist_apprenticeship_branch_choice()
    end

    Dialogue.Talk(339, "阿碧：少主手中的狼牙燕翎，是燕子坞内门暗记。凭它，可向阿碧或四大家将请教一门入门艺业。")
    Dialogue.Talk(339, "阿碧：阿碧这里偏七弦无形剑，邓大爷、包三爷、风四爷、公冶二爷也各有一路。")
    Dialogue.Talk(0, "今日先把规矩记下。真正择师、洗第二格武功，以及后续水阁书房取艺，等账册和武学条目核准后再定。")

    -- TPR-042A deliberately introduces only dialogue and save-backed flags.
    -- Later slices handle branch choice, token consumption, skills, stats,
    -- battles, companions, and ShuiGe study in separate idempotent steps.
    set_flag(PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.dialogueSeen, true)
    set_flag(PROTAGONIST_APPRENTICESHIP_INTRO_FLAGS.completed, true)
    return run_protagonist_apprenticeship_branch_choice()
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
Quest.Handlers[QUEST_ID_PROTAGONIST_OPENING_MENGXINGHUN_JOIN] = run_protagonist_opening_mengxinghun_join
Quest.Handlers[QUEST_ID_PROTAGONIST_OPENING_FAMILY_BRIEFING] = run_protagonist_opening_family_briefing
Quest.Handlers[QUEST_ID_PROTAGONIST_OPENING_BROTHER_RETURN] = run_protagonist_opening_brother_return
Quest.Handlers[QUEST_ID_PROTAGONIST_OPENING_SHUIGE_ENTRY_HINT] = run_protagonist_opening_shuige_entry_hint
Quest.Handlers[QUEST_ID_PROTAGONIST_OPENING_SHUIGE_ENTRY] = run_protagonist_opening_shuige_entry
Quest.Handlers[QUEST_ID_PROTAGONIST_OPENING_SHUIGE_INNER] = run_protagonist_opening_shuige_inner
Quest.Handlers[QUEST_ID_PROTAGONIST_OPENING_SHUIGE_CENTER_CHEST] = run_protagonist_opening_shuige_center_chest
Quest.Handlers[QUEST_ID_PROTAGONIST_OPENING_SHIJIAN_TRAINING] = run_protagonist_opening_shijian_training
Quest.Handlers[QUEST_ID_YANZIWU_TREASURE_SILVER_CHEST] = run_yanziwu_treasure_silver_chest
Quest.Handlers[QUEST_ID_PROTAGONIST_APPRENTICESHIP_INTRO] = run_protagonist_apprenticeship_intro

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
