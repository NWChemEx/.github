Setting Up VSCode for NWX
=========================

This page focuses on how to initially setup VSCode, specifically from the
perspective of NWX development.

Creating a Workspace
--------------------

When you first start up VSCode you will want to go to
``files->add folder to workspace`` and provide VSCode with one of the NWChemEx
repos in your NWX workspace, *e.g.*, `nwx_workspace/SCF` in the directory
structure assumed in :ref:`Workflow Preliminaries`). Once you have done this you
should see your folder and its subdirectories in the explorer view
(explorer view is the icon with a page overlying a square in the left toolbar).
You can repeat this process for each of the additional NWX repos in your
workspace. It is recommend that you then save your workspace
(File->Save Workspace As) that way you can quickly open all of these repos
again.

.. note::

   AFAIK adding each repo individually in this manner is the only way for the
   CMake extension to properly register the root CMakeLists.txt for each repo.
   If you try to add the workspace root it will instead look for the root
   CMakeLists.txt there.

Adding Extensions
-----------------

By default VSCode is pretty bare bones. Additional features
are added/enabled by installing extensions. When you load up source code VSCode
will inspect it and automatically recommend you install the corresponding
extenstion (if it's not installed already). For developing NWX we recommend you
minimally install:

#. ``ms-vscode.cpptools``
#. ``ms-vscode.cmake-tools``
#. ``ms-python.python``
#. ``lextudio.restructuredtext``

To install an extension click on the extensions view (the icon in the left
toolbar with a square broken into four smaller squares) and search for the
identifiers given in the above list.
