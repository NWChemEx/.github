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

################
NWChemEx Visions
################

The overall philosophy/motivation of the NWChemEx software package was
discussed in the :ref:`philosophy` section. Achieving and adhering to that
philosophy is ultimately a lofty, moving target. To facilitate development of
NWChemEx in a direction consistent with the project's philosophy, the NWChemEx
board, in coordination with the overall NWChemEx community, will maintains a
shared vision. Unlike traditional milestones/goals, "visions" are intentionally
more vague and less SMART (specific, measurable, achievable, relevant, and
time-bound) so as to only define the scope of work, not the objectives of the
work.

This page is envisioned as collecting the visions of the NWChemEx project over
its lifetime.

**************
Vision for 1.0
**************

At the end of DOE's Exascale Computing Project (ECP) the NWChemEx community had
developed:

- infrastructure for writing modular scientific software,
- a performant tensor library, and
- performant implementations of fundamental computational chemistry methods.

These three pieces remain somewhat disconnected. The vision for the initial
release of NWChemEx, i.e., the 1.0 is to connect these three pieces in a unified
manner. This requires:

- 1.0 releases of all infrastructure (i.e., ParallelZone, PluginPlay, Chemist,
  SimDE, and ChemCache).
- Modularization of fundamental computational chemistry methods.
- Reliance on stable SimDE-based user APIs.
- 1.0 of FriendZone.

The reliance on stable SimDE-based APIs means that we will focus on minimal
inputs (i.e., chemical systems, basis sets, and classes needed to implement the
chemical system and basis sets). Modularity will be coarse-grained and limited
to data-exchange using stable Chemist types. Of note this means we will not
expose the tensor library at the 1.0 stage, and instead consider it an
"under-the-hood" implementation detail. The 1.0 of FriendZone is included to
round out NWChemEx's functionality, as ECP development primarily focused on DFT
and coupled cluster.

**********************
Vision for End of 2024
**********************

TODO: Determine if this time frame is right.

The vision for post-1.0 release has not been discussed yet and will not be
discussed until the 1.0 release has happened. However, the 1.0 vision leaves
some obvious directions which we list here so that people know they have not
been forgotten.

- exposure of tensors
- more Chemist classes (e.g., operators, vector spaces, and wavefunctions)
- more fine-grained modularization (using types from chemist)
- more user-friendly API.
- interfaces to other packages.
