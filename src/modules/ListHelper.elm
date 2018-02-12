module ListHelper exposing(unique, uniqueBy)

import List exposing (..)
import Set exposing (Set)
import Tuple exposing (first, second)

unique : List comparable -> List comparable
unique list =
    uniqueHelp identity Set.empty list []


{-| Drop duplicates where what is considered to be a duplicate is the result of first applying the supplied function to the elements of the list.
-}
uniqueBy : (a -> comparable) -> List a -> List a
uniqueBy f list =
    uniqueHelp f Set.empty list []


uniqueHelp : (a -> comparable) -> Set comparable -> List a -> List a -> List a
uniqueHelp f existing remaining accumulator =
    case remaining of
        [] ->
            List.reverse accumulator

        first :: rest ->
            let
                computedFirst =
                    f first
            in
                if Set.member computedFirst existing then
                    uniqueHelp f existing rest accumulator
                else
                    uniqueHelp f (Set.insert computedFirst existing) rest (first :: accumulator)
