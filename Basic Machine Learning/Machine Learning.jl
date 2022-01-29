using Pkg

Pkg.add("Flux")

using Flux

x = ones(Float32,1,2,3)

typeof(x)

f(x) = 3x^2 + 2x + 1

f(1)

df(x) = gradient(f,x)[1]

df(1)

d2f(x) = gradient(df,x)[1]

d2f(1)

f(x,y) = sum((x.-y).^2)

gradient(f,[2,1],[2,0])
These gradients are based on x and y. Flux works by instead taking gradients based on the weights and biases that make up the parameters of a model.

Machine learning often can have hundreds of parameters, so Flux lets you work with collections of parameters, via the params functions. You can get the gradient of all parameters used in a program without explicitly passing them in.
x= [2,1];

y = [2,0];

gs = gradient(params(x,y)) do
    f(x,y)
end

gs[x]

gs[y]
Here, gradient takes a zero-argument function; no arguments are necessary because the params tell it what to differentiate.

This will come in really handy when dealing with big, complicated models. For now, though, let's start with something simple.
W = rand(2,5)

b = rand(2)

predict(x) = W*x .+ b

function loss(x,y)
    y_cap = predict(x)
    sum((y .- y_cap).^2)
end

x,y = rand(5),rand(2)

x

y

loss(x,y)
To improve the prediction we can take the gradients of the loss with respect to W and b and perform gradient descent.
gs = gradient(() -> loss(x,y), params(W,b))
Now that we have gradients, we can pull them out and update W to train the model.
W̄ = gs[W]

W .-= 0.1 .* W̄

loss(x,y)
The loss has decreased a little, meaning that our prediction x is closer to the target y. If we have some data we can already try training the model.

All deep learning in Flux, however complex, is a simple generalisation of this example. Of course, models can look very different – they might have millions of parameters or complex control flow. Let's see how Flux handles more complex models.Building Layers
It's common to create more complex models than the linear regression above. For example, we might want to have two linear layers with a nonlinearity like sigmoid (σ) in between them. In the above style we could write this as:
W1 = rand(3,5)
b1 = rand(3)
layer1(x) = W1*x .+ b1

W2 = rand(2,3)
b2 = rand(2)
layer2(x) = W2*x .+ b2

model(x) = layer2(σ.(layer1(x)))

model(rand(5))
This works but is fairly unwieldy, with a lot of repetition – especially as we add more layers. One way to factor this out is to create a function that returns linear layers.
function linear(in,out)
    W = randn(out,in)
    b = randn(out)
    x -> W*x .+ b
end

linear1 = linear(5,3)
linear2 = linear(3,2)

model(x) = linear2(σ.(linear1(x)))

model(rand(5))
Another (equivalent) way is to create a struct that explicitly represents the affine layer.
struct Affine
  W
  b
end

Affine(in::Integer, out::Integer) =
  Affine(randn(out, in), randn(out))

# Overload call, so the object can be used as a function
(m::Affine)(x) = m.W * x .+ m.b

a = Affine(10, 5)

a(rand(10)) # => 5-element vector
Congratulations! You just built the Dense layer that comes with Flux. Flux has many interesting layers available, but they're all things you could have built yourself very easily.

(There is one small difference with Dense – for convenience it also takes an activation function, like Dense(10, 5, σ).)layer1 = Dense(10, 5, σ)
# ...
model(x) = layer3(layer2(layer1(x)))
For long chains, it might be a bit more intuitive to have a list of layers, like this:
layers = [Dense(10, 5, σ), Dense(5, 2), softmax]

model(x) = foldl((x, m) -> m(x), layers, init = x)

model(rand(10)) # => 2-element vector
Handily, this is also provided for in Flux:
model2 = Chain(
  Dense(10, 5, σ),
  Dense(5, 2),
  softmax)

model2(rand(10)) # => 2-element vector
This quickly starts to look like a high-level deep learning library; yet you can see how it falls out of simple abstractions, and we lose none of the power of Julia code.

A nice property of this approach is that because "models" are just functions (possibly with trainable parameters), you can also see this as simple function composition.
m = Dense(5, 2) ∘ Dense(10, 5, σ)

m(rand(10))

m = Chain(x -> x^2, x -> x+1)

m(5) # => 26

Flux.@functor Affine


