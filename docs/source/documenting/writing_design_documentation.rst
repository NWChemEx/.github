.. Copyright 2022 NWChemEx-Project
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

.. _writing_design_documentation:

############################
Writing Design Documentation
############################

Many NWChemEx developers, particularly if they come from the chemistry side of
things, are likely not familiar with design documentation. This page is
intended to provide a gentle introduction to what design documentation is and
to establish what the NWChemEx team is looking for in design documentation.

.. _what_is_design_documentation:

*****************************
What is Design Documentation?
*****************************

`Wikipedia <https://en.wikipedia.org/wiki/Software_design_description>`__
defines design documentation as:

.. pull-quote::

   *...a representation of a software design that is to be used for recording
   design information, addressing various design concerns, and communicating
   that information to the design’s stakeholders.*

************************************
Why Do We Need Design Documentation?
************************************

The NWChemEx project is a massive undertaking and involves a large number of
developers. One of the primary reasons we need design documentation is to
outline the software infrastructure. This includes outlining the overall project
(design documents in this repo) and each sub-project (design documents in the
respective sub-repo). In theory, a new developer (or an established developer
who needs refreshers) should be able to start from the design documentation in
this repo and find their way to the source code component of interest purely
by reading the design documentation, *i.e.*, without having to read the source
code.

The other reason we need design documentation is to communicate the shared
vision of the project. NWChemEx is a large project and no one person is
expected to know every aspect of it. Design documentation provides a
mechanism for a developer new to NWChemEx, or to a piece of NWChemEx, to come
up to speed with the motivation, considerations, and decisions pertaining to
a piece of the project without having been part of the original design
discussions. Hence the design documentation communicates the shared vision of
the project.

*****************************************
What Should Design Documentation Include?
*****************************************

Ideally design document should document every decision made in structuring the
software. This ranges from repository structure to class hierarchies. Admittedly
this is a tall order. We strive to have design documentation for as much of the
NWChemEx project as possible, but realize that most of us are not getting paid
to write it. If you run into a piece of NWChemEx without design documentation
consider adding it (spoiler alert much of the present design documentation was
actually written after the code was implemented).

.. note::
   The outline below is a recommendation, and not all parts are relevant for all
   design stages. So use your best judgment.

As for the literal contents of a design document consider an outline like:

1. Define the component, feature, class

   - This is a section making sure everyone's on the same page about what design
     aspect is being documented.
   - For example consider the :ref:`what_is_design_documentation` section
     above, which defines design documentation.

2. Statement of Need

   - Once you have defined the component, feature, class, or whatever explain
     why we need it.
   - A lot of NWChemEx was designed top-down. So often the statement of need
     is more or less the feature above us kicked the can down the road to this
     component.

3. Considerations

  - When a stakeholder interacts with this component, feature, class, or
    whatever, what should they expect?
  - Ideally the considerations should be at the same granularity as the feature.
    For example when discussing the repo structure of NWChemEx it doesn't make
    sense to explicitly consider that we'll need to be able to build a
    two-center integral between f-orbitals.

4. Existing Options

   - For large components, extravagant features, or detailed classes consider
     using a library which provides that feature.
   - Once you're in the nitty-gritty, discussing existing options usually
     doesn't make as much sense because you're now worried about designing a
     component which works with infrastructure largely provided by the NWChemEx
     project, i.e., there usually won't be an existing implementation.

5. Strategy

   - Now that you've laid out what you're trying to do, and why, describe how
     you're going to do it.
   - For C++ code Doxygen can automatically generate API documentation, call
     graphs, callee graphs, and UML diagrams, so there's no need to write
     these explicitly. It usually suffices to show what components are under the
     hood to give an idea of what functionality stakeholders can expect.
   - This is a good place to work through complicated scenarios which may arise
     and explain how the component should respond.

6. Further Considerations

   - What's been left out of the design.
   - What's the current state of the implementation?
   - What has been tried, but failed?

*********************************************
Contributing Design Documentation to NWChemEx
*********************************************

Now that you know what design documentation is, why we need it, and what it
should include, the last step according to the last section is to explain how
it will work (I know pretty meta how this page follows the outline it suggests).
We strongly suggest that developers write design documentation for
contributions which implement new:

- repositories (it's important to know how these repos integrate)
- (extensive) features
- (complex) classes

Keep in mind, you may also need to modify the design documentation of the
architecture components above and below your component so it reflects the
existence of your new contribution.

.. note::

   What constitutes an extensive feature or a complex class is up for debate,
   but as a rule of thumb if someone isn't going to figure out how your
   feature/class works from the API and a couple seconds of perusing the
   source, you probably need design documentation.

Project-wide design documentation lives in this repo's documentation. This
includes documentation governing how the GitHub organization interacts with
various stakeholders and how the repositories in the organization interact.
Design documentation for features/classes that live in a specific repository
should be added to the documentation of that repository. All repositories
presently contain a ``docs/source/design`` directory where design documentation
should be placed.
