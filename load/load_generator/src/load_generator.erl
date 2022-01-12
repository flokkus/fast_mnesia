-module(load_generator).

-export([start/0]).

-define(KEY, 'key').
-define(VALUE, 'value').

start() ->
    load().

load() ->
    application:start(ponos).

insert() ->
    simple_cache:insert(?KEY, ?VALUE).
