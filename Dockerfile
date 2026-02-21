FROM gcc:15.2.0 AS build-c-stage
WORKDIR /build
COPY fib-c/lib.c .
RUN gcc -shared -o fib_c_lib.so lib.c

FROM python:3.14
WORKDIR /app
COPY . .
COPY --from=build-c-stage /build/fib_c_lib.so .
RUN pip install -r requirements.txt
CMD ["make", "run"]
