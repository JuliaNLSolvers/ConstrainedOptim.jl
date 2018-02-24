@testset "README example" begin
    using NLSolversBase
    # Rosenbrock
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

    x0 = [0.0, 0.0]
    df = TwiceDifferentiable(fun, fun_grad!, fun_hess!, x0)

    lx = [-0.5, -0.5]; ux = [0.5, 0.5]
    dfc = TwiceDifferentiableConstraints(lx, ux)
    res = optimize(df, dfc, x0, IPNewton())
    @test Optim.minimum(res) ≈ 0.25

    ux = fill(Inf, 2)
    dfc = TwiceDifferentiableConstraints(lx, ux)
    clear!(df)
    res = optimize(df, dfc, x0, IPNewton())
    @test Optim.minimum(res) < 0.0 + sqrt(eps())


    lx = fill(-Inf, 2); ux = fill(Inf, 2)
    dfc = TwiceDifferentiableConstraints(lx, ux)
    clear!(df)
    res = optimize(df, dfc, x0, IPNewton())
    @test Optim.minimum(res) < 0.0 + sqrt(eps())

    lx = Float64[]; ux = Float64[]
    dfc = TwiceDifferentiableConstraints(lx, ux)
    clear!(df)
    res = optimize(df, dfc, x0, IPNewton())
    @test Optim.minimum(res) < 0.0 + sqrt(eps())

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


    lx = Float64[]; ux = Float64[]
    lc = [-Inf]; uc = [0.5^2]
    dfc = TwiceDifferentiableConstraints(con_c!, con_jacobian!, con_h!,
                                         lx, ux, lc, uc)
    res = optimize(df, dfc, x0, IPNewton())
    @test Optim.minimum(res) ≈ 0.2966215688829263

    lc = [0.1^2]
    dfc = TwiceDifferentiableConstraints(con_c!, con_jacobian!, con_h!,
                                         lx, ux, lc, uc)
    res = optimize(df, dfc, x0, IPNewton())
    @test Optim.minimum(res) ≈ 0.2966215688829255
end
