******************
How NWX's CI Works
******************

The purpose of this page is to document various aspects of NWX's CI.

NWX has a lot of repositories. And more repositories will be added into NWX. To make the CIs of NWX generic and re-useable we used reuseable workflows with composite actions for designing our CI architecture. The goal of this design was to keep the number of codes as minimal as possible in the individual repositories and also ensuring maximum re-use of CI components across multiple repositories.

The Architecture
================

.. image:: architecture.png
  :width: 800
  :alt: The Architecture

Our CI architecture works in four layers:

1. LAYER OF CALLER WORKFLOWS (TOPMOST LAYER)
--------------------------------------------

**Workflows of individual repositories:** Each repository under our CI architecture has at least one of the following workflows: 

a. ``c-cpp.yaml``
b. ``deploy_docs.yaml``
c. ``format.yaml``
d. ``build_docs.yaml``

In the architecture image these workflows are pictured as ``Task{{1,2,3,4}}.yml``. 

Each of those workflows calls their correspondent template workflows that resides in ``.github`` repository with some input parameters. Those are as follows: 

a. ``c-cpp.yaml`` calls ``c-cpp_tmpl.yml`` template workflow with inputs ``dependencies`` and ``CPP_GITHUB_TOKEN``
b. ``deploy_docs.yaml`` calls ``deploy_docs_tmpl.yml`` template workflow with inputs ``target``, ``dependencies`` and ``skip_doxygen``
c. ``format.yaml`` calls ``format_tmpl.yml`` template workflow with input ``source``
d. ``test_docs.yaml`` calls ``test_docs_tmpl.yml`` template workflow with input ``target``, ``dependencies`` and ``skip_doxygen``.


2. LAYER OF CALLEE (REUSABLE) WORKFLOWS
---------------------------------------

**Template reusable workflows of .github repository:** We have four template workflows and they reside in the .github repository. So, these are the organization-wide generic template workflows that are used by all other repositories for their workflows. They are:

a. ``c-cpp_tmpl.yml``
b. ``deploy_docs_tmpl.yml``
c. ``format_tmpl.yml``
d. ``test_docs_tmpl.yml``

The template workflows are pictured as ``Task{{1,2,3,4}}_tmpl.yml`` in the architecture image.

These template workflows receive the input parameters from the topmost layer workflow files from which they have been called. These template workflows use some common custom actions developed by us with the inputs received from caller workflows. For example:

a. ``c-cpp_tmpl.yml`` uses the custom actions ``get_dependencies`` with input param ``dependencies`` and ``build_and_test`` with input param ``CPP_GITHUB_TOKEN``. 
b. ``deploy_docs_tmpl.yml`` uses the custom actions ``get_dependencies`` with input param ``dependencies`` and ``build_docs`` with input params ``target`` and ``skip_doxygen``.
c. ``test_docs_tmpl.yml`` uses the custom actions ``get_dependencies`` with input param ``dependencies`` and ``build_docs`` with input params ``target`` and ``skip_doxygen``.

3. LAYER OF COMPOSITE ACTIONS
-----------------------------

**Custom actions of .github repository:** The third layer consists of the actions that are used by the template workflows (previous layer) in the ``.github`` repository. The custom actions are also developed in a generic manner so that they can be used across all the repositories in the NWX organization and also note that they are composite actions. The custom composite actions are located at the ``.github/actions`` directory. There are currently 3 composite actions:

a. ``build_and_test``
b. ``build_docs``
c. ``get_dependencies``

These composite actions are illustrated as ``Action{{1,2,3}}.yml`` in the architecture image.

All these composite actions usually run some bash scripts with some input params that are passed to it from the template workflows. For example:

a. ``build_and_test`` action runs the ``build_and_test.sh`` bash scripts with input params ``CPP_GITHUB_TOKEN``
b. ``build_docs`` action runs the ``build_docs.sh`` bash script with input params ``target`` if ``doxygen`` dependency is required otherwise it runs the ``build_sphinx_docs.sh`` bash script without any parameter.
c. ``get_dependencies`` action runs the ``get_dependencies.sh`` bash script with input params ``dependencies``.


4. LAYER OF BASH SCRIPTS (BOTTOM LAYER)
---------------------------------------

**Bash scripts of .github repository:** The bottom layer consists of the bash scripts that are used by the composite actions in the previous layer. The bash scripts are also developed in a generic manner so that they can be re-used across multiple repository under the NWX organization. These bash scripts contain the bash commands necessary for building, testing and deploying the application and the corresponding documentation. The bash scripts reside in the individual action folders of the ``.github`` repository.

The bash scripts are shown as ``Action{1,2,3}_bash_{1,2}.sh`` in the architecture figure.


CI coverage
===========

Most of the repositories have the following coverage for CIs. 

Installing Dependencies
-----------------------

All logic for installing dependencies of a repository is maintained in the
``.github/actions/get_dependencies/get_dependencies.sh`` script. This script takes a list of
dependencies to install and installs them. The GitHub workflows should get their
dependencies by calling this script. This script is encapsulated by the composite action ``get_dependencies`` which resides in the ``.github/actions/get_dependencies/action.yml`` directory of ``.github`` repo. Any workflow can call this composite action as a step like the following with a list of dependencies to install those dependencies.

.. code-block:: yml

   - name: Get dependencies
           env:
             cmake_version: give_appropriate_cmake_version
             gcc_version: give_appropriate_gcc_version
           uses: NWChemEx-Project/.github/actions/get_dependencies@master
           with:
             dependencies: 'gcc gcovr cmake openblas cblas lapacke scalapack boost eigen3 openmpi cppyy numpy libint'

An example of how to use this action in a workflow file can be found in the ``.github/.github/workflows/c-cpp_tmpl.yml`` workflow file. 

Building the Repo
-----------------

Logic encapsulating the configure, build, and test phases is maintained in the
``.github/actions/build_and_test/build_and_test.sh`` script. This script will generate a CMake
toolchain file, use that file to configure the build, actually build the repo,
run the unit tests (through ctest), and finally process the coverage results. This script is encapsulated by the composite action ``build_and_test`` which resides in the ``.github/actions/build_and_test/action.yml`` directory of ``.github`` repo. Any workflow can call this composite action as a step like the following to build and test the repository.

.. code-block:: yml2

   - name: Build and test
           env:
             cmake_version: give_appropriate_cmake_version
             gcc_version: give_appropriate_cmake_version
           uses: NWChemEx-Project/.github/actions/build_and_test@master
           with: 
             CPP_GITHUB_TOKEN: provide_CPP_GITHUB_TOKEN_here

An example of how to use this action in workflow file can be found in the ``.github/.github/workflows/c-cpp_tmpl.yml`` workflow file. 

Each repo has ``c-cpp.yaml`` workflow for building and testing the repo.

Testing and Deploying Documentation
-----------------------------------

Most of the NWChemEx repos use a two-pronged approach to documentation where the
C++ documentation is built using Doxygen with ``.github/actions/build_docs/build_docs.sh`` script and the non-API documentation is built using Sphinx with the ``.github/actions/build_docs/build_sphinx_docs.sh`` script. The build_docs action encapsulates this process which resides in ``.github/actions/build_and_test/action.yml``. Any workflow can call this composite action as a step like the following to install dependencies and build the documentation of a repository.

.. code-block:: yml3

   - name: Build documentation
           uses: NWChemEx-Project/.github/actions/build_docs@master
           with:
             target: reponame_cxx_api (ex. nwchemex_cxx_api)
             skip_doxygen: true_if_skip_doxygen_install_else_false

An example of how to use this action in workflow file can be found in the ``.github/.github/workflows/test_docs_tmpl.yml`` and ``.github/.github/workflows/deploy_docs_tmpl.yml`` workflow file. 


Each repo is responsible for maintaining two workflow files. They are ``test_docs.yaml`` and ``deploy_docs.yaml``. ``test_docs.yaml`` installs the dependencies and builds the documentation whereas ``deploy_docs.yaml`` install dependencies, builds the documentation and also deploys the documentation to github pages.


Linting
-------

Linting of the C++ source code is done with ``clang-format`` (specifically version
9). The ``.github/.github/workflows/format_tmpl.yml`` workflow file is responsible for installing ``clang-format``. 

Adding a New Repo
=================

If a CI coverage for a new repo is required then we can do the following easy steps:

1. To install dependencies, build and test repo first copy the ``c-cpp.yaml`` file from ``NWChemEx-Project/NWChemEx/.github/workflows/c-cpp.yaml``. Now we only need to change the ``dependencies`` parameter and only give the names of the dependencies that are required by the new repo. Everything else remains the same. 

This ``c-cpp.yaml`` file will call the ``c-cpp_tmpl.yml`` file of the centralized ``.github`` repo and take care of the rest of the things for you!!!

2. To install dependencies and build documentation first copy the ``test_docs.yaml`` file from ``NWChemEx-Project/NWChemEx/.github/workflows/test_docs.yaml``. It has the following parameters the values should be as follows:

.. code-block:: yml

   target: reponame_cxx_api (for example: nwchemex_cxx_api)
   dependencies: cmake doxygen sphinx

However if you do not need doxygen then it should be as follows:

.. code-block:: yml

   dependencies: sphinx
   skip_doxygen: true

Notice target is not requried.

This ``test_docs.yaml`` file will call the ``test_docs_tmpl.yml`` file of the centralized ``.github`` repo and take care of the rest of the things for you!!!

3. To install dependencies, build documentation and also to deploy the documentation to github pages first copy the ``deploy_docs.yaml`` file from ``NWChemEx-Project/NWChemEx/.github/workflows/deploy_docs.yaml``. It has the following parameters and the values should be as follows:

.. code-block:: yml

   target: reponame_cxx_api (for example: nwchemex_cxx_api)
   dependencies: cmake doxygen sphinx

However if you do not need doxygen then it should be as follows:

.. code-block:: yml

   dependencies: sphinx
   skip_doxygen: true

Notice ``target`` is not requried.

This ``test_docs.yaml`` file will call the ``deploy_docs_tmpl.yml`` file of the centralized ``.github`` repo and take care of the rest of the things for you!!!

4. To install ``clang-format`` first copy the ``format.yaml`` file from ``NWChemEx-Project/NWChemEx/.github/workflows/format.yaml``. It has the following parameters and the values should be as follows:

.. code-block:: yml

   source: 'include src tests'. 

So, you do not need to change anything else.

This ``format.yaml`` file will call the ``format_tmpl.yml`` file of the centralized ``.github`` repo and take care of the rest of the things for you!!!
