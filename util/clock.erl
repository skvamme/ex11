-module(clock).
-author(skvamme).
-export([start/0,init/0,loop/7]).
-define (WT,400).
-define (HT,400).
-include("ex11_lib.hrl").
-import(ex11_lib, [xDo/2, xFlush/1,rpc/2,xCreateGC/2,xColor/2,mkRectangle/4,xCreateSimpleWindow/7,
    eMapWindow/1,ePolyFillRectangle/3,xCreatePixmap/4,eCopyArea/9,ePolyArc/3,ePolyFillArc/3,
    mkArc/6,mkPoint/2,ePolyLine/4,xSetScreenSaver/2]).


start() -> spawn(?MODULE,init,[]).

init() ->
    {ok, Display} = ex11_lib:xStart(":0.0"),
    xSetScreenSaver(Display,0),
    Win = xCreateSimpleWindow(Display,0,0,?WT,?HT,?XC_arrow,xColor(Display,?black)),
    xDo(Display, eMapWindow(Win)),
    xFlush(Display),
    White = xCreateGC(Display, [{function,'xor'},{line_width,5},{arc_mode,chord},{line_style,solid},
 	 {graphics_exposures, false},{foreground, xColor(Display, ?white)}]),
    Red = xCreateGC(Display, [{function,'xor'},{line_width,5},{arc_mode,chord},{line_style,solid},
	 {graphics_exposures, false},{foreground, xColor(Display, ?red)}]),
    White1 = xCreateGC(Display, [{function,copy},{line_width,5},{arc_mode,chord},{line_style,solid},
 	 {graphics_exposures, false},{foreground, xColor(Display, ?white)}]),
    Red1 = xCreateGC(Display, [{function,copy},{line_width,5},{arc_mode,chord},{line_style,solid},
	 {graphics_exposures, false},{foreground, xColor(Display, ?red)}]),
% hours start at 12
    Hours = [{200,75},{216,76},{232,79},{248,85},{262,92},{276,101},{288,112},
    {299,124},{308,137},{315,152},{321,168},{324,184},{325,200},{324,216},{321,232},
    {315,248},{308,263},{299,276},{288,288},{276,299},{263,308},{248,315},{232,321},
    {216,324},{200,325},{184,324},{168,321},{152,315},{138,308},{124,299},{112,288},
    {101,276},{92,263},{85,248},{79,232},{76,216},{75,200},{76,184},{79,168},{85,152},
    {92,138},{101,124},{112,112},{124,101},{137,92},{152,85},{168,79},{184,76},
    {200,75},{216,76},{232,79},{248,85},{262,92},{276,101},{288,112},{299,124},
    {308,137},{315,152},{321,168},{324,184},{325,200},{324,216},{321,232},{315,248},
    {308,263},{299,276},{288,288},{276,299},{263,308},{248,315},{232,321},{216,324},
    {200,325},{184,324},{168,321},{152,315},{138,308},{124,299},{112,288},{101,276},
    {92,263},{85,248},{79,232},{76,216},{75,200},{76,184},{79,168},{85,152},{92,138},
    {101,124},{112,112},{124,101},{137,92},{152,85},{168,79},{184,76}],
% minutes start at 12
    Minutes = [{200,25},
    {218,26},{236,29},{254,34},{271,40},{287,48},{303,58},{317,70},{330,83},{342,97},
    {352,112},{360,129},{366,146},{371,164},{374,182},{375,200},{374,218},{371,236},
    {366,254},{360,271},{352,288},{342,303},{330,317},{317,330},{303,342},{288,352},
    {271,360},{254,366},{236,371},{218,374},{200,375},{182,374},{164,371},{146,366},
    {129,360},{113,352},{97,342},{83,330},{70,317},{58,303},{48,288},{40,271},{34,254},
    {29,236},{26,218},{25,200},{26,182},{29,164},{34,146},{40,129},{48,112},
    {58,97},{70,83},{83,70},{97,58},{113,48},{129,40},{146,34},{164,29},{182,26}],
    draw_static(Display, Win, Red, White),
    Time = draw_new(Display,Win,White1,Red1,Hours,Minutes, time()),
    xFlush(Display),
    loop(Display,Win,White,Red,Hours,Minutes,Time).


loop(Display,Win,Black,Red,Hours,Minutes,Time) ->
    receive
        {'EXIT',_Pid,_Why} -> true;
        Any -> io:format("~p got unknown msg: ~p~n",[?MODULE, Any]),
		?MODULE:loop(Display,Win,Black,Red,Hours,Minutes,Time)
    after 1000 ->
        Time1 = draw_dynamic(Display,Win,Black,Red,Hours,Minutes,Time),
        xFlush(Display),
        ?MODULE:loop(Display,Win,Black,Red,Hours,Minutes,Time1)
    end.


draw_dynamic(Display,Win,White,Red,Hlist,Mlist, {Hour, Minute, Second}) ->
    T = time(),
    case  T  of
    {Hour, Minute, _} -> {Hour, Minute, Second}; % Hands should not be redrawn
    _  ->                                        % Erase hands at current position
%	{SX,SY} = lists:nth(Second+1, Mlist),
	{MX,MY} = lists:nth(Minute+1, Mlist),
	Hour1 = (Hour * 4) + (Minute div 15),
	{HX,HY} = lists:nth(Hour1+1, Hlist),
%    xDo(Display,ePolyFillArc(Win, Red, [mkArc(SX-15,SY-15,30,30,0,64*360)])),
	xDo(Display,ePolyLine(Win, Red, origin, [mkPoint(200,200),mkPoint(MX,MY)])),
	xDo(Display,ePolyLine(Win, White, origin, [mkPoint(200,200),mkPoint(HX,HY)])),
	draw_new(Display,Win,White,Red,Hlist,Mlist,T) % Draw new hands
    end.

draw_new(Display,Win,White,Red,Hlist,Mlist,{Hour, Minute, Second}) -> 
%    {SX,SY} = lists:nth(Second+1, Mlist),
    {MX,MY} = lists:nth(Minute+1, Mlist),
    Hour1 = (Hour * 4) + (Minute div 15),
    {HX,HY} = lists:nth(Hour1+1, Hlist),
%    xDo(Display,ePolyFillArc(Win, Red, [mkArc(SX-15,SY-15,30,30,0,64*360)])),
    xDo(Display,ePolyLine(Win, Red, origin, [mkPoint(200,200),mkPoint(MX,MY)])),
    xDo(Display,ePolyLine(Win, White, origin, [mkPoint(200,200),mkPoint(HX,HY)])),
    {Hour, Minute, Second}.

draw_static(Display, Win, _Pen1, Pen0) ->
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(83,70),mkPoint(66,51)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(70,83),mkPoint(51,66)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(50,200),mkPoint(0,200)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(34,146),mkPoint(10,138)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(29,164),mkPoint(4,158)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(26,182),mkPoint(1,179)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(70,125),mkPoint(27,100)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(58,97),mkPoint(38,82)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(40,129),mkPoint(17,119)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(146,34),mkPoint(138,10)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(125,70),mkPoint(100,27)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(97,58),mkPoint(82,38)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(129,40),mkPoint(119,17)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(200,50),mkPoint(200,0)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(182,26),mkPoint(179,1)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(164,29),mkPoint(158,4)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(83,330),mkPoint(66,349)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(70,317),mkPoint(51,334)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(26,218),mkPoint(1,221)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(29,236),mkPoint(4,242)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(34,254),mkPoint(10,262)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(70,275),mkPoint(27,300)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(58,303),mkPoint(38,318)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(40,271),mkPoint(17,281)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(146,366),mkPoint(138,390)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(125,330),mkPoint(100,373)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(97,342),mkPoint(82,362)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(129,360),mkPoint(119,383)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(200,350),mkPoint(200,400)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(164,371),mkPoint(158,396)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(182,374),mkPoint(179,399)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(330,125),mkPoint(373,100)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(330,83),mkPoint(349,66)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(275,70),mkPoint(300,27)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(271,40),mkPoint(281,17)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(254,34),mkPoint(262,10)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(236,29),mkPoint(242,4)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(218,26),mkPoint(221,1)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(303,58),mkPoint(318,38)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(317,70),mkPoint(334,51)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(360,129),mkPoint(383,119)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(342,97),mkPoint(362,82)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(350,200),mkPoint(400,200)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(374,182),mkPoint(399,179)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(371,164),mkPoint(396,158)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(366,146),mkPoint(390,138)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(330,275),mkPoint(373,300)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(330,317),mkPoint(349,334)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(275,330),mkPoint(300,373)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(271,360),mkPoint(281,383)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(218,374),mkPoint(221,399)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(236,371),mkPoint(242,396)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(254,366),mkPoint(262,390)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(303,342),mkPoint(318,362)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(317,330),mkPoint(334,349)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(366,254),mkPoint(390,262)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(371,236),mkPoint(396,242)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(374,218),mkPoint(399,221)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(360,271),mkPoint(383,281)])),
xDo(Display,ePolyLine(Win, Pen0, origin, [mkPoint(342,303),mkPoint(362,318)])).
%% END
