#
# Correctness Tests
#

using ConstrainedOptim
using Base.Test
using Compat
using OptimTestProblems
MVP = OptimTestProblems.MultivariateProblems
debug_printing = true

my_tests = [
    "counter.jl",
    "ipnewton_unconstrained.jl",
    "constraints.jl",
]

function run_optim_tests(method; convergence_exceptions = (),
                         minimizer_exceptions = (),
                         minimum_exceptions = (),
                         f_increase_exceptions = (),
                         iteration_exceptions = (),
                         skip = (),
                         show_name = false,
                         show_trace = false,
                         show_res = false,
                         show_itcalls = false)
    # TODO: Update with constraints?
    # Loop over unconstrained problems
    for (name, prob) in MVP.UnconstrainedProblems.examples
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
        options = Options(iterations = iters, show_trace = show_trace; ConstrainedOptim.default_options(method)...)

        # Use finite difference if it is not differentiable enough
        if  !(name in skip) && prob.istwicedifferentiable
            # Loop over appropriate input combinations of f, g!, and h!
            df = TwiceDifferentiable(MVP.objective(prob), MVP.gradient(prob),
                                     MVP.objective_gradient(prob), MVP.hessian(prob), prob.initial_x)
            infvec = fill(Inf, size(prob.initial_x))
            constraints = TwiceDifferentiableConstraints(-infvec, infvec)
            results = optimize(df,constraints,prob.initial_x, method, options)
            @test isa(Optim.summary(results), String)
            show_res && println(results)
            show_itcalls && print_with_color(:red, "Iterations: $(Optim.iterations(results))\n")
            show_itcalls && print_with_color(:red, "f-calls: $(Optim.f_calls(results))\n")
            show_itcalls && print_with_color(:red, "g-calls: $(Optim.g_calls(results))\n")
            show_itcalls && print_with_color(:red, "h-calls: $(Optim.h_calls(results))\n")
            if !(name in convergence_exceptions)
                @test Optim.converged(results)
            end
            if !(name in minimum_exceptions)
                @test Optim.minimum(results) < prob.minimum + sqrt(eps(typeof(prob.minimum)))
            end
            if !(name in minimizer_exceptions)
                @test vecnorm(Optim.minimizer(results) - prob.solutions) < 1e-2
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
