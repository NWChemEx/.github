************************
Documentation Deployment
************************

Overview
========

NWX uses a two-pronged approach to documentation: Doxygen and Sphinx. Doxygen is
the *de facto* standard for writing and generating C++ API documentation. Sphinx
is the *de facto* standard for generating Python documentation. Unfortunately,
Sphinx and Doxygen do not play so well together (there a number of efforts out
there to bridge the gap, but most seem to leave plenty to be desired).

How NWX's Documentation Actually Works
======================================

C++
---

As developers write C++ they are expected to document the APIs of classes and
functions. The C++ API documentation should be written using Doxygen's native
markdown (markup?) language. The Doxygen documentation is built using CMake's
Doxygen module. Using CMake's Doxygen module is fairly cookie-cutter so NWChemEx
provides the ``nwx_cxx_api_docs.cmake`` CMake module to avoid code duplication.
The master version of ``nwx_cxx_api_docs.cmake`` lives in the 
``MWChemEx/NWXCMake`` repo and is downloaded along with the other scripts in
that repo by the CMake module ``get_nwx_cmake.cmake`` found in most repositories
in this organization. Downstream repos need only include the following two lines
in their top-level ``CMakeLists.txt`` file:

.. code-block:: cmake

   include(nwx_cxx_api_docs)
   nwx_cxx_api_docs(/path/to/cxx/source_dir1 /path/to/cxx/source_dir2 ...)

(obviously use the actual paths to your C++ source directories). It's best that
this is included near the top of the ``CMakeLists.txt`` file as the module
includes a mechanism for avoiding much of the CMake configuration in the event
that we are only trying to build the documentation (a common CI scenario). Once
the C++ API documentation is generated it will reside in the build directory.

Sphinx
------

Tutorials, detailed background, and other narrative-based documentation is
written most easily in Sphinx's flavor of reStructuredText. This also has the
benefit of resulting in far prettier documentation than Doxygen's equivalent.
This documentation should be kept with the repository it pertains to (if it
applies project-wide it should live in the DeveloperTools repo) in the repo's
``docs`` directory. This directory should have a typical Sphinx setup::

   docs/
   ├-source/
   | ├-section1/
   | | └-index.rst
   | ├-section2/
   | | └-index.rst
   | ├-conf.py
   | └-index.rst
   └-Makefile

If the repository has C++ API documentation it will be generated at
``docs/build/html/x_cxx_api/index.html`` where ``x`` is the project name
provided in ``CMakeLists.txt``, in lowercase. It can be linked to in your main
``index.rst`` file like:

.. code-block:: rest

   `C++ API <x_cxx_api/index.html>`_

(substituting in the project name for the first ``x``. When Sphinx is run the
index of the resulting documentation will be located at
``docs/build/html/index.html``.
