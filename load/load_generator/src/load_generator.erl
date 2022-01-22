-module(load_generator).

-export([start/0,connect_to_cluster/0]).

-define(NODE, 'node').

start() ->
    load().

run_load(Name, Task) ->
    LoadSpec = ponos_load_specs:make_sawtooth(10, 20.0),
    Options = [{duration, 10*1000}, {auto_init, false}],
    Args = [{name,Name},{task,Task},{load_spec,LoadSpec},{options,Options}],
    [ok] = ponos:add_load_generators([Args]),
    ponos:init_load_generators([Name]).

load() ->
    io:fwrite("Starting load generator...~n"),
    value_gen:start(),
    connect_to_cluster(),
    application:start(ponos),
    run_load(insert, fun insert/0),
    run_load(lookup, fun lookup/0),
    io:fwrite("Test started~n").

insert() ->
    {K,V} = value_gen:get_value(),
    io:fwrite("Sending ~s:~s ~n", [K, V]),
    {mynode, 'mynode@patro-idea'} ! {K, V},
    {mynode, 'mynode2@patro-idea'} ! {K, V}.

lookup() ->
    V = value_gen:get_current_value(),
    io:fwrite("V ~s ~n", [integer_to_list(V)]),
    if 
        V > 0 -> 
            K = rand:uniform(V),
            S = value_gen:get_key_string(K),
            io:fwrite("Sending ~s ~n", [S]),
            {mynode, 'mynode@patro-idea'} ! {S},
            {mynode, 'mynode2@patro-idea'} ! {S};
        true ->
            io:fwrite("Skipping empty value")
    end.

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







