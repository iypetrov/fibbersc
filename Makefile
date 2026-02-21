run:
	@gcc -shared -o fib_c_lib.so fib-c/lib.c
	@maturin develop --manifest-path fib-rs/Cargo.toml --locked
	@python main.py

invoke-python-impl:
	@curl -sX POST "http://localhost:8080/fibonacci/python" \
		-H "Content-Type: application/json" \
		-d '{"n": 30}'

invoke-c-impl:
	@curl -sX POST "http://localhost:8080/fibonacci/c" \
		-H "Content-Type: application/json" \
		-d '{"n": 30}'

invoke-rust-impl:
	@curl -sX POST "http://localhost:8080/fibonacci/rust" \
		-H "Content-Type: application/json" \
		-d '{"n": 30}'
