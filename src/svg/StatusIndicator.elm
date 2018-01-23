module StatusIndicator exposing (main)

import Html exposing (Html, div, p, span, text)
import Html.Attributes exposing (..)
import Svg exposing (rect, svg)
import Svg.Attributes as SA


main : Html msg
main =
    div
        [ mainStyle
        ]
        [ indicator 100 10 "orange" 0.35
        , indicator 100 10 "orange" 0.9
        , indicatorWithLegend 100 40 "blue" 0.5 "charge"
        , indicatorWithLegend 100 10 "red" 0.65 "temperature"
        , indicatorWithLegend 100 10 "red" 0.9 "pressure"
        ]


indicator barWidth barHeight color fraction =
    svg
        [ SA.height <| toString barHeight
        , Html.Attributes.style [ ( "margin-top", "15px" ) ]
        ]
        [ horizontalBar barWidth barHeight "black" 1.0
        , horizontalBar barWidth barHeight color fraction
        ]


indicatorWithLegend barWidth barHeight color fraction legend =
    div []
        [ indicator barWidth barHeight color fraction
        , p [ legendStyle ] [ text legend ]
        ]


legendStyle =
    style [ ( "margin", "0" ), ( "color", "#ccc" ) ]


horizontalBar barWidth barHeight color fraction =
    svg
        [ SA.height <| toString (barHeight + 2) ]
        [ hRect barWidth barHeight color fraction ]


hRect barWidth barHeight color fraction =
    rect
        [ SA.width <| toString <| fraction * barWidth
        , SA.height <| toString barHeight
        , SA.fill color
        ]
        []


mainStyle =
    style
        [ ( "width", "200px" )
        , ( "height", "245px" )
        , ( "padding", "20px" )
        , ( "background-color", "rgb(100,100,100)" )
        , ( "color", "white" )
        ]
