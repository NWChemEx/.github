.. _why_is_the_nwchemex_api_written_in_python:

##########################################
Why is the NWChemEx API Written in Python?
##########################################

The previous section, :ref:`why_is_cxx_the_primary_language_of_nwchemex`,
explained the decision to write the majority of NWChemEx in C++. The decision
has also been made to ensure that all of NWChemEx's APIs are available from
Python. This section explains why.

If you read the previous section, you may recall that Python is one of the most
popular programming languages, if not the most popular programming language, in
the world. This popularity has also seeped into computational science, where
workflows are increasingly written in Python, and rely on tools accessible from
Python. If we want NWChemEx to be part of this ecosystem it is essential that
we ensure that we have Python bindings.

At this point, it is perhaps worth noting that nothing prevents us from having
bindings to other languages (we actually also trivially have C++ bindings). So
if down the road we want Julia or Go bindings they can coexist with the Python
bindings. In fact, because of its popularity, Python already has the ability to
interface with a number of other languages; meaning using existing Python
modules its entirely possible to ignore that NWChemEx is written in C++, and
call it from say Rust, by relying on a tool like PyO3 (which lets you call
Rust from Python and vice versa).

The other major reason for having Python bindings is for plugin system. When a
user develops a plugin, that plugin depends on the SimDE, but otherwise is an
independent piece of code from NWChemEx. So how does someone running NWChemEx
use that plugin? One way would be to link NWChemEx against the plugin at compile
time, but this kind of defeats the purpose of the plugin in the first place (and
is somewhat undesirable from the NWChemEx team's standpoint as we may end up
having to maintain the plugin as it will likely be absorbed by the code). The
typical C++ strategy for runtime linking is via ``dlopen``. While a number of
packages use ``dlopen`` to great success, its notoriously fickle. Enter Python.
If both NWChemEx, and the plugin, have Python bindings, linking is as simple as
``import plugin``. The reality is there's no magic here; Python simply does the
runtime linking for us. However, Python's runtime linking is extremely well
vetted and reliable (plus we don't have to maintain it!!!!).
