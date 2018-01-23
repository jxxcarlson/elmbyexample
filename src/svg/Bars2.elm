module Bars2 exposing (main)

import Html exposing (Html, div, table, td, text, tr)
import Html.Attributes exposing (..)
import Svg exposing (rect, svg)
import Svg.Attributes as SA


main : Html msg
main =
    div
        [ mainStyle ]
        (horizontalGraph 100 10 "red" [ 0.5, 1.0, 0.75, 0.5, 0.25 ])


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


horizontalGraph barWidth barHeight color data =
    List.map (horizontalBar barWidth barHeight color) data


mainStyle =
    style
        [ ( "width", "110px" )
        , ( "height", "90px" )
        , ( "padding", "20px" )
        , ( "background-color", "rgb(100,100,100)" )
        , ( "color", "white" )
        ]
