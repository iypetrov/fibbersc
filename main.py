import uvicorn
from timeit import timeit
from typing import Callable
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from ctypes import CDLL


app = FastAPI()


class FibonacciRequest(BaseModel):
    n: int = Field(..., ge=0, le=50, description="A single digit (0-50)")


class FibonacciResponse(BaseModel):
    n: int
    result: int
    execution_time_ms: float


def fib_py(n: int) -> int:
    if n <= 1:
        return n
    return fib_py(n - 1) + fib_py(n - 2)


def fib_c(n: int) -> int:
    fib_c_lib = CDLL("./fib_c_lib.so")
    return fib_c_lib.fib(n)


@app.post("/fibonacci/python", response_model=FibonacciResponse)
def compute_fibonacci(payload: FibonacciRequest):
    return execute_and_measure(fib_py, payload.n)


@app.post("/fibonacci/c", response_model=FibonacciResponse)
def compute_fibonacci(payload: FibonacciRequest):
    return execute_and_measure(fib_c, payload.n)


def execute_and_measure(func: Callable[[int], int], n: int) -> FibonacciResponse:
    runs = 100
    try:
        time_per_call = timeit(lambda: func(n), number=runs) / runs
        execution_time_ms = time_per_call * 1_000

        result = func(n)

        return FibonacciResponse(
            n=n,
            result=result,
            execution_time_ms=execution_time_ms,
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8080, reload=True)
