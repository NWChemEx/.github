#!/bin/sh


# This script encapsulates the process of building the Doxygen documentation
# for an NWX repo.
#
# Usage:
#   build_docs.sh <doxygen_target_name>
#
# Arguments:
#   doxygen_target_name: The name of the CMake target which controls building
#                        the Doxygen documentation. The name of this
#

set -e # Exit with error if any command fails

arch="Linux-x86_64"
cmake_command=cmake
doc_target="$1"

# Step 1: Build the Doxygen documentation
${cmake_command} -H. -Bbuild -DBUILD_DOCS=ON -DONLY_BUILD_DOCS=ON
${cmake_command} --build build --target "${doc_target}"


# Step 2: Migrate the Doxygen documentation to the docs source
mkdir docs/build
mkdir docs/build/html

mv build/html "docs/build/html/${doc_target}"

