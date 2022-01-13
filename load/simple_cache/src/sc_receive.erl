-module(sc_receive).

-export([start/0]).

start() ->
    io:format("Start receiving~n"),
    receive
        {K, V} ->
            io:format("Received ~s:~s~n", [K,V]);
        _ ->
            io:format("Received something")
    end.

