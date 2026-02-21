FROM python:3.12
WORKDIR /app
COPY . .
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    python3-dev \
    libssl-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*
RUN gcc -shared -o fib_c_lib.so fib-c/lib.c
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN python -m venv venv && \
    . venv/bin/activate && \
    pip install --upgrade pip && \
    pip install -r requirements.txt && \
    maturin develop --manifest-path fib-rs/Cargo.toml --release
EXPOSE 8080
CMD ["venv/bin/python", "main.py"]
