.. Copyright 2026 NWChemEx-Project
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

.. _nwx_community:

##################
NWChemEx Community
##################

The NWChemEx Community is made up of the stakeholders that interact with 
NWChemEx. The point of this page is to identify who these stakeholders are, what
their use cases are, and what their expectations are. Finally, we map those
use cases and expectations back to design decisions.

*****************
Executive Summary
*****************

The key design points from this analysis are:

- Performance (needed to make running on supercomputers worthwhile)
- Ease of use (too high of a barrier will inhibit use cases where there are
  other choices)
- Library instead of program mentality (we shouldn't assume we are driving the
  workflow)
- Extensibility (adding new theories should be easy)
- Varying levels of programming expertise (research is done by undergraduates,
  graduates, post docs, scientists/professors from a multitude of backgrounds)

************
Stakeholders
************

.. note::

   The stakeholder categories are NOT mutually exclusive. For example, most
   *authors* will also be *end users*. The point of the categories is not to 
   group actual people, but rather to deduce design decisions based on the needs
   of each category.

Stakeholders are people that will interact with NWChemEx either directly or
indirectly. The key stakeholders we have considered are:

- *End Users*: People who use NWChemEx to perform electronic structure
  calculations.

   - E.g., scientists, researchers, students, etc. trying to understand the
     mechanism of a chemical reaction by running a series of calculations.
   - May or may not be programmers.    

- *External Developers*: People who develop software, but do not target 
  NWChemEx during that development.

   - E.g., developers of math libraries, communication libraries.
   - Also includes developers of other electronic structure packages.

- *Contributors*: People who develop software that targets NWChemEx, but is not
  housed by the NWChemEx GitHub organization.

   - E.g., Plugins that live outside the NWChemEx organization, tools designed
     to work with multiple electronic structure packages.
   - Upstream contributors are developers want NWChemEx to call their software.
   - Downstream developers want to call NWChemEx in their software.
   - We have no formal definition of "targeting". If a developer wants to be
     included in the contributor category, they are.

- *Authors*: People who contribute directly to repositories housed by the 
  NWChemEx organization.

   - E.g., developers of SimDE or SCF.
   - Any contribution counts, from documentation to code.
   - Again up to the developer if they want to be included in this category.

- *Beneficiary institutions*: Institutions that benefit from NWChemEx. These
  institutions may or may not have people that directly interact with NWChemEx.
  Examples include universities, national labs, research institutes, etc.

   - E.g., U.S. Department of Energy, Ames National Laboratory, 
     Iowa State University.

************************
Use Cases by Stakeholder
************************

End Users
=========

*End users* want to run calculations and generate data. They are unlikely to be
concerned with how NWChemEx is implemented, rather they care about what it can
do. Uses:

- Computing properties of a molecular system.

   - E.g., energy, dipole moment, vibrational frequencies, etc. 
   - These calculations are done in small batches.
   - For very small batches users may prepare inputs by hand.
   - For larger batches users may use workflow software to prepare inputs. 

- High-throughput calculations.

   - E.g., screening a large number of molecules for a desired property.
   - These calculations are done in very large batches, to the point that 
     preparation of traditional input files would be expensive. 

- Routine and heroic calculations.

   - Not all calculations will be on the largest supercomputers, but some will.

External Developers
===================

*External developers* are not too concerned with NWChemEx itself, rather the
use cases here center around how *contributors* and *authors* can leverage
other community software to make NWChemEx better. Use cases:

- Ability to leverage existing high-performance libraries.
- Contribute back to upstream libraries to improve performance and/or
  capabilities.

Contributors
============

*Contributors* are concerned with leveraging NWChemEx. Use cases are:

- Integrate their software seamlessly into NWChemEx.
- Integrate NWChemEx seamlessly into another software package.
- Reentrant calls to NWChemEx.
- To offload high-performance algorithms to NWChemEx. This facilitates adopting
  their software to funding proposals looking for high-performance applications.

Authors
=======

*Authors* primarily want to develop new theories, algorithms, and methods. Use
cases are:

- Developing new electronic structure methods.
- Developing new properties.
- Developing new analysis techniques.
- Adapting algorithms to new hardware.

It is important to remember that computer scientists and applied mathematicians
need software frameworks for their research too, i.e., *authors* are not just
chemists and physicists.

Beneficiary Institutions
========================

*Beneficiary institutions* want to see NWChemEx benefit their missions.

- A tool for funding. When funding calls are amenable to computational 
  chemistry, researchers at the institution can leverage NWChemEx to write a
  convincing proposal. 
- Exemplar of a software portfolio, e.g., be able to say things like NWChemEx
  is used for X% of all quantum chemistry calculations on DOE supercomputers.
- As recruitment aid, e.g., if you want to do computational chemistry at
  institution Y, you can be a part of the NWChemEx community.

***************************
Expectations by Stakeholder
***************************

End Users
=========

End user expectations are focused on the experience of using NWChemEx. Key
expectations below should be EASILY accomplished:

- Able to run anywhere from one to a "very large number" of calculations.
- Can obtain good performance on all platforms.
- Accurate results.
- Good documentation and examples.
- Active support community.

The emphasis on "easily" is because being able to do the above is not enough; 
users don't want to hunt for answers or spend hours tuning the software. They
want an experience that "just works." 

Developers
==========

TODO

Authors
=======

- Rapid prototyping. New development should be as quick as possible and ideally
  have some semblance of performance.

Beneficiary Institutions
========================

TODO

*******************
Design Implications
*******************

With the above use cases and expectations in mind, we can now map those back to
design implications for NWChemEx.

Performance Focused
===================

NWChem fulfilled a niche in the community by being able to run on the largest
supercomputers. With NWChem being deprecated, NWChemEx has the opportunity to
pick up the mantle. The broader community needs software targeted at large
runs. By focusing on performance we address the following use 
cases/expectations: 

- End users wanting to run heroic calculations.
- Easily adopt community libraries that provide high-performance capabilities
  without loosing the benefits of those libraries.
- Contributors wanting to their software to benefit from NWChemEx's
  performance.
- Ability for authors to quickly prototype performant algorithms on new 
  hardware.
- "Bragging rights" for beneficiary institutions.