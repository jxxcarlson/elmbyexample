module BarsApp exposing (main)

import Html exposing (Html, div, table, td, text, tr)
import Html.Attributes exposing (..)
import Svg exposing (rect, svg)
import Svg.Attributes as SA


main : Html msg
main =
    div
        mainStyle
        [ horizontalBar 100 10 "red" 0.5
        , horizontalBar 100 10 "red" 1.0
        , horizontalBar 100 10 "red" 0.75
        , horizontalBar 100 10 "red" 0.5
        , horizontalBar 100 10 "red" 0.25
        ]


hRect barWidth barHeight color fraction =
    rect
        [ SA.width <| String.fromFloat <| fraction * barWidth
        , SA.height <| String.fromInt barHeight
        , SA.fill color
        ]
        []


horizontalBar barWidth barHeight color fraction =
    svg
        [ SA.height <| String.fromInt (barHeight + 2) ]
        [ hRect barWidth barHeight color fraction ]


mainStyle =
    [ style "width" "110px"
    , style "height" "90px"
    , style "padding" "20px"
    , style "background-color" "rgb(100,100,100)"
    , style "color" "white"
    ]
