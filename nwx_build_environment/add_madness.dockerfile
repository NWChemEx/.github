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

FROM nwx_buildenv:latest

ARG VERSION=3d585293f0094588778dbd3bec24b65e7bbe6a5d
ARG COMPILER=gcc-11

# Install MADNESS
RUN cd /tmp \
    && git clone https://github.com/m-a-d-n-e-s-s/madness.git \
    && cd madness \
    && git checkout ${VERSION}\
    && cmake -Bbuild -H. -GNinja \
    -DENABLE_UNITTESTS=OFF \
    -DMADNESS_BUILD_MADWORLD_ONLY=ON \
    -DMADNESS_ENABLE_CEREAL=ON \
    -DENABLE_MKL=OFF \
    -DENABLE_ACML=OFF \
    -DBUILD_TESTING=OFF \
    -DCMAKE_PREFIX_PATH=/nwx_dependencies/${COMPILER} \
    -DCMAKE_INSTALL_PREFIX=/nwx_dependencies/${COMPILER} \
    -DCMAKE_TOOLCHAIN_FILE=/toolchains/${COMPILER}.cmake \
    && cmake --build build --target install \
    && rm -rf /tmp/madness
