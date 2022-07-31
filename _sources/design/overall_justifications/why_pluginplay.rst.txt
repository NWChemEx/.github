.. _why_do_we_need_pluginplay:

##########################
Why Do We Need PluginPlay?
##########################

NWChemEx relies heavily on a module system. This section explains why we went
this route.

**************************************************************
How Most Electronic Structure Codes Work (and Why That is Bad)
**************************************************************

Back in my day...Seriously though there is a long history of electronic
structure codes being executables that can only be controlled by changing a
text input. The executable's functionality could not be extended without opening
the source code, adding the new functionality, and then recompiling. This is
fine when you have a tight-knit group of developers all working on the same
code, but what happens when someone outside the circle wants to extend the code?
One way or another their contributions need to make it into your source. Maybe
they make a library, and you add a hook to call that library, or maybe they just
directly add the functionality to the source code. Either way the source needs
to change. By modern standards this isn't very extensible. If I can't access the
source code, then I can't extend it.

So why is this bad? First, science by its very nature is dynamic. New methods
are always coming out. Algorithms are improving. Theories are developed while
others are retired. Anytime one of these events happen your code needs to change
to keep up. Second, hardware isn't static. New hardware typically requires new
optimizations and considerations. In an ideal world once someone optimizes some
code, or develops a new theory they would release it as a library. Your code
would then be ready to absorb those changes, and propagate them throughout,
whenever the library is made available. Ideally this would be done in an
interoperable manner (meaning you literally do not have to change your code to
use the library). For the vast majority of electronic structure codes true
interoperability is impossible as the code needs to be changed to take advantage
of the new library. If it required only minor changes to add a library, this
would perhaps be a moot point. In practice, the aforementioned design means that
a tremendous amount of developer time needs to be spent to incorporate the
library (especially if it needs to be incorporated in multiple places).

******************************
The Current State of the Field
******************************

Admittedly, we're a long ways away from the ideal world described above, but we
are moving closer to it. It's not uncommon for developers to create stand alone
libraries with new and/or optimized functionality. Funding opportunities are
routinely making this a requirement. At the moment, true interoperability is a
pipe dream since no standards exist. Less glim, existence of these libraries
suggests that with the right code design it should be possible to leverage, and
propagate, the new functionality by wrapping it.

Another somewhat recent development is that team sizes are increasing, and
becoming spatially distributed. This means you have a lot of disparate
developers trying to work on the same package at the same time. The reality is
there is minimal communication among these developers (no stand-ups, rarely are
design sessions held, etc.). Without communication, the likely hood for
conflicts (both code and interpersonal) increases. While version control like
``git`` helps when developers try to change the same line of code, it doesn't
help when developers come up with competing designs.

*************************
How PluginPlay Fixes This
*************************

The full design of PluginPlay is beyond our present scope (see the PluginPlay
documentation for design details). Instead what we are after here is how the
concept of PluginPlay, namely building a software package on top of a framework
where all major functionality is contained in modules, helps rectify the above
problems.

Modules are essentially opaque functions. When something calls a module, they
know what it takes as input and what it returns. How it goes from inputs to
results doesn't matter. This is why the module system helps out with extending
the package. Basically, the package only couples to the API of the module not
the implementation. So if you wrap the library in a module, that module can
immediately be used throughout the code. By insisting that all functionality be
modules, it places all functionality on the same footing (the code doesn't
have to distinguish between internal and external calls). This is the key to
getting the functionality to automatically propagate throughout the code. Since
every time you want to do X, you get a module from PluginPlay, and then you
call the module given to you. PluginPlay can swap out the module you're about to
call for the new one, automatically (automatically in the sense that you don't
have to modify the calling code; it's not automatic in the sense that PluginPlay
magically knows which module the user wants to call).

This disconnect between API and implementation is also the key to helping
disparately developed codes work together. Basically, each module is a sandbox
in which the developer is free to go from inputs to results however they want.
In turn it's up to the developer to:

- enforce their own coding standards/style (although modules which are part of
  NWChemEx are expected to abide by the community standards/style)
- choose to implement in Python or C/C++
- decide what dependencies to use
- optimize for specific architectures
- choose what their module exposes (beyond that required by the API)

Keep in mind that module developers are under no obligation to commit their
modules back to the main NWChemEx repos. While many codes may boast this, the
reality is since they treat the outside contributions differently, than internal
contributions, it becomes more likely for compatibility to break (often
requiring the external developer to perform maintenance to restore the
compatibility). Being able to maintain the modules in a separate location is
particularly useful for:

- maintaining code ownership
- in some cases, avoiding licensing issues
- working on new methods privately
- individual tracking metrics
- collaborating with other projects besides NWChemEx
- demonstrating the component nature of the code to funding agencies
