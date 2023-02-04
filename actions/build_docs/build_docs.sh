#!/bin/sh

################################################################################
#
# The master build_docs.sh script lives at
# NWChemEx-Project/DeveloperTools/.gihub/workflows/scripts. The build_docs.sh
# script contained in all other NWChemEx-Project repositories is a synchronized
# copy of the master script. Thus to make changes to the build_docs.sh file
# please make them to the master script.
#
################################################################################

# This script encapsulates the process of building the documentation for an NWX
# repo.
#
# Usage:
#   build_docs.sh <doxygen_target_name>
#
# Arguments:
#   doxygen_target_name: The name of the CMake target which controls building
#                        the Doxygen documentation. The name of this
# Enviornment Variables:
#   cmake_version: The version of CMake used, in the format x.y.z
#
# Notes:
#   - This script assumes Sphinx is installed via PIP into a virtual environment
#     called "venv"

set -e # Exit with error if any command fails

arch="Linux-x86_64"
cmake_command=cmake-${cmake_version}-${arch}/bin/cmake
doc_target="$1"

# Step 1: Build the Doxygen documentation
${cmake_command} -H. -Bbuild -DBUILD_DOCS=ON -DONLY_BUILD_DOCS=ON
${cmake_command} --build build --target "${doc_target}"

# Step 2: Migrate the Doxygen documentation to the docs source
# mkdir docs/build
# mkdir docs/build/html


cd build
pwd

if [ -d "html" ]; then
  rm -r html
  mkdir html
else
  mkdir html
fi

cd ..

# cd docs
# pwd

# if [ -d "build" ]; then
#   rm -r build
#   mkdir build
# else
#   mkdir build
# fi

# ls

# cd build
# pwd

# if [ -d "html" ]; then
#   rm -r html
#   mkdir html
# else
#   mkdir html
# fi

# ls

# cd html
# pwd

# if [ -d "${doc_target}" ]; then
#   rm -r ${doc_target}
#   mkdir ${doc_target}
# else
#   mkdir ${doc_target}
# fi

# ls

# cd ../../../

# pwd

# ls

# cd build
# if [ ! -d "html" ]; then
#   mkdir html
# fi
# cd ..

mv build/html "docs/build/html/${doc_target}"

#Step 3: Build the Sphinx documentation
# . venv/bin/activate
# cd docs
# make html
