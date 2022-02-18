using Printf
using Statistics

# Working with strings in julia

s1 = "Just some random words\n"
println(length(s1))

println(s1[1])
println(s1[end])

name = string("Aman", " Sharma")
println(name)

i3 = 2
i4 = 3
println("$i3 + $i4 = $(i3 + i4)")