println("I have finally started to learn julia for ML purposes")

my_answer = 42

typeof(my_answer)

my_pi = 3.14159
typeof(my_pi)

# You can leave comments on a single line using the pound/hash key

#=

For multi-line comments, 
use the '#= =#' sequence.

=#

sum = 3+7

sum

difference = 10-3

product = 20*5

quotient = 100/10

power = 10 ^ 2

modulus = 101%2

Sys.WORD_SIZE

x = 0x1

typeof(x)

# Unsigned integers are input and output using the 0x prefix and hexadecimal (base 16)
# digits 0-9a-f (the capitalized digits A-F also work for input). The size of the unsigned value is determined by the number of hex digits used:

(typemin(Int32),typemax(Int32))

for T in [Int8,Int16,Int32,Int64,Int128,UInt8,UInt16,UInt32,UInt64,UInt128]
           println("$(lpad(T,7)): [$(typemin(T)),$(typemax(T))]")
end

x= typemax(Int64)

x+1

x+1 == typemin(Int64)

10^19

# TO RESOLVE THIS OVERFLOW ERROR

big(10)^19

2.5e-4 # e notation indicates float64 values

a = 2.5f-4

typeof(a)

x = 0x.4p-1

typeof(x)

sizeof(Float16(4.))

10_000, 0.000_000_005, 0xdead_beef, 0b1011_0010

0.0 == -0.0

bitstring(0.0)

bitstring(-0.0)

1/Inf

Inf + Inf

Inf - Inf

Inf/Inf

0* Inf

NaN != NaN

(typemin(Float16),typemax(Float16))

setrounding(BigFloat, RoundUp) do
           BigFloat(1) + parse(BigFloat, "0.1")
       end

setrounding(BigFloat, RoundDown) do
           BigFloat(1) + parse(BigFloat, "0.1")
       end

setprecision(40) do
           BigFloat(1) + parse(BigFloat, "0.1")
       end

x = 3

(x-1)*(x+1)

# Vectorized Dot Operators

[1,2,3].^3

typeof([1,2,3].^2)


