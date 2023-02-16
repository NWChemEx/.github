#!/bin/sh
################################################################################
#
# The master test.sh script lives at
#
# NWChemEx-Project/.github/actions/test/test.sh. The
# 
# test.sh script is used for testing all NWChemEx-Project repositories.
# 
# Thus making changes to the test.sh will effect all NWChemEx-Project
# 
# repositories.
# 
################################################################################

# Wraps the process for testing an NWX repo
#
# Usage:
#   test.sh


set -e # Exit with error if any command fails

ctest_command=ctest


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