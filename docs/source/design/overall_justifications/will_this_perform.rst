###############################################
Sure it Looks Pretty, But is it Going to Scale?
###############################################

:ref:`why_object_oriented_programming` explained why we opted for an OOP
paradigm. To some extent this section continues that discussion, but in the
context of whether or not OOP is just "syntactic sugar" or if it actually allows
one to write performant code, that looks nice too. Put another way, this section
justifies why we can adopt a top-down philosophy (design the pretty API, then
worry about performance) and expect it to perform well.

The short answer is, OOP really is just "syntactic sugar". We proposition,
without proof, that everything on this page can be accomplished with functional
programming (FP) as well. By this we mean: it is possible to design an FP
interface that could accomplish the same tasks, in a similar number of code
statements (as a hand-wavy proof realize that class methods are basically just
functions whose first argument is the object they were called on). However,
without defining new types for that FP interface, the result would look much
nastier, e.g., there would be 10s of (if not 100s of) input parameters (yes
there's a lot rolled up into a class, but with the right design you don't need
to worry about all the state), and several nested functions per call. That said,
historically, at least within electronic structure theory, code written using FP
does not attempt to reach the level of generality we discuss here (likely
because of how unwieldy the API would be). This is another perk of OOP,
through abstraction, we can tackle very complicated problems by relatively
straightforward means.

One of the first things to keep in mind is that there are layers to the program.
There are a lot of layers separating the user's input from functions like
``dgemm``. As input traverses the layers it gets upacked  and processed. By time
you get to something like ``dgemm`` you've handled all of the other concerns
aside from the needed matrix multiplication. This is important to note because
the appearance a high-level object is designed to give off can be very different
than what it actually maps to. Case in point are tensors. With the way our
tensors work you can write building J and K like:

.. code-block:: c++

   simde::tensor_t P, I, J, K; //Assume P and I are initialized
   J("mu,nu") = P("lambda,sigma") * I("lambda,sigma,mu,nu");
   K("mu,nu") = P("lambda,sigma") * I("lambda,nu,mu,sigma");

For readers familiar with the intricacies of J and K builds, you may say "sure
you can write it that way, but it's not efficient". Turns out, through the magic
of abstraction, the code above is capable of being used as a(n):

- in core build (all tensors explicitly formed and stored in memory)
- disk build (all tensors explicitly formed, but ``I`` is stored on disk)
- core-disk hybrid (all tensors explicitly formed, only some pieces of ``I`` are
  put on disk)
- direct build (``I`` is not explicitly formed, blocks are formed on the fly)
- semi-direct build (expensive parts of ``I`` are stored in memory, cheap are
  recomputed on the fly)
- some hybrid of all of the above

Furthermore, the code is actually capable of:

- fully exploiting symmetry
- fully exploiting sparsity
- running in a distributed fashion
- running asynchronously
- running on CPUs and/or GPUs,
- being optimized for other architectures (e.g. FPGAs)

(Disclaimer: as of writing this, the code above does not actually have all of
the aforementioned properties. However the properties described can be added to
the tensor library in such a manner that the code benefits from them without
needing to be rewritten. Furthermore, when the additional considerations are
added to the tensor library they will not only be available to the J/K  build,
but throughout other modules as well.)

So how can one little snippet of code do so much? We're not going to go into all
of the details, but here's the highlights:

- The calls above actually build a task graph, before any real work is done
- From the size of the tensors we know how much work each task requires
- By having runtime information about the computer we know the amount of
  resources (nodes, CPUs, GPUs, memory, disk, etc.) available to us
- Using the above information the task graph can be inspected and optimized

One of the criticisms commonly leveraged about the above is that the complexity
is still there, it's just hidden. This is true. There really is a code path
which unrolled looks like a direct J/K build would in an FP code, i.e. something
like:

.. code-block:: c++

   // This is pseudocode that omits some details, like the prefactor
   for(auto IJ : screened_shell_pairs){
        for(auto KL : screened_shell_pairs){
            if(KL > IL) continue;
            auto I = compute_shell_quartet(IJ, KL);
            if(I == 0) continue; // integral screening
            for(auto mn : IJ){
               for(auto ls: KL){
                   if(ls > mn) continue;

                   J[mn] = P[ls] * I[mnls];
                   J[ls] = P[mn] * I[mnls];
                   K[ml] = P[ns] * I[mnls];
                   K[vl] = P[ms] * I[mnls];
                   K[ms] = P[nl] * I[mnls];
                   K[ns] = P[ml] * I[mnls];
               }
           }
       }
   }

However, instead of the user having to explicitly write such a pattern, our
objects automatically dispatch to this pattern based on resources available, the
symmetry of the tensors, which tiles are important, the fact that ``I`` is being
recomputed each time it's called (so we want to fully utilize a block before
throwing it away), and the equations for the target results (J and K). The point
is that while the complexity is still there, we argue it is easy for users to
use (the DSL makes it look like a tensor expression versus nested loops) and the
implementation is more general and extendable (being applicable to, for example,
the four-index transform of correlated methods).

The other concern one may have is what about object overhead? It is true, there
is a cost for inheritance, the increased number of function calls, and the other
OOP practices. More often than not, our experience shows that worrying about
such things is a premature optimization. With aggressive optimizations,
compilers have gotten really good at eliminating the overhead associated with
OOP. That said, in C++ one can usually resort to template meta-programming
techniques to remove much of the remaining runtime overhead (albeit at the cost
of longer compile times and larger binaries). Furthermore, the layered approach
means that we can merge two layers if need be, without having to rewrite all of
the layers on top of or under those layers (assuming APIs remain constant).

Finally we note that in this section we focused on tensors, primarily for their
easy to grasp DSL. The same logic applies to all objects. By considering the API
and implementation of each object to be two different things, one essentially
gets a series of layered DSLs. Each DSL allows you to expresses the intent of
the computation divorced from how the computation is actually done. This makes
it easier for the people above the DSL to interact with that layer, while still
providing the developers of that layer all the necessary resources to optimize
that layer.
