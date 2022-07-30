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
