.. Copyright 2025 NWChemEx-Project
..
.. Licensed under the Apache License, Version 2.0 (the "License");
.. you may not use this file except in compliance with the License.
.. You may obtain a copy of the License at
..
.. http://www.apache.org/licenses/LICENSE-2.0
..
.. Unless required by applicable law or agreed to in writing, software
.. distributed under the License is distributed on an "AS IS" BASIS,
.. WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
.. See the License for the specific language governing permissions and
.. limitations under the License.

.. _pre-commit-configuration:

######################################
pre-commmit Configuration for NWChemEx
######################################

`pre-commmit <https://pre-commit.com/>`__ is a tool for configuring and
automating `githooks <https://git-scm.com/docs/githooks>`__, which are a series
of hooks for inserting custom automations into git's operations. The pre-commit
tool takes its name from arguably the most commonly used githook, the pre-commit
hook, that runs when a user attempts to commit changes. The pre-commit tool
provides a simplified syntax for configuring githooks, and has a community of
defined hooks from which to draw. To simplify the process of formatting/linting,
we advise developers to use pre-commit as outlined in the following when working
within the NWX stack.

The NWX configuration for pre-commit (``.pre-commit-config.yaml``) lives in
`NWChemEx/pre-commit-config <https://github.com/NWChemEx/pre-commit-config>`__.
Normally, this YAML file would be expected to live in the root directory of the
repository where pre-commit would be used. NWX is made up of a number of
different libraries in different repositories, so we find it helpful to keep
the configuration file in a centralized location. This methodology does cause
some deviation from the default usage of pre-commit, but not excessively so.

The first step is to clone NWChemEx/pre-commit-config

.. code-block:: bash

    git clone https://github.com/NWChemEx/pre-commit-config.git

It is recommended to use a Python virtual environment when developing NWX
libraries (see :ref:`development_python_development_workflow` for more details).
In a new or existing Python virtual environment, install the required packages
for pre-commit:

.. code-block:: bash

    cd pre-commit-config
    # Make a virtual environment if one doesn't already exist
    python3 -m venv .venv
    # Activate the virtual environment and install the requirements
    . .venv/bin/activate
    pip install -r requirements.txt
    cd ../

When you clone a new repository, you will need to install the pre-commit hooks
for them to take effect. Assuming for the moment that you want to develop code
within the `PluginPlay <https://github.com/NWChemEx/PluginPlay>`__ library, you
would clone that repo and install the pre-commit hooks as follows:

.. code-block:: bash

    # Clone PluginPlay
    git clone https://github.com/NWChemEx/PluginPlay.git

    # Activate a Python virtual environment where pre-commit is installed
    . {path/to/}.venv/bin/activate

    # Navigate into the repository where you want to install the hooks
    cd PluginPlay

    # Finally, install the pre-commit hooks
    pre-commit install -c {path/to/}pre-commit-config/.pre-commit-config.yaml

At this point, the pre-commit hooks are installed and will run when a ``git
commit`` is attempted. If all hooks pass successfully, the commit should finish
successfully and you should see an output similar to the following:

.. code-block:: bash

    trim trailing whitespace.................................................Passed
    check for added large files..............................................Passed
    check python ast.....................................(no files to check)Skipped
    check json...........................................(no files to check)Skipped
    check for merge conflicts................................................Passed
    check xml............................................(no files to check)Skipped
    check yaml...........................................(no files to check)Skipped
    debug statements (python)............................(no files to check)Skipped
    fix end of files.........................................................Passed
    fix requirements.txt.................................(no files to check)Skipped
    mixed line ending........................................................Passed
    yapf.................................................(no files to check)Skipped
    clang-format.........................................(no files to check)Skipped
    license-eye..............................................................Passed

When one or more hooks fail, the commit will fail and the failing hooks will be
noted in the printout:

.. code-block:: bash

    trim trailing whitespace.................................................Failed
    - hook id: trailing-whitespace
    - exit code: 1
    - files were modified by this hook

    Fixing docs/source/conventions/pre_commit.rst

    check for added large files..............................................Passed
    check python ast.....................................(no files to check)Skipped
    check json...........................................(no files to check)Skipped
    check for merge conflicts................................................Passed
    check xml............................................(no files to check)Skipped
    check yaml...........................................(no files to check)Skipped
    debug statements (python)............................(no files to check)Skipped
    fix end of files.........................................................Failed
    - hook id: end-of-file-fixer
    - exit code: 1
    - files were modified by this hook

    Fixing docs/source/conventions/pre_commit.rst

    fix requirements.txt.................................(no files to check)Skipped
    mixed line ending........................................................Passed
    yapf.................................................(no files to check)Skipped
    clang-format.........................................(no files to check)Skipped
    license-eye..............................................................Passed

When most hooks fail, they will also make the requisite changes to the
corresponding files to allow them to pass. These new changes will need to be
staged for commit via ``git add .`` or equivalent, at which time the commit can
be attempted again.

It is also possible to manually run the pre-commit hooks:

.. code-block:: bash

    # With appropriate virtual environment active
    pre-commit run --all-files -c {path/to/}pre-commit-config/.pre-commit-config.yaml

Note, it is required to pass the
``-c {path/to/}pre-commit-config/.pre-commit-config.yaml`` flag each time this
command is run, even if the pre-commit hooks have already been installed. To
simplify this call, the developer may want to define an alias for this command
in their shell configuration. For the bash shell, this could be

.. code-block:: bash

    alias run_nwx_precommit="pre-commit run --all-files -c {path/to/}pre-commit-config/.pre-commit-config.yaml"

If at any point you want to remove the installed pre-commit hooks, you can run
``pre-commit uninstall`` within the repo where you want to remove the hooks.
