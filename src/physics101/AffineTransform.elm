module AffineTransform exposing (..)

{-| M\
-}

import Svg as S exposing (..)
import Svg.Attributes as SA exposing (..)


type alias Size =
    { width : Float, height : Float }


type alias Rect =
    { corner : Point
    , size : Size
    }


{-| GraphData is as in the introduction: two rectangles
plus some additional data (colors)
-}
type alias GraphMap =
    { sourceRect : Rect
    , targetRect : Rect
    }


{-| AffineTransformData carries the coefficients of an
affine transformation
xx = ax + b
yy= cy + d
-}
type alias AffineTransformData =
    { a : Float
    , b : Float
    , c : Float
    , d : Float
    }


{-| affineTransformData takes a GraphData object and
returns an AffineTransformData object such that the
associated affine transformation maps sourceRect to
targetRect.
-}
make : GraphMap -> AffineTransformData
make graphMap =
    let
        aa =
            graphMap.targetRect.size.width / graphMap.sourceRect.size.width

        bb =
            graphMap.targetRect.corner.x - graphMap.sourceRect.corner.x

        cc =
            -graphMap.targetRect.size.height / graphMap.sourceRect.size.height

        dd =
            graphMap.targetRect.corner.y - graphMap.sourceRect.corner.y + graphMap.targetRect.size.height
    in
        { a = aa, b = bb, c = cc, d = dd }


{-| affineTransformPoint affineTransformData is
an affine transformation.
-}
affineTransformPoint : AffineTransformData -> Point -> Point
affineTransformPoint affineTransformData point =
    let
        x =
            affineTransformData.a * point.x + affineTransformData.b

        y =
            affineTransformData.c * point.y + affineTransformData.d
    in
        Point x y


affineTransformSize : AffineTransformData -> Size -> Size
affineTransformSize affineTransformData size =
    let
        w =
            (abs affineTransformData.a) * size.width

        h =
            (abs affineTransformData.c) * size.height

        -- 5.0 * size.height
    in
        Size w h
