-module(simple_cache).

-export([insert/2, lookup/1, delete/1]).

insert(Key, Value) ->
    io:format("Inserting record...~n"),
    sc_store:insert(Key, Value).

lookup(Key) ->
    sc_store:lookup(Key).

delete(Key) ->
    sc_store:delete(Key).
