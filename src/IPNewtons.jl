__precompile__(true)

module IPNewtons
    using PositiveFactorizations
    using ForwardDiff
    using NLSolversBase, LineSearches
    using NaNMath
    using Optim

    import NLSolversBase: iscomplex,  AbstractObjective, hessian, hessian!,
    nconstraints, nconstraints_x
    import Optim: f_calls, g_calls, h_calls, OnceDifferentiable, TwiceDifferentiable,
    OptimizationState, OptimizationResults, OptimizationTrace, AbstractOptimizer,
    MultivariateOptimizationResults, pick_best_x, pick_best_f, x_abschange,
    f_abschange, g_residual, default_options, Options


    import Base.show

    export optimize,
           isfeasible,
           isinterior,
           nconstraints,
           OnceDifferentiable,
           TwiceDifferentiable,
           OnceDifferentiableConstraints,
           TwiceDifferentiableConstraints,
           Options,

           IPNewton

    # Types
    include("types.jl")

    # Tracing
    include("utilities/update.jl")

    # Constrained optimization
    include("iplinesearch.jl")
    include("interior.jl")
    include("ipnewton.jl")

    # Convergence
    include("utilities/assess_convergence.jl")

    # Traces
    include("utilities/trace.jl")
end
