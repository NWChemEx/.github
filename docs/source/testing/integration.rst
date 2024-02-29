.. Copyright 2023 NWChemEx-Project
..
.. Licensed under the Apache License, Version 2.0 (the "License");
.. you may not use this file except in compliance with the License.
.. You may obtain a copy of the License at
..
.. http://www.apache.org/licenses/LICENSE-2.0
..
.. Unless required by applicable law or agreed to in writing, software
.. distributed under the License is distributed on an "AS IS" BASIS,
.. WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
.. See the License for the specific language governing permissions and
.. limitations under the License.

.. _writing_integration_tests:

######################################
Writing Integration Tests for NWChemEx
######################################

NWChemEx is a modular ecosystem designed with separation of concerns as a key
design point. An example of this separation can be found with the 
self-consistent field (SCF) code and the integrals code. These two components of
NWX are linked by PluginPlay and SimDE and are intended to be used together, but
neither is therefore explicitly required for the development of the other and 
therefore reside in separate Plugins. The unit tests for these libraries are 
intended to ensure basic functionality and correctness, which can usually be 
accomplished with simple test data that allow the unit tests to run quickly. 
With that said, the initial development and testing of the SCF becomes very 
awkward when one is unable to easily acquire real integrals for real molecular 
systems. Additionally, changes to the integrals code could have deleterious
effects on the SCF code, which we would like to detect before merging. For these
(and other reasons), it can be useful to implement integration tests to ensure
the continued interoperability of the isolated components of the NWX stack.

CMake for Integration Testing
=============================

The following code-block provides an example for how one can add the option for
an integration test to a project that uses the NWX ecosystem.

.. code-block:: CMake

    # Include option
    cmaize_option_list(
        BUILD_INTEGRATION_TESTS ON "Build the integration tests?"
    )

    # How to build the integration tests
    if("${BUILD_INTEGRATION_TESTS}")
        include(nwx_pybind11)
        # Set relevant test directories
        set(CXX_INCLUDE_DIR /path/to/cxx/includes)
        set(CXX_TEST_DIR /path/to/cxx/integration/tests)
        set(PYTHON_TEST_DIR /path/to/python/integration/tests)

        # Find or build needed dependencies
        cmaize_find_or_build_dependency(
            Catch2
            URL github.com/catchorg/Catch2
            BUILD_TARGET Catch2
            FIND_TARGET Catch2::Catch2
            VERSION ${NWX_CATCH2_VERSION}
        )

        cmaize_find_or_build_dependency(
            chemcache
            URL github.com/NWChemEx/ChemCache
            VERSION ${NWX_CHEMCACHE_VERSION}
            BUILD_TARGET chemcache
            FIND_TARGET nwx::chemcache
            CMAKE_ARGS BUILD_TESTING=OFF
                       BUILD_PYBIND11_PYBINDINGS=ON
        )

        # Add C++ integration tests
        cmaize_add_tests(
            test_integration_my_project
            SOURCE_DIR "${CXX_TEST_DIR}"
            INCLUDE_DIRS "${CXX_INCLUDE_DIR}"
            DEPENDS Catch2 chemcache my_project
        )

        # Add Python integration tests
        nwx_pybind11_tests(
            py_test_integration_my_project
            "${PYTHON_TEST_DIR}/test_main.py"
            SUBMODULES parallelzone pluginplay chemist simde chemcache
        )
    endif()

Integration Tests
=================

Building on the description provided in :ref:`writing_unit_tests`, integration
tests are written in the same manner. Below are examples of how to use ChemCache
in our new integration test to acquire input values and submodules that may be
needed by a module in our project.

.. tabs::

    .. tab:: C++

        .. code-block:: C++

            #include "my_project/my_project.hpp"
            #include <catch2/catch.hpp>
            #include <chemcache/chemcache.hpp>
            #include <simde/energy/ao_energy.hpp>
            #include <simde/chemical_system/molecule_from_string.hpp>
            #include <simde/chemical_system/atom.hpp>

            // Property Types from SimDE
            using molecule_pt  = simde::MoleculeFromString;
            using basis_set_pt = simde::MolecularBasisSet;
            using energy_pt    = simde::AOEnergy;

            TEST_CASE("My New Module") {
                pluginplay::ModuleManager mm;
                chemcache::load_modules(mm);
                my_project::load_modules(mm);

                // Module we want to test
                std::string key{"My New Module"};

                // Can use ChemCache modules to get inputs
                std::string mol_name{"water"};
                auto mol = mm.at("NWX Molecules").run_as<molecule_pt>(mol_name);
                auto bs = mm.at("sto-3g").run_as<basis_set_pt>(mol);

                // set ChemCache modules as needed submodules
                std::string submod_key{"A submodule of my new module"};
                mm.change_submod(key, submod_key, "Atom")

                // Test our module
                auto egy = mm.at(key).run_as<energy_pt>(mol, bs)
                REQUIRE(egy == Approx(3.14159265359).margin(1.0e-7))
            }
        
    .. tab:: Python

        .. code-block:: python

            import unittest
            import chemcache
            import my_project
            from pluginplay import ModuleManager
            from simde import AOEnergy
            from simde import MoleculeFromString
            from simde import MolecularBasisSet

            class TestIntegration(unittest.TestCase):

                def test_my_module(self):
                    # Module we want to test
                    key = "My New Module"

                    # Property Types from SimDE
                    molecule_pt = MoleculeFromString()
                    basis_set_pt = MolecularBasisSet()
                    energy_pt = AOEnergy()

                    # Can use ChemCache modules to get inputs
                    mol = self.mm.run_as(molecule_pt, "NWX Molecules", "water")
                    bs = self.mm.run_as(basis_set_pt, "sto-3g", mol)

                    # set ChemCache modules as needed submodules
                    submod_key = "A submodule of my new module"
                    mm.change_submod(key, submod_key, "Atom")

                    # Test our module
                    egy = self.mm.run_as(energy_pt, key, mol, bs)
                    self.assertAlmostEqual(egy, 3.14159265359, places=6)


                def setUp(self):
                    self.mm = ModuleManager()
                    chemcache.load_modules(mm)
                    my_project.load_modules(mm)
            

