FROM ubuntu:20.04
LABEL maintainer="NWChemEx-Project" \
      description="Basic building environment for PluginPlay based on the ubuntu 20.04 image."

RUN    apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
		git \
		wget \
		pip \
		gcc \
		g++ \
		clang-11 \
		libc++-11-dev \
		libc++abi-11-dev \
		ninja-build \
		libxml2-dev \
		libxslt-dev \
		python3-dev \
		openmpi-bin \
		libopenmpi-dev \
		libboost-all-dev \
	&& apt-get clean \
	&& pip install gcovr \
	&& pip install cppyy \
	&& rm -rf /var/lib/apt/lists/*

ARG CMAKE_VERSION=3.17.0

RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh \
      -q -O /tmp/cmake-install.sh \
      && chmod u+x /tmp/cmake-install.sh \
      && mkdir /usr/bin/cmake \
      && /tmp/cmake-install.sh --skip-license --prefix=/usr/bin/cmake \
      && rm /tmp/cmake-install.sh

ENV PATH="/usr/bin/cmake/bin:${PATH}"

ARG libfort_version=0.4.2

ENV INSTALL_PATH=`pwd`/install

RUN wget --no-check-certificate --content-disposition https://codeload.github.com/seleznevae/libfort/tar.gz/refs/tags/v${libfort_version} \
    && tar -zxf libfort-${libfort_version}.tar.gz \
    && cd libfort-${libfort_version} \
    && cmake -GNinja -H. -Bbuild -DCMAKE_INSTALL_PREFIX=${INSTALL_PATH} \
    && cmake --build build --target install

ENV PATH="`pwd`/install:${PATH}"
