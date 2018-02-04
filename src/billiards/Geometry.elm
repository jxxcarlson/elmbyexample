module Geometry exposing (..)

import XColor exposing (..)


{-| The three data structures below define
  the needed geometric structures: points,
  lists of points, and rectangles.
-}
type alias Point =
    { x : Float, y : Float }


type alias Points =
    List Point


type alias Size =
    { width : Float, height : Float }


type alias Rect =
    { corner : Point
    , size : Size
    , fillColor : XColor
    , strokeColor : XColor
    }


type alias Circle =
    { center : Point, radius : Float, fillColor : XColor, strokeColor : XColor }


distance : Point -> Point -> Float
distance p q =
    let
        dx =
            p.x - q.x

        dy =
            p.y - q.y

        d_squared =
            dx * dx + dy * dy
    in
        sqrt d_squared
