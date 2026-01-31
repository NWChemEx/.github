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

####################
Design Documentation
####################

The documentation in these pages capture assumptions and decisions made along
the way to creating NWChemEx. These are meant to be a living document and should
be updated as new concerns arise.

*********************************
NWChemEx Philosophy and Ecosystem
*********************************

Topics in these sections cover project-wide design considerations and help
ground the rest of the design documentation.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   philosophy
   nwx_community
   nwx_ecosystem


*******************
Organization Design
*******************

Topics in these sections cover design decisions that impact how the NWChemEx
organization appears on GitHub and how that organization works. These topics
focus more on preserving and maintaining the software versus developing it. 

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   directory_structure

****************
NWChemEx Package
****************

Topics in these sections cover design decisions for the development of the
software within the NWChemEx organization. Out of scope are design decisions
for any particular component.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   overall_design
   energy_workflow
   overall_justifications/index
   ui_design

*************
Miscellaneous
*************

Topics in these sections cover high-level design decisions that don't fit into
other categories.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   faqs