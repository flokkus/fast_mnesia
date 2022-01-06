-module(udpcs).

-export([
	 server/1,
         client/1,
	 client/3,
	 startc/0,
	 starts/0
]).



starts() ->
    spawn(udpcs, server, [55555]).

server(Port) ->
    {ok,Socket} = gen_udp:open(Port,[binary]),
    loop(Socket).
% receive msg, send it back. 
loop(Socket) ->
    receive
        {udp,Socket,Host,Port,Bin} ->
            gen_udp:send(Socket,Host,Port,Bin),
            io:format("~s~n",[Bin]),
	    io:fwrite("~s~n",[Bin]),
            loop(Socket)
     end.

% client test local
client(Request) ->
    {ok,Socket} = gen_udp:open(0,[binary]),
    ok = gen_udp:send(Socket,"192.168.1.101",55555,Request),
    Value = receive
                {udp,Socket,_,_,Bin} ->
                    {ok,Bin}
                after 2000 ->
                    error
                end,
    gen_udp:close(Socket),
    Value.

% client unicast
client(Host, Port, Request) ->
    {ok,Socket} = gen_udp:open(0,[binary]),
     Id = 0,
     loopclient(Socket, Host, Port, Request, Id + 1).   
% repeat msg 10 times
loopclient(Socket, Host, Port, Request1, Id) when Id < 10 ->
    ok = gen_udp:send(Socket,Host,Port,Request1),
     loopclient(Socket,Host, Port, Request1, Id + 1);

loopclient(Socket, Host, Port, Request1, Id) ->
     gen_udp:close(Socket),
     done.


startc() ->
     spawn(udpcs, client, ["192.168.1.101", 55555, "msg from client a"]),
     spawn(udpcs, client, ["192.168.1.101", 55555, "msg from client b"]),
     spawn(udpcs, client, ["192.168.1.101", 55555, "msg from cleint c"]),
     spawn(udpcs, client, ["192.168.1.101", 55555, "msg from client d"]),
     spawn(udpcs, client, ["192.168.1.101", 55555, "msg from client d"]).
