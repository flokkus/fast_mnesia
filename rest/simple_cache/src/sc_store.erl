-module(sc_store).

-export([
         init/0,
         insert/2,
         delete/1,
         lookup/1
        ]).

-define(TABLE_ID, ?MODULE).
-define(WAIT_FOR_TABLES, 5000).

-record(key_to_value, {key, value}).

init() ->
    mnesia:stop(),
    mnesia:delete_schema([node()]),
    mnesia:start(),
    dynamic_db_init(),
    application:start(tcp_interface),
    application:start(http_interface).

insert(Key, Value) ->
    mnesia:dirty_write(#key_to_value{key = Key, value = Value}).

lookup(Key) ->
    case mnesia:dirty_read(key_to_value, Key) of
        [{key_to_value, Key, Value}] ->
	    {ok, Value};
        [] ->
	    {error, not_found}
    end.

delete(Key) ->
    mnesia:dirty_delete(key_to_value, Key).

dynamic_db_init() ->
    Nodes = init:get_plain_arguments(),
    case Nodes of
        [] ->
            db_init();
        [Node] ->
            io:fwrite("Received nodes."),
            io:fwrite(Node),
            io:fwrite("\n"),
            db_init(Node)
    end.

db_init(Node) ->
    R = list_to_atom(Node),
    io:format("Adding node: <~w>~n", [R]),
    net_adm:ping(R),
    case mnesia:change_config(extra_db_nodes, [R]) of
        {ok, [R]} ->
            mnesia:add_table_copy(key_to_value, node(), ram_copies),

            Tables = mnesia:system_info(tables),
            mnesia:wait_for_tables(Tables, ?WAIT_FOR_TABLES)
    end.

db_init() ->
    io:format("Creating table"),
    mnesia:create_table(key_to_value,
                        [{index, [value]},
                         {attributes, record_info(fields, key_to_value)}
                        ]).


