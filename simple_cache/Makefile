compile:
	erlc -o ./simple_cache/ebin ./simple_cache/src/*.erl
	erlc -o ./resource_discovery/ebin ./resource_discovery/src/*.erl

generate_boot:
	erl -noshell -pa ./simple_cache/ebin -pa ./resource_discovery/ebin -eval 'systools:make_script("simple_cache", [local])' -s init stop

start_contact_node:
	erl -sname contact2

start_node:
	erl -sname mynode -pa ./simple_cache/ebin -pa ./resource_discovery/ebin/ -boot ./simple_cache -config sys



