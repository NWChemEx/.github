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

#########################
Why Do We Need ChemCache?
#########################

Inevitably NWChemEx will need access to hard-coded data. Typically this data is
physical data (for example fundamental constants, atomic masses, etc.) or model
parameters (for ab initio calculations the atomic basis sets). We have opted to
store such data in the ChemCache repo. This section describes this decision in
more detail.

The need for ChemCache is fueled by several points: we want all of the
hard-coded data used in NWChemEx to come from a single source of truth, users
may want to use their own hard-coded data, and we want to version control the
hard-coded data we use.
