-module(mcastlistener).

-export([open/2,
         run/0,
	 stop/1,
	 receiver/0
]).

%server and client ports must match.
-define(MPORT, 5555).
-define(MADDR, {225,0,0,255}).

open(Addr, Port) ->
    {ok,Socket} = gen_udp:open(Port,
			       [{reuseaddr,true}, 
				{ip,Addr}, 
				{multicast_ttl,4}, 
				{multicast_loop,false}, binary]),
    inet:setopts(Socket,[{add_membership,{Addr,{0,0,0,0}}}]),
    Socket.

close(Socket) ->
     gen_udp:close(Socket).

run() ->
    Socket=open(?MADDR,?MPORT),
    Pid=spawn(?MODULE,receiver,[]),
    gen_udp:controlling_process(Socket,Pid),
    {Socket,Pid}.

stop({Socket,Pid}) ->
    close(Socket),
    Pid ! stop.

receiver() ->
    receive
	{udp, _Socket, IP, InPort, Packet} ->
	    io:format("~nFrom: ~p~nPort: ~p~nData: ~p~n",
		      [IP,InPort,inet_dns:decode(Packet)]),
	    receiver();
	stop -> true;
	AnythingElse -> io:format("received: ~p~n", [AnythingElse]),
			receiver()
    end.
