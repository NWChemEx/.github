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

.. _writing_unit_tests:

###############################
Writing Unit Tests for NWChemEx
###############################

Within the first party NWChemEx libraries, we aim for extensive unit testing to
ensure functionality and correctness. All classes, functions, and modules added
to any of the first party libraries will be expected to have corresponding unit
tests. Testing of functions (as well as Plugin modules) should minimally ensure
that all return routes and errors are checked. Tests for classes should do the
same for all member functions, while additionally testing that the state of all
instances is consistent at construction and after modifications. Generally, the
unit tests should be able to run quickly, and use simplified data with the
minimum level of complexity need to ensure completeness in the testing.

The C++ unit tests use the `Catch2 framework <https://github.com/catchorg/Catch2>`_,
while python tests use the `unittest framework <https://docs.python.org/3/library/unittest.html>`_.
Assume the following class and related comparison function are intended to be
added to one of the first party libraries:

.. tabs::

    .. tab:: C++

        .. code-block:: c++
            :linenos:

            #include <stdexcept>

            class ToBeTested {
            private:
                using value_type = int;
                value_type my_value_;

            public:
                ToBeTested(value_type a_value = 0) : my_value_(a_value) {}

                value_type check_my_value() { return my_value_; }

                void change_my_value(value_type new_value) {
                    if(new_value == 13) throw std::runtime_error("Unlucky Number");
                    my_value_ = new_value;
                }

                bool operator==(const ToBeTested& rhs) const noexcept {
                    return my_value_ == rhs.my_value_;
                }

            }; // ToBeTested

            inline bool operator!=(const ToBeTested& lhs, const ToBeTested& rhs) {
                return !(lhs == rhs);
            }

    .. tab:: Python

        .. code-block:: python
            :linenos:

            class ToBeTested():

            def __init__(self, a_value = 0):
                self.__my_value = a_value

            def check_my_value(self):
                return self.__my_value

            def change_my_value(self, new_value):
                if new_value == 13:
                    raise RuntimeError("Unlucky Number")
                self.__my_value = new_value

            def __eq__(self, other):
                if not isinstance(other, ToBeTested):
                    return NotImplemented
                return self.__my_value == other.__my_value

An example unit test for the above looks like:

.. tabs::

    .. tab:: C++

        .. code-block:: c++
            :linenos:

            #include "to_be_tested.hpp"
            #include <catch2/catch.hpp>

            TEST_CASE("ToBeTested") {
                auto defaulted  = ToBeTested();
                auto with_value = ToBeTested(3);

                SECTION("Comparisons") {
                    SECTION("operator==") {
                        REQUIRE(defaulted == ToBeTested());
                        REQUIRE(with_value == ToBeTested(3));
                        REQUIRE_FALSE(defaulted == with_value);
                    }
                    SECTION("operator!=") {
                        REQUIRE(defaulted != with_value);
                    }
                }

                SECTION("check_my_value") {
                    REQUIRE(defaulted.check_my_value() == 0);
                    REQUIRE(with_value.check_my_value() == 3);
                }

                SECTION("change_my_value") {
                    SECTION("Not Unlucky") {
                        defaulted.change_my_value(7);
                        REQUIRE(defaulted.check_my_value() == 7);
                    }
                    SECTION("Unlucky") {
                        REQUIRE_THROWS_AS(defaulted.change_my_value(13),
                                          std::runtime_error);
                    }
                }
            }

    .. tab:: Python

        .. code-block:: python
            :linenos:

            from to_be_tested import ToBeTested
            import unittest

            class TestNewClass(unittest.TestCase):
                def setUp(self):
                    self.defaulted = ToBeTested()
                    self.with_value = ToBeTested(3)

                def test_equality(self):
                    self.assertEqual(self.defaulted, ToBeTested())
                    self.assertEqual(self.with_value, ToBeTested(3))
                    self.assertNotEqual(self.defaulted, self.with_value)

                def test_check_my_value(self):
                    self.assertEqual(self.defaulted.check_my_value(), 0)
                    self.assertEqual(self.with_value.check_my_value(), 3)

                def test_change_my_value(self):
                    self.defaulted.change_my_value(7)
                    self.assertEqual(self.defaulted.check_my_value(), 7)

                    with self.assertRaises(RuntimeError) as context:
                        self.defaulted.change_my_value(13)
                    self.assertTrue("Unlucky Number" in str(context.exception))
