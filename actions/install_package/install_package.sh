#!/bin/sh

# Wraps the process for installing one package into a docker image
# Keep adding more package version options to cover all repos.
#
# Usage:
#   install_package.sh
#
# Other variables:
#   gcc_version: the major version of gcc being used
#

set -e # Exit with error if any command fails

docker build -t base-${package_name}:latest -f ${path_to_dockerfile} . --build-arg GCC_VERSION=${gcc_version} --build-arg CLANG_VERSION=${clang_version} --build-arg CMAKE_VERSION=${cmake_version} --build-arg UBUNTU_VERSION=${ubuntu_version} --build-arg MADNESS_VERSION=${madness_version} --build-arg CATCH2_VERSION=${catch2_version} --build-arg SPDLOG_VERSION=${spdlog_version} --build-arg CEREAL_VERSION=${cereal_version} --build-arg LIBFORT_VERSION=${libfort_version} --build-arg LIBBOOST=${libboost_version} --build-arg PARENT_IMAGE_NAME=${parent_image_name} --build-arg TILEDARRAY_VERSION=${tiledarray_version} --build-arg OPENBLAS_VERSION=${openblas_version} --build-arg CBLAS_VERSION=${cblas_version} --build-arg LAPACKE_VERSION=${lapacke_version} --build-arg SCALAPACK_VERSION=${scalapack_version} --build-arg EIGEN3_VERSION=${eigen3_version} --build-arg OPENMPI_VERSION=${openmpi_version}
