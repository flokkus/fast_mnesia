-module(sc_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    EventManager = {sc_event, {sc_event, start_link, []},
                    permanent, 2000, worker, [sc_event]},

    Children = [EventManager],
    RestartStrategy = {one_for_one, 4, 3600},
    {ok, {RestartStrategy, Children}}.
