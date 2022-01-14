-module(value_gen).

-export([start/0,get_value/0]).


-define(KEY_PREFIX, "key-").
-define(VALUE_PREFIX, "value-").

start() ->
    persistent_term:put(count, 0).

get_value() ->
    C = persistent_term:get(count),
    I = C + 1,
    S = integer_to_list(I),
    io:fwrite("Storing ~s~n", [S]),
    persistent_term:put(count, I),
    K = ?KEY_PREFIX ++ S,
    V = ?VALUE_PREFIX ++ S, 
    {K,V}.





