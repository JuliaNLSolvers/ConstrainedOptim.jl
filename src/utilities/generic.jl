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
    f_calls::Int64
    g_calls::Int64
    h_calls::Int64
end

@def add_linesearch_fields begin
    x_ls::Array{T}
    g_ls::Array{T}
    alpha::T
    mayterminate::Bool
    lsr::LineSearches.LineSearchResults
end

@def initial_linesearch begin
    (similar(initial_x), # Buffer of x for line search in state.x_ls
    similar(initial_x), # Buffer of g for line search in state.g_ls
    one(T), # Keep track of step size in state.alpha
    false, # state.mayterminate
    LineSearches.LineSearchResults(T))
end
