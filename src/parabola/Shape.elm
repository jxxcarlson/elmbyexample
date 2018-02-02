module Shape exposing (Shape(..), draw, moveTo, moveBy)

{-|  The Shape module defines Shape type which can take values
of the form `Rect data` or `Ellipse data` and which provides
functions for manipulating these shapes and rendering them
into SVG. -}

import Svg as S exposing (..)
import Svg.Attributes exposing (..)
import ColorRecord exposing (..)
import Vector exposing (Vector)


type Shape
    = Rect ShapeData
    | Ellipse ShapeData


type alias ShapeData =
    { cx : Float
    , cy : Float
    , width : Float
    , height : Float
    , strokeColor : ColorRecord
    , fillColor : ColorRecord
    }


draw : Shape -> S.Svg msg
draw shape =
    case shape of
        Rect data ->
            S.rect (svgRectAttributes data) []

        Ellipse data ->
            S.ellipse (svgEllipseAttributes data) []


data : Shape -> ShapeData
data shape =
    case shape of
        Rect data ->
            data

        Ellipse data ->
            data


moveTo : Vector -> Shape -> Shape
moveTo position shape =
    let
        shapeData =
            data shape

        newShapeData =
            { shapeData | cx = position.x, cy = position.y }
    in
        case shape of
            Rect _ ->
                Rect newShapeData

            Ellipse _ ->
                Ellipse newShapeData


moveBy : Vector -> Shape -> Shape
moveBy displacement shape =
    let
        shapeData =
            data shape

        newShapeData =
            { shapeData | cx = displacement.x + shapeData.cx, cy = displacement.y + shapeData.cy }
    in
        case shape of
            Rect _ ->
                Rect newShapeData

            Ellipse _ ->
                Ellipse newShapeData

svgRectAttributes : ShapeData -> List (Attribute msg)
svgRectAttributes data =
    [ fill (rgba data.fillColor)
    , stroke (rgba data.fillColor)
    , x (toString (data.cx - data.width / 2))
    , y (toString (data.cy - data.height / 2))
    , width (toString data.width)
    , height (toString data.height)
    ]


svgEllipseAttributes : ShapeData -> List (Attribute msg)
svgEllipseAttributes data =
    [ fill (rgba data.fillColor)
    , stroke (rgba data.fillColor)
    , cx (toString data.cx)
    , cy (toString data.cy)
    , rx (toString data.width)
    , ry (toString data.height)
    ]


