-module(sc_receive).

-export([start/0]).

start() ->
    io:format("Start receiving~n"),
    receive
        {K, V} ->
            io:format("Received ~s:~s~n", [K,V]),
            simple_cache:insert(K,V),
            start();
        {K} ->
            io:format("Received ~s~n", [K]),
            {_,V} = simple_cache:lookup(K),
            io:format("Value: ~s~n", [V]),
            start();
        _ ->
            io:format("Received unexpected something")
    end.

