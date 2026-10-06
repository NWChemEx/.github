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

"""Repair a wheel without re-vendoring its ecosystem dependencies.

cibuildwheel's repair step (auditwheel on Linux, delocate on macOS) copies
every shared library a wheel links against into the wheel. For an ecosystem
package that is wrong: e.g. libpluginplay links libparallelzone, which the
nwchemex-parallelzone wheel already installs into the same site-packages/lib.
Vendoring a second copy brings back the problem the per-project install
components fixed: two copies of one library, possibly different versions,
both loaded into one process.

Excluding those libraries is not enough on its own. Both tools refuse to
repair a wheel when a dependency can't be found at all ("Could not find all
dependencies"), whether or not it is excluded, and the build env holding the
dependency wheels is gone by the time the repair runs. So this script:

1. reads the wheel's own Requires-Dist for nwchemex-* packages,
2. installs them (newest versions, with their dependencies) into a throwaway
   directory,
3. puts that directory's lib/ on the loader's search path, so the repair tool
   can resolve the libraries, and
4. excludes every shared library those wheels ship, so none is copied.

cibuildwheel offers no {project} placeholder for the repair command, so the
action copies this file into the checkout root, which is the repair step's
working directory on both Linux (/project in the container) and macOS.

Usage:
  python repair_wheel.py --tool {auditwheel,delocate} [--archs ARCHS]
      [--exclude NAME ...] [--extra-index-url URL] WHEEL DEST_DIR
"""

import argparse
import os
import re
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

# Requirement names this script treats as ecosystem packages. nwxcmake is
# pure Python and ships no libraries, so including it is harmless.
_ECOSYSTEM_PREFIX = "nwchemex-"

# A shared library's file name: libfoo.so, libfoo.so.1.2, libfoo.dylib,
# libfoo.1.2.dylib. Wheels don't keep symlinks, so every soname variant is
# its own file and all of them get excluded.
_SHARED_LIB_RE = re.compile(r"^lib.+\.(so(\.[0-9.]+)?|([0-9.]+\.)?dylib)$")


def _ecosystem_requirements(wheel):
    """The nwchemex-* requirements in the wheel's METADATA, unparsed."""
    with zipfile.ZipFile(wheel) as zf:
        metadata = next(
            n for n in zf.namelist() if n.endswith(".dist-info/METADATA")
        )
        text = zf.read(metadata).decode()
    reqs = []
    for line in text.splitlines():
        if not line.startswith("Requires-Dist:"):
            continue
        req = line.split(":", 1)[1].strip()
        # Skip optional extras (e.g. a [dev] dependency): they are not
        # runtime dependencies of the libraries being repaired.
        if "extra ==" in req:
            continue
        if req.lower().startswith(_ECOSYSTEM_PREFIX):
            reqs.append(req)
    return reqs


def _install_dependencies(reqs, target, extra_index_url):
    """Install the requirements (and their dependencies) into target."""
    cmd = [
        sys.executable,
        "-m",
        "pip",
        "install",
        "--quiet",
        "--no-compile",
        "--only-binary",
        ":all:",
        "--target",
        str(target),
    ]
    if extra_index_url:
        cmd += ["--extra-index-url", extra_index_url]
    subprocess.run(cmd + reqs, check=True)


def _shared_libs(root):
    """File names of every shared library under root."""
    return sorted(
        {
            p.name
            for p in Path(root).rglob("*")
            if p.is_file() and _SHARED_LIB_RE.match(p.name)
        }
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        "--tool", choices=("auditwheel", "delocate"), required=True
    )
    parser.add_argument(
        "--archs", default="", help="delocate --require-archs value"
    )
    parser.add_argument(
        "--exclude",
        action="append",
        default=[],
        help="extra library to exclude (e.g. MPI)",
    )
    parser.add_argument("--extra-index-url", default="")
    parser.add_argument("wheel")
    parser.add_argument("dest_dir")
    args = parser.parse_args()

    excludes = list(args.exclude)
    env = dict(os.environ)
    with tempfile.TemporaryDirectory() as deps_dir:
        reqs = _ecosystem_requirements(args.wheel)
        if reqs:
            print(f"repair_wheel: ecosystem dependencies: {reqs}", flush=True)
            _install_dependencies(reqs, deps_dir, args.extra_index_url)
            provided = _shared_libs(deps_dir)
            print(
                f"repair_wheel: provided by dependency wheels, not "
                f"vendored: {provided}",
                flush=True,
            )
            excludes += provided
            # The dependency wheels' libraries live in <site-packages>/lib,
            # a few also flat at <site-packages> next to their extension.
            search = [str(Path(deps_dir) / "lib"), deps_dir]
            var = (
                "LD_LIBRARY_PATH"
                if args.tool == "auditwheel"
                else "DYLD_LIBRARY_PATH"
            )
            env[var] = os.pathsep.join(
                search + ([env[var]] if env.get(var) else [])
            )

        if args.tool == "auditwheel":
            cmd = ["auditwheel", "repair"]
        else:
            cmd = ["delocate-wheel", "-v"]
            if args.archs:
                cmd += ["--require-archs", args.archs]
        for name in excludes:
            cmd += ["--exclude", name]
        cmd += ["-w", args.dest_dir, args.wheel]
        print(f"repair_wheel: {' '.join(cmd)}", flush=True)
        return subprocess.run(cmd, env=env).returncode


if __name__ == "__main__":
    sys.exit(main())
