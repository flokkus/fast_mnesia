-module(test_simple_cache).

-export([start/0]).

-define(KEY, 'key').
-define(VALUE, 'value').

start() ->
    test().

test() ->
    test_insert(),
    io:fwrite("Test succeeded.\n"),
    init:stop().

test_insert() ->
    simple_cache:insert(?KEY, ?VALUE).

    