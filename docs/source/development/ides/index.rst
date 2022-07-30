.. _nwx-ide-development:

#########################
Using IDEs to Develop NWX
#########################

While you can develop code for NWChemEx purely from the terminal you'll probably
be more productive if you use an integrated development environment (IDE). IDEs
are intimidating at first, but once you get them setup, and log some hours,
you'll never go back to command line development again. Advantages of using an
IDE include (this is a union of features from across IDEs; most IDEs support
most of the features on this list, but they may not support all of them):

- Built-in debugging

  - Click to add break points
  - Easily inspect variable values

- Code inspection

  - Shows you errors/warnings without you having to compile
  - Can suggest best practices

- Code autocomplete

  - Auto inserts closing braces, brackets, etc.
  - Knows about classes, variables, etc. so you only need to type the first few
    letters

- Automatic formatting

  - No more forgetting to run ``clang-format``!!!!

- Typically a single click to build/debug
- Built in version control
- Syntax highlighting

  - Makes reading code much easier

- Code folding

  - Allows you to hide irrelevant parts of the code


The following sections focus on how to set-up various IDEs for developing NWX.
All of these tutorials assume that you have a directory set-up akin to that
suggested in the :ref:`development_preliminaries` section.

.. toctree::
   :maxdepth: 2
   :caption: Contents

   vscode/index
