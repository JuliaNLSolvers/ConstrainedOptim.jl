function trace!(tr, d, state, iteration, method::IPOptimizer, options)
    dt = Dict()
    dt["Lagrangian"] = state.L
    dt["μ"] = state.μ
    dt["ev"] = abs(state.ev)
    if options.extended_trace
        dt["α"] = state.alpha
        dt["x"] = copy(state.x)
        dt["g(x)"] = copy(state.g)
        dt["h(x)"] = copy(state.H)
        if !isempty(state.bstate)
            dt["gtilde(x)"] = copy(state.gtilde)
            dt["bstate"] = copy(state.bstate)
            dt["bgrad"] = copy(state.bgrad)
            dt["c"] = copy(state.constr_c)
        end
    end
    g_norm = vecnorm(state.g, Inf) + vecnorm(state.bgrad, Inf)
    Optim.update!(tr,
            iteration,
            value(d),
            g_norm,
            dt,
            options.store_trace,
            options.show_trace,
            options.show_every,
            options.callback)
end
