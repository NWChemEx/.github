******************
How NWX's CI Works
******************

The purpose of this page is to document various aspects of NWX's CI.

Overview
========

NWX has a lot of repositories. And more repositories will be added into NWX. To make the CIs of NWX generic and re-useable we used reuseable workflows with composite actions for designing our CI architecture. The goal of this design was to keep the number of codes as minimal as possible in the individual repositories and also ensuring maximum re-use of CI components across multiple repositories.

The Architecture
====================

Our CI architecture works in four layers:

1. Workflows of individual repositories (Topmost Layer): Each repository under our CI architecture has at least one of the following workflows:

a. c-cpp.yaml
b. deploy_docs.yaml
c. format.yaml
d. build_docs.yaml

Each of those workflows calls their correspondent template workflows that resides in .github repository with some input parameters. Those are as follows:

a. c-cpp.yaml calls c-cpp_tmpl.yml template workflow with inputs dependencies and CPP_GITHUB_TOKEN
b. deploy_docs.yaml calls deploy_docs_tmpl.yml template workflow with inputs target, dependencies and skip_doxygen
c. format.yaml calls format_tmpl.yml template workflow with input source
d. test_docs.yaml calls test_docs_tmpl.yml template workflow with input target, dependencies and skip_doxygen.

2. Template workflows of .github repository (Layer 2): We have four template workflows and they reside in the .github repository. So, these are the organization-wide generic template workflows that are used by all other repositories for their workflows. They are:

a. c-cpp_tmpl.yml
b. deploy_docs_tmpl.yml
c. format_tmpl.yml
d. test_docs_tmpl.yml

These template workflows receive the input parameters from the Layer 1 workflow files from which they have been called. These template workflows uses some common custom actions developed by us with the inputs received from caller workflows. For example:

a. c-cpp_tmpl.yml uses the custom actions get_dependencies with input param dependencies and build_and_test with input param CPP_GITHUB_TOKEN. 
b. deploy_docs_tmpl.yml uses the custom actions get_dependencies with input param dependencies and build_docs with input params target and skip_doxygen.
c. test_docs_tmpl.yml uses the custom actions get_dependencies with input param dependencies and build_docs with input params target and skip_doxygen.

3. Custom actions of .github repository (Layer 3): The third layer consists of the actions that are used by the template workflows in the .github repository. The custom actions are also developed in a generic manner so that they can be used across all the repositories in the NWX organization and also note that they are composite actions. The custom composite actions are located at the .github/actions directory. There are currently 3 composite actions:

a. build_and_test
b. build_docs
c. get_dependencies

All these composite actions usually run some bash scripts with some input params that are passed to it from the template workflows. For example:

a. build_and_test action runs the build_and_test.sh bash scripts with input params CPP_GITHUB_TOKEN 
b. build_docs action runs the build_docs.sh bash script with input params target
c. get_dependencies action runs the get_dependencies.sh bash script with input params dependencies.

4. Bash scripts (Bottom Layer): This layer consists of the bash scripts that are used by the custom composite actions. The bash scripts are also developed in a generic manner so that they can be re-used across multiple repository under the NWX organization. These bash scripts contain the bash commands necessary for building, testing and deploying the application and the corresponding documentation. The bash scripts resides in the individual action folders of the .github repository.


Writing Workflows
=================

The YAML workflows are written in terms of several Bash scripts. The scripts are
separated into several generic tasks.

Installing Dependencies
-----------------------

All logic for installing dependencies is maintained in the
`workflows/scripts/get_dependencies.sh` script. This script takes a list of
dependencies to install and installs them. The GitHub workflows should get their
dependencies by calling this script. This script will be invoked by many of the
YAML workflows.

Building the Repo
-----------------

Logic encapsulating the configure, build, and test phases is maintained in the
`workflows/scripts/build_and_test.sh` script. This script will generate a CMake
toolchain file, use that file to configure the build, actually build the repo,
run the unit tests (through ctest), and finally process the coverage results.

Testing and Deploying Documentation
-----------------------------------

Most of the NWChemEx repos use a two-pronged approach to documentation where the
C++ documentation is documented using Doxygen and the non-API documentation is
written using Sphinx. The `.github/workflows/scripts/build_docs.sh` script
encapsulates this process. Each repo is responsible for maintaining two YAML
files. The first YAML file should install the documentation dependencies
(`doxygen` and `sphinx`) and then call `build_docs.sh`. This should be done for
every PR in order to ensure the PR does not break the documentation. The second
YAML file also installs the dependencies and builds the documentation.
Additionally this YAML file deploys the documentation to GitHub Pages. The
second YAML

.. todo::

   Can we combine the two YAML files so that the last step (deployment) is
   only done when we're pushing to master?

Linting
-------

Linting of the C++ source code is done with clang-format (specifically version
9). The `.github/workflows/scripts/lint.sh` script actually executes the
linting. The workflow YAML file is responsible for installing clang-format, for
calling `lint.sh`, and for making a PR from the diff.

Adding a New Repo
=================

To add another repo to NWX's CI follow these steps.

1. Add the repo to `synch_files.yaml` so that it gets the synchronized files
2. Commit that change (once it's merged that should trigger the synchronization)
3. Add workflow files for the CI actions you are interested in
   - Easiest way is by copy/pasting from another NWX repo
4. Note that the repo must not enforce branch protection rules for admins
   otherwise the synch files plugin can't push the synched files.


