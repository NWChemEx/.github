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