-module(mcastbeacon).

-export([open/2,
	 close/1,
	 stop/1,
	 client/1,
	 client/3,
	 run/0
]).

-define(ITERATIONS, 20).
-define(MADDR, "225.0.0.255").
-define(MPORT, 5555).
-define(MSG,"pid: ").

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

% udp test
client(Request) ->
    Socket=open(?MADDR,?MPORT),
    Pid = self(),
    ok = gen_udp:send(Socket,?MADDR,?MPORT,Request++pid_to_list(Pid)),
    Value = receive
                {udp,Socket,_,_,Bin} ->
                    {ok,Bin}
                after 2000 ->
                    error
                end,
    close(Socket),
    Value.

% for 
% Iteration = 0;
client(Host, Port, Request) ->
     Socket=open(?MADDR,?MPORT),
     Iteration = 0,
     Pid = self(),
     loopclient(Socket, Host, Port, Request++pid_to_list(Pid), Iteration + 1).   
% Iteration++; Iterattion < ITERATIONS
% ITERATIONS-2 messages are sent
loopclient(Socket, Host, Port, Request1, Iteration) when Iteration =< ?ITERATIONS ->
    ok = gen_udp:send(Socket,Host,Port,Request1),
     loopclient(Socket,Host, Port, Request1, Iteration + 1);
% Iterations > ITERATIONS
loopclient(Socket, Host, Port, Request1, Iteration) ->
     close(Socket),
     done.


run() ->
     spawn(?MODULE, client, [?MADDR, ?MPORT, ?MSG]).
