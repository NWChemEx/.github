#########################################
Design of the Python Binding Architecture
#########################################

The purpose of this page is to record the decisions which went into the design
of the Python bindings.

*************************
What are Python bindings?
*************************

Presently, by "Python bindings" we are specifically referring to the ability to
call C/C++ code from Python. This requires interoperability between Python and
C/C++, *i.e.*, Python objects, functions, data, etc. must be able to seamlessly
interact with C++ objects, functions, data, etc. and vice versa.

*******************************
Why do we need Python bindings?
*******************************

Following from the design discussion in
:ref:`why_is_the_nwchemex_api_written_in_python`, NWChemEx's high-level API is
assumed to be Python-based. We thus need to


****************
Existing Choices
****************

Writing bindings directly with Python's C API is a tedious task. For that
reason, a variety of software libraries/packages have been created with the
intent of aiding in generating Python bindings.

Boost Python
============

Boost Python was one of the first libraries aimed at simplifying the generation
of Python bindings for C++ code.

Cppyy
=====

Cppyy :cite:`cppyy16`

pybind11
========

- GitHub: `https://github.com/pybind/pybind11`__
- Docs: `https://pybind11.readthedocs.io/en/stable/`__

pybind11 :cite:`pybind11`
