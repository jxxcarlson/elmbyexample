module Vigenere exposing (longKeyEncrypt, longKeyDecrypt)

import Char


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


add : Int -> Int -> Int
add x y =
    (x + y) % 26


sub : Int -> Int -> Int
sub x y =
    (x - y) % 26


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
            List.map2 add textVector longKey
    in
        intListToString newVector


longKeyDecrypt : String -> String -> String
longKeyDecrypt key text =
    let
        longKey =
            extend key text |> stringToIntList

        textVector =
            text
                |> stringToIntList

        newVector =
            List.map2 sub textVector longKey
    in
        intListToString newVector
