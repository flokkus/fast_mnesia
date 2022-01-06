-module(udpserver).

-export([
	 run/0
]).

%server and client ports must match.
-define(UPORT, 5555).



run() ->
    spawn(udpcs, server, [?UPORT]).

server(Port) ->
    {ok,Socket} = gen_udp:open(Port,[binary]),
    loop(Socket).
% loop forever
% receive msg, send it back, print it.
loop(Socket) ->
    receive
        {udp,Socket,Host,Port,Packet} ->
            gen_udp:send(Socket,Host,Port,Packet),
	    io:fwrite("~s~n",[Packet]),
            loop(Socket)
     end.

