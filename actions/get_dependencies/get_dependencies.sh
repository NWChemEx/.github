#!/bin/sh
# Wraps the process of getting dependencies during CI.
#
# Usage:
#   get_dependencies [<depend1> [<depend2> [...]]]
#
# Optional Arguments:
#   depend1: name of the first dependency
#   depend2: name of the second dependency
# Other variables:
#   cmake_version: the version of cmake to get in the format x.y.z
#   gcc_version: the major of the GCC version to install
# Notes:
#   - This script needs to be run in sudo mode to actually install dependencies
#   - Python dependencies are installed in the virtual environment "venv"
################################################################################
#             Assign Shell Commands to Variables for Consistency               #
################################################################################
APT_COMMAND="sudo apt"
APT_GET_COMMAND="sudo apt-get"
APT_REPO_COMMAND="sudo add-apt-repository"
PIP_COMMAND="pip"
################################################################################
#                               Internal Functions                             #
################################################################################
# Wraps getting Boost
#
# This function will download and install a particular version of the Boost
# libraries and header files. By default that version is 1.74, but the version
# can optionally be specified.
#
# Usage:
#   get_boost [<version>]
# Optional Arguments:
#   version: The version of Boost to download. Default is 1.74.
#
get_boost() {
  BOOST_VERSION="${1-1.74}"
  sudo apt-get install libboost-all-dev
  # ${APT_REPO_COMMAND} ppa:mhier/libboost-latest
  ${APT_COMMAND} update
  ${APT_GET_COMMAND} install "libboost${BOOST_VERSION}-dev"
}
# Wraps getting CBLAS
#
# Usage:
#   get_cblas
# TODO: Should the libgsl be made into it's own function?
get_cblas() {
  ${APT_COMMAND} update
  ${APT_GET_COMMAND} install libgslcblas0 libgsl-dev
}
# Wraps installing clang
#
# Usage:
#   get_clang clang_version
get_clang() {
  clang_no_v="/usr/bin/clang"
  clang_v="${clang_no_v}-${1}"
  echo ${1}
  ${APT_COMMAND} update
  ${APT_GET_COMMAND} install clang-${1} --install-suggests
  sudo update-alternatives --install "${clang_no_v}" clang "${clang_v}" 95
  which clang
}
# Wraps installing clang-format
#
# Usage:
#   get_clang_format
get_clang_format() {
  ${APT_COMMAND} update
  ${APT_GET_COMMAND} install -f clang-format-9
}
# Wraps downloading and installing a specific version of CMake
#
# Usage:
#   get_cmake <cmake_version>
# Arguments:
#   cmake_version: The version of CMake to get in the format x.y.z
get_cmake() {
  cmake_url_base="https://github.com/Kitware/CMake/releases/download"
  arch="Linux-x86_64"
  script_name="cmake-${1}-${arch}.sh"
  wget "${cmake_url_base}/v${1}/${script_name}"
  yes | /bin/sh "${script_name}"
}
# Wraps installing Cppyy
#
# Usage:
#   get_cppyy
get_cppyy() {
  ${PIP_COMMAND} install cppyy
}
# Wraps installing Doxygen
#
# Usage:
#   get_doxygen
get_doxygen() {
  ${APT_COMMAND} update
  ${APT_GET_COMMAND} install -f doxygen
}
# Wraps installing Eigen3
#
# Usage:
#   get_eigen3
get_eigen3() {
  ${APT_COMMAND} update
  ${APT_GET_COMMAND} install libeigen3-dev
}
# Wraps installing GCC
#
# Usage:
#   get_gcc <gcc_version>
# Arguments:
#   gcc_version: The major of the GCC to install (e.g., 8 or 9)
get_gcc() {
  gcc_no_v="/usr/bin/gcc"
  gcc_v="${gcc_no_v}-${1}"
  gxx_no_v="/usr/bin/g++"
  gxx_v="${gxx_no_v}-${1}"
  gfort_no_v="/usr/bin/gfortran"
  gfort_v="${gfort_no_v}-${1}"
  gcov_no_v="/usr/bin/gcov"
  gcov_v="${gcov_no_v}-${1}"
  ${APT_REPO_COMMAND} ppa:ubuntu-toolchain-r/test
  ${APT_COMMAND} update
  ${APT_GET_COMMAND} install "gcc-${1}" "g++-${1}" "gfortran-${1}"
  sudo update-alternatives --install "${gcc_no_v}" gcc "${gcc_v}" 95 \
                           --slave "${gxx_no_v}" g++ "${gxx_v}" \
                           --slave "${gfort_no_v}" gfortran "${gfort_v}" \
                           --slave "${gcov_no_v}" gcov "${gcov_v}"
}
# Wraps installing gcovr
#
# Usage:
#   get_gcovr
get_gcovr() {
  ${APT_COMMAND} update
  ${APT_GET_COMMAND} install libxml2-dev libxslt-dev python3-dev
  ${PIP_COMMAND} install gcovr
}
# Wraps installing graphviz
#
# Usage:
#   get_graphviz
get_graphviz() {
  ${APT_COMMAND} update
  ${APT_GET_COMMAND} install graphviz
}
# Wraps installing LAPACKe
#
# Usage:
#   get_lapacke
# TODO: Does this need synchronized with the version of BLAS being installed?
get_lapacke() {
  ${APT_COMMAND} update
  ${APT_GET_COMMAND} install liblapacke liblapacke-dev
}
# Wraps installing libint
#
# Usage:
#   get_libint
get_libint() {
  export INSTALL_PATH=`pwd`/install
  # check code out
  wget https://github.com/evaleev/libint/releases/download/v2.6.0/libint-2.6.0.tgz
  tar -zxf libint-2.6.0.tgz
  cd libint-2.6.0
  export CXX=`which g++`
  export CC=`which gcc`
  ../cmake-3.16.3-Linux-x86_64/bin/cmake -H. -Bbuild -DCMAKE_INSTALL_PREFIX=${INSTALL_PATH} -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_FLAGS="-std=c++17" -DBUILD_SHARED_LIBS=ON -DCPP_GITHUB_TOKEN=$CPP_GITHUB_TOKEN
  cd build
  make
  make install
}
# Wraps installing ninja
#
# Usage:
#   get_ninja
#
get_ninja() {
  ${APT_COMMAND} update
  ${APT_GET_COMMAND} install ninja-build
}
# Wraps installing numpy
#
# Usage:
#   get_numpy
get_numpy() {
  ${PIP_COMMAND} install numpy
}
# Wraps installing OpenBLAS
#
# Usage:
#   get_openblas
get_openblas() {
  ${APT_COMMAND} update
  ${APT_GET_COMMAND} install libopenblas-base libopenblas-dev
}
# Wraps installing OpenMPI
#
# Usage:
#   get_openmpi
get_openmpi() {
  ${APT_COMMAND} update
  ${APT_GET_COMMAND} install openmpi-bin libopenmpi-dev
}
# Wraps installing PySCF
#
# Usage:
#  get_pyscf
get_pyscf() {
  ${PIP_COMMAND} install git+https://github.com/pyscf/pyscf
}
# Wraps installing ScaLAPACK
#
# Usage:
#   get_scalapack
#
# TODO: We probably need to take the MPI distro into account
get_scalapack() {
  ${APT_COMMAND} update
  ${APT_GET_COMMAND} install libscalapack-openmpi-dev
}
# Wraps installing Sphinx and the ReadTheDocs Theme
#
# Usage:
#   get_sphinx
get_sphinx() {
  ${APT_COMMAND} update
  ${APT_GET_COMMAND} install -f python3-venv
  python3 -m venv venv
  . venv/bin/activate
  ${PIP_COMMAND} install sphinx sphinx_rtd_theme
}
# Wraps installing the Togglebutton Sphinx Extension
#
# Usage:
#   get_togglebutton
get_togglebutton() {
  ${PIP_COMMAND} install sphinx-togglebutton
}



################################################################################
#                               Main Script                                    #
################################################################################
set -e # Exit with error if any command fails
#str="${{inputs.dependencies}}"
#declare -a array=($str)
#for depend in "$@"; do
#for depend in "${array[@]}"; do
for depend in "$@"; do
  echo "Getting dependency: ${depend}"
  # Please use camel_case for dependency names and keep the if-statements in
  # alphabetical order.
  if [ "${depend}" = "boost" ];then
    get_boost
  elif [ "${depend}" = "cblas" ]; then
    get_cblas
  elif [ "${depend}" = "clang" ]; then
    get_clang "${clang_version}"
  elif [ "${depend}" = "clang_format" ]; then
    get_clang_format
  elif [ "${depend}" = "cmake" ]; then
    get_cmake "${cmake_version}"
  elif [ "${depend}" = "cppyy" ]; then
    get_cppyy
  elif [ "${depend}" = "doxygen" ]; then
    get_doxygen
  elif [ "${depend}" = "eigen3" ]; then
    get_eigen3
  elif [ "${depend}" = "gcc" ]; then
    get_gcc "${gcc_version}"
  elif [ "${depend}" = "gcovr" ]; then
    get_gcovr
  elif [ "${depend}" = "graphviz" ]; then
    get_graphviz
  elif [ "${depend}" = "lapacke" ]; then
    get_lapacke
  elif [ "${depend}" = "libint" ]; then
    get_libint
  elif [ "${depend}" = "ninja" ]; then
    get_ninja
  elif [ "${depend}" = "numpy" ]; then
    get_numpy
  elif [ "${depend}" = "openblas" ]; then
    get_openblas
  elif [ "${depend}" = "openmpi" ]; then
    get_openmpi
  elif [ "${depend}" = "pyscf" ]; then
    get_pyscf
  elif [ "${depend}" = "scalapack" ]; then
    get_scalapack
  elif [ "${depend}" = "sphinx" ]; then
    get_sphinx
  elif [ "${depend}" = "togglebutton" ]; then
    get_togglebutton
  else
    echo "Unrecognized dependency: ${depend}"
    exit 99
  fi
done
