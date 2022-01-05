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
    {ok, CacheNodes} = resource_discovery:fetch_resources(simple_cache),
    dynamic_db_init(lists:delete(node(), CacheNodes)).

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
    case mnesia:dirty_index_read(key_to_value, Key, #key_to_value.key) of
        [#key_to_value{} = Record] ->
            mnesia:dirty_delete_object(Record);
        _ ->
            ok
    end.


%% Internal Functions

dynamic_db_init([]) ->
    mnesia:create_table(key_to_value,
                        [{index, [value]},
                         {attributes, record_info(fields, key_to_value)}
                        ]);
dynamic_db_init(CacheNodes) ->
    add_extra_nodes(CacheNodes).

add_extra_nodes([Node|T]) ->
    case mnesia:change_config(extra_db_nodes, [Node]) of
        {ok, [Node]} ->
            mnesia:add_table_copy(key_to_value, node(), ram_copies),

            Tables = mnesia:system_info(tables),
            mnesia:wait_for_tables(Tables, ?WAIT_FOR_TABLES);
        _ ->
            add_extra_nodes(T)
    end.

