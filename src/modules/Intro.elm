module Intro exposing (..)


type alias Person =
    { id: Int
      , firstName : String
      , lastName: String
      , age : Int
      , friends: List Int
    }

p1 = Person 1 "John" "Jones"   23 [2, 4]
p2 = Person 2 "Fred" "Mayer"   21 [1, 3]
p3 = Person 3 "Mary" "Smith"   21 [2, 4]
p4 = Person 4 "Jane" "Freeman" 25 [1, 2, 3]

people = [p1, p2, p3, p4]


type Suit
    = Spade
    | Heart
    | Diamond
    | Club


cardValue card =
    case card of
        Spade ->
            6

        Heart ->
            4

        Diamond ->
            2

        Club ->
            1
