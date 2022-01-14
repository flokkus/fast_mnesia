-module(load_generator).

-export([start/0]).

-define(NODE, 'node').

start() ->
    load().

load() ->
    io:fwrite("Starting load generator...~n"),
    value_gen:start(),
    connect_to_cluster(),
    application:start(ponos),
    Name = load_cache,
    Task = fun insert/0,
    LoadSpec = ponos_load_specs:make_sawtooth(10, 20.0),
    Options = [{duration, 60*1000}, {auto_init, false}],
    Args = [{name,Name},{task,Task},{load_spec,LoadSpec},{options,Options}],
    [ok] = ponos:add_load_generators([Args]),
    ponos:init_load_generators([Name]).

insert() ->
    {K,V} = value_gen:get_value(),
    io:fwrite("Sending ~s:~s ~n", [K, V]),
    {mynode, 'mynode@Eduardos-MacBook-Pro-2'} ! {K, V},
    {mynode, 'mynode2@Eduardos-MacBook-Pro-2'} ! {K, V}.

connect_to_cluster() ->
    Nodes = init:get_plain_arguments(),
    case Nodes of
        [] ->
            io:fwrite("Empty cluster list"),
            throw("Expected node name");
        [Node] ->
            io:fwrite("Received nodes."),
            io:fwrite(Node),
            io:fwrite("\n"),
            R = list_to_atom(Node),
            io:format("Adding node: <~w>~n", [R]),
            net_adm:ping(R),
            persistent_term:put(?NODE, R)
    end.







