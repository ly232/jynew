Talk(0, "这里是小虾米居。案上摊着一本《金书红颜录5 如画江山》路线手册。");
Talk(0, "这不是寻常游记，而是一张江湖因果图：每一页都写着触发、分线、战斗、入队、洗武功和结局。");
Talk(0, "今日先从最短的试炼开始，把手册里的路线拆成可以游玩的事件。");
Talk(0, "已载入路线索引。其中《鸳鸯刀》和《越女剑》已经整理为事件节点，可作为第一批可游玩路线继续接入地图触发。");
if JSHYL_RouteData ~= nil then
    local yy = JSHYL_RouteData.yuanyangdao
    local yn = JSHYL_RouteData.yuenvjian
    ShowMessage(string.format("样例MOD：金书红颜录5 如画江山\\n已整理路线：%s（%d步）、%s（%d步）", yy.title, #yy.steps, yn.title, #yn.steps));
else
    ShowMessage("样例MOD：金书红颜录5 如画江山\\n当前纵切：JYX2开局场景 + 路线索引 + 开局事件。");
end
ModifyEvent(-2, 0, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
do return end;
