-module(simple_cache).

-export([insert/2, lookup/1, delete/1]).

insert(Key, Value) ->
% Add observability
    sc_store:insert(Key, Value).

lookup(Key) ->
% Add observability
    sc_store:lookup(Key).

delete(Key) ->
% Add observability
    sc_store:delete(Key).
