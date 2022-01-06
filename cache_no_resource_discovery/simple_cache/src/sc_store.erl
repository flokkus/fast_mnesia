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
    dynamic_db_init().

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
    [R] = io_lib:format('~s', [Node]),
    io:format("Adding node: <~w>~n", [R]),
    io:format("Hard-coded:  <~w>~n", ['mynode@Eduardos-MacBook-Pro-2']),
    net_adm:ping('mynode@Eduardos-MacBook-Pro-2'),
    io:format(R == 'mynode@Eduardos-MacBook-Pro-2'),
%    N = 'mynode@Eduardos-MacBook-Pro-2',
    N = io:format("~s", [Node]),
    io:format("Mnesia node: <~p>~n", [N]).
%    case mnesia:change_config(extra_db_nodes, [N]) of
%        {ok, [N]} ->
%            mnesia:add_table_copy(key_to_value, node(), ram_copies),
%
%            Tables = mnesia:system_info(tables),
%            mnesia:wait_for_tables(Tables, ?WAIT_FOR_TABLES)
%    end.

db_init() ->
    io:format("Creating table"),
    mnesia:create_table(key_to_value,
                        [{index, [value]},
                         {attributes, record_info(fields, key_to_value)}
                        ]).


