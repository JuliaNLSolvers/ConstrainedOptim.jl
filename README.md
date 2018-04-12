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

### Optimization interface
To solve a constrained optimization problem we call the `optimize`
method
``` julia
optimize(d::AbstractObjective, constraints::AbstractConstraints, initial_x::Tx, method::ConstrainedOptimizer, options::Options)
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

*Note*: For constrained optimization problems, we recommend
always enabling `allow_f_increases` and `successive_f_tol` in the options passed to `optimize`.
The default is set to `Optim.Options(allow_f_increases = true, successive_f_tol = 2)`.

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



### Box minimzation
We want to optimize the Rosenbrock function in the box
`-0.5 ≤ x ≤ 0.5`, starting from the point `x0=zeros(2)`.
Box constraints are defined using, for example,
`TwiceDifferentiableConstraints(lx, ux)`.

``` julia
x0 = [0.0, 0.0]
df = TwiceDifferentiable(fun, fun_grad!, fun_hess!, x0)

lx = [-0.5, -0.5]; ux = [1.0, 1.0]
dfc = TwiceDifferentiableConstraints(lx, ux)

res = optimize(df, dfc, x0, IPNewton())
```
The output from `res` is
```
Results of Optimization Algorithm
 * Algorithm: Interior Point Newton
 * Starting Point: [0.0,0.0]
 * Minimizer: [0.5,0.2500000000000883]
 * Minimum: 2.500000e-01
 * Iterations: 41
 * Convergence: true
   * |x - x'| ≤ 1.0e-32: false
     |x - x'| = 8.88e-14
   * |f(x) - f(x')| ≤ 1.0e-32 |f(x)|: true
     |f(x) - f(x')| = 0.00e+00 |f(x)|
   * |g(x)| ≤ 1.0e-08: false
     |g(x)| = 1.00e+00
   * Stopped by an increasing objective: false
   * Reached Maximum Number of Iterations: false
 * Objective Calls: 63
 * Gradient Calls: 63
```

If we only want to set lower bounds, use `ux = fill(Inf, 2)`
``` julia
ux = fill(Inf, 2)
dfc = TwiceDifferentiableConstraints(lx, ux)

clear!(df)
res = optimize(df, dfc, x0, IPNewton())
```
The output from `res` is now
```
Results of Optimization Algorithm
 * Algorithm: Interior Point Newton
 * Starting Point: [0.0,0.0]
 * Minimizer: [0.9999999998342594,0.9999999996456271]
 * Minimum: 7.987239e-20
 * Iterations: 35
 * Convergence: true
   * |x - x'| ≤ 1.0e-32: false
     |x - x'| = 3.54e-10
   * |f(x) - f(x')| ≤ 1.0e-32 |f(x)|: false
     |f(x) - f(x')| = 3.00e+00 |f(x)|
   * |g(x)| ≤ 1.0e-08: true
     |g(x)| = 8.83e-09
   * Stopped by an increasing objective: true
   * Reached Maximum Number of Iterations: false
 * Objective Calls: 63
 * Gradient Calls: 63
```


### Defining "unconstrained" problems

An unconstrained problem can be defined either by passing
`Inf` bounds or empty arrays.
**Note that we must pass the correct type information to the empty `lx` and `ux`**
``` julia
lx = fill(-Inf, 2); ux = fill(Inf, 2)
dfc = TwiceDifferentiableConstraints(lx, ux)

clear!(df)
res = optimize(df, dfc, x0, IPNewton())

lx = Float64[]; ux = Float64[]
dfc = TwiceDifferentiableConstraints(lx, ux)

clear!(df)
res = optimize(df, dfc, x0, IPNewton())
```

### Generic nonlinear constraints

We now consider the Rosenbrock problem with a constraint on
`x[1]^2 + x[2]^2`.

We pass the information about the constraints to the `optimize`
by defining a vector function `c(x)` and its Jacobian `J(x)`.

The Hessian information is treated differently, by considering the
Lagrangian of the corresponding slack-variable transformed
optimization problem. This is similar to how the CUTEst library works.
Let `H_j(x)` represent the Hessian of the `j`th component of
`c(x)`, and `λ_j` the corresponding dual variable in the
Lagrangian. Then we want the `constraint` object to
add the values of the `H_j(x)` to the Hessian of the objective,
weighted by `lambda_j`.

The Julian form for the supplied function `c(x)` and the derivative
information is then added in the following way.
``` julia
con_c!(c, x) = (c[1] = x[1]^2 + x[2]^2; c)
function con_jacobian!(J, x)
    J[1,1] = 2*x[1]
    J[1,2] = 2*x[2]
    J
end
function con_h!(h, x, λ)
    h[1,1] += λ[1]*2
    h[2,2] += λ[1]*2
end
```
**Note that `con_h!` adds the `λ`-weighted Hessian value of each element of `c(x)` to the Hessian of `fun`.**


We can then optimize the Rosenbrock function inside the ball of radius
`0.5`.
``` julia
lx = Float64[]; ux = Float64[]
lc = [-Inf]; uc = [0.5^2]
dfc = TwiceDifferentiableConstraints(con_c!, con_jacobian!, con_h!,
                                     lx, ux, lc, uc)
res = optimize(df, dfc, x0, IPNewton())
```
The output from the optimization is

```
Results of Optimization Algorithm
 * Algorithm: Interior Point Newton
 * Starting Point: [0.0,0.0]
 * Minimizer: [0.45564896414551875,0.2058737998704899]
 * Minimum: 2.966216e-01
 * Iterations: 28
 * Convergence: true
   * |x - x'| ≤ 1.0e-32: true
     |x - x'| = 0.00e+00
   * |f(x) - f(x')| ≤ 1.0e-32 |f(x)|: false
     |f(x) - f(x')| = 0.00e+00 |f(x)|
   * |g(x)| ≤ 1.0e-08: false
     |g(x)| = 7.71e-01
   * Stopped by an increasing objective: false
   * Reached Maximum Number of Iterations: false
 * Objective Calls: 109
 * Gradient Calls: 109
```

We finish the examples by optimizing the objective on the annulus with
inner and outer radii `0.1` and `0.5` respectively.

``` julia
lc = [0.1^2]
dfc = TwiceDifferentiableConstraints(con_c!, con_jacobian!, con_h!,
                                     lx, ux, lc, uc)
res = optimize(df, dfc, x0, IPNewton())
```
**Note that the algorithm warns that the Initial guess is not an
interior point.** `IPNewton` can often handle this, however, if the
initial guess is such that `c(x) = u_c`, then the algorithm currently
fails. We hope to fix this in the future.
