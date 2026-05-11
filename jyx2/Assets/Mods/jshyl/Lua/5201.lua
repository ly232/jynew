Talk(337, "双儿：少主一路辛苦了，要在屋里歇一会儿吗？");
if AskRest() == false then goto no_rest end;
Rest();
Talk(337, "双儿：我已经替大家备好了茶水。少主精神好些了吗？");
do return end;

::no_rest::
Talk(337, "双儿：那我就在这里候着，少主需要休息时再来找我。");
do return end;
