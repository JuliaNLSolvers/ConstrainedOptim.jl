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

The nonlinear constrained optimization interface in `ConstrainedOptim` assumes that the user can write the optimization problem in the following way.

<img src="https://camo.githubusercontent.com/0ed7f44cc77719a67791e3b51ad05f25dcfc5d6f/68747470733a2f2f6c617465782e636f6465636f67732e636f6d2f706e672e6c617465783f2535436c61726765253230253543626567696e253742616c69676e2a2537442532302535436d696e5f25374278253543696e2535436d6174686262253742522537442535456e2537446625323878253239253236253543717561642532302535437465787425374273756368253230746861742537442535432535432532306c5f782532302535436c65712532302535437068616e746f6d25374263253238253744782535437068616e746f6d2537422532392537442532302532362532302535436c6571253230755f782535432535432532306c5f632532302535436c657125323063253238782532392532302532362532302535436c6571253230755f632e253230253543656e64253742616c69676e2a253744" title="Constrained optimization problem" />

Multiple nonlinear constraints can be set by considering `c(x)` as a
vector. An equality constraint `g(x) = 0` is then defined by setting,
say, `c(x)_1 = g(x)`, `l_{c,1}= u_{c,1} = 0`.


## Example usage

We will go through examples of how to use `ConstrainedOptim` and
illustrate how to use the constraints interface with an interior-point
Newton optimization algorithm.
Throughout these examples we work with the standard Rosenbrock function.
The objective and its derivatives are given by
``` julia
fun(x) =  (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2

function fun_grad!(g, x)
    g[1] = -2.0 * (1.0 - x[1]) - 400.0 * (x[2] - x[1]^2) * x[1]
    g[2] = 200.0 * (x[2] - x[1]^2)
end

function fun_hess!(h, x)
    h[1, 1] = 2.0 - 400.0 * x[2] + 1200.0 * x[1]^2
    h[1, 2] = -400.0 * x[1]
    h[2, 1] = -400.0 * x[1]
    h[2, 2] = 200.0
end
```

6. Describe `optimize` interface, and add the correct options to
   IPNewton

To solve a constrained optimization problem we call the `optimize`
interface

``` julia
optimize(d::AbstractObjective, constraints::AbstractConstraints, initial_x::Tx, method::ConstrainedOptimizer)
```
We can create instances of `AbstractObjective` and
`AbstractConstraints` using the types `TwiceDifferentiable` and
`TwiceDifferentiableConstraints` from the package `NLSolversBase.jl`.

This package contains one `ConstrainedOptimizer` method called `IPNewton`.
To get information on the keywords used to construct method instances, use the Julia REPL help prompt (`?`).
```
help?> IPNewton
search: IPNewton

     Interior-point Newton
    ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡

     Constructor
    =============

  IPNewton(; linesearch::Function = ConstrainedOptim.backtrack_constrained_grad,
           μ0::Union{Symbol,Number} = :auto,
           show_linesearch::Bool = false)

  The initial barrier penalty coefficient μ0 can be chosen as a number, or set to :auto to let the
  algorithm decide its value, see initialize_μ_λ!.

  As of February 2018, the line search algorithm is specialised for constrained interior-point
  methods. In future we hope to support more algorithms from LineSearches.jl.

     Description
    =============

  The IPNewton method implements an interior-point primal-dual Newton algorithm for solving nonlinear,
  constrained optimization problems. See Nocedal and Wright (Ch. 19, 2006) for a discussion of
  interior-point methods for constrained optimization.

     References
    ============

  The algorithm was originally written by Tim Holy (@timholy, tim.holy@gmail.com).

    •    J Nocedal, SJ Wright (2006), Numerical optimization, second edition. Springer.

    •    A Wächter, LT Biegler (2006), On the implementation of an interior-point filter
        line-search algorithm for large-scale nonlinear programming. Mathematical Programming 106
        (1), 25-57.
```


### Defining "unconstrained" problems

1. Passing empty arrays
2. Passing Infs

### Box minimzation

1. Include one-sided and equality constraints (if possible?)

### Generic nonlinear

2. Use HS9 problem
