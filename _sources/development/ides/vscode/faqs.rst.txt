FAQs
====

This subsection covers frequently asked questions regarding VSCode and
developing NWX with VSCode.

**How do I change the editor font size?**
-----------------------------------------

In settings search "editor.fontSize". Change the field to your preferred font
size.

**How do I get a ruler to signify the 80 character limit?**
-----------------------------------------------------------

In settings search "editor.rulers". Click on the "edit in settings.json" link.
In the ``settings.json file`` add "80" to the settings file that gets opened.

**How do I get the reST extension to use a virtual environment?**
-----------------------------------------------------------------

Assuming you have created a virtual environment ``venv`` and installed all of
your reST/Sphinx dependencies in to it. Start by using ctrl+shift+p to bring up
the command palette. Then select ``Python: Select Interpreter``. Navigate to
``venv/bin/python3``. Now the reST extension should use the virtual environment
``venv`` for rendering your documentation preview.

**How do I get the debugger to set breakpoints per file and not per filename?**
-------------------------------------------------------------------------------

By default VSCode assumes that when you set a breakpoint in a file ``x.cpp``
you want that breakpoint to be set in ``src/x.cpp`` and in ``tests/x.cpp``;
you probably don't. To fix this add to the ``launch.json`` file for your 
debugging session:
 
.. code-block:: json

   "sourceFileMap": {
     "${workspaceFolder}": {
       "editorPath": "${workspaceFolder}",
       "useForBreakpoints": "true"
     }
   }

**How do I get the debugger to break on a throw?**
--------------------------------------------------

Add the following to the ``"setupCommands"`` block of your ``launch.json`` file:

.. code-block:: json
   
   "description": "Enable break on all exceptions",
   "text": "catch throw",
   "ignoreFailures": true
