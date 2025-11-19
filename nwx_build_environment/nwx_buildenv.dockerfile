# Copyright 2025 NWChemEx-Project
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

FROM ubuntu:noble

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y \
    gcc-14 g++-14 \
    clang-19 libc++-19-dev libc++abi-19-dev \
    libomp-dev \
    doxygen \
    graphviz \
    python3-dev python3-pip python3-sphinx python3-venv\
    cmake \
    ninja-build \
    git \
    vim \
    openmpi-bin libopenmpi-dev \
    libgslcblas0 libgsl-dev \
    libeigen3-dev \
    liblapacke liblapacke-dev \
    libboost-dev \
    libopenblas-dev \
    libscalapack-openmpi-dev \
    wget \
    libxml2-dev \
    libxslt-dev \
    nwchem \
    && python3 -m venv /pyenv \
    && . /pyenv/bin/activate \
    && pip install gcovr numpy qcelemental qcengine networkx ase \
    && deactivate \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY toolchains /toolchains
COPY scripts /scripts
