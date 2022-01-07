-module(test_simple_cache).

-export([start/0]).

-define(KEY, 'key').
-define(VALUE, 'value').

start() ->
    test().

test() ->
    test_insert(),
    test_lookup(),
    io:fwrite("Test succeeded.\n"),
    init:stop().

test_insert() ->
    io:fwrite('Testing insert.\n'),
    ok = insert().

test_lookup() ->
    io:fwrite('Testing lookup.\n'),
    insert(),
    {ok,value} = simple_cache:lookup(?KEY).

insert() ->
    simple_cache:insert(?KEY, ?VALUE).

    