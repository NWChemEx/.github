.. Copyright 2025 NWChemEx-Project
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

####
FAQs
####

This page collects frequently asked questions pertaining to NWChemEx's Design.

**************
Overall Design
**************

Why So Many Repos?
------------------

When transitioning from developing a more traditional electronic structure
package to NWChemEx, one of the first observations developers make is that there
are a lot of repos. The motivation behind this is a separation of concerns and
to enforce a decoupled nature to the source code. Each repo is designed to be a
reusable component. It is our hope that such a code factorization will
facilitate adoption of these components by other codes. Even if our components
are never adopted by other codes, a component-based design still benefits us by
making it easier to refactor if need be.


*******
General
*******

So Where's "NWChemEx"?
----------------------

Having a bunch of individual repos is great for developers, but confusing to
users. Users only need to build the ``NWChemEx`` repo. Building this repo will
build all dependencies which are required to have the complete NWChemEx
electronic structure package. The result of building ``NWChemEx`` is a set of
Python bindings. There is no "NWChemEx" executable, rather users use the Python
module.
