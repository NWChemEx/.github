FROM ubuntu:20.04
LABEL maintainer="NWChemEx-Project" \
      description="Basic environment for building the documentation based on the ubuntu 20.04 image."

RUN    apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y \
                git \
                doxygen \
                graphviz \
                wget \
                python3-dev \
                python3-sphinx \
                python3-pip \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

ARG CMAKE_VERSION=3.17.0

RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh \
      -q -O /tmp/cmake-install.sh \
      && chmod u+x /tmp/cmake-install.sh \
      && mkdir /usr/bin/cmake \
      && /tmp/cmake-install.sh --skip-license --prefix=/usr/bin/cmake \
      && rm /tmp/cmake-install.sh

ENV PATH="/usr/bin/cmake/bin:${PATH}"
