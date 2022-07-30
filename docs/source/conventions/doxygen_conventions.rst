*************************************
Using Doxygen in the NWChemEx Project
*************************************

The purpose of this page is to give you a (likely less than 10 minute) primer on
how to use Doxygen particularly with respect to the NWChemEx project. The
NWChemEx project uses Doxygen to document C++ code. For documenting Python or
writing documentation pages like this one the project uses Sphinx's ReST flavor.

Intro To Doxygen
================

Doxygen allows you to document your C++ code in a minimally invasive manner.  It
does this by requiring you to write your C++ comments using Doxygen's markup
language. Bare-bones this looks like:

.. code-block:: c++

   /// This is a Doxygen, single-line comment for the following function
   void function1();
 
   /** For more extened documentation block comments are preferred.
    *
    *  This line is also part of the comment.
    */
   void function3();

Doxygen supports other conventions; however, the two above are the approved
conventions for the NWChemEx project.  For consistency please use them.

Doxygen has two types of comments: brief and detailed. Brief comments are
primarily used to give a reader a quick, one-line summary of a function, class,
*etc.*. By convention single line comments are always briefs, whereas the first
line (up to the first period)of a multi-line comment is the brief and the
remaining lines are the detailed description.  When making multi-line comments
it is good practice to start the brief with ``@brief``.  This will ensure that
the brief continues until the first blank line and will prevent surprises from
forgetting the period convention. ``@brief`` is an example of a Doxgyen keyword.
Keywords are signaled by the ``@`` symbol (there's another convention too, but
this is the one approved for NWChemEx) and have a special meaning to Doxygen.
There's a lot of
`keywords <http://www.stack.nl/~dimitri/doxygen/manual/commands.html>`_ and the
next section acquaints you with the minimum set of keywords that you must use
when documenting C++ code for use with NWChemEx.


Minimal Documentation Standards
===============================

By far the most useful keywords are shown in the following code example.  For
documenting a function this should be considered as a minimal acceptable
amount of documentation.  For documenting data members and types a single line
comment is often fine (just describing what it is).

.. code-block:: C++

   /** @brief This is the brief description of fake function 1.
    *
    *  Fake function 1 demonstrates the bare minimal documentation standards.
    *  What you are currently reading, is the detailed description that will
    *  show up in the documentation. The "*" border is optional, but
    *  encouraged.
    *
    *  @tparam T The type this function takes.  The documentation should tell
    *            you what concept it satisfies.
    *  @param[in] Param1 The first parameter; it's read-only.
    *  @param[out] Param2 The second parameter; it's going to be written to.
    *  @param[in,out] Param3 The third parameter; it's going to be read from
    *                        and written to.
    *  @returns Whatever this function returns.
    *
    *  @throws std::runtime_error Tell you when it throws and what exception
    *                             guarantee is afforded.
    */
   template<typename T>
   int function1(int Param1, int& Param2, int& Param3);

 Obviously the real documentation should be more helpful, but this illustrates
 the key things to document: brief, detailed description, input/output 
 parameters, return value, template type (or non-type) parameters, and 
 exceptions that are thrown (as well as the level of exception guarantee).
 
 Other useful commands to be aware of:

- ``@file`` for documenting files (particularly useful for files containing 
  many functions)
- ``@defgroup`` used to define groups for organizational reasons
- ``@ingroup`` for associating a file, class, member, *etc.* with a particular
  group
- ``@f$<latex here> @f$`` for adding on line Latex formulae
- ``@f{eqnarray}{`` for starting a Latex ``eqnarray`` (change the environment 
  name to get other environments), this environment is ended by ``@f}``
- ``@note`` for starting a note
- ``@warning`` for displaying a warning to the reader
- ``@bug`` for letting the reader know about a known bug
- ``@relates`` for free-functions associated with a particular class
