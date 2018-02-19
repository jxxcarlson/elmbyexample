module Data exposing (scale, scaleData, roundTo, timeLine)


timeLine : Int -> List Float
timeLine n =
    (List.range 0 (n - 1)) |> List.map toFloat


{-| multply all data ponts by k
-}
scale : Float -> List Float -> List Float
scale k data =
    List.map (\datum -> k * datum) data


{-| Scale data so that data points line in
the range [-1, +1]
-}
scaleData : List Float -> List Float
scaleData data =
    let
        m =
            data |> List.map abs |> List.maximum |> Maybe.withDefault 1.0
    in
        scale (1.0 / m) data


{-| round the `value` to `digits` number
of decimal places.
-}
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
