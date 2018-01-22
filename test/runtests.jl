#
# Correctness Tests
#

using IPNewtons
using Base.Test
using Compat
using OptimTestProblems
UP = OptimTestProblems.UnconstrainedProblems

debug_printing = true

my_tests = [
    "ipnewton_unconstrained.jl",
    "constraints.jl",
]#"constrained.jl"]


function run_optim_tests(method; convergence_exceptions = (),
                         minimizer_exceptions = (),
                         minimum_exceptions = (),
                         f_increase_exceptions = (),
                         iteration_exceptions = (),
                         skip = (),
                         show_name = false,
                         show_trace = false,
                         show_res = false)
    # Loop over unconstrained problems
    for (name, prob) in OptimTestProblems.UnconstrainedProblems.examples
        if !isfinite(prob.minimum) || !any(isfinite, prob.solutions)
            debug_printing && println("$name has no registered minimum/minimizer. Skipping ...")
            continue
        end
        show_name && print_with_color(:green, "Problem: ", name, "\n")
        # Look for name in the first elements of the iteration_exceptions tuples
        iter_id = find(n[1] == name for n in iteration_exceptions)
        # If name wasn't found, use default 1000 iterations, else use provided number
        iters = length(iter_id) == 0 ? 1000 : iteration_exceptions[iter_id[1]][2]
        # Construct options
        allow_f_increases = (name in f_increase_exceptions)
        options = OptimizationOptions(iterations = iters, show_trace = show_trace)

        # Use finite difference if it is not differentiable enough
        if  !(name in skip) && prob.istwicedifferentiable
            # Loop over appropriate input combinations of f, g!, and h!
            df = TwiceDifferentiable(UP.objective(prob), UP.gradient(prob),
                                     UP.objective_gradient(prob), UP.hessian(prob), prob.initial_x)
            infvec = fill(Inf, size(prob.initial_x))
            constraints = TwiceDifferentiableConstraints(-infvec, infvec)
            results = optimize(df,constraints,prob.initial_x, method, options)
            @test isa(summary(results), String)
            show_res && println(results)
            if !(name in convergence_exceptions)
                @test IPNewtons.converged(results)
            end
            if !(name in minimum_exceptions)
                @test IPNewtons.minimum(results) < prob.minimum + sqrt(eps(typeof(prob.minimum)))
            end
            if !(name in minimizer_exceptions)
                @test vecnorm(IPNewtons.minimizer(results) - prob.solutions) < 1e-2
            end
        else
            debug_printing && print_with_color(:blue, "Skipping $name\n")
        end
    end
end


println("Running tests:")

for my_test in my_tests
    println(" * $(my_test)")
    include(my_test)
end
