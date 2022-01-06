-module(udpclient).

-export([
	 run/0
]).

-define(ITERATIONS, 20).
-define(UDPIP, "192.168.1.101").
-define(UPORT, 5555).
-define(MSG,"a simple message.").

% udp test
client(Request) ->
    {ok,Socket} = gen_udp:open(0,[binary]),
    ok = gen_udp:send(Socket,?UDPIP,?UPORT,Request),
    Value = receive
                {udp,Socket,_,_,Bin} ->
                    {ok,Bin}
                after 2000 ->
                    error
                end,
    gen_udp:close(Socket),
    Value.

% for 
% Iteration = 0;
client(Host, Port, Request) ->
    {ok,Socket} = gen_udp:open(0,[binary]),
     Iteration = 0,
     loopclient(Socket, Host, Port, Request, Iteration + 1).   
% Iteration++; Iterattion < ITERATIONS
% ITERATIONS-2 messages are sent
loopclient(Socket, Host, Port, Request1, Iteration) when Iteration =< ?ITERATIONS ->
    ok = gen_udp:send(Socket,Host,Port,Request1),
     loopclient(Socket,Host, Port, Request1, Iteration + 1);
% Iterations > ITERATIONS
loopclient(Socket, Host, Port, Request1, Iteration) ->
     gen_udp:close(Socket),
     done.


run() ->
     spawn(udpcs, client, [?UDPIP, ?UPORT, ?MSG]).
