module Shape exposing (..)

import Svg as S exposing (..)
import Svg.Attributes as SA exposing (..)
import XColor exposing (..)
import Vector exposing (Vector)


{-| The three data structures below define
the needed geometric structures: points,
circles, and rectangles.
-}
type alias ShapeData =
    { cx : Float
    , cy : Float
    , width : Float
    , height : Float
    , strokeColor : XColor
    , fillColor : XColor
    }


type Shape
    = Rect ShapeData
    | Ellipse ShapeData


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
moveTo displacement shape =
    let
        shapeData =
            data shape

        newShapeData =
            { shapeData | cx = displacement.x, cy = displacement.y }
    in
        case shape of
            Rect _ ->
                Rect newShapeData

            Ellipse _ ->
                Ellipse newShapeData


svgRectAttributes data =
    [ fill (rgba data.fillColor)
    , stroke (rgba data.fillColor)
    , x (toString (data.cx - data.width / 2))
    , y (toString (data.cy - data.height / 2))
    , width (toString data.width)
    , height (toString data.height)
    ]


svgEllipseAttributes data =
    [ fill (rgba data.fillColor)
    , stroke (rgba data.fillColor)
    , cx (toString data.cx)
    , cy (toString data.cy)
    , rx (toString data.width)
    , ry (toString data.height)
    ]


distance : Shape -> Shape -> Float
distance p q =
    let
        pd =
            data p

        qd =
            data q

        dx =
            pd.cx - qd.cx

        dy =
            pd.cy - qd.cy

        d_squared =
            dx * dx + dy * dy
    in
        sqrt d_squared
