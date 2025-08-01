*******************************************
How NWX's Continuous Integration (CI) Works
*******************************************

The purpose of this page is to document various aspects of NWX's CI.

NWX has a lot of repositories. And more repositories will be added into NWX. To 
make the CI of NWX generic and re-useable, we've used `reuseable workflows 
<https://docs.github.com/en/actions/using-workflows/reusing-workflows>`__ and 
`composite actions 
<https://docs.github.com/en/actions/creating-actions/creating-a-composite-action>`__ 
for designing our CI architecture. The goal of this design was to ensure 
maximum re-use of CI components across multiple repositories.

Here are a few useful tutorials on workflows in GitHub:

- `Quickstart for GitHub Actions <https://docs.github.com/en/actions/quickstart>`__
- `GitHub Actions Tutorial, From Zero to Hero in 90 minutes 
  <https://www.youtube.com/watch?v=TLB5MY9BBa4>`__

Currently the following repositories in ``NWChemEx`` follow the methods
outlined here:

#. ``.github`` (This is our configuration repository) 
#. ``ChemCache``
#. ``Chemist`` 
#. ``Integrals``
#. ``Mokup`` 
#. ``NWChemEx`` 
#. ``ParallelZone``
#. ``PluginPlay``
#. ``SimDE``
#. ``SCF``
#. ``TensorWrapper``
#. ``Utilities``

Common and Repo-Specific Workflows
==================================

The ``.github/workflow`` directory in the ``NWChemEx/.github`` repo
houses both the set of workflows specific to the ``.github`` repo and the set 
of reusable workflows that should be used throughout the NWX stack. Generally,
these reusable workflows should be named in a way that describes what kind of
effect they should achieve, e.g. ``tag.yaml`` or ``check_formatting.yaml``.
These common workflows represent the reoccurring GitHub Actions operations 
required by the NWX repos, e.g tagging a newly merged commit or checking 
formatting. The common workflows currently available include:

* ``check_formatting.yaml`` - performs common formatting and licensing checks
* ``deploy_nwx_docs.yaml`` - deploys the docs for an NWX library to GitHub pages
* ``tag.yaml`` - updates the version tag for a commit, used after merging into ``master``
* ``test_nwx_docs.yaml`` - ensures the documentation of an NWX library builds properly
* ``test_nwx_library.yaml`` - ensures an NWX library builds and passes its tests

Aside from the common workflows, there are the repo-specific workflows with the
naming convention ``{trigger event}.yaml``. Where needed, a version of these
workflows can be added in each repo. Here's an example of a repo-specific
``pull_request.yaml``:

.. code-block:: yaml

    name: Pull Request Workflow

    on:
      pull_request:
        branches:
          - master

    jobs:
      check_formatting:
        uses: NWChemEx/.github/.github/workflows/check_formatting.yaml@master
        with:
          license_config: ".github/.licenserc.yaml"

      test_nwx_docs:
        uses: NWChemEx/.github/.github/workflows/test_nwx_docs.yaml@master
        with:
          doc_target: "tensorwrapper_cxx_api"

      test_library:
        uses: NWChemEx/.github/.github/workflows/test_nwx_library.yaml@master
        with:
          compilers: '["gcc-11", "clang-14"]'

      unique_job:
        # Other steps unique to the individual repos can be added as Jobs

And here is an example of the repo-specific ``merge.yaml``:

.. code-block:: yaml

    name: Merge Workflow

    on:
      push:
        branches:
          - master

    jobs:
      tag-commit:
        uses: NWChemEx/.github/.github/workflows/tag.yaml@master
        secrets: inherit

      deploy_nwx_docs:
        uses: NWChemEx/.github/.github/workflows/deploy_nwx_docs.yaml@master
        with:
          doc_target: "XYZ_cxx_api"
        secrets: inherit

      unique_job:
        # Other steps unique to the individual repos can be added as Jobs

Generally, these workflows are expected to call to the necessary reusable
workflows to handle the reoccurring tasks and then locally implement any unique
automations.

NWX Build Environment Image
===========================

To avoid rebuilding costly dependencies for the various repos in the NWX stack,
the building and testing steps in the common workflows run in containers built
on the image ``ghcr.io/nwchemex/nwx_buildenv:latest``. This image 
defines an Ubuntu based environment where the various dependencies of the stack
(such as compilers, math libraries, MPI, and other C++ libraries outside) have
been pre-installed. The files used to build this image are found in
``NWChemEx/.github/nwx_build_environment``, along side the 
``buildenv.sh`` script which builds the image through consecutive Docker calls.
