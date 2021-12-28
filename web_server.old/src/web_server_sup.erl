-module(web_server_sup).

-behaviour(supervisor).

-export([start_link/1, start_child/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link(LSock) ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, {LSock}).

start_child() ->
    supervisor:start_child(?SERVER, []).

init([LSock]) ->
    Server = {web_server, {web_server, start_link, [LSock]},
        temporary, brutal_kill, worker, [web_server]},
    Children = [Server],
    RestartStrategy = {simple_one_for_one, 0, 1},
    {ok, [RestartStrategy, Children]}.

