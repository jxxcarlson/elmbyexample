module Intro exposing (..)


type alias Person =
    { name : String, age : Int }


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
