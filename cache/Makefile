cache_output = ./simple_cache/ebin
rd_output = ./resource_discovery/ebin

compile_src:
	erlc -o ${cache_output} ./simple_cache/src/*.erl
	erlc -o ${rd_output} ./resource_discovery/src/*.erl
 
compile_test:
	erlc -o ${cache_output} ./simple_cache/test/*.erl

run_test:
	erl -o ${cache_output} -run  

run_mynode:
	erl -sname mynode -pa ./simple_cache/ebin -pa ./resource_discovery/ebin/ -boot ./simple_cache -config sys

run_mynode2:
	erl -sname mynode2 -pa ./simple_cache/ebin -pa ./resource_discovery/ebin/ -boot ./simple_cache -config sys

start_contact_nodes:
	erl -sname contact1 -detached
	erl -sname contact2 -detached

all: compile_src compile_test
