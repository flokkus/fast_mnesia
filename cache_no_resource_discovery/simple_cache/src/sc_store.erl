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
%    {ok, CacheNodes} = resourceXXX_discovery:fetch_resources(simple_cache),
%    dynamic_db_init(lists:delete(node(), CacheNodes)).

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
    mnesia:create_table(key_to_value,
                        [{index, [value]},
                         {attributes, record_info(fields, key_to_value)}
                        ]).


