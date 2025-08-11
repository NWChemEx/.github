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

ARG VERSION=63e180bf55849c173585a734c5e7456cbf31a986
ARG COMPILER=gcc-11

# Install TiledArray
RUN cd /tmp \
    && git clone https://github.com/ValeevGroup/TiledArray.git tiledarray \
    && cd tiledarray \
    && git checkout ${VERSION} \
    && cmake -Bbuild -H. -GNinja \
    -DTA_BUILD_UNITTEST=OFF \
    -DBUILD_TESTING=OFF \
    -DBLAS_THREAD_LAYER=sequential \
    -DCMAKE_PREFIX_PATH=/nwx_dependencies/${COMPILER} \
    -DCMAKE_INSTALL_PREFIX=/nwx_dependencies/${COMPILER} \
    -DCMAKE_TOOLCHAIN_FILE=/toolchains/${COMPILER}.cmake \
    && cmake --build build --target install \
    && cd .. \
    && rm -rf tiledarray
