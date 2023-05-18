#!/bin/sh

# Wraps the process for configuring, building, and testing an NWX repo
#
# Usage:
#   build.sh
#
# Other variables:
#   cmake_version: the version of cmake being used in the format x.y.z
#

set -e # Exit with error if any command fails

arch=Linux-x86_64
cmake_root=$(pwd)/cmake-"${cmake_version}"-"${arch}"
cmake_command=cmake
toolchain_file=$(pwd)/toolchain.cmake


echo "set(BUILD_TESTING ON)" > "${toolchain_file}"
{
  echo "set(CMAKE_CXX_STANDARD 17)"
  echo 'set(CMAKE_POSITION_INDEPENDENT_CODE TRUE)'
  echo "set(BUILD_SHARED_LIBS ON)"
  echo "set(CATCH_ENABLE_COVERAGE ON)"
  echo "set(CMAKE_PREFIX_PATH $(pwd)/install)"
  echo 'set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage -std=c++17")'
  echo 'set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DOMPI_SKIP_MPICXX")'
  echo 'set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --coverage")'
  echo 'set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fprofile-arcs")'
  echo 'set(CMAIZE_GITHUB_TOKEN '${CMAIZE_GITHUB_TOKEN}')'
  echo 'set(CMAKE_BUILD_TYPE Debug)'
  echo 'set(ENABLE_SCALAPACK ON)'
  echo 'set(LIBDIR "/usr/lib/x86_64-linux-gnu")'
  echo 'set(BLAS_LIBRARIES   "-L${LIBDIR} -lopenblas")'
  echo 'set(LAPACK_LIBRARIES "-L${LIBDIR} -llapack ${BLAS_LIBRARIES}")'
  echo 'set(ScaLAPACK_LIBRARIES  "-L${LIBDIR} -lscalapack-openmpi ${LAPACK_LIBRARIES}")'
} >> "${toolchain_file}"

# if clang_version is not empty set clang and 
# clang++ as default c and cxx compiler
if [ ! -z "$clang_version" ]
then
    {
      echo "set(CMAKE_C_COMPILER /usr/bin/clang)"
      echo "set(CMAKE_CXX_COMPILER /usr/bin/clang++)"  
      echo 'set(gpu_backend "none" CACHE STRING "" FORCE)'
    } >> "${toolchain_file}"
else 
  {
    echo "set(CMAKE_C_COMPILER /usr/bin/gcc)"
    echo "set(CMAKE_CXX_COMPILER /usr/bin/g++)"  
  } >> "${toolchain_file}"
fi

#Step 2: Configure
if [ "${INSTALL}" = true ]; then
  export INSTALL_PATH=install
  if [ "${ninja_build}" = true ] ; then
    ${cmake_command} -GNinja -H. -Bbuild -DCMAKE_TOOLCHAIN_FILE="${toolchain_file}" -DCMAKE_INSTALL_PREFIX=${INSTALL_PATH}
  else
    ${cmake_command} -H. -Bbuild -DCMAKE_TOOLCHAIN_FILE="${toolchain_file}" -DCMAKE_INSTALL_PREFIX=${INSTALL_PATH}
  fi
else
  if [ "${ninja_build}" = true ] ; then
    ${cmake_command} -GNinja -H. -Bbuild -DCMAKE_TOOLCHAIN_FILE="${toolchain_file}"
  else
    ${cmake_command} -H. -Bbuild -DCMAKE_TOOLCHAIN_FILE="${toolchain_file}"
  fi
fi

#Step 3: Compile
${cmake_command} --build build

#Step 4: Install
if [ "${INSTALL}" = true ]; then
  ${cmake_command} --build build --target install
fi
