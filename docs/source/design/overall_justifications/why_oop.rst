.. _why_object_oriented_programming:

################################
Why Object-Oriented Programming?
################################

The decision has been made to use object-oriented programming (OOP) throughout
NWChemEx. This page explains why.

The summary: OOP is, in our opinion, easier to use for encapsulation and
extending the code.

Dating back to the earliest electronic structure codes, there has been a strong
propensity for using functional programming (FP) paradigms. Even some of the
modern codes which purport to adhere to OOP have very strong FP components (vide
infra). Furthermore, FP is the work horse of high-performance computing (HPC).
So why go against the grain?

*********
FP vs OOP
*********

Let's start with the difference between FP and OOP. For this purpose let's
consider a simple application. We want:

- A general API for computing the area of a shape
- For simplicity we only worry about squares and triangles, but the design
  should be extensible.
- Computing the area should be a separate concern from determining which formula
  to use (if computing the area was harder this would make it easier to optimize
  a specific area formula without disturbing the rest of the code).

The FP approach may come up with something like:

.. code-block:: c++

   double triangle_area(double base, double height) {
       return 0.5 * base * height;
   }

   double square_area(double base, double height) {
       return base * height;
   }

   double compute_area(int n_sides, double base, double height) {
       if(n_sides == 3) return triangle_area(base, height);
       if else(n_sides == 4) return square_area(base, height);
       /* if you get here raise an error in your favorite way (error code, or
          crash)*/
   }

and the OOP approach might come up with:

.. code-block:: c++

   struct Shape{
       Shape(double base, double height) : m_base(base), m_height(height) {}
       virtual double compute_area() = 0;

       double m_base;
       double m_height;
   };

   struct Triangle : Shape {
       Triangle(double base, double height) : Shape(base, height) {}
       double compute_area() { return 0.5 * m_base * m_height; }
   };

   struct Square : Shape {
       Square(double base, double height) : Shape(base, height) {}
       double compute_area() { return 0.5 * m_base * m_height; }
   };

The primary difference between the approaches is that in the FP approach the
problem is solved primarily by using functions, whereas in the OOP approach its
solved by defining and implementing objects.

Comparing the two examples one may note:

- Both succeed in achieving the desired encapsulation
- Extending either approach is about the same amount of work (define a new
  function, register it)
- The FP approach is arguably simpler (less lines, no abstractions)
- The OOP is less-coupled (can just derive a new class, no need to
  change ``Shape``). The FP approach requires modifying the ``compute_area``.

Admittedly one may try to dismiss the last point by pointing out that
``compute_area`` could be modified to take a list of callbacks and a list of
what shape those callbacks are for. This is a valid point; however, it's perhaps
worth nothing this is basically a manual implementation of inheritance and
arguably brings with it the complexities of OOP most FP programmers are trying
to avoid in the first place.


Additional FP vs. OOP Remarks
=============================

Particularly if you look at an article like
`this one <https://betterprogramming.pub/object-oriented-programming-the-trillion-dollar-disaster-92a4b666c7c7>`__,
you may see a number of additional FP vs. OOP comparisons. Largely based on the
aforementioned article some of the other comparisons between FP and OOP are:

- OOP languages tend to have more language options
- OOP tends to have shared mutable state
- OOP is harder to refactor
- OOP is harder to unit test


***********
So Why OOP?
***********

The discussion above is heavily biased against OOP, so why would we still
want to use it vs. FP?

First, it is worth noting that design plays a huge role in how good a code is.
A well thought out design avoids many of the OOP criticisms stated above. As
evidenced by many of the legacy codes in the field of electronic structure
theory, FP alone will not make up for bad (or lack of a) design. For example,
many of the legacy electronic structure codes have resorted to shared state to
avoid massive refactoring efforts (keep in mind files are shared state...) and
many of them have gotten so coupled that refactoring is impractical. Perhaps
you might argue that it's harder to design a code which relies on OOP than on
FP. At least for our purposes, this is a bit of a moot point, since if you're
reading this then you don't have to worry about designing NWChemEx because it's
already been designed (and we'll toot our own horn and claim that the design is
good).

Despite criticisms to the contrary, the main reason we have opted for OOP is
that we feel that using OOP it is far easier to encapsulate state than with FP.
At the end of the day, there is some set of inputs that each underlying
algorithm needs in order to function. As the underlying algorithm evolves that
set of inputs may change (think targeting new platforms, better approximations,
etc.). With strict FP the only way for the function to get that additional state
is to modify the call signature (or use some shared state, which we want to
avoid); unfortunately, if you modify the signature of a low-lying function you
often need to modify the signatures of all of the calling functions. With OOP
you can simply add a member variable to the object and be on your way. The
caveat is that it should make sense to add that member to one of the objects,
e.g. letting a triangle forecast the weather doesn't make much sense from a
design standpoint; if your function takes triangles and needs to forecast the
weather then you probably should just admit that the original design missed a
use case and add another field to the function. But doesn't that make it more
complicated? Strictly speaking, it's not any more complicated than the FP
approach. You now have one additional piece of data and each function touching
that data can choose to use it or ignore it.

Another major reason for opting for OOP is ease of extension. We want
NWChemEx to be extendable. Science is continually evolving and the code needs to
evolve with it. Inheritance is minimally invasive and can be done without
modifying the source code. When combined with the encapsulation point, this
means extension is easier because developers only need to worry about
implementing the function they are overriding in the context of the provided
state.

Some other reasons:

- For better or worse OOP is also familiar to the current generation of
  programmers.
- In HPC there is a move to C++/Python which are object-oriented languages.
  Using C++/Python lets us better capitalize on other libraries

That all said, most developers of NWChemEx will be writing plugins; since
plugins can be written in either C++ or Python (and both languages support OOP
and FP) those developers can use OOP or FP paradigms in their plugin. The point
being the decision to use OOP primarily affects the developers of the NWChemEx
infrastructure, not plugin developers who are free to make their own decisions
(although the latter do have to contend with it at the APIs).
