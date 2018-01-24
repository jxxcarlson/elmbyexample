module MaybePeople exposing

{- This module is a variant of the module People.
The age field is not an Int but a Maybe Int.
This change, which recognizes that the data set
may be icomplete or that people may not wich to
divulge their age, requires manny changes to the code.
We discuss these changes in the notes

-}

type alias Person = {name: String, age: Maybe Int}

p1 = {name = "John Henry", age = Just 47}
p2 = {name = "Maria O'Donnell", age = Just 24}
p3 = {name = "Isacac Stone", age = Nothing}
p4 = Person "Doris Harnack" Nothing
p5 = Person "Hubert Lane" (Just 22)

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
  case person.age of
    Just nYears -> { person | age = Just (nYears + increment)}
    Nothing -> person

updateAges : Int -> List Person -> List Person
updateAges increment people =
  List.map (updateAge increment) people

averageAge : List Person -> (Float, Int)
averageAge people =
  let
    ages = people
      |> List.filter (\person -> person.age /= Nothing)
      |> List.map .age |> List.map ((Maybe.withDefault 0) >> toFloat)
    numberOfPeopleWithAnAge = List.length ages |> toFloat
    total = List.sum ages
    average = total/numberOfPeopleWithAnAge
    numberOfPeopleWithOutAnAge = (List.length people) - (List.length ages)
  in
    (average, numberOfPeopleWithOutAnAge)
