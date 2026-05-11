if GetFlagInt("jshyl_home_treasure_taken") == 1 then goto already_taken end;
Talk(0, "箱中整整齐齐放着一批用于测试红颜录样例路线的神兵、防具与秘籍。");
AddItem(94, 1);   -- 九阴真经
AddItem(95, 1);   -- 九阳真经
AddItem(109, 1);  -- 倚天剑
AddItem(117, 1);  -- 屠龙刀
AddItem(120, 1);  -- 软猬甲
AddItem(200, 1);  -- 越女剑谱
AddItem(201, 1);  -- 瑶池仙袖
AddItem(202, 1);  -- 长生诀
AddItem(203, 1);  -- 天元剑气诀
AddItem(204, 1);  -- 玄女剑
SetFlagInt("jshyl_home_treasure_taken", 1);
ModifyEvent(-2, -2, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
ShowMessage("已取得红颜录样例测试物品。可在物品界面查看秘籍、神兵与防具的属性加成。");
do return end;
::already_taken::
Talk(0, "箱子已经空了。");
do return end;
