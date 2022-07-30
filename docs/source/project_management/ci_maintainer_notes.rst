******************
How NWX's CI Works
******************

The purpose of this page is to document various aspects of NWX's CI.

Overview
========

NWX's CI uses GitHub actions. GitHub actions allows you to have one or more
workflows which get executed upon certain triggers. The workflows themselves are
YAML and are a bit hard to write in a generic manner. This leads to copy/pasting
these YAML files across repos and then making repo-specific changes to the copy
pasted file. This is hard to maintain and leads to several sources of truth. Our
solution is to write several generic Bash scripts which encapsulate how we do
various CI steps (e.g., get a dependency or build documentation). The YAML files
are then written by calling these scripts with the repo-specific options. We
rely on file synchronization to keep the Bash scripts consistent across repos
(the master versions live here in the DeveloperTools repo).

File Synchronization
====================

There are several files which need to appear in each NWX repo and whose content
needs to be synchronized. This includes:

- .github/workflows/scripts/build_docs.sh
- .github/workflows/scripts/get_dependencies.sh
- .github/workflows/scripts/lint.sh
- .clang-format
- .gitignore
- LICENSE

Rather than remembering to update these files in each repo anytime they change,
we rely on the
`Files Sync Action<https://github.com/marketplace/actions/files-sync-action>`_
to keep them synchronized. Synchronizing these files is done in the
SynchronizeFiles workflow (YAML file: ``.github/workflows/synch_files.yaml``).
This workflow is executed when a DeveloperTools PR is merged into master.

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


