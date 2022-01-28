Data structures
Once we start working with many pieces of data at once, it will be convenient for us to store data in structures like arrays or dictionaries (rather than just relying on variables).

Types of data structures covered:

Tuples
Dictionaries
Arrays

As an overview, tuples and arrays are both ordered sequences of elements (so we can index into them). Dictionaries and arrays are both mutable. We'll explain this more below!

Tuples
We can create a tuple by enclosing an ordered collection of elements in ( ).

Syntax:
(item1, item2, ...)
myfavoriteanimals = ("Tiger","cheetah","shark")

myfavoriteanimals[1]
but since tuples are immutable, we can't update it
myfavoriteanimals[1] = "otters"
Now in 1.6: NamedTuples
As you might guess, NamedTuples are just like Tuples except that each element additionally has a name! They have a special syntax using = inside a tuple:

(name1 = item1, name2 = item2, ...)
myfavoriteanimals = (bird="penguins",character="Ben Ten",name="Aman")

myfavoriteanimals.character
Dictionaries
If we have sets of data related to one another, we may choose to store that data in a dictionary. We can create a dictionary using the Dict() function, which we can initialize as an empty dictionary or one storing key, value pairs.

Syntax:

Dict(key1 => value1, key2 => value2, ...)
A good example is a contacts list, where we associate names with phone numbers.
myphonebook = Dict("Jenny" => "867-5309", "Ghostbusters" => "555-2368")

myphonebook["Jenny"]

myphonebook["Aman"] = "127-0727"

myphonebook
We can delete Jenny from our contact list - and simultaneously grab his number - by using pop!
pop!(myphonebook, "Jenny")

myphonebook
Unlike tuples and arrays, dictionaries are not ordered. So, we can't index into them.
myphonebook[1]
Arrays
Unlike tuples, arrays are mutable. Unlike dictionaries, arrays contain ordered collections.
We can create an array by enclosing this collection in [ ].

Syntax:

[item1, item2, ...]
For example, we might create an array to keep track of my friends
myfriends = ["Ted", "Robyn", "Barney", "Lily", "Marshall"]

fibonacci = [1, 1, 2, 3, 5, 8, 13]

mixture = [1, 1, 2, 3, "Ted", "Robyn"]

myfriends[3]

myfriends[3] = "Aman"

myfriends
Yes, Julia is 1-based indexing, not 0-based like Python. Wars are fought over lesser issues. I have a friend with the wisdom of Solomon who proposes settling this once and for all with ½ 😃

We can also edit the array by using the push! and pop! functions. push! adds an element to the end of an array and pop! removes the last element of an array.

We can add another number to our fibonnaci sequence
fibonacci

push!(fibonacci,21)

pop!(fibonacci)

fibonacci
So far I've given examples of only 1D arrays of scalars, but arrays can have an arbitrary number of dimensions and can also store other arrays.

For example, the following are arrays of arrays:
favorites = [["koobideh", "chocolate", "eggs"],["penguins", "cats", "sugargliders"]]

numbers = [[1, 2, 3], [4, 5], [6, 7, 8, 9]]

rand(4,3,2)

fibonacci

someNumbers = fibonacci

someNumbers[1] = 404

fibonacci
Editing somenumbers caused fibonacci to get updated as well!

In the above example, we didn't actually make a copy of fibonacci. We just created a new way to access the entries in the array bound to fibonacci.

If we'd like to make a copy of the array bound to fibonacci, we can use the copy function.
# First, restore fibonacci
fibonacci[1] = 1
fibonacci

somemorenumbers = copy(fibonacci)

somemorenumbers[1] = 404

fibonacci
In this last example, fibonacci was not updated. Therefore we see that the arrays bound to somemorenumbers and fibonacci are distinct.
a_ray = [1,2,3]

push!(a_ray,4)

pop!(a_ray)

a_ray

myphonebook

myphonebook["Emergency"] = 911

myphonebook

# Datatypes of key value should be consistent in the dictionary after a pattern has been established

flexible_phonebook = Dict("Jenny" => 8675309, "Ghostbusters" => "555-2368")

flexible_phonebook["Emergency"] = 911

flexible_phonebook


