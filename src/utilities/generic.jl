macro def(name, definition)
    esc(quote
      macro $name()
        esc($(Expr(:quote, definition)))
      end
    end)
  end

  # TODO decide if this is wanted and/or necessary
@def add_generic_fields begin
    n::Int64
    x::Array{T}
    f_x::T
end

@def add_linesearch_fields begin
    dphi0_previous::T
    x_ls::Array{T}
    alpha::T
    mayterminate::Bool
    lsr::LineSearches.LineSearchResults
end

@def initial_linesearch begin
    (T(NaN), # Keep track of previous descent value ⟨∇f(x_{k-1}), s_{k-1}⟩
    similar(initial_x), # Buffer of x for line search in state.x_ls
    one(T), # Keep track of step size in state.alpha
    false, # state.mayterminate
    LineSearches.LineSearchResults(T))
end
