output = ./simple_cache/ebin

compile_src:
	erlc -o ${output} ./simple_cache/src/*.erl
	erlc -o ${output} ./resource_discovery/src/*.erl
 
compile_test:
	erlc -o ${output} ./simple_cache/test/*.erl

run_test:
	erl -o ${output} -run  

run_shell:
	erl -o ${output}

all: compile_src compile_test
