module BarsApp exposing (main)

import Html exposing (Html, div, table, td, text, tr)
import Html.Attributes exposing (..)
import Svg exposing (rect, svg)
import Svg.Attributes as SA


main : Html msg
main =
    div
        [ mainStyle ]
        [ horizontalBar 100 10 "red" 0.5
        , horizontalBar 100 10 "red" 1.0
        , horizontalBar 100 10 "red" 0.75
        , horizontalBar 100 10 "red" 0.5
        , horizontalBar 100 10 "red" 0.25
        ]


hRect barWidth barHeight color fraction =
    rect
        [ SA.width <| toString <| fraction * barWidth
        , SA.height <| toString barHeight
        , SA.fill color
        ]
        []


horizontalBar barWidth barHeight color fraction =
    svg
        [ SA.height <| toString (barHeight + 2) ]
        [ hRect barWidth barHeight color fraction ]


mainStyle =
    style
        [ ( "width", "110px" )
        , ( "height", "90px" )
        , ( "padding", "20px" )
        , ( "background-color", "rgb(100,100,100)" )
        , ( "color", "white" )
        ]
