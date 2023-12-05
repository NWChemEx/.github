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

1. ``ChemCache``
2. ``Chemist`` 
3. ``.github`` (This is our configuration repository) 
4. ``Integrals``
5. ``Mokup`` 
6. ``NWChemEx`` 
7. ``ParallelZone``
8. ``PluginPlay``
9. ``SimDE``
10. ``SCF``
11. ``TensorWrapper``
12. ``Utilities``

Common and Repo-Specific Workflows
==================================

The ``.github/workflow`` directory in the ``NWChemEx/.github`` repo
houses both the set of workflows specific to the ``.github`` repo and the set 
of reusable workflows that should be used throughout the NWX stack. Generally,
these reusable workflows should be named as ``common_{trigger event}.yaml``,
where ``{trigger event}`` can be ``pull_request``, ``merge``, or other `workflow
triggering events <https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows>`__.
These common workflows aggregrate the reoccurring jobs required by the NWX repos 
when a given event occurs, e.g applying formatting and testing changes to files 
in a pull request. The common workflows for pull requests and merging changes 
are discussed more specifically below.

Aside from the common workflows, there are the repo-specific workflows with the
naming convention ``{trigger event}.yaml``. Where needed, a version of these
workflows can be added in each repo. Here's an example of a repo-specific
``pull_request.yaml``:

.. code-block:: yaml

    on:
      pull_request:
        branches:
          - master
  
    jobs:
      Common-Pull-Request:
        uses: NWChemEx/.github/.github/workflows/common_pull_request.yaml@master
        with:
          config_file: ''
          source_dir: ''
          compilers: ''
          doc_target: 'Sphinx'
        secrets:
          CMAIZE_GITHUB_TOKEN: ${{ secrets.CMAIZE_GITHUB_TOKEN }}
      Unique-Job:
        # Other steps unique to the individual repos can be added as Jobs

Generally, these workflows are expected to call to the corresponding reusable
workflow to handle the reoccurring task and then locally implement any unique
automations.

CI coverage
===========

Common Pull Request Workflow
----------------------------

The common workflow for pull requests first handles the addition of any license
headers to files and runs clang formatting. NWChemEx uses `Apache License (2.0) 
<https://www.apache.org/licenses/LICENSE-2.0>`__. We want all our source code 
(except for some configuration, test and input files) to have the proper license
header when deployed. The licensing setting are configured by the 
``.licenserc.yaml`` file in each repo's ``.github`` directory. For details on
this files construction, see `here <https://github.com/apache/skywalking-eyes/tree/v0.4.0>`__

If there are changes resulting from these first steps, they will be pushed to
the branch and the workflow will end. The new commit resulting from this step
should then re-trigger the origin workflow, ensuring that the new changes are
included in the following steps. If changes were not made by the license and 
formatting step, the workflow continues on to attempt to build the current 
library and its documentation. If the library builds properly, it's test suite 
is also run.

Common Merge Workflow
---------------------

The common workflow for merging a successful pull request applies the correct
version tag to the resulting commit and deployes the repo's documentation to
GitHub Pages.

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
