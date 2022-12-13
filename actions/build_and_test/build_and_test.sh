#!/bin/sh
################################################################################
#
# The master build_and_test.sh script lives at
# NWChemEx-Project/DeveloperTools/.github/workflows/scripts. The
# build_and_test.sh script contained in all other NWChemEx-Project repositories
# is a synchronized copy of the master script. Thus to make changes to the
# build_and_test.sh file please make them to the master script.
#
################################################################################

# Wraps the process for configuring, building, and testing an NWX repo
#
# Usage:
#   build_and_test.sh
#
# Other variables:
#   cmake_version: the version of cmake being used in the format x.y.z
#

set -e # Exit with error if any command fails

arch=Linux-x86_64
cmake_root=$(pwd)/cmake-"${cmake_version}"-"${arch}"
cmake_command=cmake #"${cmake_root}/bin/cmake"
ctest_command=ctest #"${cmake_root}/bin/ctest"
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
  echo 'set(CPP_GITHUB_TOKEN '${CPP_GITHUB_TOKEN}')'
  echo 'set(CMAKE_BUILD_TYPE Debug)'
  echo 'set(ENABLE_SCALAPACK ON)'
  echo 'set(LIBDIR "/usr/lib/x86_64-linux-gnu")'
  echo 'set(BLAS_LIBRARIES   "-L${LIBDIR} -lopenblas")'
  echo 'set(LAPACK_LIBRARIES "-L${LIBDIR} -llapack ${BLAS_LIBRARIES}")'
  echo 'set(ScaLAPACK_LIBRARIES  "-L${LIBDIR} -lscalapack-openmpi ${LAPACK_LIBRARIES}")'
  #echo 'set(blacs_LIBRARIES ${SCALAPACK_LIBRARIES})'
  #echo 'set(scalapack_LIBRARIES ${SCALAPACK_LIBRARIES})'
  #echo 'set(lapack_LIBRARIES ${LAPACK_LIBRARIES})'
} >> "${toolchain_file}"

# if clang_version is not empty set clang and 
# clang++ as default c and cxx compiler
if [ ! -z "$clang_version" ]
then
    {
      echo "set(CMAKE_C_COMPILER /usr/bin/clang)"
      echo "set(CMAKE_CXX_COMPILER /usr/bin/clang++)"  
      # echo 'set(OpenMP_CXX "${CMAKE_CXX_COMPILER}" CACHE STRING "" FORCE)'
      # echo 'set(OpenMP_CXX_FLAGS "-fopenmp=libomp -Wno-unused-command-line-argument" CACHE STRING "" FORCE)'
      # echo 'set(OpenMP_CXX_LIB_NAMES "libomp" "libgomp" "libiomp5" CACHE STRING "" FORCE)'
      # echo 'set(OpenMP_libomp_LIBRARY ${OpenMP_CXX_LIB_NAMES} CACHE STRING "" FORCE)'
      # echo 'set(OpenMP_libgomp_LIBRARY ${OpenMP_CXX_LIB_NAMES} CACHE STRING "" FORCE)'
      # echo 'set(OpenMP_libiomp5_LIBRARY ${OpenMP_CXX_LIB_NAMES} CACHE STRING "" FORCE)'
      echo 'set(gpu_backend "none" CACHE STRING "" FORCE)'
    } >> "${toolchain_file}"
else 
  {
    echo "set(CMAKE_C_COMPILER /usr/bin/gcc)"
    echo "set(CMAKE_CXX_COMPILER /usr/bin/g++)"  
  } >> "${toolchain_file}"
fi

#Step 2: Configure
if which ninja >/dev/null
then
  ${cmake_command} -GNinja -H. -Bbuild -DCMAKE_TOOLCHAIN_FILE="${toolchain_file}"
else
  ${cmake_command} -H. -Bbuild -DCMAKE_TOOLCHAIN_FILE="${toolchain_file}"
fi

#Step 3: Compile
${cmake_command} --build build

#Step 4: Unit-test
cd build
${ctest_command} -VV
cd ..

#Step 5: Generate coverage report
# curr_dir=$(pwd)
# cd ..
# gcovr --root "${curr_dir}" \
#       --filter "${curr_dir}" \
#       --exclude "${curr_dir}"/tests \
#       --xml "${curr_dir}"/coverage.xml