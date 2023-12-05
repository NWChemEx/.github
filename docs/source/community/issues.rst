.. Copyright 2022 NWChemEx
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

.. _issues_and_nwx:

########################################
NWChemEx Community Guidelines for Issues
########################################

The TL;DR is that the NWChemEx community has elected to use GitHub for hosting
the source code of NWChemEX. Issues are well integrated into the GitHub
ecosystem and thus we will use Issues for logging bug reports, and tracking
user feedback. User feedback includes, but is not limited to: feature requests,
performance concerns, questions related to the code, and suggestions.

This page is an academic look at issues. For tutorials on how to use issues,
from the perspective of the NWChemEx organization, see :ref:`nwx_github_issues`.

*************************
What are (GitHub) Issues?
*************************

GitHub introduced Issues for planning and tracking work that needs to be done
on a code base. The basic idea is any time you find a bug, think of a feature
which would be cool, find an algorithm which runs slow, or can't find
documentation to answer a question you have, you open an issue. If you're a
developer, you can then use Issues as a task list. If you're a user, you can
use Issues to give feedback to the code developers.

For a tutorial on using GitHub issues within the NWChemEx organization
see :ref:`nwx_github_issues`.

**********************
Why Do We Need Issues?
**********************

As much as we wish it weren't true, NWChemEx can always be improved. When we
find something that could be better, we need to fix it. Often times
we're in the middle of something else and don't want to drop everything
to address the problem. This is where Issues can help. Using Issues we are
able to track tasks and make the code better.

.. _issues_use_cases:

**********************************
What Do We Want to Use Issues For?
**********************************

#. Bug tracking and pull requests.

   - It's easy to open an issue, link it to a line of code, or type a quick
     description.
   - "TODO" statements in PRs or other Issues get forgotten (there's GitHub
     integrations for turning
     them into issues. This is very convenient for avoiding context switching
     from the code to GitHub to open the issue.).
   - Emails, Slack conversations, forum posts, etc. get lost/forgotten.

#. Feature Requests

   - Most new features require some planning.
   - Opening an issue starts the process.
   - Issues integrate easily with GitHub Projects, facilitating organization.

#. Work Planning

   - Similar to feature requests, but more general.
   - Documents individual tasks in a longer sprint (not necessarily a feature).
   - Issues are natural building blocks for GitHub Projects.

#. User to Developer Communication

   - Bug tracking and feature requests are specific use cases.
   - Users can ask questions.
   - Users can provide other feedback (code is slow, hard to use, etc.).
   - Users can see challenges that other users are having.


******************
Issue Alternatives
******************

To provide background, this section explores some of the other alternatives to
GitHub Issues. This is
far from exhaustive and just represents some other options we considered.

GitHub Discussions
==================

Over the years GitHub has rolled out many communication features. To help GitHub
users navigate the options, GitHub provides guidance
`here <https://docs.github.com/en/get-started/quickstart/communicating-on-github>`__.
The take-away is that of all the GitHub communication features, issues most
overlaps with Discussions.

Based on the aforementioned link, discussions is meant for forum-style,
open-ended communication. Discussions targets:

- questions not related to specific pieces of the code
- sharing news
- open-ended discussions
- announcements

This contrasts with Issues, which are supposed to be tied to specific lines of
code. These lines of code can be: in the repo already, planned, or part of an
invocation of the repo.

Slack, Forums, Email Servers, etc.
==================================

There are a variety of tools for "real-time" communication among users and
developers. Generally speaking the biggest problem with these options is that
they're not dedicated to tracking bugs/feedback, and bugs/feedback can get lost
in the noise. That said, in many cases it makes sense to talk about
bugs/feedback via these avenues when the bug report/feedback is still being
formulated. Once formulated, it's better to move the bug report/feedback to a
dedicated tool.

Jira
====

`Main page <https://www.atlassian.com/software/jira>`__.

Jira is a commercial software solution for tracking product development. At
this point the NWChemEx project is not at a point where we would use Jira for
anything beyond what Issues already provides. With the most recent changes and
improvements
in GitHub project boards, some of the Jira project management features are also
available in
a GitHub workflow. Thus it's not clear what the
benefit would be. It's possible that with a more thorough review of Jira this
opinion would change, but for now, the fact that Issues is free and well
integrate with GitHub make us prefer Issues over Jira.

Trello
======

`Main page <https://trello.com/>`__.

Before GitHub Projects Trello, was a very attractive option. Trello allows you
to create tickets, and organize them on kanban boards. Now, however, using
Trello just adds an extra synchronization step between the repo and the Trello
board.

Monday
======

`Main page <https://monday.com/>`__.

This winner of worst name (try googling ``monday`` and seeing how far you need
to scroll to find a relevant result) is arguably just a more advanced version
of Trello. Again, it's somewhat redundant with GitHub Projects, and it's use
just adds another synchronization step.

************************************
Using Issues in the NWChemEx Project
************************************

Ultimately because of how well Issues integrates with GitHub, the decision has
been made to use Issues. To address the considerations in
:ref:`issues_use_cases` we rely on Issue templates. The Issue templates for the
NWChemEx organization are kept in the ``.github`` repository in the
``.github/ISSUE_TEMPLATES`` directory. We presently have three templates:

#. Bug reports
#. Feature requests
#. Questions

(it's assumed that most user feedback will be questions, not statements).

The full details of project planning are beyond this page. What is relevant
here is that GitHub Projects are comprised of Issues. The idea is that when
a more involved feature or development effort is to be undertaken the team
creates a project board. In the project board, individual tasks are added as
Issues. As PRs are merged, the Issues are closed and removed from the project.

We also note that Issue templates hosted in the ``.github`` repository are used
as the defaults organization wide. They can be overridden on a repo by repo
basis by also defining Issue templates in individual repos.

*********************
Future Considerations
*********************

GitHub is currently (as of 12/9/2022) introducing issue forms. These are an
upgraded version of issue templates. Once available for private repos (or our
repos are all public) we should move to issue forms for a better user
experience.
