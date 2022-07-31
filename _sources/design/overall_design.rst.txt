##############
Overall Design
##############

The point of this page is to explain the philosophy, organization, and overall
design of the NWChemEx software stack.

******************************
NWChemEx Organization Overview
******************************

The NWChemEx organization manages a lot of repositories. Generally speaking
those repositories fall into one of two groups: the framework known as the
simulation development environment, or SimDE for short, and the NWChemEx
electronic structure package. The breakdown is shown in the following figure:

.. figure:: overall_design.png
   :figwidth: 100 %
   :align: center

   Diagram of the overall NWChemEx Design

It's worth noting that each repo is capable of being used as an independent
product (aside from the repos it depends on). Generally speaking, however, we
anticipate most people will interact with the stack in one of three ways:

#. They are writing an external module, in which case they will pull the SimDE
   repo and use it as a dependency;
#. They are writing an internal module, in which case they will pull the
   NWChemEx repo and the module collection they are adding the module to; or
#. They are running NWChemEx, in which case they will only pull the NWChemEx
   repo.

These three use cases underlie why we have place an emphasis on the SimDE and
NWChemEx repos. The following subsections describe the SimDE and NWChemEx groups
of repos in more detail.

SimDE
=====

SimDE encapsulates the infrastructure required to:
- interact with the hardware,
- manage and run modules,
- model and express commonly occurring computational chemistry concepts, and
- define the APIs used to compute properties

SimDE is intended to have APIs that are long-term stable. This is important for
ensuring modules remain interoperable with the framework for a long time. The
goal is to get SimDE to a point where most developers will only interact with
SimDE, and will not need to perform development on it. The main exception being
the addition of standardized APIs for new properties.

Conceptually you can think of SimDE as being akin to a typical smartphone
operating system, but targeting computational chemistry. Like a smartphone OS,
SimDE manages a bunch of apps (which we call modules), takes care of inter-app
communication (passing data among the modules), and automates more mundane tasks
(like logging and saving results). SimDE is extensible in that new modules and
communication protocols can be added downstream from it, even at runtime.
Specifically the design of SimDE is such that downstream developers don't need
to modify any source code of SimDE to extend it.

This generality and flexibility comes at the cost of complexity. While design
efforts have striven to make SimDE as simple as possible, the reality is that it
is still quite verbose from a typical electronic structure user's perspective.
It is the responsibility of whatever sits on top of SimDE to provide more
user-friendly APIs (in addition to the module functionalities). More complicated
workflows can always directly access SimDE for finer-grained control.

The main components of SimDE are summarized in the following table:

============== ======================================================
Repository     Description
============== ======================================================
Utilities      General classes/functions, i.e. our own personal Boost
ParallelZone   The runtime abstraction layer
PluginPlay     Framework for working with plugins
Chemist        Chemistry specific classes, used to define APIs
SimDE          Definitions of APIs, top-level repo for SimDE
============== ======================================================


NWChemEx
========

The NWChemEx electronic structure theory package is itself made up of two main
components: a series of modules for use with SimDE and a user-friendly API for
running those modules. If we continue the smartphone analogy, the modules
provided by NWChemEx are first-party apps (for Android users think GMail, Google
Calendar, Chrome, *etc.*; iPhone users think Mail, iCal, Safari, *etc.*). SimDE
doesn't limit you to the modules which come from NWChemEx, and developers are
free to write their own modules to use with the NWChemEx package. From the
perspective of SimDE, where a module comes from doesn't matter, *i.e.*, modules
that are part of NWChemEx are treated no differently than modules that are not
part of NWChemEx.

Finally in the smartphone analogy, the user-friendly API of NWChemEx is similar
to the graphical user interface your phone provides. When you click on a street
address in an email app and it brings up the location in your map app, you don't
really think about how the apps communicated or what library calls were needed
to make that happen. Similarly, when you tell NWChemEx to compute the energy of
a molecule, through the user-friendly API, you don't have to think about how
that request gets dispatched through the modules and libraries underlying
NWChemEx.

The main components of NWChemEx are summarized in the following table:

============== =======================================================
Repository     Description
============== =======================================================
Mokup          Hard-coded tensorial data used for unit testing
Integrals      Modules for computing integrals with AOs
SCF            Modules related to Hartree-Fock and DFT
MP2            Modules related to Moller-Plesset perturbation theory
TAMM-SDE       An assortment of modules which use TAMM instead of TA
ChemCache      Hard-coded physical data and basis sets
NWChemEx       The top-level repo which provides the user-friendly API
============== =======================================================

Miscellaneous Repositories
==========================

The NWChemEx-Project organization contains a number of additional "meta"
repositories that are not directly required for building NWChemEx. These repos
are typically associated with a particular research project, provide CI
infrastructure, or in some other way support the project without being source
code. The following table summarizes these repositories.

============== ==========================================================
Repository     Description
============== ==========================================================
DeveloperTools Developer documentation and tools for maintaining NWChemEx
Publications   Manuscripts written by the NWChemEx team about NWChemEx
============== ==========================================================
