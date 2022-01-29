.. code:: julia

    using Pkg

.. code:: julia

    Pkg.add("Flux")


.. parsed-literal::

    [32m[1m    Updating[22m[39m registry at `C:\Users\amans\.julia\registries\General.toml`
    [32m[1m   Resolving[22m[39m package versions...
    [32m[1m  No Changes[22m[39m to `C:\Users\amans\.julia\environments\v1.7\Project.toml`
    [32m[1m  No Changes[22m[39m to `C:\Users\amans\.julia\environments\v1.7\Manifest.toml`
    

.. code:: julia

    using Flux

.. code:: julia

    x = ones(Float32,1,2,3)




.. parsed-literal::

    1×2×3 Array{Float32, 3}:
    [:, :, 1] =
     1.0  1.0
    
    [:, :, 2] =
     1.0  1.0
    
    [:, :, 3] =
     1.0  1.0



.. code:: julia

    typeof(x)




.. parsed-literal::

    Array{Float32, 3}



.. code:: julia

    f(x) = 3x^2 + 2x + 1




.. parsed-literal::

    f (generic function with 1 method)



.. code:: julia

    f(1)




.. parsed-literal::

    6



.. code:: julia

    df(x) = gradient(f,x)[1]




.. parsed-literal::

    df (generic function with 1 method)



.. code:: julia

    df(1)




.. parsed-literal::

    8.0



.. code:: julia

    d2f(x) = gradient(df,x)[1]




.. parsed-literal::

    d2f (generic function with 1 method)



.. code:: julia

    d2f(1)




.. parsed-literal::

    6.0



.. code:: julia

    f(x,y) = sum((x.-y).^2)




.. parsed-literal::

    f (generic function with 2 methods)



.. code:: julia

    gradient(f,[2,1],[2,0])




.. parsed-literal::

    ([0.0, 2.0], [-0.0, -2.0])



These gradients are based on x and y. Flux works by instead taking gradients based on the weights and biases that make up the parameters of a model.

Machine learning often can have hundreds of parameters, so Flux lets you work with collections of parameters, via the params functions. You can get the gradient of all parameters used in a program without explicitly passing them in.

.. code:: julia

    x= [2,1];

.. code:: julia

    y = [2,0];

.. code:: julia

    gs = gradient(params(x,y)) do
        f(x,y)
    end




.. parsed-literal::

    Grads(...)



.. code:: julia

    gs[x]




.. parsed-literal::

    2-element Vector{Float64}:
     0.0
     2.0



.. code:: julia

    gs[y]




.. parsed-literal::

    2-element Vector{Float64}:
     -0.0
     -2.0



Here, gradient takes a zero-argument function; no arguments are necessary because the params tell it what to differentiate.

This will come in really handy when dealing with big, complicated models. For now, though, let's start with something simple.

.. code:: julia

    W = rand(2,5)




.. parsed-literal::

    2×5 Matrix{Float64}:
     0.761199  0.518721  0.299738  0.819246  0.795295
     0.695557  0.294634  0.136187  0.966324  0.556343



.. code:: julia

    b = rand(2)




.. parsed-literal::

    2-element Vector{Float64}:
     0.14996273490197987
     0.6003021631713606



.. code:: julia

    predict(x) = W*x .+ b




.. parsed-literal::

    predict (generic function with 1 method)



.. code:: julia

    function loss(x,y)
        y_cap = predict(x)
        sum((y .- y_cap).^2)
    end




.. parsed-literal::

    loss (generic function with 1 method)



.. code:: julia

    x,y = rand(5),rand(2)




.. parsed-literal::

    ([0.7296468340269642, 0.46668665850674407, 0.1263968430225897, 0.8288758645565867, 0.6767460059294579], [0.45303268852343126, 0.5292262928918061])



.. code:: julia

    x




.. parsed-literal::

    5-element Vector{Float64}:
     0.7296468340269642
     0.46668665850674407
     0.1263968430225897
     0.8288758645565867
     0.6767460059294579



.. code:: julia

    y




.. parsed-literal::

    2-element Vector{Float64}:
     0.45303268852343126
     0.5292262928918061



.. code:: julia

    loss(x,y)




.. parsed-literal::

    6.712027970590133



To improve the prediction we can take the gradients of the loss with respect to W and b and perform gradient descent.

.. code:: julia

    gs = gradient(() -> loss(x,y), params(W,b))




.. parsed-literal::

    Grads(...)



Now that we have gradients, we can pull them out and update W to train the model.

.. code:: julia

    W̄ = gs[W]




.. parsed-literal::

    2×5 Matrix{Float64}:
     2.55314  1.633    0.44228  2.90035  2.36803
     2.78837  1.78346  0.48303  3.16758  2.58621



.. code:: julia

    W .-= 0.1 .* W̄




.. parsed-literal::

    2×5 Matrix{Float64}:
     0.505886  0.355421  0.25551    0.529211  0.558492
     0.41672   0.116288  0.0878837  0.649566  0.297722



.. code:: julia

    loss(x,y)




.. parsed-literal::

    2.561531290621767



The loss has decreased a little, meaning that our prediction x is closer to the target y. If we have some data we can already try training the model.

All deep learning in Flux, however complex, is a simple generalisation of this example. Of course, models can look very different – they might have millions of parameters or complex control flow. Let's see how Flux handles more complex models.

Building Layers
It's common to create more complex models than the linear regression above. For example, we might want to have two linear layers with a nonlinearity like sigmoid (σ) in between them. In the above style we could write this as:

.. code:: julia

    W1 = rand(3,5)
    b1 = rand(3)
    layer1(x) = W1*x .+ b1
    
    W2 = rand(2,3)
    b2 = rand(2)
    layer2(x) = W2*x .+ b2




.. parsed-literal::

    layer2 (generic function with 1 method)



.. code:: julia

    model(x) = layer2(σ.(layer1(x)))




.. parsed-literal::

    model (generic function with 1 method)



.. code:: julia

    model(rand(5))




.. parsed-literal::

    2-element Vector{Float64}:
     2.708607068601554
     2.544804321090009



This works but is fairly unwieldy, with a lot of repetition – especially as we add more layers. One way to factor this out is to create a function that returns linear layers.

.. code:: julia

    function linear(in,out)
        W = randn(out,in)
        b = randn(out)
        x -> W*x .+ b
    end




.. parsed-literal::

    linear (generic function with 1 method)



.. code:: julia

    linear1 = linear(5,3)
    linear2 = linear(3,2)




.. parsed-literal::

    #5 (generic function with 1 method)



.. code:: julia

    model(x) = linear2(σ.(linear1(x)))




.. parsed-literal::

    model (generic function with 1 method)



.. code:: julia

    model(rand(5))




.. parsed-literal::

    2-element Vector{Float64}:
     -1.232166461802826
      1.0905079003829419



Another (equivalent) way is to create a struct that explicitly represents the affine layer.

.. code:: julia

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




.. parsed-literal::

    5-element Vector{Float64}:
     -2.0569200043481457
      0.5291964258570815
      0.022364722343165444
     -2.1226540250795836
     -1.6916634276472302



Congratulations! You just built the Dense layer that comes with Flux. Flux has many interesting layers available, but they're all things you could have built yourself very easily.

(There is one small difference with Dense – for convenience it also takes an activation function, like Dense(10, 5, σ).)

Stacking It Up
==============

It’s pretty common to write models that look something like:

layer1 = Dense(10, 5, σ)
# ...
model(x) = layer3(layer2(layer1(x)))


For long chains, it might be a bit more intuitive to have a list of layers, like this:

.. code:: julia

    layers = [Dense(10, 5, σ), Dense(5, 2), softmax]
    
    model(x) = foldl((x, m) -> m(x), layers, init = x)
    
    model(rand(10)) # => 2-element vector




.. parsed-literal::

    2-element Vector{Float64}:
     0.30598508147716963
     0.6940149185228304



Handily, this is also provided for in Flux:

.. code:: julia

    model2 = Chain(
      Dense(10, 5, σ),
      Dense(5, 2),
      softmax)
    
    model2(rand(10)) # => 2-element vector




.. parsed-literal::

    2-element Vector{Float64}:
     0.6417426727013729
     0.35825732729862725



This quickly starts to look like a high-level deep learning library; yet you can see how it falls out of simple abstractions, and we lose none of the power of Julia code.

A nice property of this approach is that because "models" are just functions (possibly with trainable parameters), you can also see this as simple function composition.

.. code:: julia

    m = Dense(5, 2) ∘ Dense(10, 5, σ)
    
    m(rand(10))




.. parsed-literal::

    2-element Vector{Float64}:
      0.5298847658491741
     -0.7395216463803215



.. code:: julia

    m = Chain(x -> x^2, x -> x+1)
    
    m(5) # => 26




.. parsed-literal::

    26



.. code:: julia

    Flux.@functor Affine

