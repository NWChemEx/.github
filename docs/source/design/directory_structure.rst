####################
Repository Structure
####################

To facilitate development and maintenance we suggest that all repositories in
the NWChemEx Ecosystem adopt a common structure.

**************
Considerations
**************

- Most repositories will be C++ projects with Python bindings.
   - Python bindings will be the preferred way for users to leverage the
     functionality provided by the code.
   - Linking to the C++ library from other C++ projects should also be possible.  
- Repositories may include additional Python source code.
- Some repositories may be pure Python projects.


*****************
Existing Examples
*****************

- `Demo repo for a C++/Python project <https://github.com/smrfeld/cmake_cpp_pybind11_tutorial>`__
   - Advocates for a ``cpp/`` directory for C++ code and a ``python/`` directory
     for Python code.
   - C++ tests are in ``cpp/tests/`` and similar for Python tests.

*****************************
NWChemEx Repository Structure
*****************************

Every repository owned by the NWChemEx organization must follow the same
structure, which is as follows:

.. code-block:: text

   <repo-root>/
   ├── cmake/                  # CMake helper modules
   ├── docs/                   # Documentation
   ├── examples/               # Example codes and scripts
   ├── cpp/                    # Root for the C++ library
   |   ├── include/            # Public C++ headers
   |   └── src/                # C++ source files
   ├── python/                 # Root for Python source code
   |   └── <repo-name>/        # Root for Python package  
   |       └── __init__.py     # Python package initializer
   ├── tests/                  # Unit and integration tests
   ├── CMakeLists.txt          # CMake build script
   ├── README.md               # Project overview
   ├── LICENSE                 # License information
   └── pyproject.toml          # Python project configuration

Here:

- ``<repo-name>`` should be a snake_case "C"-style name, i.e., no spaces, no
  special characters, all lowercase letters, and underscores used to join
  words.

   - Motivation: Easier on the user (e.g., no needing to escape spaces) and 
     consistent regardless of whether the file system is case sensitive or 
     not.

*******************
Alternative Layouts
*******************

In coming up with the above we considered some alternative layouts. This section
explains why we rejected those alternatives.

The "Flat" Python Layout
------------------------

A common Python layout is to do something like:

.. code-block:: text

   <repo-root>/
   └── <repo-name>/            # Root for Python package  
   |   └── __init__.py         # Python package initializer
   ├── docs/                   # Documentation
   ├── tests/                  # Unit and integration tests
   └── ...

This is called a "flat" layout because there is no separation between source
code and other files (e.g., documentation, tests, build scripts, *etc.*). The
alternative is:

.. code-block:: text

   <repo-root>/
   ├── src/                 # Root for Python source code
   |   └── <repo-name>/        # Root for Python package  
   |       └── __init__.py     # Python package initializer
   ├── docs/                   # Documentation
   ├── tests/                  # Unit and integration tests
   └── ...

`Src vs Flat <https://medium.com/@adityaghadge99/python-project-structure-why-the-src-layout-beats-flat-folders-and-how-to-use-my-free-template-808844d16f35>`__
provides a good discussion of the pros and cons of each layout. The main reason
to avoid flat is that it can lead to import issues.

**********************************************
Repositories Outside the NWChemEx Organization
**********************************************

We strongly suggest following the same structure as the repositories in the
organization.