#########################################
Design of the Python Binding Architecture
#########################################

The purpose of this page is to record the decisions which went into the design
of the Python bindings.

*************************
What are Python bindings?
*************************

Presently, by "Python bindings" we are specifically referring to an
interoperability layer between C/C++ code and Python. This layer allows Python
objects, functions, data, etc. to seamlessly interact with C++ objects,
functions, data, etc. and vice versa.

*******************************
Why do we need Python bindings?
*******************************

Following from the design discussion in
:ref:`why_is_the_nwchemex_api_written_in_python`, NWChemEx's high-level API is
assumed to be Python-based, but the guts of NWChemEx are written in C++. Hence,
to expose the C++ guts to Python we will need to write Python bindings.

*****************************
Python Binding Considerations
*****************************

In creating our Python bindings, and choosing the library to help us create the
bindings, we have considered the following:

.. _pb_diff_lang:

Different languages.
   Fundamentally Python and C++ are different coding languages. They rely on
   different assumptions, have different designs, are fundamentally
   implemented different, and embrace different coding paradigms. The point is
   there is no perfect one-to-one mapping between C++ and Python and the
   developer may need to step in to ensure the conversion happens in the manner
   best aligned with the specific interface.

.. _pb_features:

Full featured.
   We expect that C++ developers will use the full extent of the C++ language
   and that Python developers will too. We thus expect the binding solution
   to not stifle either developer's creativity.

.. _pb_native_apis:

Native APIs.
   C++ APIs should be defined purely using C++, and Python bindings should be
   defined purely with Python. Any conversions needed to go from one language to
   the other should happen under the hood.

.. _pb_minimally_invasive:

Minimally invasive.
   Ideally Python bindings should be created in the least invasive manner
   possible. The ideal solution will live organically with the existing C++
   source files or exist in Python. Namely we want to avoid solutions which
   require us to rely on too many external tools, or intermediate markup
   languages.

.. _pb_maintainable:

Easily maintained.
   As NWChemEx grows we expect the API to grow as well. Python bindings will
   need to be created for the new APIs and ideally whatever Python binding
   solution we go with should be accessible to developers and easily extendable.

.. _pb_supported:

Active support.
   Our goal is for the Python bindings of NWChemEx to live for as long as the
   NWChemEx project does. This requires our Python binding solution to also be
   maintained over the course of this time period. The ideal solution should be
   well supported, not only in terms of development, but also in terms of
   documentation and/or StackOverflow-like help.

.. _pb_existing_choices:

****************
Existing Choices
****************

Writing bindings directly with Python's C API is a tedious task. For that
reason, a variety of software libraries/packages have been created with the
intent of aiding in generating Python bindings. They are listed below (in
alphabetical order) along with brief summaries.

.. note::

   Obligatory disclaimer. We are NOT experts in all of the packages listed in
   this section. The summaries have been assembled based on documentation and
   examples provided by the packages. We have done our best to accurately
   reflect the state of these packages, but it is possible that what we have
   inferred does not actually represent the state of the packages.

Boost.Python
============

- GitHub: https://github.com/boostorg/python

  - 28 watchers
  - 396 stars

- Docs: http://boostorg.github.io/python/doc/html/index.html

Boost.Python was one of the "OG" binding libraries to rely on template meta-
programming to dramatically simplify the process of binding C++ code. Its
inclusion in the Boost libraries makes it a very heavy dependency (if your code
does not already use Boost). At this point in time, the C++ community
overwhelming seems to prefer :ref:`pybind11` over Boost.Python.

Pros:

- Part of the Boost libraries (not going anywhere any time soon).
- Very robust library.

Cons:

- Part of the Boost libraries (heavy dependency).
- Performance. :ref:`pybind11` (an admittedly very biased source) seems to
  suggest that in order to live up to Boost's lofty standards the performance
  of the bindings suffer.

C Foreign Function Interface (CFFI)
===================================

- Docs: https://cffi.readthedocs.io/en/latest/

TODO: Look at CFFI

.. _cppyy:

Cppyy
=====

- GitHub: https://github.com/wlav/cppyy

  - 9 watchers
  - 255 stars

- Docs: https://cppyy.readthedocs.io/en/latest/index.html

Cppyy :cite:`cppyy16` piggybacks off of the LLVM suite of tools to fully
automate the creation of dynamic Python bindings.

Pros:

- Bindings are generated automatically. No boilerplate!!
- Use of LLVM makes it future-proof (bindings evolve with the compilers).
- Supports packaging bindings for distribution.
- Used by a number of high-profile projects at CERN.

Cons:

- Appears to have more or less a single maintainer.
- Bindings are in ``cppyy.gbl`` namespace, leading to a slightly awkward UI.
- Bindings learned from inspecting headers, which, especially for template
  classes/functions, have a tendency to leak a lot of low-level APIs (take a
  look at how much code is included just by doing ``#include <vector>``).
- Tied to LLVM. If underlying C++ is not compiled with LLVM, you are forced
  to mix compilers.
- Overriding Cppyy's binding decisions can be tricky. More over the only way to
  know one must override a binding decision is through extensive unit testing
  or intimate knowledge of how Cppyy's bindings are generated.
- Choosing what gets exposed needs to be done on a per file basis, *i.e.*, if
  you don't want the contents of a file to be exposed to Python, don't let
  Cppyy process that file. This may require refactoring C++ source code.
- Leaks purely C++ concepts like pointers, references, and templates into
  Python. Users don't necessarily have to call them, but they're there.
- Packaging bindings, so they do not need to be generated on-the-fly each run
  and can be reliably distributed is complicated and somewhat poorly documented.
  It appears to require using rootcling (a seemingly nice tool), or genreflex
  (which appears to be a wrapper around rootcling). This process is somehow
  related to "Dictionaries" (not in the Python sense), XML selection files,
  and rootmap files. How this all comes together is not really clear.
- Cppyy seems to acknowledge the packaging problems (see
  `here <https://cppyy.readthedocs.io/en/latest/cmake_interface.html>`__) and
  provides a CMake solution. The CMake solution is complicated and seemingly not
  compatible with modern CMake practices (namely target-based build systems).

ctypes
======

- Docs: https://docs.python.org/3.8/library/ctypes.html

TODO: Look ctypes over.


Cython
======

- Docs: https://cython.org/

TODO: Look Cython over

nanobind
========

- GitHub: https://github.com/wjakob/nanobind

  - 27 watchers
  - 1.4K stars

- Docs: https://nanobind.readthedocs.io/en/latest/

nanobind :cite:`nanobind` is from the original author of pybind11 and was
started because he wanted to create a more streamlined, more performant python
binding library, while not breaking support for pybind11. The API and usage of
nanobind is largely the same as pybind11

Pros:

- Better performance compared to Boost.Python and pybind11.
- Essentially a subset of pybind11 (if nanobind becomes vaporware, can easily
  fall back to pybind11)

Cons:

- Same as pybind11: verbose boilerplate and manual exposure of C++.
- Relatively new project, could turn into vaporware.
- At present expects you to install via pip (does not easily integrate with
  CMake).


.. _pybind11:

pybind11
========

- GitHub: https://github.com/pybind/pybind11

  - 244 watchers
  - 12.6K stars

- Docs: https://pybind11.readthedocs.io/en/stable/

pybind11 :cite:`pybind11` has largely replaced Boost.Python as the predominant
mechanism for exposing C/C++ code to Python. The API of pybind11 is modeled
after that of Boost.Python, but is significantly simpler on account of pybind11
requiring minimum C++11 (Boost.Python is based on C++03). More specifically,
using C pre-processor macros, users register the C++ classes and functions they
want to expose to Python. pybind11 then creates the Python bindings based
on the information provided during the registration process.

Pros:

- Heavily used, widely supported.
- Used in Tensorflow and PyTorch.
- More lightweight than Boost.Python.
- Header-only.
- Bindings are rolled into C++ library for easy packaging.

Cons:

- Verbose C++ boilerplate for exposing C++.
- Exposing C++ classes and functions must be done manually.

PyBindGen
=========

- Docs: https://pybindgen.readthedocs.io/en/latest/

Shiboken
========

- Docs: https://doc.qt.io/qtforpython-6/shiboken6/index.html

SIP
===

- Docs: https://www.riverbankcomputing.com/static/Docs/sip/introduction.html

TODO: Better look at SIP

SWIG
====

- Website: https://swig.org/

********************************
NWChemEx Python Binding Strategy
********************************

History
=======

Being honest the NWChemEx team really only considered Boost.Python, pybind11,
and Cppyy. pybind11 was the original choice and was preferred to Boost.Python
on account of the fact that, at the time, the NWChemEx team was trying to avoid
adding Boost to the stack. A number of team members, had had previous
experience with pybind11 which facilitated the decision.

After initial bindings were created, the existence of Cppyy was noted and the
decision was then made to switch to Cppyy to take advantage of its automatic
bindings, so as to avoid needing to write more bindings in the future. In
practice the automatic bindings of Cppyy were found to be far less than
automatic. More specifically, to ensure consideration :ref:`pb_native_apis` is
addressed we quickly realized that the automatically generated Cppyy-bindings
will not suffice and we would need to create a compatibility layer.

Cppyy provides two mechanisms for controlling the generated bindings:
Pythonizations and writing a wrapper layer. The former is accessible from
either Python or C++, and amounts to manually changing which implementation is
bound to a class's method. This conceptually appears to be a slimmed down
version of pybind11's "trampoline" mechanism. The latter mechanism amounts to
writing a Python module over top of the Cppyy generated bindings and, in Python,
writing shuttling the data from Python to C++ and vice versa for returns. This
is far more complicated than it sounds as one must often deal with C++ concepts
like pointers, references, templates, type casts etc. in Python, purely through
Cppyy-defined interfaces.

In our opinion, the need to write a compatibility layer largely negates the
main advantage of Cppyy over other solutions, such as pybind11. Combined with
some of the other cons:

- requiring builds to support mixed compilers,
- lack of control over what gets exposed,
- interacting with the complicated CMake-based infrastructure, and
- limited team expertise on how Cppyy works

the decision was made to switch back to pybind11. While the bindings require
writing boilerplate, that boilerplate is relatively straightforward to write.
Furthermore, the compatibility layer is written in C++ and is part of the C++
library, facilitating encapsulation/packaging without needing to rely heavily
on CMake (beyond normal CMake C++ packaging). When/if nanobind is more stable
we may want to switch to that.

Architecture
============

As described above, the original intent was to use pybind11 for Python bindings.
Consequently, the overall NWChemEx architecture was designed in a manner to
facilitate this.

***********************************
References and Additional Resources
***********************************

- `This <https://realpython.com/python-bindings-overview/>`__ tutorial covers
  some of the other options available in more detail and was used to partially
  populate the list in :ref:`pb_existing_choices`.
