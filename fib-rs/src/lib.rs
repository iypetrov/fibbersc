use pyo3::prelude::*;

/// A Python module implemented in Rust.
#[pymodule]
mod fib_rs {
    use pyo3::prelude::*;

    #[pyfunction]
    fn fib(n: u32) -> PyResult<u32> {
        if n <= 1 {
            return Ok(n);
        }
        Ok(fib(n - 1)? + fib(n - 2)?)
    }
}
