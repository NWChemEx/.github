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

CC=gcc CXX=g++ FC=gfortran cmake -Bbuild -H. -DCMAKE_INSTALL_PREFIX=/nwx_dependencies/gcc-11 -DCMAKE_BUILD_TYPE=Release -DBLAS_INT4=ON -DMODULES="CC" -DCMAKE_TOOLCHAIN_FILE=/toolchains/tamm.cmake -DUSE_LIBNUMA=OFF
cd build
make -j2
make install
