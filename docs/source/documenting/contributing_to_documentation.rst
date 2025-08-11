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

.. _contributing_to_documentation:

**************************************
Contributing to NWChemEx Documentation
**************************************

In this section we explain the basic orgnization of the NWChemEx documentation
system and present instructions on how to contribute to the documentation.

Structure of NWChemEx Documentation
===================================

In the repo of every NWChemEx package, there is a ``docs`` directory. Under
this diretory there is a ``source`` subdirectory which contains all .rst
source files of the documentation (recursive subdirectory structures may
exist). The files ``Makefile`` and ``requirements.txt`` are for generating
formatted files of the documentation, and will be explained below. The
``README.md`` file briefly decscribes the documentation and how to generate
the documentation files.

How to Contribute to NWChemEx Documentation
===========================================
Suppose one plans to update the documentation of the package PluginPlay.
First, one should create a local working copy of the PluginPlay repo using
``git clone``, then edit the existing .rst files or create new .rst files
under the ``doc`` directory.
Remember, when new .rst files are added, one needs to add the names of the
new files into the toctree list in the ``index.rst`` file under the same
directory.
When all editing work is done one needs to generate a local copy of the
documentation (see below), usually in html format, and check the .html files
in a browser to make sure everything is displayed properly. Finally one can
open a pull request to the PluginPlay repo and merge the updated documentation
to master.

Note: the developer documentation of NWChemEx resides in the .github repo.


How to Generate a Local Copy of the Documentation
=================================================

NWChemEx uses `Sphinx - a Python documentation generator
<https://www.sphinx-doc.org/en/master/index.html>`_ to transform the
source files (.rst, .md. etc) into documentation files in various formats
(.html, .pdf, etc). One can see the content of the file ``requirements.txt``
with the linux command ``vi``:

.. code-block:: console

   docutils<=0.19
   sphinx
   sphinx_rtd_theme

This list contains the required Python packages to install. We recommend to
install these packags into a Python virtual environment, in order to avoid
possible conflicts in the base environment. One can run the linux commands

.. code-block:: console

   python3 -m venv venv
   . venv/bin/activate
   pip3 install -r requirements.txt

to create a virtual environment ``venv``, activate it, and then install the
required packages into it.
Note: during the installation of the packages, one may see an error message
like "*ERROR: sphinx-rtd-theme 1.2.0 has requirement docutils<0.19, but you'll
have docutils 0.19 which is incompatible.*". This is a known issue, but not
affecting documentation generation.

After all packages are successfully installed, one can run

.. code-block:: console

   make html

under the directory of ``docs`` to generate the documentation in .html format.
One can also choose other formats, for example, .pdf, for the generated
documentation files by running

.. code-block:: console

   make latexpdf

In this case the installation of additional packages such as ``latexmk`` might
be necessary.
After successfully running these ``make`` commands, a directory of ``build``
would be created under ``docs``. So one can go to the subdirectories ``html``
or ``latex`` to check whether generated .html or .pdf files are correct or not.
