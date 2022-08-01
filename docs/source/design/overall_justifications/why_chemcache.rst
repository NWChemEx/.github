#########################
Why Do We Need ChemCache?
#########################

Inevitably NWChemEx will need access to hard-coded data. Typically this data is
physical data (for example fundamental constants, atomic masses, etc.) or model
parameters (for ab initio calculations the atomic basis sets). We have opted to
store such data in the ChemCache repo. This section describes this decision in
more detail.

The need for ChemCache is fueled by several points: we want all of the
hard-coded data used in NWChemEx to come from a single source of truth, users
may want to use their own hard-coded data, and we want to version control the
hard-coded data we use.
