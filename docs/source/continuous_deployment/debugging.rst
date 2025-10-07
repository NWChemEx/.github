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

##############################
How to Debug CI Issues Locally
##############################

.. note::

   When you try to Google "how to debug Github Actions locally" you will find
   a tool called `Act <https://github.com/nektos/act>`__. In our experience,
   we seem to always be in th 10% of edge cases that Act cannot faithfully
   reproduce locally, i.e., feel free to try it, but it probably won't work.

*************************
Building the Docker Image
*************************

Prerequisites
=============

- Have Docker installed.
  - We recommend using `Docker Desktop <https://www.docker.com/products/docker-desktop/>`__.
- Have the Docker daemon running.
  - If you are using Docker Desktop, just make sure the app is open.

Steps
=====

1. In a terminal run ``docker pull ghcr.io/nwchemex/nwx_buildenv:latest``.

   - This will download the Docker image we use in our CI workflows.
   - It's somewhat big and will probably take a while to download.

2. Run the image: ``docker run -it ghcr.io/nwchemex/nwx_buildenv:latest``.
3. Clone the branch you want to debug.

   - ``git clone https://url/of/repo/your/branch/is/part/of.git``
   - ``cd /directory/where/repo/was/cloned``
   - ``git fetch``
   - ``git checkout your_branch_name``

3. You now need to manually run the commands that are in the workflow
   you want to debug. Workflows can be found in the ``.github``
   `repository <https://github.com/NWChemEx/.github/tree/master>`__ in the
   ``.github/workflows`` directory.

   - If you are building a library that uses CMake follow the
     ``test_nwx_library.yaml`` workflow.

4. (Optional) After you are done building we recommend saving the state of the
   container as a new image. This way you don't have to repeat steps 2-3 if the
   container is stopped/closed for whatever reason.

   - From another terminal run
     ``docker commit <container_id> nwchemex_debug_image`` to create the
     image.

****
FAQs
****

- When trying to run an executable in a Docker container under lldb, I get an
  lldb error: ``lldb error: 'A' packet returned an error: -1``.

  - This means lldb was not allowed to start debugging the executable.
  - If you have Apple silicon you may not be able to debug x86_64 binaries
    (`source <https://github.com/docker/for-mac/issues/5191#issuecomment-821319621>`__).
