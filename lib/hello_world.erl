-module(hello_world).

%%% Hello_world template
%%% Created: 2003-12-29 by joe@sics.se

%%% Cut and paste from this to make your first windows
%%% program


-import(ex11_lib, [eMapWindow/1,
		   ePolyText8/5,
		   xAddAction/3,
		   xCreateGC/2,
		   xCreateSimpleWindow/7,
		   xDo/2,
		   xEnsureFont/2,
		   xFlush/1,
		   xColor/2,
		   xSpawn/1,
		   xStart/1]).

-export([start/0]).

-include("ex11_lib.hrl").

start() -> 
    spawn_link(fun() -> init() end).

init() ->
    {ok, Pid} = ex11_lib:xStart(os:getenv("DISPLAY", ":1.0")),
    Win  = xCreateSimpleWindow(Pid, 10, 10, 300, 100, ?XC_arrow, 
			       xColor(Pid, ?wheat2)),
    Font = xEnsureFont(Pid, "9x15"),  
    Pen  = xCreateGC(Pid, [{function, copy},
			   {font, Font},
			   {fill_style, solid},
			   {foreground, xColor(Pid, ?DarkBlue)}]),
    Cmd =  ePolyText8(Win, Pen, 10, 35, "Hello World"),
    xDo(Pid, Cmd),
    xDo(Pid, eMapWindow(Win)),
    % Hello World + Waving Hand Sign (U+1F44B); Emoji support seems mixed
    ex11_lib:xSetWMName(Pid, Win, <<"Hello World", 16#F0, 16#9F, 16#91, 16#8B>>),
    ex11_lib:xSetNormalHints(Pid, Win, [{min_size, 300, 100}, {max_size, 300, 100}]),
    xFlush(Pid),
    loop(Pid, Win, Cmd).

loop(Pid, Win, Cmd) ->
    receive
	{event,Win,expose,_} ->
	    io:format("expose event sending data~n"),
	    xDo(Pid, Cmd),
	    xFlush(Pid),
	    loop(Pid, Win, Cmd);
	Any ->
	    io:format("Here:~p~n",[Any]),
	    loop(Pid, Win, Cmd)
    end.
