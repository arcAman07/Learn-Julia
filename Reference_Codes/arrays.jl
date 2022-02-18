using Printf
using Statistics

a1 = zeros(Int32, 2, 2)

a2 = Array{Int32}(undef, 5)

a3 = Float64[]

a4 = [1, 2, 3]
println(a4[1])
println(a4[end])
println(5 in a4)
println(findfirst(isequal(2), a4))
f(a) = (a >= 2) ? true : false
println(f(4))
println(findall(f(4)))
println(count(f(4)))