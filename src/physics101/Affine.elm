module Affine exposing (Coefficients, linearTransform, make, transform)

import Svg as S exposing (..)
import Svg.Attributes as SA exposing (..)
import Vector exposing (..)


type alias Rect =
    { corner : Vector
    , size : Vector
    }


{-| Coefficients carries the coefficients of an
affine transformation
xx = ax + b
yy= cy + d
-}
type alias Coefficients =
    { a : Float
    , b : Float
    , c : Float
    , d : Float
    }


type alias Transform =
    Coefficients -> Vector -> Vector


{-| coefficients takes a GraphData object and
returns an Coefficients object such that the
associated affine transformation maps sourceRect to
targetRect.
-}
make : Rect -> Rect -> Coefficients
make sourceRect targetRect =
    let
        aa =
            targetRect.size.x / sourceRect.size.x

        bb =
            targetRect.corner.x - sourceRect.corner.x

        cc =
            -targetRect.size.y / sourceRect.size.y

        dd =
            targetRect.corner.y - sourceRect.corner.y + targetRect.size.y
    in
    { a = aa, b = bb, c = cc, d = dd }


{-| affineTransformPoint coefficients is
an affine transformation.
-}
transform : Transform
transform coefficients point =
    let
        x =
            coefficients.a * point.x + coefficients.b

        y =
            coefficients.c * point.y + coefficients.d
    in
    Vector x y


linearTransform : Transform
linearTransform coefficients size =
    let
        w =
            abs coefficients.a * size.x

        h =
            abs coefficients.c * size.y

        -- 5.0 * size.height
    in
    Vector w h
