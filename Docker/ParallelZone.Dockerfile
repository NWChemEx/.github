# Copyright 2023 NWChemEx-Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:20.04
LABEL maintainer="NWChemEx-Project" \
      description="Basic building environment for ParallelZone based on the ubuntu 20.04 image."

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
	&& apt-get clean \
	&& pip install gcovr \
	&& rm -rf /var/lib/apt/lists/*

ARG CMAKE_VERSION=3.17.0

RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh \
      -q -O /tmp/cmake-install.sh \
      && chmod u+x /tmp/cmake-install.sh \
      && mkdir /usr/bin/cmake \
      && /tmp/cmake-install.sh --skip-license --prefix=/usr/bin/cmake \
      && rm /tmp/cmake-install.sh

ENV PATH="/usr/bin/cmake/bin:${PATH}"



