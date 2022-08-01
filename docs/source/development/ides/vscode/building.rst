Building NWX with VSCode
========================

Once you've minimally added the C++ and CMake extensions it's time to start
setting up your build process. For the purposes of this tutorial we assume you
are using a toolchain file with all of your CMake options. For sake of arguement
we assume that the full path to your toolchain file is given by:
``/home/user/nwx_workspace/toolchain.cmake``.

To modify VSCode's CMake settings click on the gear in the left toolbar and then
settings. You will then be presented with all of VSCode's settings. At the top
you will see three tabs ("User", "Workspace", and the name of your current
folder); these tabs indicate the scope of the settings you are setting (user
settings follow you, workspace settings are for the entire workspace, and folder
setings are only for the current folder). Since building is somewhat project-
specific we recommend you click on either "Workspace" or folder. The CMake
settings are then accessed by expanding the "Extensions" settings and navigating
to "CMake configuration".

Configuring the Build
---------------------

The first step is to set the paths of the CMake executables. If the ``cmake``
and ``ctest`` executables are in your path feel free to skip this step.
Otherwise set "CMake Path" to the full path to your CMake executable. VSCode
will automatically use the ``ctest`` executable that comes with the ``cmake``
executable you specify (but if you want to use a different one you can change
its path below via the "Ctest Path" option).

Next we need to make sure the build uses our toolchain file. For our purposes
the main option we need to change is "Configure Args" (do not confuse this with
"Build Tool Args", which are the arguments that get passed to
the underlying build tool, typically ``make``). Under "Configure Args" click on
"Add Item" and type:

.. code-block:: .cmake

   -DCMAKE_TOOLCHAIN_FILE=/home/user/nwx_workspace/toolchain.cmake

substituting in your toolchain's path.

Configuring the Project (i.e., running CMake)
---------------------------------------------

Once you've setup the options it's time to actually configure the project. To
configure say SCF, click on a C++ file or a CMake file in the ``SCF`` directory.
The bottom toolbar should show a folder icon with ``SCF`` next to it; this is
how you can tell which project will be configured. In the bottom toolbar you
should also see a panel with something like "CMake: [Debug]: Ready". Click on
this. You will get a pop-up asking you to select a kit. Choose "Unspecified" to
let CMake detect the kit for you (it'll end-up using your toolchain file). Then
pick the build type you want (Debug for normal development). After this you
should see the normal CMake configuration dialog fly by in the terminal. You'll
know it's configured successfully if you get a line like

.. code-block:: bash

   -- Build files have been written to: <your/build/directory/path>

Building the Project
--------------------

Once the project has been configured you simply click the word "Build" in the
toolbar at the bottom. Akin to the configure step, you should see the usual
build dialog fly by on the terminal.

Testing the Project
-------------------

After a successful build you should be able to click the play arrow
(right-facing triangle) in the bottom toolbar to run the resulting executable
(assuming you enabled testing by putting ``BUILD_TESTING=TRUE`` in your
toolchain file). Again the normal testing output will fly by in the terminal.

Building Sphinx Documentation
-----------------------------

As a preliminary step you will need to install the documentation dependencies.
Each repo should contain instructions on how to do this, which amount to
something like:

- Create a virtual Python environment
- run ``pip install -r requirements.txt``

Assuming you have installed the documentation's actual dependencies and the
``reStructuredText`` extension, the easiest way to setup the documentation build
is to go to settings (click on gear, then "settings") and navigate to
``Extensions->reStructuredText`` in the settings scope of your choice.

.. note::

   All NWX repos follow the same conventions for documentation so if you like
   you can safely use these settings for the entire workspace.

Minimally you should then set:

- ``Built Documentation Path`` to ``${workspaceFolder}/build/html``
- ``Conf Path`` to ``${workspaceFolder}/docs/source``

It is then recommended that you set:

- ``Update on Text Changed`` to ``true`` (may be the default)
- ``Update Delay`` to a smaller value

and if you are using virtual environments you will need to set
``Sphinx Build Path`` so that it points to the ``sphinx-build`` executable in
your virtual environment (should be something like
``/path/to/venv/bin/sphinx-build``. If for each repo you always create the
virtual environment in the same location you can still set this for the entire
workspace.

Once you have set this all up you can open a ``.rst`` file and hit
``ctrl+shift+R`` to build the documentation (you'll want to point your
webbrowser at ``${workspaceFolder}/build/html/index.html`` to see it).
