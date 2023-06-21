######################
User Interface Design
######################

This document outlines the design principles and guidelines for the user interface (UI) of NWChemEx. 
Our main goal is to provide a user-friendly and intuitive interface that enables users to carry out a variety of quantum chemistry calculations seamlessly.
However, please note that a graphical user interface (GUI) is not part of the current design.


The current UI enables users to conduct commonly used quantum chemistry calculations such as single-point energies and geometry optimizations 
in as few steps as possible. 
It is designed to be straightforward, yet flexible enough to allow for more complex workflows using the helper/driver functions and PluginPlay modules. 
Users can execute these calculations either via Python scripts or interactively using Jupyter notebooks. 
For those who desire a fine-grained control of their workflow, they can utilize the Python and/or C++ API.

Before we delve into the specifics of the NWChemEx UX, we provide examples of SCF/sto-3g energy calculations for a hydrogen molecule using two widely 
used quantum chemistry packages with Python interfaces, PySCF and PSI4. 
We will also provide an example from MolSSI QCEngine, which aims to provide a standard UI for a variety of quantum chemistry packages.

PySCF
======
PySCF is a Python-based open-source quantum chemistry package distributed under the Apache License 2.0.
The code is written mostly in Python (~90%), while computational hot spots are written in C following C89 standard.
Most functions are pure (exceptions are named with a suffix underscore) and functional programming is preffered over object oriented style as described in 
their `code standard https://pyscf.org/code-rule.html`__.

Below you can find how to run an SCF calculation for a hydrogen molecule using PySCF.

.. code-block:: python

    >>> from pyscf import gto, scf
    >>> mol = gto.M(atom='O 0 0 0; H 0 1 0; H 0 0 1', basis='sto-3g')
    >>> rhf = scf.RHF(mol)
    >>> energy = rhf.kernel()

Here, mol is the object (type ``pyscf.gto.mole.Mole``) representing the molecule and integrals with the given basis set and
rhf is the object (type ``pyscf.scf.hf.RHF``) that holds method specific information. The energy is computed using the ``kernel()`` function.

PSI4
====
PSI4 is a C++/Python (70%/30%) open-source quantum chemistry package distributed under the LGPL3 license.
PSI4 provides two different types of UI referred to as Psithon and PsiAPI modes. 
In the Psithon mode, the user writes an input file in a domain specific language similar to Python.
In the PsiAPI mode, the user can write a pure Python script that interacts with PSI4 as a Python module.
Since the latter is more relavant to our design, we show below how to run an SCF calculation for a hydrogen molecule using the PsiAPI mode.

.. code-block:: python

    >>> import psi4
    >>> mol = psi4.geometry('H 0. 0. 0. \n H 0. 0. 1.')
    >>> energy= psi4.energy('scf/sto-3g')    

Here, mol is the molecule object, which is created using the ``psi4.geometry()`` function and the energy is computed using the ``psi4.energy()`` function, which takes the method name as
the required argument. Note that the user do not need to pass
the molecule object explicitly to the subsequent energy calculation. By default energy is computed for the last molecule defined with the ``psi4.geometry()`` function.
Additional options can be set with the ``psi4.set_options()`` function, which takes a Python dictionary as the required argument. 


QCEngine
========
QCEngine is a general purpose quantum chemistry program interface. It is a Python library that provides a common API for quantum chemistry programs.
QCEngine is an open-source package distributed under the Apache License 2.0.

Below you can find how to run an SCF calculation for a hydrogen molecule using QCEngine.

.. code-block:: python

    >>> import qcengine as qcng
    >>> import qcelemental as qcel
    >>> mol = qcel.models.Molecule.from_data('H 0. 0. 0. \n H 0. 0. 1.')
    >>> out = qcng.compute({"molecule": mol, "driver": "energy", "model": {"method": "SCF", "basis": "sto-3g"}})
    >>> energy = out.return_result

Here, mol is the molecule object (type ``qcelemental.models.molecule.Molecule``), which is created using the ``qcel.models.Molecule.from_data()`` function from QCElemental package.
The SCF energy  is computed using the ``qcng.compute()`` function, from QCEngine package. Note that, the input for the `qcng.compute` function is a Python dictionary with a schema
defined by QCElemental.


NWChemEx
========

In NWChemEx, running an SCF calculation for a hydrogen molecule is made easy through the use of a simple Python with named arguments, as shown below.

.. code-block:: python

    import nwchemex as nwx
    energy = nwx.calculate_scf_energy(molecule = 'H 0. 0. 0. \n H 0. 0. 1.', basis = "sto-3g")


