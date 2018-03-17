-module(main). 
-author(skvamme).
-export([start/0,init/0,loop/7]).
-import(ex11_lib,[xColor/2,xCreateSimpleWindow/7,eMapWindow/1,xDo/2,xFlush/1,xSetScreenSaver/2]).
-include("ex11_lib.hrl").
-define(WT,800).
-define(HT,480).

start() -> spawn(?MODULE,init,[]).

init() ->
	Pid = self(),
	{ok, Display} = ex11_lib:xStart(),
    xSetScreenSaver(Display,0),
	Win = xCreateSimpleWindow(Display,0,0,?WT,?HT,?XC_arrow,xColor(Display,?black)),
	xDo(Display, eMapWindow(Win)),
	xFlush(Display),
	%Port = open_port({spawn, "../priv/atlast -i../priv/kwh.atl"}, [{line,127}]),
	Port = undefined, % No port installed
	loop(Pid,Port,Display,Win,false,undefined,undefined).

loop(Pid,Port,Display,Win,Ready,Graph,Num) ->
    receive
    	{event,_,expose,expose} when Ready == false -> % The window is ready for use
			Graph1 = graph:make(Pid,Display,Win,0,0), % Place the graph
			Num1 = numdisplay:make(Pid,Display,Win,200,20), % Place the numeric real time display
			dialerbutton:make(Pid,Display,Win,200,100,"5"),
			timer:send_interval(5000, poll),
		    ?MODULE:loop(Pid,Port,Display,Win,true,Graph1,Num1);
		poll when is_port(Port) -> Port ! {self(), {command, "w\n"}},
			 ?MODULE:loop(Pid,Port,Display,Win,Ready,Graph,Num);
		{Port,{data,{eol,Data}}} when Data /= [] andalso length(Data) < 6 ->
			Graph ! {new,Data},
			Num ! {new,Data},
			?MODULE:loop(Pid,Port,Display,Win,Ready,Graph,Num);
		Any -> io:format("~p got unknown msg: ~p~n",[?MODULE, Any]),
			?MODULE:loop(Pid,Port,Display,Win,Ready,Graph,Num)
	end.
