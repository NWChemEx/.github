.. _development_preliminaries:

*************
Preliminaries
*************

NWChemEx modules are written in C++ and a large part of the setup for developing
for NWChemEx pertains to setting up a good C++ development environment.

Dependencies
------------

The NWChemEx build system can build a lot of dependencies for you; however, it
can't build everything. You'll need to get:

- C++ compiler
- CMake
- MPI
- BLAS/LAPACK
- Boost

on your own. Check your operating system's package manager as they're all super
common things.

Directory Structure
-------------------

Once you have your dependencies you'll need to get the NWChemEx source code. The
source code for NWChemEx is spread out over a series of repos. It is strongly
recommended that you create a folder named something like ``nwx_workspace`` and
check out each repo you intend to develop for into this directory. We'll term
this directory your NWChemEx workspace.

As a bare minimum you'll want the ``NWChemEx-Project/NWChemEx`` repo in your
NWChemEx workspace. More than likely you will need to clone at least one
additional repository, namely the repo where your module/code will live. For
example if you are writing a module that will live in the SCF repo, you'll
also need to clone the ``NWChemEx-Project/SCF``. For this example your NWChemEx
workspace will look like:

.. code-block::

   nwx_workspace/
   |
   |-- NWChemEx/
   |
   |-- SCF/
   |
   `--toolchain.cmake

where the ``toolchain.cmake`` file will be described below. It should be noted
that to do development in the SCF repo this a complete NWChemEx workspace, you
don't need to clone any other repo.

Toolchain File
--------------

The last piece of the preliminary set-up is the toolchain file. By convention
this is a file named ``toolchain.cmake``. Its contents are a series of CMake
``set`` commands like:

.. code-block:: cmake

   set(CMAKE_CXX_COMPILER /path/to/your/C++/compiler)
   set(BUILD_TESTING TRUE) # Always a good idea to enable tests when developing
   set(CPP_GITHUB_TOKEN my_super_secret_token) # Needed to get private repos
   set(CMAKE_BUILD_POSITION_INDEPENDENT_CODE TRUE) # Adds -fPIC to static libs

For development purposes we also want to tell the build system to use our local
copies of repos we're developing in. This is done with CMake's
``FETCHCONTENT_SOURCE_DIR_XXX`` variables. For example if we're developing code
for the SCF repo we need to also add:

.. code-block:: cmake

   set(FETCHCONENT_SOURCE_DIR_SCF /path/to/nwx_workspace/SCF)

to our toolchain. If you are writing code for multiple repos you simply set
multiple ``FETCHCONTENT_SOURCE_DIR_XXX`` values, one for each repo.

.. note::

   Having a line like ``FETCHCONENT_SOURCE_DIR_SCF`` in a toolchain file is fine
   when building repos which live upstream from SCF (such as SDE and LibChemist)
   and even for SCF itself. Thus it's possible to use one toolchain file for the
   entire workspace.
