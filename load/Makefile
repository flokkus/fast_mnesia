compile_src:
	erlc -o ./simple_cache/ebin ./simple_cache/src/*.erl
 
compile_test:
	erlc -o ./test/ebin ./test/src/*.erl

compile_load:
	erlc -o ./load_generator/ebin ./load_generator/src/*.erl

run_test:
	erl -sname test -pa ./simple_cache/ebin -pa ./test/ebin -boot ./simple_cache \
		-config sys -s test_simple_cache

run_mynode:
	erl -sname mynode -pa ./simple_cache/ebin -boot ./simple_cache -config sys

run_mynode2:
	erl -sname mynode2 -pa ./simple_cache/ebin -boot ./simple_cache -config sys \
		-extra mynode@Eduardos-MacBook-Pro-2 

run_load:
	erl -sname load -pa ./load_generator/ebin pa ../../ponos/ebin \
		-config sys -s load_generator -extra mynode@Eduardos-MacBook-Pro-2 

remove_beams:
	rm ./simple_cache/ebin/*.beam

generate_boot:
	erl -noshell -pa ./simple_cache/ebin -eval 'systools:make_script("simple_cache", [local])' -s init stop

all: compile_src compile_test
