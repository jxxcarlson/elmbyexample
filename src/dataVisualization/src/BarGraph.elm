module BarGraph exposing (makeBarGraph)

import Svg exposing (rect, svg)
import Svg.Attributes as SA
import Html
import Data
import LineGraph


makeBarGraph : Float -> Float -> List Float -> Html.Html msg
makeBarGraph plotWidth plotHeight data =
    let
        svgData =
            (barGraph plotWidth plotHeight "red" (Data.scaleData data))
                |> (\x -> x ++ [ LineGraph.abscissa plotWidth plotHeight 1.0 ])
    in
        svg
            [ SA.width <| String.fromFloat (plotWidth), SA.height <| String.fromFloat <| plotHeight ]
            svgData


barWidth plotWidth data =
    (0.9 * plotWidth) / (toFloat (List.length data))


barGraph : Float -> Float -> String -> List Float -> List (Html.Html msg)
barGraph plotWidth plotHeight color scaledData =
    let
        n =
            List.length scaledData

        k =
            plotWidth / (toFloat n)

        timeLine =
            (List.range 0 (n - 1)) |> List.map toFloat |> (Data.scale k)

        barWidth_ =
            barWidth plotWidth scaledData
    in
        List.map2 (verticalBar barWidth_ (plotHeight / 2) color) timeLine scaledData


vRect : Float -> Float -> String -> Float -> Float -> Svg.Svg msg
vRect barWidth_ barHeight_ color x y =
    if y > 0 then
        vRectPlus barWidth_ barHeight_ color x y
    else
        vRectMinus barWidth_ barHeight_ color x y


vRectPlus : Float -> Float -> String -> Float -> Float -> Svg.Svg msg
vRectPlus barWidth_ barHeight_ color x y =
    rect
        [ SA.y <| String.fromFloat <| (1 - y) * barHeight_
        , SA.x <| String.fromFloat x
        , SA.height <| String.fromFloat <| barHeight_ * y
        , SA.width <| String.fromFloat barWidth_
        , SA.fill color
        ]
        []


vRectMinus : Float -> Float -> String -> Float -> Float -> Svg.Svg msg
vRectMinus barWidth_ barHeight_ color x y =
    rect
        [ SA.x <| String.fromFloat x
        , SA.y <| String.fromFloat <| barHeight_
        , SA.height <| String.fromFloat <| -1 * barHeight_ * y
        , SA.width <| String.fromFloat barWidth_
        , SA.fill color
        ]
        []


verticalBar : Float -> Float -> String -> Float -> Float -> Html.Html msg
verticalBar barWidth_ barHeight_ color x y =
    svg
        []
        [ vRect barWidth_ barHeight_ color x y ]
