.. _development_python_development_workflow:

###########################
Python Development Workflow
###########################

This page is intended to get you up and running so that you can develop for
NWX from Python.

*********************
Step 0: Preliminaries
*********************

The Python workflow builds off of the :ref:`development_preliminaries` setup.

********************
Step 1: Python Setup
********************

When doing Python development it's always a good idea to do so in a virtual
environment. Assuming you completed the preliminary step, run these commands
in the NWChemEx workspace directory you created:

.. code-block:: bash

   python3 -m venv <virtual_environment_name>
   source <virtual_environment_name>/bin/activate
   pip install cppyy

``<virtual_environment_name>`` should be replaced with whatever you want to call
the virtual environment. The last line installs Cppyy which is needed for
generating the Python bindings for NWChemEx.

Unfortunately, the Python detection in NWChemEx will not find the virtual
environment Python by default so you have to add:

.. code-block:: cmake

   set(Python3_EXECUTABLE <path_to_your_virtual_environment>/bin/python3)

to your toolchain (obviously substituting the actual path). This is a known
`issue <https://github.com/NWChemEx-Project/.github/issues/27>`__.

**********************
Step 2: Build NWChemEx
**********************

Instructions for building NWChemEx can be found xxx.

.. todo::

   add link

For the sake of this tutorial we'll assume that ``${BUILD_DIR}`` is the build
directory where NWChemEx was built.
