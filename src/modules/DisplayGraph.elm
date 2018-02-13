module DisplayGraph exposing (..)

import Vector exposing (Vector)
import List.Extra
import Shape exposing (..)
import ColorRecord exposing (..)
import Line exposing (..)
import Svg exposing (Svg)


type alias Vertex =
    { id : Int, label : String }


type alias Edge =
    ( Int, Int )


type alias Graph =
    { vertices : List Vertex, edges : List Edge }


getPoints : Graph -> List Vector
getPoints graph =
    let
        points =
            []

        n =
            List.length graph.vertices

        theta =
            2 * 3.14159265 / (toFloat n)

        point =
            rotate (Vector 1 0) theta
    in
        List.range 0 (n - 1)
            |> List.foldl (\k acc -> (acc ++ [ point k ])) []


rotate : Vector -> Float -> Int -> Vector
rotate vector angle k =
    Vector.rotate ((toFloat k) * angle) vector


getIndexedPoints : Graph -> List ( Int, Vector )
getIndexedPoints graph =
    let
        points =
            getPoints graph

        ids =
            graph.vertices |> List.map .id
    in
        List.Extra.zip ids points


getPoint : List ( Int, Vector ) -> Int -> Maybe Vector
getPoint indexedPoints id =
    indexedPoints
        |> List.filter (\item -> (Tuple.first item) == id)
        |> List.head
        |> Maybe.map Tuple.second


edgeToSegment : List ( Int, Vector ) -> Edge -> Maybe Vector.DirectedSegment
edgeToSegment indexedPoints edge =
    let
        maybeA =
            getPoint indexedPoints (Tuple.first edge)

        maybeB =
            getPoint indexedPoints (Tuple.second edge)
    in
        case ( maybeA, maybeB ) of
            ( Just a, Just b ) ->
                Just (Vector.DirectedSegment a b)

            _ ->
                Nothing


renderPoints : List Vector -> List Shape
renderPoints centers =
    let
        size =
            0.5 / (toFloat (List.length centers))
    in
        centers |> List.map (\center -> makeCircle size center)


renderSegments : List Vector.DirectedSegment -> List Line
renderSegments directedSegments =
    directedSegments |> List.map (\edge -> makeLine edge)


makeCircle : Float -> Vector -> Shape
makeCircle size center =
    let
        shapeData =
            ShapeData center (Vector size size) ColorRecord.lightBlueColor ColorRecord.lightBlueColor
    in
        Ellipse shapeData


makeLine : Vector.DirectedSegment -> Line
makeLine segment =
    Line segment.a segment.b 2.5 ColorRecord.blackColor ColorRecord.blackColor


graphDisplay : Float -> Graph -> List (Svg msg)
graphDisplay scale graph =
    let
        k =
            0.8

        points =
            getPoints graph

        indexedPoints =
            getIndexedPoints graph

        segments =
            List.map (edgeToSegment indexedPoints) graph.edges
                |> List.filterMap identity

        renderedPoints =
            renderPoints points
                |> List.map (Shape.scaleBy (k * scale))
                |> List.map (Shape.moveBy (Vector scale scale))
                |> List.map Shape.draw

        renderedSegments =
            segments
                |> renderSegments
                |> List.map (Line.scaleBy (k * scale))
                |> List.map (Line.moveBy (Vector scale scale))
                |> List.map Line.draw
    in
        renderedSegments ++ renderedPoints ++ [ boundingBox scale ]


boundingBoxData =
    { center = (Vector 0 0)
    , dimensions = (Vector 2 2)
    , strokeColor = ColorRecord.blackColor
    , fillColor = ColorRecord.transparentBlueColor
    }


boundingBox scale =
    Rect boundingBoxData
        |> Shape.scaleBy (1.2 * scale)
        |> (Shape.moveBy (Vector (1.07 * scale) (scale)))
        |> Shape.draw
