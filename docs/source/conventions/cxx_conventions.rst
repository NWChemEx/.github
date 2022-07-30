**********************
C++ Coding Conventions
**********************

This page introduces the NWX team's coding conventions for writing C++. All pull
requests are expected to adhere to these conventions. When possible
``clang-format`` will be used to enforce them; however, it is not possible to
automatically enforce all of these conventions. This page is primarily targeted
at conventions which you must manually adhere to, while ``ci/lint/clang-format.in`` is
the linting file used and should be consulted for the conventions which will be
automatically enforced.

Capitalization
==============

C++ is a case-sensitive language. For this reason it is extremely useful for all
coders on a project to use the same capitalization conventions, doing so avoids
needing to remember how a method, file, *etc.* is capitalized.

.. note::

   When describing capitalization formats the common choices are

   - snake_case        : All lowercase, underscores used to separate words
   - (upper) CamelCase : Each word is capitalized, no spaces
   - (lower) camelCase : Upper CamelCase that does not capitalize the first word
   - ALL_CAPS          : All letters are capitalized, underscores separate words

The common elements of a C++ code are listed below as well as how they should be
capitalized.

=================== ==========
Code Element        Case
=================== ==========
files               snake_case
namespaces          snake_case
classes             CamelCase
functions           snake_case
class members       snake_case
template parameters CamelCase
typedefs            snake_case
macros              ALL_CAPS
=================== ==========

The rationale behind these conventions is largely to match common C++ practices
such as those used by Boost and the STL. The only exception to this statement is
the decision to use CamelCase for class names. This decision stems from wanting
to distinguish between built-in types/classes from standard libraries and domain
specific classes.
