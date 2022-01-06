-module(sc_app).

-behaviour(application).

-export([start/2, stop/1]).

-define(WAIT_FOR_RESOURCES, 2500).

start(_StartType, _StartArgs) ->
    net_adm:ping('mynode@Eduardos-MacBook-Pro-2'),
    sc_store:init(),
    case sc_sup:start_link() of
        {ok, Pid} ->
            sc_event_logger:add_handler(),
            {ok, Pid};
        Other ->
            {error, Other}
    end.

stop(_State) ->
    ok.

