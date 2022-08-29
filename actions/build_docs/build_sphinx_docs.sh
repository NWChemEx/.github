#!/bin/sh

#Step 3: Build the Sphinx documentation
. venv/bin/activate
cd docs

if [ -f requirements.txt ]; then
    pip install -r requirements.txt
fi
make html
