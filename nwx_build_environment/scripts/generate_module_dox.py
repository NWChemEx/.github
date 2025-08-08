# Copyright 2025 NWChemEx-Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import glob
import importlib
import os
import sys

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
manager is constructed and the modules of the library are loaded into it.
The document_modules function is called on the manager.
"""

if __name__ == "__main__":
    # Exit if more than a single argument is passed
    if len(sys.argv) != 2:
        sys.exit()
    target = sys.argv[1].replace("_cxx_api", "")

    # Add paths to libraries
    cwd = os.getcwd()
    build_dir = os.path.join(cwd, "build")
    sys.path.append(build_dir)

    pythonsrc_dir = os.path.join(cwd, "src", "python")
    sys.path.append(pythonsrc_dir)

    deps_dir = os.path.join(cwd, "build", "_deps")
    deps_builds = glob.glob("*-build/", root_dir=deps_dir)
    for build in deps_builds:
        sys.path.append(os.path.join(deps_dir, build))

    # Exit on any exception
    try:
        pluginplay = importlib.import_module("pluginplay")
        library = importlib.import_module(target)
        # If this library is a plugin, try to print the dox.
        if hasattr(library, "load_modules"):
            mm = pluginplay.ModuleManager()
            library.load_modules(mm)
            # This is no-op if docs/source/module_api doesn't exist
            pluginplay.document_modules(mm, "docs/source/module_api")
    except Exception as e:
        print(f"An exception caught: {e}")
        sys.exit()
