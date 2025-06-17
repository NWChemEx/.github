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

  .. figure:: assets/mac_setup/pick_theme.png
     :align: center

     First you will be asked to pick your theme. The choice is up to you.

- Pick your languages. We want the C/C++, and Python language extensions.
   
   .. figure:: assets/mac_setup/choose_apps.png
      :align: center

      You will be prompted to choose the coding languages you will use.

   .. figure:: assets/mac_setup/cxx_extension.png
      :align: center

      The VSCode C++ extension.

   .. figure:: assets/mac_setup/python_extension.png
      :align: center

      Install the Python extension.

   - If you have not previously installed "command line developer tools" follow 
     the prompts.

     .. figure:: assets/mac_setup/install_command_line_tools.png
        :align: center

        If necessary, install command line developer tools to get access to
        Python.

- Tune your settings. Click "Open Settings".
  
   .. figure:: assets/mac_setup/tune_settings.png
      :align: center

      Tune VSCode's settings to your liking. 

   - Recommended to enable backup and sync settings. If you want do this then
     sign in before changing any options.

      .. figure:: assets/mac_setup/synch_settings.png
         :align: center

         Recommended to turn on settings synch to ensure a consistent VSCode
         experience across devices.

   - Settings to consider (you can search for them to quickly find them):

      .. figure:: assets/mac_setup/settings_open.png
         :align: center

         VSCode has a lot of settings. If you're new to IDEs you probably just 
         want to start with the suggestions below.  

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

.. figure:: assets/mac_setup/source_control_view.png
   :align: center

   Step 1. Switch to the source control view (if it's not there go to
   ``"View"->"Source Control"``). (If you have files open you will instead
   see the source control for those files. To add a repo close the files or
   skip ahead to step 9).

   - If you have not previously installed git see
     `obtaining_dependencies_on_macos` (if you click on "Download Git for
     macOS", it'll just redirect you to git's website which will duplicate
     our instructions). Once git is installed, click ``reload`` in the source
     control view.

.. figure:: assets/mac_setup/clone_repo.png
   :align: center

   Step 2. (With git installed) click "Clone Repository".
 
.. figure:: assets/mac_setup/clone_from_github.png
   :align: center

   Step 3. Click "Clone from Github".

.. figure:: assets/mac_setup/allow_github.png
   :align: center
   
   Step 4. If asked, allow the GitHub extension to sign in.

.. figure:: assets/mac_setup/your_repos.png
   :align: center

   Step 5. You should now see all the repos you have. Search for the one you
   want. For sake of the tutorial search for ``NWChemEx/.github``, i.e., this 
   repo.

6. That will bring up Finder. Select the workspace directory as the
   destination.

.. figure:: assets/mac_setup/open_cloned_repo.png
   :align: center

   Step 7. When prompted open the repository.

.. figure:: assets/mac_setup/trust_us.png
   :align: center
   
   Step 8. If prompted, decide whether you trust us (we'll assume you do and
   click yes).

.. figure:: assets/mac_setup/search_git_clone.png
   :align: center
   
   Step 9. Once there are files in your workspace the souce control view will
   change to allow you to interact with the version control of the open files.
   Unfortunately, this means we can not add additional repositories the same way
   we did in Step 2. Rather, you need to use the command palate
   (command + shift + P) then search ``Git: Clone``. That will return you to
   Step 3 above, with the caveat that what was Step 7 should be replaced by
   Step 10 below.
   
.. figure:: assets/mac_setup/add_to_workspace.png
   :align: center
   
   Step 10. Since you have files in your workspace already the dialog box from
   Step 7 will change and you will want to select "Add to Workspace" instead of 
   "Open".

.. figure:: assets/mac_setup/save_workspace.png
   :align: center
   
   Step 11. Repeat Steps 9 and 10 until you have all the repositories you want.
   Once you are done save your workspace by going to 
   ``File->"Save Workspace As..."``. We recommend saving it into the 
   ``nwchemex`` workspace directory and naming it as 
   ``nwchemex.code-workspace``.

   .. note::

      If you choose a repository containing C++ source code, e.g.,
      ``NWChemEx/chemist``, VSCode may prompt you to select a kit.
      Instructions for this are below. To get this to go away for now just
      click "unspecified" or press esc.

.. _creating_a_cmake_toolchain_file:

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

.. _setting_up_kits:

Setting up Kits
===============

Kits are sets of tools to use to build the code. They are usually named based
on the compiler you want to use. Since MacOS ships with Clang, this tutorial
assumes you have Clang and are creating a Clang kit.

.. note::

   This tutorial assumes you have set the setting
   ``cmake.options.statusBarVisibility`` to visible.

.. figure:: assets/mac_setup/click_no_active_kit.png
   :align: center
   
   Step 1. Click on ``No active kit``. If you had previously selected a kit,
   this may instead display the name of that kit.

.. figure:: assets/mac_setup/select_clang.png
   :align: center
   
   Step 2. Select ``Clang <version goes here>``.

   .. note::
      
      Depending on your VSCode settings, selecting your kit will
      immediately start a CMake configuration run. Since we're not done setting
      up, it will likely fail...

.. figure:: assets/mac_setup/edit_kit.png
   :align: center 

   Step 3.  If you want to always use the same options with the same
   tool kit (e.g., always use Ninja generator), you can edit the tool
   kit file. To do this, open the command palette (command + shift + P) 
   and search for  ``Edit User-Local CMake Kits``.

.. figure:: assets/mac_setup/add_toolchain_to_kit.png
   :align: center
   
   Step 4. If we want to always use the same toolchain file with the same 
   toolkit, we can edit the kit to know about the toolchain file.
   Add ``"toolchainFile": "<path/to/the/toolchain>"`` to your kit.

   .. note::

      This step assumes you did not skip the 
      :ref:`creating_a_cmake_toolchain_file` section.

   Another good idea, assuming you have Ninja installed 
   (``brew install ninja``) is to add it to your kit via:

   .. code-block::

      "preferredGenerator": {
        "name": "Ninja"
      },
      "environmentVariables": {
        "PATH": "/opt/homebrew/bin;${env:PATH}"
      }

Configuring a Project
=====================

.. figure:: assets/mac_setup/select_active_project.png
   :align: center

   Step 1. If you have multiple git projects open, make sure you select the one
   you want to configure.

.. figure:: assets/mac_setup/run_configure.png
   :align: center
   
   Step 2. Click ``CMake: [Debug]: Ready`` to start configuring.

.. figure:: assets/mac_setup/select_configuration.png
   :align: center

   Step 3. Select the configuration you would like.

Troubleshooting
---------------

- If you get an error about the CMake executable like:

   .. figure:: assets/mac_setup/bad_cmake_executable.png
      :align: center

      Bad CMake executable error.

  it most likely means you do not have CMake installed (see 
  :ref:`obtaining_dependencies_on_macos` for instructions) or VSCode can not 
  find CMake. To set the CMake executable open the command pallette 
  (command + shift + P) and search for ``cmake.cmakePath``.

- If you get an error about ``NWX_MODULE_DIRECTORY`` not being set, i.e.:

   .. figure:: assets/mac_setup/nwx_module_dir_not_set.png
      :align: center

      Failure to set ``NWX_MODULE_DIRECTORY``.

  it either means you did not pass your toolchain to CMake (see
  :ref:`creating_a_cmake_toolchain_file`) or you did not set 
  ``NWX_MODULE_DIRECTORY`` in your toolchain file.

- If the configuration fails because of a missing dependency (e.g.,
  MPI or Boost) consult :ref:`obtaining_dependencies_on_macos`.

- If the configuration fails because of the missing Python developer files, 
  e.g.,

   .. figure:: assets/mac_setup/missing_python_headers.png
      :align: center

      CMake could not locate the Python header files.
  
   consult :ref:`obtaining_dependencies_on_macos`.

Building and Testing
====================

.. note::

   We assume you have setup a kit already. If not see :ref:`setting_up_kits`.

.. figure:: assets/mac_setup/select_what_to_build.png
   :align: center

   Step 1. Set the project, build configuration, and kit to what you want.

.. figure:: assets/mac_setup/click_build.png
   :align: center

   Step 2. Click build.

.. figure:: assets/mac_setup/run_ctest.png
   :align: center

   Step 3. Assuming Step 2 is successful, click on "Run CTest" to run the test
   suite.

Committing Changes Back to GitHub
=================================

.. note::

   This section assumes familiarity with git terminology.

.. figure:: assets/mac_setup/switch_to_source_control.png
   :align: center

   Step 1. Switch to the source control view.

.. figure:: assets/mac_setup/stage_changes.png
   :align: center

   Step 2. (Optional) select the file(s) you want to stage by clicking on the 
   "+" next to the file(s). If you do not stage files VSCode will assume you
   want to commit all changed files.

.. figure:: assets/mac_setup/commit_message.png
   :align: center

   Step 3. Type a descriptive commit message.

.. figure:: assets/mac_setup/click_commit.png
   :align: center

   Step 4. Click on the commit button. At this point your changes are only
   committed to your local copy of the repository. We still need to push them
   to GitHub.

.. figure:: assets/mac_setup/click_synch.png
   :align: center

   Step 5. Once you click "Commit" the button should change to "Synch Changes".
   Click that to push your changes to GitHub.

Troubleshooting
---------------

- You get an error about ``user.name`` and/or ``user.email`` for git is not set.
  i.e., something like:

   .. figure:: assets/mac_setup/error_git_name_not_set.png
      :align: center

      Error when your git credentials have not been set.
 
  The easiest way to fix this is to open a terminal (the one in VSCode works
  fine) and run:

  .. code-block:: bash

     git config --global user.email "your email goes here"
     git config --global user.name "your name goes here"

  For example:

  .. figure:: assets/mac_setup/set_git_name.png
     :align: center

     How to set the email and user name for git.   


- When attempting to synchronize with GitHub you get a cryptic error like:

   .. figure:: assets/mac_setup/cryptic_error.png
      :align: center

      Cryptic error when synchronizing.
  
  For me this was caused by a credentials issue. I simply ran ``git push`` from
  the VSCode terminal (in the root directory of the repo) and gave permission
  to VSCode to use my passwords. From that point forward commit and 
  synchronization worked fine from VSCode.
