##########################
Setting Up VSCode on MacOS
##########################

These instructions were created on 9/16/2025 for macOS Sonoma (Version 14.6.1)
targeting VSCode Version 1.93.1.

****************
Obtaining VSCode
****************

The easiest way to obtain VSCode is from their
`website <https://code.visualstudio.com/Download>`__. Select the version you
want, download it, open the downloaded file, and copy the application to the
``Applications`` directory.

************************
Setup From Fresh Install
************************

When you start up VSCode you'll be greeted with the "Get Started with VS Code"
screen.

- Pick your preferred theme.
- Pick your languages. We want the C/C++, and Python language extensions.

   - If you have not previously installed command line tools follow the prompts.

- Tune your settings. Click "Open Settings".

   - Recommended to enable backup and sync settings. If you want do this then
     sign in before changing any options.
   - Settings to consider (you can search for them to quickly find them):

      - Files: Auto Save
      - Editor: Rulers (we're sticklers for 80 character lines)
      - CMake: Options: Status Bar Visibility (set to visible)

   .. note::

      With setting synching on make sure you don't set any user setting to a
      workspace specific path or it will be set across all your accounts.

- At this point you're free to follow the remaining "Get Started" steps, but
  VSCode is mainly interested in showing you how to start a new project and we
  want to use an existing one.

********************************************
Creating an NWChemEx Development Environment
********************************************

Now that you have VSCode initialized we will create a development environment,
or as VSCode calls it, a "workspace". Workspaces reside in directories so go
ahead and create the directory for the workspace now. We recommend something
like ``/Users/your_username/nwchemex`` (you can create the directory in Finder
or via terminal). The remainder of this tutorial refers to this directory as
the "workspace directory".

Adding Repositories
===================

Assuming you do not have any files open:

1. Switch to the source control view (if it's not there go to
   ``"View"->"Source Control"``).

   - If you have not previously installed git see
     `obtaining_dependencies_on_macos` (if you click on "Download Git for
     macOS", it'll just redirect you to git's website which will duplicate
     our instructions). Once git is installed, click ``reload`` in the source
     control view.

2. (With git installed) click "Clone Repository".
3. Click "Clone from GitHub".
4. If asked, allow the extension to sign in.
5. You should now see all the repos you have. For sake of the tutorial search
   for ``NWChemEx/.github``, i.e., this repo.
6. That will bring up Finder. Select the workspace directory as the
   destination.
7. When prompted open the repository.
8. If prompted, decide whether you trust us (we'll assume you do and
   click yes).
9. For some reason, adding additional repositories can not be done from the
   source control view, rather you need to use the command palate
   (command + shift + P) then search ``Git: Clone``. That will return you to
   step 3 above, noting that since you have files in your workspace already
   step 7 will change slightly and you will want to select "Add to Workspace"
   instead of "Open".
10. Repeat step 9 until you have all the repositories you want.

   .. note::

      If you choose a repository containing C++ source code, e.g.,
      ``NWChemEx/chemist``, VSCode may prompt you to select a kit.
      Instructions for this are below. To get this to go away for now just
      click "unspecified" or press esc.

11. Save your workspace by going to ``File->"Save Workspace As..."``. We
    recommend saving it into the ``nwchemex`` workspace directory and naming
    it as ``nwchemex.code-workspace``.

Creating a CMake Toolchain File
===============================

CMake relies on toolchain files to pass configuration variables to dependencies.

.. note::

   We suggest putting the toolchain in the workspace directory and not in any
   of the repositories. Unfortunately, this means we can't use VSCode's editor
   to create/edit the file (VSCode will only let us create/edit files in the
   repository directories we downloaded). Thus, if you put it in the workspace
   you'll have to use an external editor to write the file.

1. In the directory of you choice, create a new file ``toolchain.cmake``.
2. Modify the toolchain file. Syntax is ``set(<name_of_variable> <value>)``.
   Some variables you may want to include are:

        - ``NWX_MODULE_DIRECTORY``. Set this to where you want plugins and
          modules to be installed to.
        - ``CMAKE_CXX_STANDARD``. Set this to 17 if for some reason your C++17
          compliant compiler doesn't at least default to 17 being enabled.
        - ``BUILD_TESTING``. To build the unit tests.

    An example:

    .. code-block:: cmake

       set(NWX_MODULE_DIRECTORY /path/to/your/workspace/directory)
       set(CMAKE_CXX_STANDARD 17)
       set(BUILD_TESTING TRUE)

Setting up Kits
===============

Kits are sets of tools to use to build the code. They are usually named based
on the compiler you want to use. Since MacOS ships with Clang, this tutorial
assumes you have Clang and are creating a Clang kit.

.. note::

   This tutorial assumes you have set the setting
   ``cmake.options.statusBarVisibility`` to visible.

1. Set the active folder to one with C++ files, e.g. ``chemist``.
2. Click on ``No active kit``.
3. Select ``Clang <version goes here>``.

   - Depending on your VSCode settings, selecting your kit will likely
     immediately start a CMake configuration run. Since we're not done setting
     up, it will likely fail...

4. Now we need to edit the kit to know about the toolchain file. Open the
   command pallette (command + shift + P) and search for
   ``Edit User-Local CMake Kits``.
5. Add ``"toolchainFile": "<path/to/the/toolchain>"`` to your kit.
6. Click ``CMake: [Debug]: Ready`` to try configuring again.

   - If the configuration fails because of a missing dependency (e.g.,
     MPI or Boost) consult `obtaining_dependencies_on_macos`.
