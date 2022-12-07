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

.. _prs_and_nwx:

###############################################
NWChemEx Community Guidelines for Pull Requests
###############################################

Pull requests (PR)

*************
What is a PR?
*************

A PR is a GitHub feature used to contribute changes to a GitHub repo. More
specifically, each GitHub repo contains one or more branches. When you
want to modify one of those branches you:

#. Fork the target repo on GitHub
#. Clone the fork on you local machine
#. Make a new branch in your local copy.
#. Make the changes to the new branch
#. Push the modified branch to the fork on GitHub
#. Open a PR on the target repo asking the maintainers to pull the branch from
   your fork.

*******************
Why do We Need PRs?
*******************

The master branch of each repo is considered the "single source of truth." As
a community we need to do our best to make sure this branch is the best it can
be and conforms to the design and vision of the project. Bluntly speaking, the
primary point of a PR is to make sure contributions do not invalidate the single
source of truth by breaking the code, or moving the code in an inconsistent
direction. That said, particularly in a large project like NWChemEx it can be
almost impossible for any one person to fully understand what can break any
given component or for any one person to comprehend the entire design and
vision. The point being, while PRs do protect against malicious attacks, they
are primarily meant to avoid accidental breakages. Part of this is through
automated continuous integration pipelines (making sure the code builds and
tests pass, etc.) and part of this is through manual code review, *i.e.*,
having people read your code.

Modern PRs are about more than just code review, they also are meant to be
learning opportunities for both experienced and inexperienced coders. Again,
no one person knows every aspect of a code, so when you make a PR it may turn
out that the reviewer knows a better way to do something. This works both ways
and reviewers often learn new techniques or discover previously unknown
features by reviewing code.

PRs are also about staking a claim. When you open a draft PR you're telling
people that you are going to work on resolving a bug etc. This tells other
people not to.


*****************
PR Considerations
*****************

This section lists considerations for authors and/or reviewers of PRs.
Following semantic versioning, we can think of each PR as addressing one of
three use cases:

#. API breaking changes

   - Any change to a public-facing API which breaks previously working code.

#. New features

   - Introduces new code without breaking the API
   - New alternative APIs
   - Allows the code to compute new things
   - Quality of life improvements (e.g., extensive optimization)
   - Entirely new documentation sections

#. Patch

   - Largely modifies existing code
   - Bug fixes, typos, documentation tweaks
   - Performance optimizations spanning a couple lines of code

In general PR considerations are going to be highly tied to what the PR wants
to accomplish, the following subsections group considerations into which of the
the three use cases they address.

General Considerations
======================

- Channels for discussion between reviewers and the PR author.
- Start early to get on radar of reviewers
- Sufficiently explain what is and is not in scope for the PR
- Each PR should have a lifetime of no more than 2 weeks!!!

API Breaking Changes
====================

- Require detailed explanation why the API must break.
- What has been tried to avoid the break?
-
