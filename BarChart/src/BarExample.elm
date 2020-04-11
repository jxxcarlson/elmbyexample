module BarExample exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input

import Html exposing (Html, div)
-- import Html.Attributes exposing (..)
import Svg exposing (Svg, rect, svg, g)
import Svg.Attributes as SA


main : Html msg
main =
    Element.layout [] mainView



mainView =
    column [padding 40]
            [ el [] (text "Here I am")
             , barGraphAsHtml gA testData |> Element.html
             , el [] (text "Graph")

             ]

testPattern =  svg [] [g [] [barRect "blue" 10 100 0 0.5, barRect "blue" 10 100 20 1.0]] |> Element.html
testData = [ 0.5, 1.0, 0.75, 0.5, 0.25 ]


barGraphAsHtml : GraphAttributes -> List Float -> Html msg
barGraphAsHtml ga data =
    svg [SA.transform "scale(1,-1)"
       , SA.height <| String.fromFloat ga.barHeight
       , SA.viewBox <| "0 0 " ++ String.fromFloat ga.graphWidth ++ " " ++ String.fromFloat ga.barHeight]
      [barGraphAsSVG gA data]

barGraphAsSVG : GraphAttributes -> List Float -> Svg msg
barGraphAsSVG ga data =
    g [] (svgOfData ga data)

-- SA.transform "scale(1,-1)"

type alias GraphAttributes =
    { dx : Float
    , color : String
    , barHeight : Float
     , graphWidth: Float}


gA = { dx = 10
       , color = "blue"
       , barHeight = 100
       , graphWidth = 200 }


svgOfData : GraphAttributes -> List Float -> List (Svg msg)
svgOfData ga data =
    let
        barWidth = 0.8*ga.dx
        gbar = \(x,y) -> barRect ga.color barWidth ga.barHeight x y
    in
    List.map gbar (prepare ga.dx data)


-- PREPARE DATA

prepare : Float -> List Float -> List (Float, Float)
prepare dx data =
    let
        xs = xCoordinates (List.length data) dx
        ymax = List.maximum data |> Maybe.withDefault 1
        ys = List.map (\y -> y/ymax) data
    in
      List.map2 Tuple.pair xs ys

-- COMPUTE LIST OF X COORDINATES

{-
 > List.map (\i -> toFloat i / 10) (List.range 0 4)
 [0,0.1,0.2,0.3,0.4] : List Float


 > List.map (\i -> toFloat i / 1000) (List.range 0 1000000) |> List.reverse |> List.take 5 |> List.reverse
 [999.996,999.997,999.998,999.999,1000]

 -}

xCoordinates : Int -> Float -> List Float
xCoordinates n dx =
    List.reverse <| xCoordinates_ n dx [0]

xCoordinates_ : Int -> Float -> List Float -> List Float
xCoordinates_ n dx list =
    case List.length list == n of
        True -> list
        False -> xCoordinates_ n dx ((augment dx (List.head list))::list)

augment : Float -> Maybe Float -> Float
augment dx xx =
    case xx of
        Nothing -> 0
        Just x -> x + dx

-- BASIC SVG ELEMENT

barRect : String -> Float -> Float ->  Float -> Float -> Svg msg
barRect  color barWidth barHeight x fraction =
    rect
        [ SA.width <| String.fromFloat barWidth
        , SA.height <| String.fromFloat <| fraction*barHeight
        , SA.x <| String.fromFloat x
        , SA.fill color
        ]
        []

