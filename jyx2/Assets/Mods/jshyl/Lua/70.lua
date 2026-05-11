local step = GetFlagInt("jshyl_yuenvjian_step");

if step <= 0 then goto step_kunlun end;
if step == 1 then goto step_wanxian end;
if step == 2 then goto step_jueqinggu end;
if step == 3 then goto step_tomb end;
goto step_done;

::step_kunlun::
Talk(0, "姑娘，你一个人在这昆仑深谷，不怕么？");
Talk(320, "阿青：我不怕。白公公在，羊儿也在。只是今日山外来了许多陌生人，他们说要找一部剑谱。");
Talk(0, "剑谱？莫非是《越女剑》？");
Talk(320, "阿青：我不懂什么剑谱。白公公教我的只是竹枝怎么走、风怎么让、人怎么不伤人。");
Talk(0, "远处忽然传来衣袂破空之声。觉远、何足道与几名西域高手循着白猿踪迹闯入谷中。");
Talk(320, "阿青：你们不能伤白公公。");
if TryBattle(140) == false then goto battle_failed end;
Talk(323, "白公公忽地长啸，竹影翻飞，似要试一试阿青新悟的剑意。");
if TryBattle(141) == false then goto battle_failed end;
Talk(320, "阿青：他们没有伤到白公公。你这个人，好像也不坏。以后我跟你一起走一段路吧。");
if InTeam(320) == false then Join(320); end;
SetFlagInt("jshyl_yuenvjian_step", 1);
AddItem(200, 1);
ShowMessage("越女剑线推进：昆仑仙境初遇完成\n阿青入队，并获得《越女剑谱》。下一步：万仙大会，阿青对卓不凡。");
do return end;

::step_wanxian::
Talk(0, "按路线手册记载，天龙逍遥御风篇万仙大会后，阿青会遇上一字慧剑门卓不凡。");
Talk(332, "卓不凡：小姑娘也敢称剑？让卓某看看你的竹枝有几分火候。");
Talk(320, "阿青：剑不是用来吓人的。你若一定要比，我只出一枝竹。");
if TryBattle(142) == false then goto battle_failed end;
Talk(332, "卓不凡：一字慧剑，竟不如一枝青竹……");
Talk(320, "阿青：门派掌门什么的，我不懂。但若他们不再乱伤人，我便记下这件事。");
SetFlagInt("jshyl_yuenvjian_step", 2);
AddItem(202, 1);
ShowMessage("越女剑线推进：万仙大会完成\n阿青压服卓不凡，获得《长生诀》样例秘籍。下一步：神雕双剑后回昆仑。");
do return end;

::step_jueqinggu::
Talk(0, "神雕双剑完成觉醒古之剑后，你带阿青回到昆仑仙境。绝情谷主公孙止拦在谷口。");
Talk(333, "公孙止：刀剑合璧，岂能落在你们手中？");
Talk(320, "阿青：你的剑气很乱，像心里有刺。");
if TryBattle(143) == false then goto battle_failed end;
Talk(333, "公孙止：这等剑法……我认输。");
SetFlagInt("jshyl_yuenvjian_step", 3);
AddItem(203, 1);
ShowMessage("越女剑线推进：绝情谷后回昆仑完成\n获得《天元剑气诀》。下一步：侠客岛后调查昆仑墓碑。");
do return end;

::step_tomb::
Talk(0, "侠客岛风波之后，阿青带你来到昆仑仙境深处的古老墓碑前。");
Talk(320, "阿青：这里有一个很远很远的声音，像天上的剑落下来。");
Talk(334, "九天玄女：凡心执剑，若能守一念清明，便接我一招。");
if TryBattle(144) == false then goto battle_failed end;
Talk(334, "九天玄女：竹枝能通天心。阿青，你的剑已成。");
Talk(320, "阿青：我还是喜欢羊儿和白公公。不过这剑，我会记住。");
SetFlagInt("jshyl_yuenvjian_step", 4);
AddItem(201, 1);
AddItem(204, 1);
ShowMessage("越女剑线完成：墓碑问玄女\n获得瑶池仙袖、玄女剑。阿青的完整样例线已经跑通。");
do return end;

::step_done::
Talk(320, "阿青：昆仑的风很安静。我们再去别处看看吧。");
ShowMessage("越女剑线已完成。主角家宝箱可领取样例神兵、防具与秘籍用于继续测试。");
do return end;

::battle_failed::
Talk(320, "阿青：先退开吧。白公公不愿再伤人。");
do return end;
