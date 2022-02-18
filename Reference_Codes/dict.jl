using Statistics
d1 = Dict("pi" =>3.14, "e" =>2.71)
println(d1["pi"])
d1["golden"] = 1.618
println(d1)
delete!(d1,"pi")
println(haskey(d1,"pi"))
println(in("pi" => 3.14))
println(keys(d1))
println(values(d1))
for kv in d1
    println(kv)
end
for (key,value) in d1
    println(key,value)
end