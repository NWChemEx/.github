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

######################
User Interface Design
######################

This document outlines the design principles and guidelines for the user
interface (UI) of NWChemEx. Our main goal is to provide a user-friendly and
intuitive interface that enables users to carry out a variety of quantum
chemistry calculations seamlessly. Please note that a graphical user interface
(GUI) is not part of the current UI design. Other possible UI elements that are
not part of the current design are noted here :ref:`not-in-scope`.

******************
Design Principles
******************

Pythonic
=========
While NWChemEx is mainly written in C++ for performance, the UI is designed for
and implemented in Python, which is arguably one of the most intuitive and
widely-used programming languages in scientific computing. This removes the
burden from our users to learn a special syntax, a new domain specific language,
or dealing with customized parsers for extracting data. Moreover, Python's
extensive ecosystem and user-friendly syntax allow for quicker prototyping and
easier integration with external tools, making it an ideal choice for this
interface. Adhering to the Pythonic style of programming is preferred due to its
emphasis on code readability and simplicity, as described in the Zen of Python
(PEP 20) <https://peps.python.org/pep-0020/>_. A more in depth discussion of the
implementation language choices can be found in
:ref:`why_is_the_nwchemex_api_written_in_python`.

Performant
==========
Performance is critical for NWChemEx with kernels supporting optimized MPI
parallelization and GPU offloading. The UI is designed to uphold this
performance standard and to provide the user with critical control elements to
achieve high performance. This requires keeping the overhead of UI as minimal as
possible by avoiding unnecessary copies or data movements and enabling user to
access and modify the MPI communicator and toggle between CPU-based/GPU-offloaded algorithms.

Light weight
============
Following from performance, the UI should shuttle data into C++ as quickly as
possible.For user convenience some conversions may be necessary (*e.g.*, our
`Molecule` class is never going to do string parsing), but the set of such
conversions should be minimal, or limited to those supported by some other
library (which we agree to take on as a dependency).

User-friendly
=============
We aim to make our UI intuitive and simple particularly for the most common use
cases to minimize the learning curve for beginners. The UI is also designed to
provide user-friendly error handling, offering clear and actionable feedback
when something goes wrong, guiding users to resolve issues effectively.

Tool-friendly
=============
In some workflows, NWChemEx can be used as a library driven by another code,
rather than directly by a user. Therefore, our UI needs to avoid assuming that
it is the top layer in order to better integrate into external tools.

The ability to take an MPI communicator is one particularly important UI design
element implied by this combined with the performance consideration. Python-based
interface is also useful to support many external tools easily.

Minimal I/O
===========
Many quantum chemistry codes are designed to use input/output (I/O) files as
their primary (sometimes only) user interface. Users are expected to provide
input files in certain format and parse output files to extract the information
required. This is not only cumbersome but also can hinder performance
particularly when the code is used as a library by an external code in
high-throughput mode. The UI should avoid or minimize the I/O by providing the
user with the ability to pass the input and output data directly to the code.
This enables better interactivity and allows for more efficient use of the code
as a library.

Interactive
============
The UI should support interactivity, allowing users to run the code in a Jupyter
notebook or IPython shell. This is particularly important for beginners who are
not familiar with the code and want to explore its capabilities and for
education. It is also important for visualization and for workflows supporting
machine learning applications.

Limited results
===============
In theory, there's a very large set of results a user could want. Thankfully
most users target the same quantities. The UI should focus on those quantities.

The most common quantities are: energy, molecular-orbital coefficients,
gradients, vibrational frequencies, and geometries (including minimum energy,
transition states, reaction paths, etc.).

Limited inputs
==============
Generally speaking the inputs required for the aforementioned results tend to be
the molecule, level of theory (method plus basis set), and method parameters.
While the set of potential parameters is huge, again there are only a handful of
commonly used parameters.

Primary targets are: algorithm variations (e.g. density fitting), number of
iterations, and convergence criteria.

Focus on common tasks
=====================
The UI targets the most common use cases (see :ref:`common-tasks`), but should
try to be flexible. At some point, harnessing the full power of the code
requires forgoing the UI and dropping down to PluginPlay's API.

Minimal dependencies
====================
The UI is designed to be a thin-layer on top of the PluginPlay API and should
have minimum number of dependencies. This improves maintainability and reduces
the risk of breaking the code due to changes in the dependencies.

Archiving and reproducibility
=============================
The UI should support archiving and reproducibility by providing the user with a
way to save the input and output data for each calculation. This not only serves
as a tool for managing and organizing data but also plays an integral role in
facilitating reproducibility.

.. _common-tasks:

*************************************
Common Quantum Chemistry Calculations
*************************************

As described in the design principles, the UI should enable users to conduct
commonly used quantum chemistry calculations such as single-point energies and
geometry optimizations in as few steps as possible. It should also be flexible
enough to allow for more complex workflows using the helper/driver functions and
PluginPlay modules. Users can execute these calculations either via Python
scripts or interactively using Jupyter notebooks. For those who desire a
fine-grained control of their workflow, they can utilize the Python and/or C++
API.

1. **Single Point Energy**

   In these calculations total energy is computed for a fixed geometry of the
   molecule (arrangement of atomic nuclei) corresponding to a single point in
   the potential energy surface. While energy calculation is the most common
   case, the user might be interested in obtaining the wave function,
   derivatives, or other properties (dipole moment, electron density, etc.) for
   this specific geometry.

2. **Geometry Optimization**

   This is a procedure to find the arrangement of atomic nuclei that corresponds
   to a stationary point in the potential energy surface. This procedure
   generally requires the calculation of the gradients and Hessian (first and
   second order partial derivatives of the energy with respect to nuclear
   coordinates, respectively) at many different geometries.

3. **Vibrational Frequency Calculation**

   These calculations provide the vibrational modes of a molecule and their
   corresponding frequencies. The procedure requires Hessian calculation at the
   equilibrium  geometry.

4. **Molecular Dynamics Simulation**

   These calculations allow for the study of the trajectory of atoms and
   molecules over time using classical dynamics. Gradient calculations are
   required to compute the forces acting on the atoms.

We will initially focus on the UI design of the "single point energy"
calculations in this document since other types of calculations (geometry
optimization, vibrational frequency calculation, etc.) require similar inputs.

Before we delve into the specifics of the NWChemEx UX, we provide examples of
restricted Hartree--Fock (RHF) energy calculations for a hydrogen molecule using
PySCF, PSI4, and MolSSI QCEngine. Finally, we will provide an NWChemEx example
and discuss about the choices made.

**************************
Existing Python-based UIs
**************************

PySCF
======
PySCF is a Python-based open-source quantum chemistry package distributed under
the Apache License 2.0. The code is written mostly in Python (~90%), while
computational hot spots are written in C following C89 standard. Most functions
are pure (exceptions are named with a suffix underscore) and functional
programming is preferred over object oriented style as described in their `code
standard <https://pyscf.org/code-rule.html>`_.

Below you can find how to run an RHF calculation for a hydrogen molecule using
PySCF.

.. code-block:: python

    from pyscf import gto, scf
    mol = gto.M(atom='O 0 0 0; H 0 1 0; H 0 0 1', basis='sto-3g')
    rhf = scf.RHF(mol)
    energy = rhf.kernel()

Here, mol is the object (type ``pyscf.gto.mole.Mole``) representing the molecule
and integrals with the given basis set and rhf is the object (type
``pyscf.scf.hf.RHF``) that holds method specific information. The energy is
computed using the ``kernel()`` function.

PSI4
====
PSI4 is a C++/Python (70%/30%) open-source quantum chemistry package distributed
under the LGPL3 license. PSI4 provides two different types of UI referred to as
Psithon and PsiAPI modes. In the Psithon mode, the user writes an input file in
a domain specific language similar to Python. In the PsiAPI mode, the user can
write a pure Python script that interacts with PSI4 as a Python module. Since
the latter is more relevant to our design, we show below how to run an RHF
calculation for a hydrogen molecule using the PsiAPI mode.

.. code-block:: python

    import psi4
    mol = psi4.geometry('H 0. 0. 0. \n H 0. 0. 1.')
    energy= psi4.energy('scf/sto-3g')

Here, mol is the molecule object, which is created using the ``psi4.geometry()``
function and the energy is computed using the ``psi4.energy()`` function, which
takes the method name as the required argument. Note that the user do not need
to pass the molecule object explicitly to the subsequent energy calculation. By
default energy is computed for the last molecule defined with the
``psi4.geometry()`` function. Additional options can be set with the
``psi4.set_options()`` function, which takes a Python dictionary as the required
argument.

QCEngine
========
QCEngine is a general purpose quantum chemistry program interface. It is a
Python library that provides a common API for quantum chemistry programs.
QCEngine is an open-source package distributed under the Apache License 2.0.

Below you can find how to run an RHF calculation for a hydrogen molecule using
QCEngine.

.. code-block:: python

    import qcengine as qcng
    import qcelemental as qcel
    mol = qcel.models.Molecule.from_data('H 0. 0. 0. \n H 0. 0. 1.')
    out = qcng.compute({"molecule": mol, "driver": "energy", "model": {"method":
    "SCF", "basis": "sto-3g"}}, "NWChemEx")
    energy = out.return_result

Here, mol is the molecule object (type
``qcelemental.models.molecule.Molecule``), which is created using the
``qcel.models.Molecule.from_data()`` function from QCElemental package. The RHF
energy is computed using the ``qcng.compute()`` function, from QCEngine package.
Note that, the input for the ``qcng.compute`` function is a Python dictionary
with a schema defined by QCElemental.

********************
Current NWChemEx UI
********************

The backbone of the current NWChemEx UI is the `calculate()` function. This
function enables users to run quantum chemistry methods implemented in NWChemEx,
with a very simple interface. The signature of this function is given below.

.. code-block:: python

    def calculate(molecule: Union[str, Dict[str, Any], chemist.Molecule],
    method: str, basis: Union[str, chemist.AOBasisSet, simde.type.ao_space],
    task: Literal["energy", "gradient", "wavefunction"] = "energy", options: Dict[str,
    Any] = None, **kwargs) -> Dict[str, Any]:

In this function, there are three required arguments. First one is the molecule,
which can be given as a Python string or a dictionary-like object (composed of
key-value pairs) that contains the information required to create a
``chemist.Molecule`` object. The user can also pass a ``chemist.Molecule``
object directly. The second required argument is the ``method``, which is a
Python string that corresponds to one of the quantum chemistry methods
implemented in NWChemEx. The third required argument is the ``basis``, which can
be given as a Python string or a ``chemist.AOBasisSet`` object or a
``simde.type.ao_space`` object. The ``calculate()`` function also takes optional
arguments. ``task`` argument enables users to choose the type of calculation,
which can be ``energy`` (default), ``gradient``, or ``wavefunction`` currently,
but this list is expected to grow as more functionalities are added to NWChemEx.
``options`` argument enables users to customize the calculation further by
modifying different parameters related to the selected ``method`` and ``task``. At
this point, it is an opaque type (to be designed later in coordination with
PluginPlay `#308 <https://github.com/NWChemEx/PluginPlay/issues/308>`_),
which is capable of holding key/value pairs for inputs similar to a Python
dictionary. Alternatively, key/value pairs can be passed directly to the
function call as ``kwargs``. The return type of the ``calculate()`` function is
also an opaque type that can hold key/value pairs.

With the ``calculate()`` function, a user can run the RHF example by
specifying only the required arguments as shown below.

.. code-block:: python

    import nwchemex as nwx
    result = nwx.calculate(molecule = 'H 0. 0. 0. \n H 0., 0. 1.', method='scf', basis = 'sto-3g')

Here, ``method = 'scf'`` will default to the RHF energy calculation since the
molecule is a closed-shell system and default value for the ``task`` is a single
point energy calculation.

Parallel calculations
=====================

NWChemEx also provides a simple interface to run calculations in parallel. Here,
we provide an example where the user wants to run a potential energy surface
scan, which is basically an embarrassingly parallel workflow composed of single
point energy calculations at different geometries. The user can run this
workflow in two different ways:

.. code-block:: python

    # Initialize the parallel environment with mpi4py
    from mpi4py import MPI
    comm = MPI.COMM_WORLD
    rank = comm.Get_rank()

    # Use one rank per sub-communicator
    sub_comm = comm.Split(rank)
    # Define the distance between atoms based on the global rank
    d = 1. + rank * 0.1

    # Alternative 1
    # Initialize NWChemEx runtime with the sub-communicator
    nwx_comm = nwx.initialize(sub_comm)
    result = nwx.calculate(molecule = f'H 0. 0. 0. \n H 0. 0. {d}', method = 'scf', basis = 'sto-3g')
    print(f'Energy calculated by rank: {rank} for distance: {d} is {result.scf_energy}')

    # Alternative 2
    # Initialize NWChemEx runtime inside the function call
    # Sub-communicator can be passed directly or through the options argument
    result = nwx.calculate(molecule = f'H 0. 0. 0. \n H 0. 0. {d}', method = 'scf', basis = 'sto-3g', communicator = sub_comm)
    print(f'Energy calculated by rank: {rank} for distance: {d} is {result.scf_energy}')

.. _not-in-scope:

*************
Not In Scope
*************

**Graphical user interface (GUI)**

Arguably a GUI represents the pinnacle of UX; however, we presently are focused
on a programmatic UI. Implementing a GUI is an orthogonal task that can benefit
from the existence of the programmatic UI.

**Interfaces for driving NWChemEx**

While we want NWChemEx to be part of an ecosystem, the design on this page is
purely focused on a UI which uses a combination of native NWChemEx and Python
objects.

   - With a NWChemEx UI in place driving NWChemEx from other packages becomes easier.
   - Ideally such interfaces should be maintained on the driver's side, and not
     by us, in order to avoid needing to weigh down NWChemEx with additional
     dependencies. Note that making a dependency optional for a user does NOT
     negate this as NWChemEx developers must support all optional features.
