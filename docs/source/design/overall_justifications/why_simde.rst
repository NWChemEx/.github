#####################
Why Do We Need SimDE?
#####################

In :ref:`why_do_we_need_pluginplay` we explained the decision to build NWChemEx
on top of a modular framework. The actual design of SimDE goes beyond just using
modules, to decoupling the APIs of those modules from the guts of the framework.
This section explains why we wanted to keep the framework chemistry agnostic.

PluginPlay is designed to be a relatively generic framework. There is no
chemistry concepts tied to PluginPlay. In theory, this allows PluginPlay to be
used by other projects which are not chemistry specific. In practice, it is
probably somewhat unlikely that another project will pick up PluginPlay. Our
decision to separate the APIs from the framework is primarily based off the
realization that there needs to be a way to extend the types of modules that the
framework can use, without changing the framework's source code. This is where
the remainder of the SimDE comes in.

SimDE defines the module APIs we use throughout NWChemEx. These APIs have two
parts: the classes representing the chemistry concepts (primarily stored in
Chemist) and the actual property types. Barring the emergence of community
standards, NWChemEx will continue to use the APIs and classes within SimDE
as our standard. However, our standards do not cover every property that may be
of interest to a computational chemistry simulation (for example we are very
focused on ab initio methods and have not attempted to standardize molecular
mechanics properties). Thus we need a mechanism for developers to extend the
set of properties which can be computed. The property type system allows other
developers to define whatever APIs they like (using whatever classes they like
as well) and have PluginPlay be capable of using the resulting modules, all
without having to modify PluginPlay's source.
