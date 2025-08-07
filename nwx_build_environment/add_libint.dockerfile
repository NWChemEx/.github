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

ARG VERSION=2.9.0
ARG COMPILER=gcc-11

# Install libfort ##
RUN cd /tmp \
    && wget https://github.com/evaleev/libint/releases/download/v${VERSION}/libint-${VERSION}.tgz \
    && tar -zxf libint-${VERSION}.tgz \
    && cd libint-${VERSION} \
    && cmake -Bbuild -H. -GNinja \
    -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE \
    -DCMAKE_INSTALL_PREFIX=/nwx_dependencies/${COMPILER} \
    -DCMAKE_TOOLCHAIN_FILE=/toolchains/${COMPILER}.cmake \
    && cmake --build build --target install --parallel \
    && rm -rf /tmp/libint-${VERSION}
