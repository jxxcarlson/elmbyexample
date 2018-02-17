module LineGraph exposing (makeLineGraph, abscissa)

import Svg exposing (rect, svg)
import Svg.Attributes as SA
import Data
import Html


makeLineGraph : Float -> Float -> Float -> List Float -> Html.Html msg
makeLineGraph plotWidth plotHeight strokeWidth data =
    let
        segments =
            (makeLineSegments plotWidth data)
                |> List.map (draw strokeWidth)
                |> (\x -> x ++ [ abscissa plotWidth plotHeight strokeWidth ])
    in
        svg
            [ SA.width <| toString (plotWidth), SA.height <| toString <| plotHeight ]
            segments


abscissa plotWidth plotHeight strokeWidth =
    let
        abscissaSegment =
            makeSegment 0 (plotHeight / 2) plotWidth (plotHeight / 2)
    in
        draw strokeWidth abscissaSegment


rescale data =
    List.map (\x -> 100 - 100 * x) data


type alias Point =
    { x : Float, y : Float }


type alias LineSegment =
    { a : Point, b : Point }


makePoints : Float -> List Float -> List Point
makePoints width data =
    let
        n =
            List.length data

        k =
            width / (toFloat n)

        timeLine =
            (List.range 0 (n - 1)) |> List.map toFloat |> (Data.scale k)

        scaledData =
            data |> Data.scaleData |> rescale
    in
        List.map2 Point timeLine scaledData


makeLineSegments : Float -> List Float -> List LineSegment
makeLineSegments width data =
    let
        points =
            makePoints width data

        n =
            List.length data

        aa =
            List.take (n - 1) points

        bb =
            List.drop 1 points
    in
        List.map2 LineSegment aa bb


draw : Float -> LineSegment -> Svg.Svg msg
draw strokeWidth segment =
    Svg.line (lineAttributes strokeWidth segment) []


makeSegment : Float -> Float -> Float -> Float -> LineSegment
makeSegment x1 y1 x2 y2 =
    let
        a =
            Point x1 y1

        b =
            Point x2 y2
    in
        LineSegment a b


lineAttributes : Float -> LineSegment -> List (Svg.Attribute msg)
lineAttributes strokeWidth lineSegment =
    [ SA.fill (rgba (ColorRecord 0 0 0 1.0))
    , SA.stroke (rgba (ColorRecord 0 0 0 1.0))
    , SA.x1 (toString lineSegment.a.x)
    , SA.y1 (toString lineSegment.a.y)
    , SA.x2 (toString lineSegment.b.x)
    , SA.y2 (toString lineSegment.b.y)
    , SA.strokeWidth (toString strokeWidth)
    ]


type alias ColorRecord =
    { r : Int, g : Int, b : Int, a : Float }


rgba : ColorRecord -> String
rgba color =
    "rgba(" ++ toString color.r ++ "," ++ toString color.g ++ "," ++ toString color.b ++ "," ++ toString color.a ++ ")"
