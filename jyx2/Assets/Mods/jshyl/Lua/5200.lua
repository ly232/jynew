if GetFlagInt("jshyl_opening_done") == 1 then goto after_opening end;

Talk(336, "慕容秋荻：你既回了燕子坞，便该记住自己的路。江湖诸线纷乱，第一步先去杭州。");
Talk(0, "杭州？我初入江湖，只怕脚下还不稳。");
Talk(336, "慕容秋荻：所以我让孟星魂随你同行。他话少，剑快，足够护你走过开局这一段。");
Talk(335, "孟星魂：我随少主去杭州。路上若有人拦，我来出剑。");
Talk(336, "慕容秋荻：屋中双儿可为你休整，旁边宝箱里有三万两银子。还施水阁侍剑可安排十二金钗演武，若想熟悉战斗，先去那里。");
if InTeam(335) == false then Join(335); end;
SetFlagInt("jshyl_opening_done", 1);
ShowMessage("红颜开局：慕容秋荻命你前往杭州，孟星魂加入队伍。\n燕子坞中可找双儿休息、开宝箱取三万两银子，或在还施水阁挑战十二金钗演武。");
do return end;

::after_opening::
Talk(336, "慕容秋荻：杭州是你开局要走的第一步。出燕子坞上大地图，向江南去。");
do return end;
