-module(sc_receive).

-export([start/0]).

start() ->
    io:format("Start receiving~n"),
    receive
        {K, V} ->
            io:format("Received ~s:~s~n", [K,V]),
            simple_cache:insert(K,V),
            start();
        _ ->
            io:format("Received something")
    end.

