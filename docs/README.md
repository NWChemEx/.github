<!--
  ~ Copyright 2025 NWChemEx-Project
  ~
  ~ Licensed under the Apache License, Version 2.0 (the "License");
  ~ you may not use this file except in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~ http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing, software
  ~ distributed under the License is distributed on an "AS IS" BASIS,
  ~ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ~ See the License for the specific language governing permissions and
  ~ limitations under the License.
-->

Source Files for Developer Documentation
========================================

This directory contains the source files for NWChemEx's developer documentation.

Building the Documentation
--------------------------

The developer documentation has several dependencies which can be installed via
`pip`

~~~.sh
#These first two steps are recommended, but not required
python3 -m venv venv
. venv/bin/activate
pip3 install -r requirements.txt
~~~

With the dependencies installed the documentation is built by running (in the
same directory as this README):

~~~.sh
make html
~~~

This will result in HTML documentation, the main index of which will be
located at `<directory_containing_this_readme>/build/html/index.html` and can be
viewed by directing your web browser of choice to that file (this is done by
using `file:///path/to/index.html` as the URL).
