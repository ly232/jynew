if GetFlagInt("jshyl_yanzi_treasure_taken") == 1 then goto empty_chest end;

AddItem(174, 30000);
SetFlagInt("jshyl_yanzi_treasure_taken", 1);
ModifyEvent(-2, -2, 0, 0, -1, -1, -1, -1, -1, -1, -2, -2, -2);
ShowMessage("获得银两三万。");
do return end;

::empty_chest::
ShowMessage("宝箱已经空了。");
do return end;
