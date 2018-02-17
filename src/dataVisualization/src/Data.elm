module Data exposing (..)


scale : Float -> List Float -> List Float
scale k data =
    List.map (\datum -> k * datum) data


scaleData : List Float -> List Float
scaleData data =
    let
        m =
            data |> List.map abs |> List.maximum |> Maybe.withDefault 1.0
    in
        scale (1.0 / m) data


roundTo : Int -> Float -> Float
roundTo digits value =
    let
        factor =
            10 ^ digits |> toFloat
    in
        value
            |> (\x -> x * factor)
            |> round
            |> toFloat
            |> (\x -> x / factor)
