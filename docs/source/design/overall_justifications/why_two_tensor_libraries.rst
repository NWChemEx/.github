###############################################
Why Does NWChemEx Rely on Two Tensor Libraries?
###############################################

At the moment NWChemEx has two tensor libraries: TiledArray (TA) and TAMM. TA is
used to define all of the APIs by virtue of being under the hood of the
TensorWrapper component of Chemist. TAMM is used throughout the TAMM-SDE repo.
Developers new to the project may wonder why this is and this page does its best
to explain how this decision came to be.

So why do we not just use TA everywhere? The answer here is historical more
than anything else. Basically TAMM was originally supposed to be the tensor
library used throughout NWChemEx, but the initial developers of SCF and MP2 had
difficulty implementing SCF and MP2 routines (particularly the local versions)
with TAMM. Owing to time constraints, the decision was made to use TA to
implement SCF and MP2. This also required solidifying a number of APIs, which is
why TA (under the hood of TensorWrapper) became the default library.

While the above was going on, the TAMM team was hard at work on an HPC
implementation of CCSD and CCSD(T), which relied on TAMM. These implementations
underlie the modules in the TAMM-SDE repo.

Long-term the use of multiple tensor libraries in the community is a real
hurdle to interoperability and use of SimDE. This is part of the reason why we
introduced TensorWrapper. It is our hope that the various tensor libraries in
use can learn to communicate under the hood of TensorWrapper so that module
developers can use their tensor library of choice. Whether this is possible
remains to be seen.
