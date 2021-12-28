-module(web_server_app).

-behaviour(application).

-export([start/2, stop/1]).

-define(DEFAULT_PORT, 4455).

start(_StartType, _StartArgs) ->
    Port = case application:get_tcp(tcp_interface, port) of
        {ok, P} -> P;
        undefined -> ?DEFAULT_PORT
    end,
    {ok, LSock} = gen_tcp:listen(Port, [{active, true}]),
    case web_server_sup:start_link(LSock) of
        {ok, Pid} ->
            web_server_sup:start_child(),
            {ok, Pid};
        Other ->
            {error, Other}
        end.

stop(_State) ->
    ok.

