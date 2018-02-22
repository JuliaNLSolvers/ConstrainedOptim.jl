# ConstrainedOptim

[![Build Status](https://travis-ci.org/JuliaNLSolvers/ConstrainedOptim.jl.svg?branch=master)](https://travis-ci.org/JuliaNLSolvers/ConstrainedOptim.jl)

[![Coverage Status](https://coveralls.io/repos/JuliaNLSolvers/ConstrainedOptim.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/JuliaNLSolvers/ConstrainedOptim.jl?branch=master)

[![codecov.io](http://codecov.io/github/JuliaNLSolvers/ConstrainedOptim.jl/coverage.svg?branch=master)](http://codecov.io/github/JuliaNLSolvers/ConstrainedOptim.jl?branch=master)

This package adds support for constrained optimization algorithms
to the package [Optim](https://github.com/JuliaNLSolvers/Optim.jl).
We intend to merge the code in `ConstrainedOptim` with `Optim` when
the interfaces and algorithms in this repository have been tested properly.
**Feedback is very much appreciated, either via [gitter](https://gitter.im/JuliaNLSolvers/Lobby)
or by creating an issue or PR on github.**

## Example usage

1. Motivate steps and examples.
2. Write down generic optimization problem.
3. Note that equality constraints are given by setting upper and lower bounds equal.
2. Define HS9 objective, gradient, hessian
5. Use IPNewton (for more info see the help `help?> IPNewton` in the Julia REPL.)
6. Describe `optimize` interface, and add the correct options to IPNewton

### Defining "unconstrained" problems

1. Passing empty arrays
2. Passing Infs

### Box minimzation

1. Include one-sided and equality constraints (if possible?)

### Generic nonlinear

2. Use HS9 problem
