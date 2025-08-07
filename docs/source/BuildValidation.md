<!--
  ~ Copyright 2025 NWChemEx-Project
  ~
  ~ Licensed under the Apache License, Version 2.0 (the "License");
  ~ you may not use this file except in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~ http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing, software
  ~ distributed under the License is distributed on an "AS IS" BASIS,
  ~ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ~ See the License for the specific language governing permissions and
  ~ limitations under the License.
-->

NWChemEx Build Validation Policy
================================

It is impractical to test all functionality in NWChemEX on every permutation
of software/hardware platforms for every pull request. We should identify a
core test set which executes on every pull request in order to catch
low-hanging bugs, and a more comprehensive extended test set to run before
releases.

- Core test set
  - Adequatly cover core functionality such as Hartree-Fock, DFT, MP2, CC for
    a small range of molecules/basis sets.
  - Hard execution time limit for the complete set (1 hour?).
  - While the core test set might not explicitly test the features contributed
    in the pull request, the core test set is executed in addition to the new
    tests included with the pull request.

- Extended test set
  - Run before each public release, or periodically.
  - A hard execution time limit makes less sense here.
  - In addition to covering more of the NWChemEx code,

- NWChemEx should be validated for most or all of the hardware/softare environments
  in use at major supercomputing centers. Covering all permutations is impractical,
  but the most important combinations should be identified and updated as platforms are
  introduced or retired.
  - Hardware:
    - Intel Xeon CPU
    - AMD CPU
    - IBM PowerX CPU
    - Intel Xeon Phi
    - Nvidia GPU
  - Software:
    - Compilers
      - Intel
      - GCC
      - PGI
      - clang
    - Math Libraries
      - MKL
      - ATLAS
      - OpenBLAS
    - MPI
      - MVAPICH
      - IMPI
      - OpenMPI
    - Other Software
      - Linux kernel (from experience, this is important)
        - Current Ubuntu and Redhat LTS?
	- Just cover kernels used on target supercomputers?
      - Different versions of CUDA, OpenCL, OpenACC, etc.


- Continuous integration software
  - TravisCI is convenient for the core test set triggered on each PR. It does
    not offer an adequate hardware/software environment to validate code for
    the full range of use cases.
  - What are some alternative CI frameworks which offer more control over these
    parameters?
