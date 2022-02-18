using Statistics

st1 = Set(["Jim","John","Jill","Jack","Jill"])
println(st1)
println(in("Dwight",st1))
st2 = Set(["Aman","Deepak","Roma"])
println(union(st1,st2))
println(intersect(st1,st2))
println(setdiff(st1,st2))