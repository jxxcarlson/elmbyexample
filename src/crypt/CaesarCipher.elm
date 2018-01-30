module CaesarCipher exposing(..)

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

shift : Int -> Int -> Int
shift k n =
  (k + n) % 26


encryptWithCaesar : Int -> String -> String
encryptWithCaesar k str =
  str
    |> String.toUpper
    |> stringToIntList
    |> List.map (shift k)
    |> intListToString
