FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y gcc-9 g++-9 \
    gcc-11 g++-11 \
    clang-11 libc++-11-dev libc++abi-11-dev \
    python3-dev pip \
    cmake \
    ninja-build \
    git \
    vim \
    openmpi-bin libopenmpi-dev \
    libgslcblas0 libgsl-dev \
    libeigen3-dev \
    liblapacke liblapacke-dev \
    libboost-all-dev \
    libopenblas-base libopenblas-dev \
    libscalapack-openmpi-dev \
    libint2-dev \
    libxml2-dev \
    libxslt-dev \
    && pip install gcovr numpy \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY toolchains /toolchains

