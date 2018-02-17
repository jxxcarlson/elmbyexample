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
            [ SA.width <| toString (plotWidth), SA.height <| toString <| plotHeight ]
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
vRect barWidth barHeight color x y =
    if y > 0 then
        vRectPlus barWidth barHeight color x y
    else
        vRectMinus barWidth barHeight color x y


vRectPlus : Float -> Float -> String -> Float -> Float -> Svg.Svg msg
vRectPlus barWidth barHeight color x y =
    rect
        [ SA.y <| toString <| (1 - y) * barHeight
        , SA.x <| toString x
        , SA.height <| toString <| barHeight * y
        , SA.width <| toString barWidth
        , SA.fill color
        ]
        []


vRectMinus : Float -> Float -> String -> Float -> Float -> Svg.Svg msg
vRectMinus barWidth barHeight color x y =
    rect
        [ SA.x <| toString x
        , SA.y <| toString <| barHeight
        , SA.height <| toString <| -1 * barHeight * y
        , SA.width <| toString barWidth
        , SA.fill color
        ]
        []


verticalBar : Float -> Float -> String -> Float -> Float -> Html.Html msg
verticalBar barWidth barHeight color x y =
    svg
        -- [ SA.width <| toString (1.3 * barWidth), SA.height <| toString <| 2 * barHeight ]
        []
        [ vRect barWidth barHeight color x y ]
