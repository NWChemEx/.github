.. _philosophy:

###################
NWChemEx Philosophy
###################

NWChemEx, the software package, strives to be the *de facto* choice for running
high-performance quantum chemistry calculations on platforms ranging from
laptops to the world's largest supercomputers. This requires a software package
which is:

- portable,
- user and developer friendly,
- and above all else performant.

The above will not happen by accident and require careful planning and community
efforts. To accomplish this goal, NWChemEx's overall design has adopted two
philosophies:

- Separation-of-concerns: We strive to decouple pieces to the extent possible.
- Top-down: APIs at each level are designed to only expose what that level
  needs, details needed by lower levels are hidden.

Admittedly these philosophies may seem at odds with our driving goal. After all
there is a long history of achieving performance using tightly coupled code with
little to no abstraction. However many of the legacy high-performance codes were
designed over 30 years ago. Since then the computational chemistry community
has:

- greatly improved their software engineering skills,
- recognized the importance of good software infrastructure, and
- embraced object-oriented programming (OOP)

The latter in particular is a key component to achieving our philosophy as it
allows us to pretty much have whatever API we want and hide the details in
otherwise opaque objects. Admittedly, heavy usage of OOP abstractions come with
their own costs:

- design complexity,
- higher learning curves, and
- compiling costs

Our design attempts to place the brunt of these costs on the more experienced
developers, leaving the more novice developers to use the objects like a domain
specific language. In this scenario everybody wins; developers wanting to test
out new chemistry can do that easily, whereas developers wanting to improve
performance can do so without impacting the chemistry development.
