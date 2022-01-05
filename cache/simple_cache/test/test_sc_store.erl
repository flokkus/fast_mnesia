-module(test_sc_store).

-export[test/0].

test() ->
    sc_score:insert('MyKey', 'MyValue').