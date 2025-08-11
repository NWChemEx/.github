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

set(BUILD_TESTING ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_POSITION_INDEPENDENT_CODE TRUE)
set(BUILD_SHARED_LIBS ON)
set(CATCH_ENABLE_COVERAGE ON)
set(CMAKE_BUILD_TYPE Debug)

list(APPEND CMAKE_PREFIX_PATH "/nwx_dependencies/${CMAKE_C_COMPILER}")
# list(APPEND CMAKE_PREFIX_PATH "/usr/share/cmake/libint2/")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage -std=c++17 -Wall")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DOMPI_SKIP_MPICXX")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --coverage")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fprofile-arcs")

set(ENABLE_SCALAPACK ON)
set(LIBDIR "/usr/lib/x86_64-linux-gnu")
set(BLAS_LIBRARIES   "-L${LIBDIR} -lopenblas")
set(LAPACK_LIBRARIES "-L${LIBDIR} -llapack ${BLAS_LIBRARIES}")
set(ScaLAPACK_LIBRARIES  "-L${LIBDIR} -lscalapack-openmpi ${LAPACK_LIBRARIES}")

set(BUILD_CPPYY_PYBINDINGS OFF)
set(BUILD_PYBIND11_PYBINDINGS ON)
set(Python_EXECUTABLE /usr/bin/python3)
set(NWX_MODULE_DIRECTORY /NWX_PyModules)
