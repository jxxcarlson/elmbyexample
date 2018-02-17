module BarGraph exposing (..)

import Html exposing (Html, div, table, td, text, tr)
import Html.Attributes exposing (..)
import Svg exposing (rect, svg)
import Svg.Attributes as SA


main : Html msg
main =
    div
        [ mainStyle ]
        (barGraph 10 100 "red" [ 1.0, 0.5, 0.1, -0.1, -0.5, -1.0 ])


barGraph : Float -> Float -> String -> List Float -> List (Html.Html msg)
barGraph barWidth barHeight color scaledData =
    List.map (verticalBar barWidth barHeight color) scaledData


vRect : Float -> Float -> String -> Float -> Svg.Svg msg
vRect barWidth barHeight color fraction =
    if fraction > 0 then
        vRectPlus barWidth barHeight color fraction
    else
        vRectMinus barWidth barHeight color fraction


vRectPlus : Float -> Float -> String -> Float -> Svg.Svg msg
vRectPlus barWidth barHeight color fraction =
    rect
        [ SA.y <| toString <| (1 - fraction) * barHeight
        , SA.height <| toString <| fraction * barHeight
        , SA.width <| toString barWidth
        , SA.fill color
        ]
        []


vRectMinus : Float -> Float -> String -> Float -> Svg.Svg msg
vRectMinus barWidth barHeight color fraction =
    rect
        [ SA.y <| toString <| barHeight
        , SA.height <| toString <| -1 * fraction * barHeight
        , SA.width <| toString barWidth
        , SA.fill color
        ]
        []


verticalBar : Float -> Float -> String -> Float -> Html.Html msg
verticalBar barWidth barHeight color fraction =
    svg
        [ SA.width <| toString (1.3 * barWidth), SA.height <| toString <| 2 * barHeight ]
        [ vRect barWidth barHeight color fraction ]


mainStyle =
    style
        [ ( "width", "110px" )
        , ( "height", "190px" )
        , ( "padding", "20px" )
        , ( "background-color", "rgb(100,100,100)" )
        , ( "color", "white" )
        ]
