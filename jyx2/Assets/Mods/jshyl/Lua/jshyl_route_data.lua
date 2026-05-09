JSHYL_RouteData = {
    yuanyangdao = {
        title = "鸳鸯刀",
        chapter = "鸯旋竞秀篇",
        source = "03_story14Y0.htm",
        recommendedSlice = true,
        steps = {
            {
                id = "yy_01_zhongdu",
                title = "中都遇萧中慧",
                prerequisites = { "碧血剑收到蓝凤凰", "蓝凤凰在队" },
                location = "长安城上方进入中都城，寺庙",
                events = {
                    "主角与萧中慧冲突",
                    "识破乞丐为满清大内高手卓天雄",
                    "袁冠南到来"
                },
                battles = {
                    "主角 vs 萧中慧",
                    "主角 + 袁冠南 vs 卓天雄"
                },
                rewards = { "呼延鞭法+2", "拂柳刀谱+2", "萧中慧加入", "素绸朱绫" },
                stateChanges = { "道德+2", "主角生命-10", "萧中慧攻击+2" }
            },
            {
                id = "yy_02_weixin",
                title = "威信镖局抢鸯刀",
                prerequisites = { "萧中慧在队" },
                location = "长安城威信镖局",
                battles = {
                    "主角 + 萧中慧 + 太岳四侠 vs 周威信 + 曹猛 + 崔百胜",
                    "主角 + 萧中慧 + 太岳四侠 vs 周威信 + 崔百胜 + 曹猛 + 卓天雄"
                },
                rewards = { "六合刀法+2", "萧中慧第2格洗六合刀法1级" },
                stateChanges = { "道德+2", "主角生命-10", "萧中慧攻击+2" }
            },
            {
                id = "yy_03_cart",
                title = "大车藏刀",
                prerequisites = { "萧中慧在队" },
                location = "威信镖局门口大车",
                battles = { "主角 + 萧中慧 vs 骆冰" },
                rewards = { "鸯刀", "银两3000", "夫妻刀法+5", "燕子三抄水" },
                stateChanges = { "萧中慧兵+100", "主角生命-20", "萧中慧攻击+4" }
            },
            {
                id = "yy_04_zijincheng",
                title = "紫禁城取双刀",
                prerequisites = { "鹿鼎记双线营救反清志士", "萧中慧在队" },
                location = "燕京紫禁城右上书房",
                battles = { "主角 + 萧中慧 + 骆冰 vs 僵尸拳众人" },
                rewards = { "连珠飞刀秘诀+3", "鸳鸯宝刀", "鸳刀", "鸯刀" },
                stateChanges = { "道德+2", "萧中慧第4格洗连珠飞刀1级" }
            },
            {
                id = "yy_05_xiaofu",
                title = "晋阳萧府寿宴",
                prerequisites = { "萧中慧在队" },
                location = "晋阳城萧府",
                battles = { "主角众人 + 袁冠南 + 萧半和 vs 卓天雄 + 满清侍卫" },
                rewards = { "袁萧身世揭晓" },
                stateChanges = { "道德+2", "主角生命-10", "萧中慧攻击+2" }
            },
            {
                id = "yy_06_pool",
                title = "池塘决卓天雄",
                prerequisites = { "萧中慧在队" },
                location = "晋阳右边池塘",
                battles = { "主角 + 萧中慧 vs 卓天雄" },
                rewards = { "碧血金蟾", "萧中慧专精变为夫妻刀法" },
                stateChanges = { "道德+2", "萧中慧资质+10", "主角第1格临时洗夫妻刀法10级" }
            },
            {
                id = "yy_07_book",
                title = "天书鸳鸯刀",
                prerequisites = { "萧中慧在队" },
                location = "晋阳城萧府",
                battles = { "主角 + 萧中慧 vs 萧半和" },
                rewards = { "天书《鸳鸯刀》", "萧中慧天赋可洗神光流转" },
                stateChanges = { "胜则萧中慧第3格洗混元一气1级，轻功挂葵花迷影" }
            }
        }
    },
    yuenvjian = {
        title = "越女剑",
        source = "03_story15N0.htm",
        recommendedSlice = true,
        steps = {
            {
                id = "yn_01_kunlun",
                title = "昆仑仙境遇阿青",
                prerequisites = { "倚天对应路线过围攻光明顶/明教/蒙古节点" },
                location = "昆仑仙境房子",
                battles = {
                    "主角 + 阿青 vs 觉远 + 何足道 + 白猿 + 无相 + 无色 + 尹克西 + 潇湘子 + 西域三僧 + 天鸣",
                    "主角 + 阿青 vs 白猿"
                },
                rewards = { "阿青入队", "天书《越女剑》", "白猿" },
                stateChanges = { "带韩小莹则韩小莹御剑+100，第2格洗越女神剑10级，天赋可洗闪电惊虹" }
            },
            {
                id = "yn_02_wanxian",
                title = "万仙大会",
                prerequisites = { "天龙逍遥御风篇万仙大会", "阿青在队" },
                location = "万仙大会",
                battles = { "阿青 vs 卓不凡" },
                rewards = { "阿青成为一字慧剑门掌门", "侠客岛上岛时必定上岛" },
                stateChanges = { "阿青御剑+20", "阿青第4、5格洗逍遥神剑1级，小无相功1级" }
            },
            {
                id = "yn_03_jueqinggu",
                title = "绝情谷后回昆仑",
                prerequisites = { "神雕侠侣龙女线完成绝情谷支线", "阿青在队" },
                location = "昆仑仙境",
                battles = { "阿青 vs 公孙止" },
                rewards = { "刀剑合璧秘诀" },
                stateChanges = { "公孙止攻防+200", "阿青第5格洗阴阳倒乱刃1级" }
            },
            {
                id = "yn_04_tomb",
                title = "墓碑问玄女",
                prerequisites = { "侠客行屠灭侠客岛", "阿青在队" },
                location = "昆仑仙境墓碑",
                battles = { "阿青 vs 九天玄女" },
                rewards = { "瑶池仙袖", "长生诀", "越女神剑剑谱" },
                stateChanges = { "胜则阿青洗飞仙剑阵、越女神剑、长生仙诀，天赋可洗天元剑气，+50武常", "主角生命-20", "阿青攻击+4" }
            }
        }
    }
}
