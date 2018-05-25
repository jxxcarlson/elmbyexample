module StatusIndicatorApp exposing (main)

import Browser
import Html exposing (Html, div, p, span, text)
import Html.Attributes exposing (..)
import Svg exposing (rect, svg)
import Svg.Attributes as SA


main =
    Browser.staticPage mainDiv


mainDiv =
    div
        mainStyle
        [ indicator 100 10 "orange" 0.35
        , indicator 100 10 "orange" 0.9
        , indicatorWithLegend 100 40 "blue" 0.5 "charge"
        , indicatorWithLegend 100 10 "red" 0.65 "temperature"
        , indicatorWithLegend 100 10 "red" 0.9 "pressure"
        ]


indicator barWidth barHeight color fraction =
    svg
        [ SA.height <| String.fromInt barHeight
        , Html.Attributes.style "margin-top" "15px"
        ]
        [ horizontalBar barWidth barHeight "black" 1.0
        , horizontalBar barWidth barHeight color fraction
        ]


indicatorWithLegend barWidth barHeight color fraction legend =
    div []
        [ indicator barWidth barHeight color fraction
        , p legendStyle [ text legend ]
        ]


legendStyle =
    [ style "margin" "0", style "color" "#ccc" ]


horizontalBar barWidth barHeight color fraction =
    svg
        [ SA.height <| String.fromInt (barHeight + 2) ]
        [ hRect barWidth barHeight color fraction ]


hRect barWidth barHeight color fraction =
    rect
        [ SA.width <| String.fromFloat <| fraction * barWidth
        , SA.height <| String.fromInt barHeight
        , SA.fill color
        ]
        []


mainStyle =
    [ style "width" "200px"
    , style "height" "245px"
    , style "padding" "20px"
    , style "background-color" "rgb(100,100,100)"
    , style "color" "white"
    ]
