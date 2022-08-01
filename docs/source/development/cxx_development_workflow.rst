************************
C++ Development Workflow
************************

This page assumes you have already read
:ref:`development_preliminaries` and that you are adding a module to a repo
which is considered part of NWChemEx (see :ref:`software_stack_overview` for
more clarification on what's part of NWChemEx and what's not). If you are
developing a plugin for NWChemEx you should follow the documentation at xxx.

.. todo::

   Write plugin documentation and link to it

Adding new features to NWChemEx is accomplished by adding new modules. NWChemEx
relies on a plugin-based architecture and module development follows a
more-or-less traditional plugin development cycle. This means you write your
module's source code largely decoupled from the rest of NWChemEx. When you need
to get a quantity that your module does not know how to compute (and is not an
input) you call out to a submodule. You do not have to write the submodule you
call (unless it's not available in any other repo). Providing your module with
the submodule will happen at runtime.

Module development looks a little different depending on whether your module
needs to call a submodule or not. The former is the easier scenario

Developing a Module without Submodules
======================================

This can be done largely as you would expect. You add your source code to the
repo, add a unit test for your module's source code, and then make sure the unit
test works.

.. todo::

   Make this into a true tutorial.


Developing a Module with Submodule(s)
=====================================

Development gets a bit more hairy when your module depends on a submodule (and
those submodules are not part of the current repo). For concreteness let's
assume we are writing a module called ``JCanonical`` which does a naive
canonical J build. The source file for such a module will live in the SCF repo
and will have the path ``nwx_workspace/SCF/src/scf/j_canonical.cpp``. The
contents of this source file could be something like:

.. code-block:: c++

   #include "scf/property_types.hpp" // List of property types used in SCF repo
   #include "scf/scf_modules.hpp" // Declarations of SCF modules, including ours
   #include "scf/types.hpp"       // types of objects used in SCF repo

   namespace scf {


    MODULE_CTOR(JCanonical) {
        // Our module knows how to compute J
        using j_prop_type = pt::coulomb<double, type::derived_space_t<double>>;
        satisfies_property_type<j_prop_type>();

        add_submodule<pt::eri4c<double>>("ERI Builder")
        .set_description("Computes 4C ERI integrals");
    }

    MODULE_RUN(JCanonical) {
        using j_prop_type = pt::coulomb<double, type::derived_space_t<double>>;
        auto [mol, MOs, bra, ket] = j_prop_type::unwrap_inputs(inputs);

        auto& eri_mod = submods.at("ERI Builder");
        auto [ERI4] = eri_mod.run_as<pt::eri4c<double>>(bra, bra, ket, ket);

        type::tensor<double> J;
        type::tensor<double> rho;
        const auto& C = MOs.C();
        rho("mu,nu") = C("mu,i") * C("nu,i");
        J("mu, nu") = rho("lambda, sigma") * ERI4("lambda, sigma, mu, nu");

        auto rv = results();
        return j_prop_type::wrap_results(rv, J);
    }

   } // namespace scf

Of importance for our current purposes is the fact that this module depends on a
submodule (for computing the four-center, electron-repulsion integrals) which is
not part of the SCF repo. Aside from that, there's nothing too remarkable about
the implementation of this module.

To finish off the implementation we also need to make sure ``JCanonical`` is
declared in ``nwx_workspace/SCF/include/scf/scf_modules.hpp`` (this file should
really live in ``src`` and may have been moved since this documentation was
written; if it has and you're reading this please file an issue/make a PR) and
we need to make sure our new module is added to the module manager in
``nwx_workspace/SCF/src/scf/scf_mm.cpp``. The former amounts to adding:

.. code-block:: c++

   DECLARE_MODULE(JCanonical);

to ``nwx_workspace/SCF/include/scf/scf_modules.hpp`` and the latter requires
adding:

.. code-block:: c++

   mm.add_module<JCanonical>("A key users will use to request your module");

to ``nwx_workspace/SCF/src/scf/scf_mm.cpp``.

Running the Module
------------------

Now that we wrote the module we need to test/run it. Since our module needs
integrals, and integrals are not provided by the SCF repo, we can't simply add a
unit test to ``nwx_workspace/SCF/tests`` which calls our module (we'll get to
how to unit test the module, in the SCF repo, later) because our module won't
have integrals. How to proceed depends on whether you are ok with using a Python
script to run the calculation or if you insist on the entire development
(including running the calculation) occurring in C++ (the former is preferred
and the latter will likely be deprecated at some point).

Running the module from Python
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In theory you write a Python script which looks like:

.. code-block:: python

   import nwchemex as nwx

   mm = nwx.sde.ModuleManager()
   nwx.load_modules(mm)

   #We need to tell our module which ERIs to use
   key = "whatever key you used in SCF for your module"
   eri_key = "ERI4" # or whatever 4-center ERIs you want to use
   mm.change_submod(key, "ERI Builder", eri_key);

   # Make the input for our module
   mol = nwx.libchemist.Molecule() # Make a Molecule
   aos = nwx.libchemist.apply_basis(mol, "sto-3g")
   mos = nwx.libchemist.DerivedSpaceD # get MOs from somewhere

   # Call our module and bask in the result
   mod                = mm.at("the key you put your module under")
   derived_space_type = nwx.scf.type.derived_space_t[double]
   j_prop_type        = nwx.scf.pt.coulomb[double, derived_space_type]
   J                  = mod.run_as[j_prop_type](mol, mos, aos, aos)
   print(J)

Assuming ``nwx.load_modules()`` is written in Python, you then would simply need
to recompile ``nwx_workspace/SCF`` and run the above Python script. Python would
take care of all of the dynamic linking etc.

.. todo::

   Finish/write this section when NWX's Python bindings allow this workflow.


Running the module from C++
^^^^^^^^^^^^^^^^^^^^^^^^^^^

To run our module from C++ the eaiest way is to add a validation test to the
NWChemEx repo, say ``nwx_workspace/NWChemEx/tests/j_canonical.cpp``. The
contents of this validation test look something like:

.. code-block:: c++

    #include <catch2/catch.hpp>
    #include <nwchemex/load_modules.hpp>
    #include <scf/property_types.hpp>
    #include <scf/types.hpp>

    using namespace scf;
    using j_prop_type = pt::coulomb<double, type::derived_space_t<double>>;

    TEST_CASE("Canonical J"){
        sde::ModuleManager mm;
        nwx::load_modules(mm);

        // We need to tell our module which ERIs to use
        const auto key     = "whatever key you used in SCF for your module";
        const auto eri_key = "ERI4"; // or whatever 4-center ERIs you want
        mm.change_submod(key, "ERI Builder", eri_key);

        // Make the input for our module
        auto mol = ;// Make a Molecule
        auto aos = libchemist::apply_basis(mol, "sto-3g");
        auto mos = ;// get MOs from somewhere

        // Call our module and bask in the result
        auto mod = mm.at("the key you put your module under");
        auto [J] = mod.run_as<j_prop_type>(mol, mos, aos, aos);
        std::cout << J << std::endl;
    }

With this validation test written, we then compile ``nwx_workspace/NWChemEx``,
and run the tests in ``nwx_workspace/NWChemEx``. *N.B.*, we are not compiling
the SCF repo; if the toolchain file is setup correctly building
``nwx_workspace/NWChemEx`` will use our local, modified, copy of SCF.

.. note::

   After development is complete you should add the ``mm.change_submod`` line
   to the ``NWChemEx/src/nwchemex/load_modules.cpp`` file. So that the module is
   ready to be used outside of just the validation test.

Unit Testing the Module
-----------------------

It's sometimes easier to get a module working using "real" data, which is what
the previous section focused on. That said the unit test for our module should
live in the SCF repo and not be coupled to the module used to get the integrals,
*i.e.*, if the integrals module breaks/changes we don't want it break our
module's unit test too. To avoid this coupling in our module's unit test we use
a lambda module, which wraps some hard-coded data.

To start with we create a source file ``nwx_workspace/SCF/tests/jcanonical.cpp``
with the contents:

.. code-block:: c++

    #include <catch2/catch.hpp>
    #include <scf/scf_mm.hpp>
    #include <scf/property_types.hpp>
    #include <scf/types.hpp>
    #include <sde/lambda_module.hpp>

    using namespace scf;
    using j_prop_type   = pt::coulomb<double, type::derived_space_t<double>>;
    using eri_prop_type = pt::eri4c<double>;

    TEST_CASE("Canonical J"){
        sde::ModuleManager mm;
        scf::load_modules(mm);

        // Make the input for our module
        auto mol = ;// Make a Molecule
        auto aos = libchemist::apply_basis(mol, "sto-3g");
        auto mos = ;// get MOs from somewhere

        // Make the lambda module which will serve as the submodule
        type::tensor<double> eris; // hard-coded ERIS, in practice need state
        auto l = [=](auto& bra1, auto& bra2, auto& ket1, auto& ket2) {
            // Make sure our module passes the right info to the submodule
            REQUIRE(bra1 == aos);
            REQUIRE(bra2 == aos);
            REQUIRE(ket1 == aos);
            REQUIRE(ket2 == aos);

            // It did so return the hard coded result
            return eris;
        };
        auto submod = sde::make_lambda<eri_prop_type>(l);


        // Tell our module to use the lambda module
        const auto key     = "whatever key you used in SCF for your module";
        auto& mod = mm.at(key);
        mod.change_submod("ERI Builder", submod);

        // Call our module and compare J to the correct value
        auto [J] = mod.run_as<j_prop_type>(mol, mos, aos, aos);
        std::cout << J << std::endl;
    }

We now build ``nwx_workspace/SCF`` and run its tests to ensure our module works
correctly. In particular note that this test is self-contained in that it should
only fail if the implementation of our module changes (ignoring infrastructure
breaks).

Neding hard-coded data for unit tests is very common which is why we made the
``NWChemEx-Project/testing`` repo
(https://github.com/NWChemEx-Project/testing). You are encouraged to use that
data when it makes sense.

.. note::

   For developers who prefer test-based development it's entirely possible to
   start with these unit tests and then to proceed to the validation tests with
   real integrals modules.
