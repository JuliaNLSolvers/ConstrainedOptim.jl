#
# Correctness Tests
#

using IPNewtons
using Base.Test
using Compat

my_tests = [
     "constraints.jl",
    ]#"constrained.jl"]

println("Running tests:")

for my_test in my_tests
    println(" * $(my_test)")
    include(my_test)
end
