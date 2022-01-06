-module(mcastlistener).

-export([
	 run/0
]).

%server and client ports must match.
-define(MPORT, 5555).
-define(MADDR, {225,0,0,251}).

run() ->
    Socket=open({225,0,0,251}, 5555),
    Pid=spawn(?MODULE,listener,[]),
    gen_udp:controlling_process(Socket,Pid),
    {Socket,Pid}.

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

stop({Socket,Pid}) ->
    close(Socket),
    Pid ! stop.

listener() ->
    receive
	{udp, _Socket, IP, InPort, Packet} ->
	    io:format("~nFrom: ~p~nPort: ~p~nData: ~p~n",
		      [IP,InPort,inet_dns:decode(Packet)]),
	    listener();
	stop -> true;
	AnythingElse -> io:format("received: ~p~n", [AnythingElse]),
			listener()
    end.
