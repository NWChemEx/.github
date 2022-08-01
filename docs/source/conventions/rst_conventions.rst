##########################################
Conventions for Writing reST Documentation
##########################################

*****
Style
*****

The style of reST pages follows Python's
`conventions <https://devguide.python.org/documenting/#documenting-python>`_.
In particular:

- Follow the usual practice of at most 80 characters per line
- Indentation in reST is 3 spaces **NOT** 4

  - 3 spaces is natural for reST as this aligns with directives

********
Sections
********

Python's reST `conventions <https://devguide.python.org/documenting/#sections>`_
for denoting sections are:

- ``#`` with overline should be used for parts
- ``*`` with overline is for chapters
- ``=`` for sections
- ``-`` for subsections
- ``^`` for subsubsections
- ``"`` for paragraphs

The exact distinction between "parts", "chapters", *etc*. seems to be based
largely on how nested in the documentation a file is. For example, "parts" would
be topics in the top-level table of contents; in the case of DeveloperTools'
documentation the parts are: Project Conventions, Design Documentation, *etc.*.
Chapters are topics within one of the parts (*e.g.* this page is a chapter in
the Project Conventions part).

The definitions of parts, chapters, etc. are a bit annoying as they require
changing under/overlines in a potentially large number of documentation files if
andy refactoring occurrs. To avoid this, the NWX project adopts the convention
that definitions of parts, chapters, etc. are file specific. In other words,
the first title in a particular reST file should be considered the title of a
part; the first title within that part is considered a chapter, *etc.*. As a
more concrete example see the raw source for this file.
