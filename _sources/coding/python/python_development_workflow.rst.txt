.. _development_python_development_workflow:

###########################
Python Development Workflow
###########################

This page is intended to get you up and running so that you can develop for
NWX from Python. These instructions walk you through getting to a point
where you can do ``import nwchemex`` in Python.

.. todo::

   At some point it will probably make sense to combine at least some of these
   instructions with the build instructions in the NWChemEx repo.

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
generating the Python bindings for NWChemEx. It is worth noting that you may
want to respectively set the environment variables ``CC`` and ``CXX`` to
the full paths of your C and C++ compilers before running ``pip install cppyy``
to help ensure that Cppyy is built with the correct compiler.

.. note::

   There is a known
   `issue <https://github.com/NWChemEx-Project/.github/issues/29>`__ with
   Cppyy, NWChemEx, and GCC 9. It is thus strongly recommended you use GCC 11
   (or newer).

Unfortunately, by default the Python detection in NWChemEx will not find
the virtual environment Python interpreter by default. To get around this
you can add:

.. code-block:: cmake

   set(Python3_EXECUTABLE <path_to_your_virtual_environment>/bin/python3)

to your toolchain (obviously substituting the actual path). This is a known
`issue <https://github.com/NWChemEx-Project/.github/issues/27>`__.

**********************
Step 2: Build NWChemEx
**********************

Instructions for building NWChemEx can be found
`here <https://nwchemex-project.github.io/NWChemEx/installation/building.html>`__.

For the sake of this tutorial we'll assume that ``${BUILD_DIR}`` is the build
directory where NWChemEx was built.

*******************
Step 3: Python Path
*******************

After Step 2, the NWChemEx Python modules will reside at
``${BUILD_DIR}/Python`` so assuming you have a Python script ``test.py`` which
contains:

.. code-block:: python

    import nwchemex as nwx

    # Do stuff with nwx

You'll have to run ``test.py`` like:

.. code-block:: bash

   PYTHONPATH=${BUILD_DIR}/Python python3 test.py

(or similarly correctly set up the Python path).


At this point you should now have access to all of NWChemEx from Python.
