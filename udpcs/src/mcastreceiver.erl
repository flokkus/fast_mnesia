-module(mcastreceiver).

-export([open/2,
	 start/0,
	 stop/1,
	 receiver/0
]).

open(Addr, Port) ->
    {ok, S} = gen_udp:open(Port, [{reuseaddr,true}, {ip,Addr},
				  {multicast_ttl,4}, {multicast_loop,false},
				  binary]),
    inet:setopts(S,[{add_membership,{Addr,{0,0,0,0}}}]),
    S.

close(S) ->
     gen_udp:close(S).

start() ->
    S=open({225,0,0,0}, 6666),
    Pid=spawn(?MODULE,receiver,[]),
    gen_udp:controlling_process(S,Pid),
    {S,Pid}.

stop({S,Pid}) ->
    close(S),
    Pid ! stop.

receiver() ->
    receive
	{udp, _Socket, IP, InPortNo, Packet} ->
	    io:format("~nFrom: ~p~nPort: ~p~nData: ~p~n",
		      [IP,InPortNo,inet_dns:decode(Packet)]),
	    receiver();
	stop -> true;
	AnythingElse -> io:format("received: ~p~n", [AnythingElse]),
			receiver()
    end.
