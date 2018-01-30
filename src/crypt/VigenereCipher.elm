module VigenereCipher exposing(..)

import Char

{- Conversion functions -}

stringToIntList : String -> List Int
stringToIntList str =
    str
        |> String.toUpper
        |> String.toList
        |> squeeze
        |> List.map charToInt

intListToString : List Int -> String
intListToString nums =
    nums
        |> List.map intToChar
        |> String.fromList

charToInt : Char -> Int
charToInt x =
  (Char.toCode x) - (Char.toCode 'A')

intToChar : Int -> Char
intToChar x =
   Char.fromCode (x + (Char.toCode 'A'))


squeeze : List Char -> List Char
squeeze chars =
  chars |> List.filter (\char -> char >= 'A' && char <= 'Z')


{- Encryption Functions -}

modularReduce : Int -> Int
modularReduce  k =
  k % 26


extend : String -> String -> String
extend key str =
    let
        n =
            String.length str

        k =
            String.length key

        r =
            (n // k) + 1

        longkey =
            List.repeat r key |> String.join ""
    in
        String.slice 0 n longkey


longKeyEncrypt : String -> String -> String
longKeyEncrypt key text =
    let
        longKey =
            extend key text |> stringToIntList

        textVector =
            text |> stringToIntList

        newVector =
            List.map2 (+) textVector longKey
            |> List.map modularReduce
    in
        intListToString newVector


longKeyDecrypt : String -> String -> String
longKeyDecrypt key text =
    let
        longKey =
            extend key text |> stringToIntList

        textVector =
            text |> stringToIntList

        newVector =
            List.map2 (-) textVector longKey
            |> List.map modularReduce
    in
        intListToString newVector
