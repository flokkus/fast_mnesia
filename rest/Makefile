compile_src:
	erlc -o ./tcp_interface/ebin ./tcp_interface/src/*.erl
	erlc -o ./gen_web_server/ebin ./gen_web_server/src/*.erl
	erlc -pa ./gen_web_server/ebin -o ./http_interface/ebin ./http_interface/src/*.erl
	erlc -o ./simple_cache/ebin ./simple_cache/src/*.erl
 
compile_test:
	erlc -o ./test/ebin ./test/src/*.erl

run_web_server:
	erl -sname mynode -pa ./tcp_interface/ebin -pa ./gen_web_server/ebin -pa ./http_interface/ebin -pa ./simple_cache/ebin \
		-pa ./resource_discovery/ebin/ -boot ./simple_cache -config sys

test_rest:
	curl -T put.txt http://localhost:1156/key
	curl http://localhost:1156/key

remove_beams:
	rm ./simple_cache/ebin/*.beam

generate_boot:
	erl -noshell -pa ./simple_cache/ebin -eval 'systools:make_script("simple_cache", [local])' -s init stop

all: compile_src compile_test
