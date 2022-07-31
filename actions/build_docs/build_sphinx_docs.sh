#!/bin/sh

#Step 3: Build the Sphinx documentation
. venv/bin/activate
cd docs
make html
