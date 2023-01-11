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

TL;DR Pull Requests (PRs) are the most natural way to update a project hosted
on GitHub. We have created a PR template to help PR authors include enough
detail for reviewers to do their job. And we have suggested workflows for
authors and reviewers.

*************
What is a PR?
*************

A PR is a GitHub feature used to contribute changes to a GitHub repo. More
specifically, each GitHub repo contains one or more branches. When you
want to modify one of those branches you open a PR with the suggested changes.
Maintainers of the branch then determine whether or not they want to pull your
changes into the branch. Often this is an iterative process where the branch
maintainers request changes to the PR before they will merge it.

A full tutorial on PRs, tailored to the NWChemEx-Project organization, is
given in the :ref:`nwx_github_pull_requests` section.

*******************
Why do We Need PRs?
*******************

The master branch of each repo is considered the "single source of truth." As
a community we need to do our best to make sure this branch is the best it can
be and conforms to the design and vision of the project. Bluntly speaking, the
primary point of a PR is to make sure contributions do not invalidate the single
source of truth by breaking the code or moving the code in an inconsistent
direction. That said, particularly in a large project like NWChemEx, it can be
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
people not to duplicate the effort and/or gives them a chance to join the
cause.


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

#. Patches

   - Largely modifies existing code
   - Bug fixes, typos, documentation tweaks
   - Performance optimizations spanning a relatively small amount of code

In general the PR considerations are going to be highly tied to what the PR
wants to accomplish, the following subsections group considerations by use cases
and assume archetypal PRs. In other words, not all points are going to be
relevant to every PR. If they're not relevant for a specific PR they should be
ignored.

General Considerations
======================

#. Making a PR should be easy.

   - If it's too hard to make a PR people won't do it.
   - Setting the bar too high discourages new contributors.

#. It should be possible to open the PR early.

   - Channel for discussion between reviewers and the PR author.
   - Gets work on radar of reviewers and other developers.
   - Time to hash out what is and is not in scope before time is wasted

#. The PR's lifetime should be short.

   - Shoot for merging in less than two weeks.

     - Long-lived PRs are typically overlooked in ongoing design
     - Easy for new changes to break correctness/performance of long-lived PR
     - Others can't leverage your feature if it's a PR )
     - PR author needs to keep PR up to date, which can be a lot of time if the
       PR is long-lived
     - Hard to remember subtleties over life of long-lived PRs (*e.g.*, why
       something was/wasn't done)
     - The longer the PR lives, the more code it tends to contain, and the harder
       to review
     - Long-lived PRs tend to increase the amount of technical debt by seemingly
       justifying the "let's just merge this" mentality

   - Merge function by function if necessary
   - See :ref:`using_issues_to_track_progress` for tracking progress.

#. Code submitted as PRs should adhere to the organization's standards.

   - Important for continuity
   - Makes code reviews easier
   - Current standards:

      - :ref:`cxx_conventions`.
      - :ref:`python-coding-conventions`.
      - :ref:`rest_conventions`.
      - :ref:`doxygen_conventions`.

#. PRs should contain code of high-caliber.

   - NWChemEx strives to be an exemplar package
   - Easier to maintain good code
   - High-quality is especially important for senior developers as new
     developers look to your code for examples
   - There is a time and place for "just get something working", but should
     ideally be avoided

API Breaking Changes
====================

#. Breaking API should be a last resort.

   - Maintaining stable APIs leads to users and developers instilling trust
     in us.
   - Need to document what was tried to avoid the break.

#. Need a plan to avoid breaking the APIs again.

   - Determine breakage points
   - Update design documentation relying on old API.
   - Carefully plan design of new API to avoid another break
   - Test new API

Features
========

#. Need to avoid the "Hit by a bus" scenario.

   - The NWChemEx code base needs to be maintainable by multiple developers.
   - Knowledge needs to be discoverable and shared
   - Design Documentation helps other developers understand the feature
   - User documentation makes sure users can use the feature without needing to
     read the code/ask a developer.
   - Developer documentation for technical aspects, avoids the costly exercise
     of reverse engineering how algorithms work.

#. Features need to be tested.

   - As a scientific code we need to be reliable and reproducible.
   - NWChemEx is a big project, so it can be very difficult to understand
     ramifications of a change. These changes can be caught by appropriate
     testing.


Patches
=======

#. Patches are often small and ready to go upon opening PR.

   - Don't require PR to be opened in advance.

#. Not all feature considerations are applicable to patches.

   - Documentation usually not needed for bug fixes.
   - Need tests to ensure bug doesn't appear again.
   - New documentation usually doesn't need new tests.
   - Snippets added to documentation do need to be tested.
   - Performance updates may require updating documentation if it affects
     behavior and/or use cases, *e.g.*, the method's scope may have expanded.


*****************
Current PR Policy
*****************

Based on the above considerations our current PR policies are listed below.

Pull Request Template
=====================

.. note::

   GitHub supports PR templates (although as of this writing 12/8/2022) they do
   not seem to support the same feature set as issue templates (and some of the
   information seems outdated, like being able to have a separate directory).
   Should this get fixed we should look into multiple PRs for the different use
   cases.

We have written a PR template to streamline the process of opening PRs. The
template is designed to have meaningful prompts that can be filled out quickly.
The prompts ask the author to:

#. specify what sort of PR this is (major, minor, or patch)
#. describe what's in scope for the PR
#. describe what's not in scope for the PR
#. confirm that they have done documentation, etc., and
#. (for drafts only) listing what still needs to be done.

Why these prompts? The first prompt is for categorizing the PR (and
automating the resulting semantic versioning that needs to happen). The next
two relate to ensuring that the reviewer knows what is supposed to be in the PR
and what is not. The fourth prompt is to hopefully avoid the reviewer needing
to explicitly ask for documentation, etc. And the fifth is to give a rough
idea of what still needs to be done before the PR can be merged.

The template contains comments which explain the prompts in more detail.

PR Author Process
=================

.. note::

   The contents of this section provide the motivation for
   :ref:`nwx_github_pull_requests`.

Once an author has decided to work on a feature or patch they should open a PR.
This entails:

#. Start a branch ``b`` for the PR.
#. Initiate a draft PR from ``b`` to the target branch (usually master/main).
#. Fill out the PR template GitHub prompts with.
#. Continue to push changes to the branch (checking off tasks as appropriate).

   - Generally speaking changes should clearly identify todos raised by the
     change, *e.g.*, if you add a function, but don't document it. Put
     ``TODO:document me``.
   - This helps reviewers know what you've overlooked vs. what you just haven't
     gotten around to.

#. Notify the reviewers when the author thinks that ``b`` is ready to merge
   by messaging ``r2g`` (or something similar) in the PR conversation.
#. Respectfully address any reviewer concerns. Marking each one as resolved when
   it has been addressed.
#. If the PR has changed return to item 5.
#. The last approving reviewer merges the PR after all CI workflows pass.

.. note::

   For PRs whose description requires more than a couple sentences. The author
   should open a corresponding issue with the full description. The issue is
   for tracking the design, scope, concerns, etc. that the PR should address.
   The PR itself is for discussing how the PR author literally chose to
   implement the feature, patch, etc.


Review Process
==============

.. note::

   GitHub allows reviewers to suggest changes. This is very useful when there's
   a typo, formatting error, etc. Please use this feature rather than
   writing comments like "should be capitalized".

Reviewers of a PR are expected to:

#. Understand what the PR is supposed to accomplish.
#. If necessary, the reviewers should help the author refine the PR contents.

   - Should the PR (and corresponding issue) be split into multiple issues/PRs?
   - Did the author miss any obvious concerns?

#. Keep an eye on the PR as it progresses. The frequency of "check-ins" should
   be inversely proportional to the author's familiarity with the process,
   *i.e.*, keep a closer eye on newer authors than seasoned veterans.
#. Comment on the code when issues are spotted.

   - Is the code using existing infrastructure to the extent possible?
   - Is the code accruing technical debt?
   - Is the formatting consistent? (Don't worry about formatting which CI will
     fix)

#. When the PR is marked as ready to go, complete a final pass through the code
   flagging any potential issues.
#. If issues arise, work with the author to resolve them. Repeating the previous
   steps as necessary.
#. If you are the last reviewer to approve a PR then merge it (assuming all
   CI workflows have passed).

Notes on PR Quality
===================

.. note::

   The contents of this section are written assuming a 1.0 has occurred. We
   admittedly have not lived up to the lofty standards of this section and
   part of getting to a 1.0 is making sure existing code meets or exceeds
   these standards.

.. note::

   Occasional contributors from outside the project are not the target of this
   section. This section is targeting developers who are regular contributors
   to the code (part of the team).

NWChemEx is designed to be a modular code. The vast majority of electronic
structure development occurs in modules. Each of these modules are disjoint,
and can be separately hosted. The checklist on the PR template is admittedly
asking a lot of the author. If you are working on new research (as opposed to
say adding a well known feature) then, you can (and should) go through the
"just get something working" phase outside of the NWChemEx repositories. Once
you have hashed out your design, and decided that the feature is worth
contributing back, then you should begin the PR process, *i.e.*, rapid
prototyping should be done external to NWChemEx.

When you open a (draft) PR for adding a module into an NWX repository you are
saying that you think that the module will be useful, should be supported, and
that you are willing to get the first version of the module up and running.
This does not necessarily mean that upon merging the PR the module is as
performant as it is going to get, or that the module is fully featured (both
of which can be addressed in subsequent PRs). Once the module is merged it
becomes available to users, and since taking it back would break any code that
uses the module, we as a project are obligated to support that module (or
break an API to retract it). The point being, before merging the PR we expect
the module to be fully documented, tested, and to adhere to the organization's
standards so that we can begin stewardship of the module. As a slight aside,
many electronic structure features take a while to implement. If this is the
case for your feature, open an issue to track progress (see
:ref:`using_issues_to_track_progress`) and break the module implementation down
into pieces, *e.g.*, PR one is design, PR two is some low level functions, PR
three combines the functions, etc.

For PRs addressing infrastructure, the requirements are a bit different.
When developing a module, the stability of the property type APIs helps ensure
that your module will remain compatible with the rest of NWChemEx, even if it
takes you a while to develop the module. Property types do not exist for
infrastructure, and infrastructure necessarily needs to be developed in a much
more coupled manner. To facilitate rapid merging of infrastructure, we thus
allow some technical debt, as long as the developer is willing to repay that
technical debt, and makes a plan for repaying it. In practice what this means
is, say you really need a new type of cache to complete a run. We'll let you
merge that cache, say without documentation, as long as you open an issue
tracking that documentation is still needed. Developers are expected to repay
technical debt in a relatively timely manner. That said, since the
infrastructure is going into the main repository, it still needs to be vetted
before it can be merged. In turn, infrastructure cannot still be in the
design phase, nor can it be untested.


*********************
Future Considerations
*********************

As of 12/8/2022, GitHub is overhauling the issue templates and adding issue
forms. We anticipate that PR templates will get the same treatment. If this
happens, we should revisit the template and try to make it mesh better with
CI. For example:

- Automate tagging for versioning.
- Having content of the template update/change based on user feedback.
- Auto-assigning reviewers.
- Not marking a PR as ready to go until all items have been addressed (I'm
  thinking the author needs to confirm they've added documentation etc. before
  the PR can be made ready to go).
- Ideally we should automate as much of the required checklist as possible.
