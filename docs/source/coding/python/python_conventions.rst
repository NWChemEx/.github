.. _python-coding-conventions:

*************************
Python Coding Conventions
*************************

This page tentatively introduces the NWX team's coding conventions for writing
Python.

.. All pull requests are expected to adhere to these conventions. 

Code Formatting
===============

When possible, ``yapf`` (`PyPI link <https://pypi.org/project/yapf/>`__) will 
be used to enforce code conventions. In general, Python code should be 
`PEP 8 compliant <https://www.python.org/dev/peps/pep-0008/>`__.

Docstrings
==========

A general description of a docstring and standardized conventions are described
in `PEP 257 <https://www.python.org/dev/peps/pep-0257/>`__. Docstrings in
NWChemEx are written using the ``Sphinx`` format, described
`here <https://sphinx-rtd-tutorial.readthedocs.io/en/latest/docstrings.html>`__.

Docstrings should be used to sufficiently document Python modules, classes, 
and functions, similar to the expectation that C++ code be documented 
sufficiently through Doxygen documentation blocks.

.. note:: 
   
   For IDE tools to help with these conventions, see :ref:`nwx-ide-development`.
