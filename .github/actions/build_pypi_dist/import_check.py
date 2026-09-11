# Copyright 2026 NWChemEx-Project
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

"""Import every top-level module a freshly installed wheel provides.

Run by build_pypi_dist's "Verify Wheel Installs" step, inside the throwaway
venv the wheel was just installed into. `pip install` only proves the wheel
unpacks; an extension module that crashes the interpreter on load installs
perfectly cleanly, so the only way to catch it before publishing is to
actually import it.

A separate file rather than a `python -c` one-liner in the action: this
needs enough logic (read the RECORD, filter it down to importable
top-level names) that inlining it would mean quoting a multi-line script
through both YAML and bash.

Inputs arrive as environment variables so nothing is interpolated into
source text:
  IMPORT_CHECK -- optional space-separated override; when set, exactly
                  these names are imported.
  DIST_NAME    -- the installed distribution's name, e.g. nwchemex_scf.
"""

import importlib
import os
import re
import sys
from importlib.metadata import distribution

# Suffixes a top-level RECORD entry can carry and still name something
# importable. Compiled extensions are the whole point of the check, so the
# platform-tagged forms (scf.cpython-312-darwin.so) matter as much as .py;
# everything else a wheel installs at the root -- libscf.dylib, the
# delocate/auditwheel .dylibs/ and .libs/ directories, lib/, include/,
# share/, the .dist-info -- is data, not a module.
_MODULE_SUFFIXES = (".py", ".so", ".pyd", ".dll")

# On macOS the difference between say libscf.dylib and scf.cpython-312-darwin.so
# (the C++ library vs. the python bindings) was  distinguishable by suffix alone
# (.dylib vs .so), which is why the comment above only mentions
# libscf.dylib -- but on Linux both a raw C++ library and a real Python
# extension end in .so, so we need to also look for the "lib" prefix to
# distinguish them.
_LIB_NAME_RE = re.compile(r"^lib.+\.(so|dylib)(\.[0-9.]+)?$")


def _top_level_modules(dist_name):
    """Top-level importable module names the distribution installs."""
    files = distribution(dist_name).files or []
    modules = set()
    for path in files:
        parts = path.parts
        name = parts[0]
        if name.endswith(".dist-info") or name.endswith(".data"):
            continue
        if len(parts) > 1:
            # A directory at the root is a package only if it has an
            # __init__; bundled shared-library and data directories don't.
            if parts[1] == "__init__.py":
                modules.add(name)
            continue
        if not name.endswith(_MODULE_SUFFIXES):
            continue
        if _LIB_NAME_RE.match(name):
            continue
        # scf.cpython-312-darwin.so -> scf; friendzone.py -> friendzone
        modules.add(name.split(".")[0])
    return sorted(modules)


def main():
    override = os.environ.get("IMPORT_CHECK", "").split()
    dist_name = os.environ["DIST_NAME"]
    modules = override or _top_level_modules(dist_name)

    if not modules:
        print(f"{dist_name} installs no top-level module; nothing to import")
        return 0

    for module in modules:
        print(f"Importing {module} ...", flush=True)
        importlib.import_module(module)
    print(f"Imported {len(modules)} module(s) from {dist_name} cleanly")
    return 0


if __name__ == "__main__":
    sys.exit(main())
