#################################
Why not Just Have One Giant Repo?
#################################

Most of the electronic structure packages in the field have a single monolithic
code base. When transitioning to NWChemEx from one of those packages it is not
uncommon to be taken aback by the number of repositories that NWChemEx
maintains. Surely this just complicates things right?

As you can probably guess, we argue that it does not add any additional
complexity (at least in the long run). While it may take you some time to come
up to speed with what's in each repo, we argue you have to do the same thing
with a monolithic code base too. In the case of a well organized, but single
repo electronic structure package, you have to learn what's in each library
(or module for Python packages). Repos in the NWChemEx project map to the
same level of granularity. Basically they collect a set of related
functionalities into a single component.

The motivation for going beyond separate libraries to separate repos is to
automate, to an extent, the enforcement of our library separation. Basically
since each repo must compile and pass CI, given only its immediate dependencies
we know that we have not introduced a cross-coupling between what are supposed
to be independent components. If they were simply libraries, which we linked
into one executable, then its possible for someone to break the separation by
say calling PluginPlay from Chemist. The resulting code would still compile and
unless it was caught in the code review process, we'd have an unexpected
dependency. It's of course possible to make Chemist call PluginPlay with our
design, but to do so would require a significant amount of additional work (
versus just adding a header file).

With the guarantee that our components really our separate components, we can
market them as individual products. This is useful for collaborative work,
where someone may just want say our SCF algorithm, but not the rest of the code.
By only pulling what they want, they avoid introducing a lot of extra code
bloat (the MP2, coupled-cluster, etc.). Sure it's possible to accomplish the
same thing with build system logic, but once you've spent an extensive amount of
time writing build system logic, you try to avoid complicating it any more than
you need to.

Another advantage to our multi-repo set-up is that we have orthogonal
workspaces. This is useful for organizing documentation, conversations, bug
tracking, issues, etc. It ultimately keeps the discussion closer to the code
versus having it all in a single place. In our opinion this also makes things
less daunting.
