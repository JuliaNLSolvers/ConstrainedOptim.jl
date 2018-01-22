@testset "IPNewton Unconstrained" begin
    #run_optim_tests(IPNewton(); show_name=true, show_res=true)

    prob = UP.examples["Rosenbrock"]
    df = TwiceDifferentiable(UP.objective(prob), UP.gradient(prob),
                             UP.objective_gradient(prob), UP.hessian(prob), prob.initial_x)

    infvec = fill(Inf, size(prob.initial_x))
    constraints = TwiceDifferentiableConstraints(-infvec, infvec)

    options = OptimizationOptions(iterations = 1000, show_trace = false)

    results = optimize(df,constraints,prob.initial_x, IPNewton(), options)
    @test isa(summary(results), String)
    @test IPNewtons.converged(results)
    @test IPNewtons.minimum(results) < prob.minimum + sqrt(eps(typeof(prob.minimum)))
    @test vecnorm(IPNewtons.minimizer(results) - prob.solutions) < 1e-2
end
