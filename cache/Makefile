compile_src:
	erlc -o ./simple_cache/ebin ./simple_cache/src/*.erl
	erlc -o ./resource_discovery/ebin ./resource_discovery/src/*.erl
 
compile_test:
	erlc -o ./test/ebin ./test/src/*.erl

run_test:
	erl -sname test -pa ./simple_cache/ebin -pa ./resource_discovery/ebin/ -pa ./test/ebin -boot ./simple_cache \
		-config sys -s test_simple_cache

run_mynode:
	erl -sname mynode -pa ./simple_cache/ebin -pa ./resource_discovery/ebin/ -boot ./simple_cache -config sys

run_mynode2:
	erl -sname mynode2 -pa ./simple_cache/ebin -pa ./resource_discovery/ebin/ -boot ./simple_cache -config sys

start_contact_nodes:
	erl -sname contact1 -detached
	erl -sname contact2 -detached

remove_beams:
	rm ./simple_cache/ebin/*.beam
	rm ./resource_discovery/ebin/*.beam

all: compile_src compile_test
