module People exposing(..)

type alias Person = {name: String, age: Int}

p1 = {name = "John Henry", age = 47}
p2 = {name = "Maria O'Donnel", age = 24}
p3 = {name = "Isacac Stone", age = 71}
p4 = Person "Doris Harnack" 40
p5 = Person "Hubert Lane" 22

people = [p1, p2, p3, p4, p5]

names : Person -> List String
names person  =
  person.name |> String.split " " |> List.reverse

sortNames : List Person -> List String
sortNames people =
  people
    |> List.map names
    |> List.sort
    |> List.map List.reverse
    |> List.map (String.join " ")

updateAge : Int -> Person -> Person
updateAge increment person =
  { person | age = person.age + increment}

updateAges : Int -> List Person -> List Person
updateAges increment people =
  List.map (updateAge increment) people

averageAge : List Person -> Float
averageAge people =
  let
    ages = List.map .age people |> List.map toFloat
    n = List.length ages |> toFloat
    total = List.sum ages
  in
    total/n
