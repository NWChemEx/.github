****************
reST Cheat Sheet
****************

The purpose of this page is to provide a convenient resource for quickly
becoming familiar with ReStructured text (reST) as commonly needed in
documenting NWChemEx.

Terminology
===========

reST is an extensible markup language, which means it's a bit more complicated
than say Markdown. This complication comes from some additional concepts.

- roles: These are the qualifiers on inline text

  - *e.g.*, ``:math:\alpha``

- directives: These markup blocks of text

  - *e.g.*, ``.. math::``

Basic Text Formatting
=====================

- Italics: ``*text to italicize``

  - Result: *text to italicize*

- Bold: ``**text to bold**``

  - Result: **text to bold**

Math
====

To write inline math use the ``:math:`` role:

.. code-block:: rest

   The area, :math:`a`, of a circle of radius :math:`r` is :math:`a=\pi r^2`

Result:

   The area, :math:`a`, of a circle of radius :math:`r` is :math:`a=\pi r^2`

To make a block of math use the ``.. math::`` directive:

.. code-block:: rest

   .. math::

      a = \pi r^2

Which renders as:

.. math::

   a = \pi r^2


Equations in a math block can be aligned in the usual LaTeX way (*i.e.*, with
``&``):

.. code-block:: rest

   .. math::

      \widehat{H}\Psi &= E\Psi \\
      \widehat{H}     &= -\frac{1}{2}\sum_{i} \bigtriangledown^2_i -
                         \sum_i \sum_A \frac{Z_A}{\mathbf{r}_{iA}} +
                         \sum_{i > j} \frac{1}{\mathbf{r}_{ij}} +
                         \sum_A \sum_B \frac{Z_AZ_B}{\mathbf{R}_{AB}}

which shows up as:

.. math::

   \widehat{H}\Psi &= E\Psi \\
   \widehat{H}     &= -\frac{1}{2}\sum_{i} \bigtriangledown^2_i -
                      \sum_i \sum_A \frac{Z_A}{\mathbf{r}_{iA}} +
                      \sum_{i > j} \frac{1}{\mathbf{r}_{ij}} +
                      \sum_A \sum_B \frac{Z_AZ_B}{\mathbf{R}_{AB}}

To simplify writing complicated math equations you can define LaTeX commands in
a math directive:

.. code-block:: rest

   .. math::
      
      \newcommand{\bra}[1]{\left\langle{#1}\right|}
      \newcommand{\ket}[1]{\left|{#1}\right\rangle}
   
      \bra{\psi} = \left(\ket{\psi}\right)^\dagger

which renders as:

.. math::
    
   \newcommand{\bra}[1]{\left\langle{#1}\right|}
   \newcommand{\ket}[1]{\left|{#1}\right\rangle}
   
   \bra{\psi} = \left(\ket{\psi}\right)^\dagger

Commands defind in a math directive are good for the page, so:

.. code-block:: rest

    .. math::

       \ket{i} = \sum_{\mu}C_{\mu i}\ket{\mu}

renders as:

    .. math::

       \ket{i} = \sum_{\mu}C_{\mu i}\ket{\mu}

without needing to redefine the ``\ket`` command.

To make aliases for inline math the best solution I have found is to do:

.. code-block:: rest

   .. |fock_matrix| replace:: :math:`f_{\mu\nu}`

   The :math:`\mu\nu`-th element of the fock matrix is |fock_matrix|.

Which renders as:   

.. |fock_matrix| replace:: :math:`f_{\mu\nu}`

The :math:`\mu\nu`-th element of the fock matrix is |fock_matrix|.

Code Blocks
===========

Code blocks are done with the ``.. code-block::`` directive. To get syntax
highlighting you can specify the language after the ``::``. For example:

.. code-block:: rest

   .. code-block:: python

      import os
      print("The current directory is: " + os.getcwd())

which renders as:

.. code-block:: python

   import os
   print("The current directory is: " + os.getcwd())
   
FAQs
====

#. How do I have URLs with the same generic link text?

For example the following reST will give rise to
the warning ``WARNING: Duplicate explicit target name: "here"``:

.. code-block:: rest
   
   See `here <https://github.com/NWChemEx-Project/DeveloperTools>`_ or
   `here <https://github.com/NWChemEx-Project/NWChemEX>`_ for a really
   cool repo.

This problem is caused by the fact that Sphinx automatically creates a 
target for your link based on the link text. To avoid this problem you
can make the link have an anonymous target. This is done by using two
underscores at the end like:

.. code-block:: rest
   
   See `here <https://github.com/NWChemEx-Project/DeveloperTools>`__ or
   `here <https://github.com/NWChemEx-Project/NWChemEX>`__ for a really
   cool repo.   

   
