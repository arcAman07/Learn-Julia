using Pkg

Pkg.add("Flux")

Pkg.add("BSON")

Pkg.add("Printf")

using Printf

using Flux

X = [1,2,3,4,5,6,7,8]
Y = [1,3,5,7,9,11,13,15]

W = rand(1)

b = rand(1)

size(X)

predict(x) = W*x + b

m = size(X)

function loss(x,y)
    ŷ = predict(x)[1]
    return sum((y - ŷ).^2)/2m[1]
end

loss(1,2)

for epoch in 1:100
    tot_loss = 0
    iteration_total = 0
    correct_pred = 0
    for i in 1:8
        iteration_total += 1
        x = X[i]
        y = Y[i]
        prediction = predict(x)
        if prediction[1] == y
            correct_pred += 1
        end
        pred_loss = loss(x,y)
        tot_loss += pred_loss
        gs = gradient(() -> loss(x,y), params(W,b))
        W̄ = gs[W]
        W -= 0.1 .* W̄
        bias = gs[b]
        b -= 0.1 .*bias
    end
    accuracy = correct_pred/iteration_total
    @printf("Epoch:%d, Accuracy:%f, Loss:%f ",epoch,accuracy,tot_loss)
    println()
end

W

b

using BSON: @save


