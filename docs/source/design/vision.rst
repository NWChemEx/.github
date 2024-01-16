################
NWChemEx Visions
################

The overall philosophy/motivation of the NWChemEx software package was 
discussed in the :ref:`philosophy` section. That philosophy is ultimately a 
lofty, moving target. 

**********
1.0 Vision
**********

The overall vision of NWChemEx is lofty and a moving target. Version 1.0 serves 
to lay the groundwork for future releases. To this end we envision NWChemEx as
being comprised of 1.0 releases of:

- ParallelZone 
- PluginPlay
- Chemist
- SimDE
- ChemCache
- TAMM
- FriendZone
- NWChemEx

The end goal is to be able to call the SCF, DFT, and coupled cluster routines 
developed within the ECP program via the NWChemEx infrastructure. Roughly
speaking this amounts to:

- ParallelZone providing distributed parallelism primitives.
- PluginPlay providing an inversion-of-control framework for managing 
  module interoperability.
- Chemist providing basic quantum chemistry classes for describing the inputs
  to the simulation (e.g., the chemical system and the molecular basis set).
- SimDE providing standardized interfaces for computing energies.
- ChemCache a plugin providing fundamental quantum chemistry parameters (e.g., 
  physical constants, atomic basis sets).
- TAMM plugin providing HPC implementations of SCF, DFT, and coupled cluster
  via the interfaces defined in SimDE.
- FriendZone plugin providing interoperability with other electronic structure 
  packages.
- NWChemEx wrapping the modular architecture in a easily distributable package.

Additionally, version 1.0 of NWChemEx will have:

- Python bindings and support
- CI/CD based on GitHub actions
- community, user, and developer documentation.