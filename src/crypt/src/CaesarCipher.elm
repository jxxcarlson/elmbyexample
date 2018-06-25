module CaesarCipher exposing (..)

import Char


{- Conversion functions -}


stringToIntList : String -> List Int
stringToIntList string =
    string
        |> String.toUpper
        |> String.toList
        |> List.map Char.toCode
        |> List.map (\c -> c - 65)


intListToString : List Int -> String
intListToString intList =
    intList
        |> List.map (\i -> i + 65)
        |> List.map Char.fromCode
        |> String.fromList



{- Encryption Functions -}


shift : Int -> Int -> Int
shift k n =
    remainderBy 26 (k + n)


encryptWithCaesar : Int -> String -> String
encryptWithCaesar k str =
    str
        |> String.toUpper
        |> stringToIntList
        |> List.map (shift k)
        |> intListToString
