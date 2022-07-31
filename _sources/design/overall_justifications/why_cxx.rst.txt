.. _why_is_cxx_the_primary_language_of_nwchemex:

############################################
Why is C++ the Primary Language of NWChemEx?
############################################

:ref:`why_object_oriented_programming` explained our justification for using
object-oriented programming paradigms. This limits our choice of primary coding
languages to those which support OOP practices. We ultimately chose to go with
C++, in short because it is the popular language which still allows us to
achieve performance. This subsections below provide more details.

****************
Why Not Fortran?
****************

Fortran 2003 added support so that derived types can encapsulate both data and
features; furthermore derived types support inheritance. That's all the basic
underpinnings of OOP. The original NWChem was written in Fortran so writing
NWChemEx in Fortran would allow us to reuse NWChem source in NWChemEx and still
have OOP. Hence the titular question, why not Fortran?

The answer is going to ruffle some feathers, but Fortran (and FORTRAN; if you're
unaware FORTRAN distinguishes the legacy use of the language, typically defined
as before the 1990 revision, from Fortran, the modern use of the language) has
become a bit of a niche language. At this point saying Fortran is dying is
perhaps an overstatement since inertia seems to be preventing Fortran use
from declining further, hence preventing it from truly dying. That said, there
is not a large flux of incoming Fortran programmers. Most computer science
students have not learned it, and a growing number have never even heard of it.
For what it's worth students right now are typically learning Java, Python,
and/or C/C++. Vendor support is waning, as vendors right now are primarily
interested in ensuring legacy codes run, rather than spending large efforts
optimizing the compiled code. Even the champions of Fortran, the HPC community,
are moving away from it (e.g. look at the number of Exascale Computing Projects
which use C/C++ vs. Fortran).

Even if the previous paragraph doesn't dissuade you from the merits of writing
NWChemEx in Fortran, the reality is there is a severe lack of third-party
libraries written in Fortran. Particularly missing are Fortran libraries
supporting OOP. Thus we would need to reinvent a large number of wheels just to
use OOP and Fortran. Admittedly, compared to Java or Python, the number
of third-party C++ libraries is also not great, but support seems to be there
for most needs.

***************
Why Not Python?
***************

Python is right now one of the most popular languages, if not the most popular
language, in the world. With it's easy to learn syntax, abundance of tutorials,
and its plethora of modules, what's not to love? Furthermore Python is quickly
becoming the de facto language of choice for most scientific workflows and tools
that are not performance driven. So why not the lovable Python?

The big reason is our focus on HPC. At the moment anecdotal evidence suggests
that Python is about 100x slower than C++. Of course this depends on the exact
problem, the programmer's competency level, the Python implementation, the
C++ compiler, etc., but the point remains there's a significant overhead for
using Python versus C++. For a workflow that could be run in a millisecond in
C++, do most people care if in Python it now takes a tenth of a second? No, it's
almost imperceptible. However, if you have to do that call a million times
you've now made something which should take about 15 minutes, take over a day.
It's for this reason that a lot of performance critical pieces of Python still
rely on compiled code under the hood (e.g. NumPy). Even PySCF, the champion of
Python in computational chemistry, contains a significant amount of C under the
hood. So the point remains that Python just isn't at a point where it's suitable
for HPC, at least at the moment. Who knows, in 10 years this might change.

*************
Why Not Java?
*************

Like Python, Java is also one of the most popular languages in the world right
now. It's one of the most taught, if not the most taught language in the world.
Pretty much every computer science student knows Java. So why did we decide to
not go with Java?

The short answer is Java never seemed to catch on in HPC or scientific computing
for whatever reason (at least in the computational chemistry circles), and we
don't have any motivation to go against this trend. As for why Java hasn't
caught on, we can wager a guess that because FORTRAN to C isn't a big jump, when
people started shedding FORTRAN, C seemed welcoming. If you want to go a step
further and embrace OOP, then C++ is the next logical jump from C. Which may be
why C/C++ seem to be emerging as the HPC languages of choice. It probably also
helps that C++ came out about a decade before Java, so by time Java came out
there was already investment in C++. Particularly from the HPC perspective, Java
also leaves a lot to be desired as the underlying runtime is quite heavy.

************
Why Not XXX?
************

Look, there's a ton of other languages. We're not going to claim that we
evaluated every single one of them and ultimately decided that C++ was the best.
It's entirely possible that in 10 years we're going to regret our C++ decision
and really wish we went with Julia or something. We took a look at the languages
commonly being used in HPC (Fortran, C, C++, and Python) and based on the
explanations in the previous sub-sections we opted for C++.
