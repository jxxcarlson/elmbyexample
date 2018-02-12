module SocialNetwork exposing(..)

import List.Extra

type alias Person =
    { id: Int
      , firstName : String
      , lastName: String
      , age : Int
      , friends: List Int
    }

p1 = Person 1 "John" "Jones"   23 [2, 4, 6]
p2 = Person 2 "Fred" "Mayer"   21 [1, 3]
p3 = Person 3 "Mary" "Smith"   21 [2, 4]
p4 = Person 4 "Jane" "Freeman" 25 [1, 2, 3, 5]
p5 = Person 5 "Liz" "Yang" 21 [4]
p6 = Person 6 "Tom" "Toles" 20 [1]

network = [p1, p2, p3, p4, p5, p6]

{- Given a list o people, invite all their friends -}
includeFriends: List Person -> List Person
includeFriends group =
  let
    peopleIds = group |> List.map .id
    friendIds = group |> List.map .friends |> List.concat
  in
  peopleIds ++ friendIds
    |> List.Extra.unique
    |> idsToPeople

idsToPeople : List Int -> List Person
idsToPeople idList =
  network |> List.filter (\person -> (List.member person.id idList))

iterate : (a -> a) -> Int -> a -> a
iterate f n initialValue =
  if n == 0 then
    initialValue
  else
    iterate f (n-1) (f initialValue)



f n = iterate includeFriends n [p6] |> List.map .firstName

{-

> f n = iterate includeFriends n [p6] |> List.map .firstName
<function> : Int -> List String
> f 0
["Tom"] : List String
> f 1
["John","Tom"] : List String
> f 2
["John","Fred","Jane","Tom"] : List String
> f 3
["John","Fred","Mary","Jane","Liz","Tom"] : List String
> f 4
["John","Fred","Mary","Jane","Liz","Tom"] : List String

-}
