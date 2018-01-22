__precompile__(true)

module IPNewtons
    using PositiveFactorizations
    using ForwardDiff
    using LineSearches

    import NLSolversBase: iscomplex, OnceDifferentiable, TwiceDifferentiable, AbstractObjective, hessian, hessian!
    import Base.length,
           Base.push!,
           Base.show,
           Base.getindex,
           Base.setindex!

    export optimize,
           isfeasible,
           isinterior,
           nconstraints,
           OnceDifferentiable,
           TwiceDifferentiable,
           OnceDifferentiableConstraints,
           TwiceDifferentiableConstraints,
           OptimizationOptions,
           OptimizationState,
           OptimizationTrace,

           IPNewton

    # Types
    include("types.jl")

    # API
    include("api.jl")

    # Generic stuff
    include("utilities/generic.jl")

    # Maxdiff
    include("utilities/maxdiff.jl")

    # Tracing
    include("utilities/update.jl")

    # Constrained optimization
    include("iplinesearch.jl")
    include("interior.jl")
    include("ipnewton.jl")

    # End-User Facing Wrapper Functions
   # include("optimize.jl")

    # Convergence
    include("utilities/assess_convergence.jl")

    # Traces
    include("utilities/trace.jl")

    # Examples for testing
#    include(joinpath("problems", "multivariate.jl"))
#    using .MultivariateProblems
end
