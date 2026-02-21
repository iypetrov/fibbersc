run:
	@python main.py

invoke-python-impl:
	@curl -sX POST "http://localhost:8080/fibonacci/python" \
		-H "Content-Type: application/json" \
		-d '{"n": 10}'
