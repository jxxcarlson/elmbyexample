module Poker exposing(..)

import List.Extra

type Face = Jack | Queen | King | Ace
type CardValue = IntValue Int|  FaceValue Face
type Card =  Spade CardValue | Heart CardValue | Diamond CardValue | Club CardValue
type HandType = Pair CardValue | TwoPair CardValue CardValue | ThreeOfAKind CardValue | FourOfAKind CardValue | FullHouse CardValue CardValue
type CrudeHandType = OneOfAKind_ | Pair_ | TwoPair_ | ThreeOfAKind_ | FourOfAKind_ | FullHouse_

value : Card -> CardValue
value card =
    case card of
      Spade v -> v
      Heart v -> v
      Diamond v -> v
      Club v -> v

pointValue : CardValue -> Int
pointValue value =
  case value of
    IntValue k -> k
    FaceValue k -> evalFace k

evalFace : Face -> Int
evalFace face =
  case face of
    Jack -> 11
    Queen -> 12
    King -> 13
    Ace -> 14

handValues : List Card -> List Int
handValues hand =
  List.map (value >> pointValue) hand


signature : List Card -> List (List Int)
signature hand =
  hand
    |> handValues
    |> List.sort
    |> List.Extra.group
    |> List.sortBy List.length
    |> List.reverse
    |> List.take 2

shortSignature : List Card -> List Int
shortSignature hand =
  hand
    |> signature
    |> List.map List.length


kindOfHand : List Card -> CrudeHandType
kindOfHand hand =
    case shortSignature hand of
      [1,1] -> OneOfAKind_
      [2,1] -> Pair_
      [2,2] -> TwoPair_
      [3,1] -> ThreeOfAKind_
      [4,1] -> FourOfAKind_
      [3,2] -> FullHouse_
      _ -> OneOfAKind_




hand1 = [Spade (IntValue 2),
         Diamond (IntValue 10),
         Club (FaceValue King),
         Diamond (IntValue 9),
         Heart (IntValue 2)]

hand2 = [Spade (IntValue 7),
         Diamond (IntValue 10),
         Club (FaceValue King),
         Diamond (IntValue 9),
         Heart (IntValue 2)]
