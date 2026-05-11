Talk(340, "侍剑：少主，十二金钗已经列阵。此战只为演武，不伤性命。是否现在开始？");
if ShowYesOrNoSelectPanel("挑战十二金钗演武？") == false then goto decline end;
if TryBattle(145) == false then goto failed end;
Talk(340, "侍剑：少主今日进退有度。之后去杭州，也算有了几分底气。");
AddItem(174, 500);
do return end;

::failed::
Talk(340, "侍剑：先歇一歇也好。演武可随时再来。");
do return end;

::decline::
Talk(340, "侍剑：那我让她们候着。少主想练时再来。");
do return end;
