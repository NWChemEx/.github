#!/bin/sh

# Wraps the process for testing an NWX repo
#
# Usage:
#   test.sh


set -e # Exit with error if any command fails

ctest_command=ctest

# set up the envs for running mpiexec in a container
# otherwise tests would fail
export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

#Step 4: Unit-test
cd build
if [[ "${int_test}" == "true" ]]; then
  echo "Running integration tests..."
  ${ctest_command} -VV -R test_integration*
else
  echo "Running unit tests..."
  ${ctest_command} -VV -R test_unit*
fi
cd ..

#Step 5: Generate coverage report
# curr_dir=$(pwd)
# cd ..
# gcovr --root "${curr_dir}" \
#       --filter "${curr_dir}" \
#       --exclude "${curr_dir}"/tests \
#       --xml "${curr_dir}"/coverage.xml
