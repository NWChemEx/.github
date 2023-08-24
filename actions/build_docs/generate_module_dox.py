import sys
import importlib

"""This script will generate the module api documentation for a plugin library.

Usage
-----

::

   usage: generate_module_dox.py library_name

   positional arguments:
     library_name  The name of the library for which the documentation is 
                   supposed to be generated.

This script checks that only one library name is passed and that it can import
pluginplay and the library specified. If the library is a plugin, a module
manager if constructed and the modules of the library are loaded into it.
The document_modules is called on the manager.
"""

if __name__ == "__main__":
    # Exit if more than a single argument is passed
    if len(sys.argv) != 2:
        sys.exit()

    # Can we find pluginplay? If not, exit
    try:
        pluginplay = importlib.import_module("pluginplay")
    except Exception:
        sys.exit()

    # Can we find the library to document? If not, exit
    try:
        library = importlib.import_module(sys.argv[1])
    except Exception:
        sys.exit()

    # If this library is a plugin, print the dox
    if hasattr(library, "load_modules"):
        mm = pluginplay.ModuleManager()
        library.load_modules(mm)
        # This is no-op if docs/source/module_api doesn't exist
        pluginplay.document_modules(mm, "docs/source/module_api")

