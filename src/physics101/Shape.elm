module Shape exposing (Shape(..), ShapeData, draw, moveBy, moveTo, scaleBy, transform)

{-| The Shape module defines Shape type which can take values
of the form `Rect data` or `Ellipse data` and which provides
functions for manipulating these shapes and rendering them
into SVG.
-}

import Affine
import ColorRecord exposing (..)
import Svg as S exposing (..)
import Svg.Attributes exposing (..)
import Vector exposing (Vector)


type Shape
    = Rect ShapeData
    | Ellipse ShapeData


type alias ShapeData =
    { center : Vector
    , dimensions : Vector
    , strokeColor : ColorRecord
    , fillColor : ColorRecord
    }


transform : Affine.Coefficients -> Shape -> Shape
transform coefficients shape =
    let
        shapeData =
            data shape

        newCenter =
            Affine.transform coefficients shapeData.center

        newDimensions =
            Affine.linearTransform coefficients shapeData.dimensions

        newShapeData =
            { shapeData | center = newCenter, dimensions = newDimensions }
    in
        updateData shape newShapeData


draw : Shape -> S.Svg msg
draw shape =
    case shape of
        Rect data ->
            S.rect (svgRectAttributes data) []

        Ellipse data ->
            S.ellipse (svgEllipseAttributes data) []


updateData : Shape -> ShapeData -> Shape
updateData shape data =
    case shape of
        Rect _ ->
            Rect data

        Ellipse _ ->
            Ellipse data


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

        center =
            shapeData.center

        newCenter =
            { center | x = position.x, y = position.y }

        newShapeData =
            { shapeData | center = newCenter }
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

        center =
            shapeData.center

        newCenter =
            { center | x = displacement.x + center.x, y = displacement.y + center.y }

        newShapeData =
            { shapeData | center = newCenter }
    in
        case shape of
            Rect _ ->
                Rect newShapeData

            Ellipse _ ->
                Ellipse newShapeData


scaleBy : Float -> Shape -> Shape
scaleBy factor shape =
    let
        shapeData =
            data shape

        center =
            shapeData.center

        newCenter =
            { center | x = factor * center.x, y = factor * center.y }

        dimensions =
            shapeData.dimensions

        newDimensions =
            { dimensions | x = factor * dimensions.x, y = factor * dimensions.y }

        newShapeData =
            { shapeData | center = newCenter, dimensions = newDimensions }
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
    , x (toString (data.center.x - data.dimensions.x / 2))
    , y (toString (data.center.y - data.dimensions.y / 2))
    , width (toString data.dimensions.x)
    , height (toString data.dimensions.y)
    ]


svgEllipseAttributes : ShapeData -> List (Attribute msg)
svgEllipseAttributes data =
    [ fill (rgba data.fillColor)
    , stroke (rgba data.fillColor)
    , cx (toString data.center.x)
    , cy (toString data.center.y)
    , rx (toString data.dimensions.x)
    , ry (toString data.dimensions.y)
    ]
