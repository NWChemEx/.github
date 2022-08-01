Testing Requirements for New Pull Requests
==========================================

The usefulness of automated testing is dictated by the code coverage spanned
by the test set. Developers are required to provide tests which adequately evaluate
the functionality of their newly contributed code.

There are outstanding questions regarding the test requirements:
- Maintaining code coverage
  - Require a minimum percentage for the lines of code spanned by the tests?
    - We can evaluate this automatically with things like gcov, Codecov.
  - Put the burden on NWX code reviewers to ensure that the major functionality
    of the new code is covered by the tests?
    - More work, and more arbitrary.
    - Tests from approved pull requests should be added to either the [core or
      extended test sets](BuildValidation.md), as determined by the code reviewers.
- What do tests look like?
  - Unit tests 
    - Very useful, but they don't test interoperability with other software
      components. For example, a unit test for some Rys Quadrature code doesn't test
      whether those AO integrals can be used successfully in a subsequent coupled
      cluster job.
    - While guidelines and requirements for unit testing are not yet outlined,
      [Catch](https://github.com/philsquared/Catch) has been chosen as the automated
      test framework for NWX.
  - NWX input files
    - Tests module interoperability, but tests overlap unnecessarily over core
      routines.
    - Care must be taken to minimize the execution time while maintaining
      code coverage.
    - Developers are responsible for submitting tests with their pull requests
      which test functionality without unnecessarily long execution time. For
      example, a molecular dynamics equilibration run with thousands of timesteps
      is a poor test for a canonical Hartree-Fock gradient code.

