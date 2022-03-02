using Pkg

Pkg.add("StatsBase")

Pkg.add("NNlib")

Pkg.add("Missings")

Pkg.add("CSV")

Pkg.add("MLDatasets")

Pkg.add("Flux")

Pkg.add("DataFrames")

Pkg.add("Parameters")

using Parameters: @with_kw

using CSV

using NNlib

using Flux

using Flux: logitcrossentropy, normalise, onecold, onehotbatch, onehot

using MLDatasets:Titanic

using StatsBase

using DataFrames

using Missings

# Cleaning the data => Removing the "Name", "Ticket", "Cabin", "PassengerId"

train_data = CSV.read("D:/Julia/TitanicML/train.csv",DataFrame)

describe(train_data)

# Cleaning the data => Removing the "Name", "Ticket", "Cabin"

train_data = select(train_data, Not(:"Name"))

train_data = select(train_data,Not(:"PassengerId"))

train_data = select(train_data, Not(:"Ticket"))

train_data = select(train_data, Not(:"Cabin"))

train_data = dropmissing(train_data, :"Embarked")

describe(train_data)

replace!(train_data."Age", missing =>  29.6421);

train_data

describe(train_data)

for i in 1:889
    if train_data[i,3] == "male"
        train_data[i,3] = "0"
    elseif train_data[i,3] == "female"
        train_data[i,3] = "1"
    end
end

train_data

train_data[!,:"Sex"] = parse.(Int64,train_data[!,:"Sex"])

train_data

train_data[:,8]

for i in 1:889
    if train_data[i,8] == "C"
        train_data[i,8] = "1"
    elseif train_data[i,8] == "Q"
        train_data[i,8] = "2"
    elseif train_data[i,8] == "S"
        train_data[i,8] = "0"
    end
end

train_data

train_data[!,:"Embarked"] = parse.(Int64,train_data[!,:"Embarked"])

train_data

train_data = dropmissing(train_data, :"Age")

# train_data = select(train_data, Not(:"Fare"))

# train_data = select(train_data, Not(:"Age"))

targets = select(train_data, Not(:"Survived"))

labels = select(train_data, (:"Survived"))

targets=Matrix(targets)

labels = Matrix(labels)

targets = reshape(targets,(7,889))

labels = reshape(labels,(1,889))

using Flux: logitcrossentropy, normalise, onecold, onehotbatch

NNlib.sigmoid(0)

normed_targets = normalise(targets, dims=2)

train_indices = [1:3:889 ; 2:3:889]

X_train = normed_targets[:, train_indices]
y_train = labels[:, train_indices]

X_train

X_test = normed_targets[:, 3:3:889]
y_test = labels[:, 3:3:889]

full_train_data = (X_train, y_train)

testing_data = (X_test,y_test)

X_test

testing_data

pred(x, model) = Int64(round(model(x)[1]))

model =  Chain(Dense(7, 64, NNlib.relu),Dense(64,128,NNlib.relu),Dense(128,32,NNlib.relu),Dense(32,16,NNlib.relu),Dense(16,7,NNlib.relu),Dense(7,1,NNlib.sigmoid))

model

loss(x, y) = Flux.Losses.binarycrossentropy(model(x), y)

using Flux: train!

opt = Flux.Optimise.ADAM()

training_data = Iterators.repeated((X_train, y_train), 1000)

parameters = Flux.params(model)

train!(loss, parameters, training_data, opt)

accuracy(x, y, model) = mean(round(model(x)) .== (y))

function train(model, train)
    # Testing model performance on test data 
    X_train, y_train = train
    total_pred = 0
    correct_pred = 0
    for i in 1:593
        prediction = (pred(X_train[:,i],model))
        true_value = y_train[:,i][1]
        print(prediction)
        print(true_value)
        if prediction == true_value
            correct_pred +=1
        end
        total_pred += 1
    end
    return correct_pred,total_pred

    # To avoid confusion, here is the definition of a Confusion Matrix: https://en.wikipedia.org/wiki/Confusion_matrix
#     println("\nConfusion Matrix:\n")
#     display(confusion_matrix(X_test, y_test, model))
end

correct_pred,total_pred = train(model,full_train_data)

print(correct_pred/total_pred)

function test(model, test)
    # Testing model performance on test data 
    X_test, y_test = test
    total_pred = 0
    correct_pred = 0
    for i in 1:296
        prediction = (pred(X_test[:,i],model))
        true_value = y_test[:,i][1]
        print(prediction)
        print(true_value)
        if prediction == true_value
            correct_pred +=1
        end
        total_pred += 1
    end
    return correct_pred,total_pred

    # To avoid confusion, here is the definition of a Confusion Matrix: https://en.wikipedia.org/wiki/Confusion_matrix
#     println("\nConfusion Matrix:\n")
#     display(confusion_matrix(X_test, y_test, model))
end

correct_pred,total_pred = test(model,testing_data)

print(correct_pred/total_pred)

total_pred

correct_pred


