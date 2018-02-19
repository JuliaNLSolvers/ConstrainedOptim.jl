abstract type ConstrainedOptimizer{T}  <: AbstractOptimizer end
abstract type IPOptimizer{T} <: ConstrainedOptimizer{T} end # interior point methods

function print_header(method::IPOptimizer)
    @printf "Iter     Lagrangian value Function value   Gradient norm    |==constr.|      μ\n"
end

function Base.show(io::IO, t::OptimizationState{Tf, M}) where M<:IPOptimizer where Tf
    md = t.metadata
    @printf io "%6d   %-14e   %-14e   %-14e   %-14e   %-6.2e\n" t.iteration md["Lagrangian"] t.value t.g_norm md["ev"] md["μ"]
    if !isempty(t.metadata)
        for (key, value) in md
            key ∈ ("Lagrangian", "μ", "ev") && continue
            @printf io " * %s: %s\n" key value
        end
    end
    return
end

function Base.show(io::IO, tr::OptimizationTrace{Tf, M}) where M <: IPOptimizer where Tf
    @printf io "Iter     Lagrangian value Function value   Gradient norm    |==constr.|      μ\n"
    @printf io "------   ---------------- --------------   --------------   --------------   --------\n"
    for state in tr
        show(io, state)
    end
    return
end
