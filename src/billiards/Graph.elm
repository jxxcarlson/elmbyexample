module Graph exposing (..)

{-| Module Graph provides a set of functions for
constructing simple graphs, give a sequence of points
like

  data = [(0.0, 0.0), (5.0, 7.0), (8.0, 2.0), ...]

or a "time series" like

  data = [1, 2, 4, 9, 7, ...],

where we assume the time intervals between data points are equal.

The main functions are

  (1)  Graph.drawPointList graphData "yellow" data

  (2)  Graph.drawTimeSeries "blue" graphData data

  (3)  Graph.drawIntegerTimeSeries "blue" graphData data

where (1) is for sequences of points, (2) is for seqeunces of integers,
and (3) is for sequences of floats.

graphData is a structure that defines two rectangles, sourceRect and
targetRect.  The first should be though of as being in the Cartesian
plane, the second on the computer screen.  The information in graphData
is used to define a mapping from the first rectangle to the second.

-}

import Svg as S exposing (..)
import Svg.Attributes as SA exposing (..)
import XColor exposing (..)
import Geometry exposing (..)


{-| GraphData is as in the introduction: two rectangles
  plus some additional data (colors)
-}
type alias GraphMap =
    { sourceRect : Rect
    , targetRect : Rect
    }


{-| boundingRect returns an SVG representation of
  the targetRect in graphData.
-}
boundingRect : GraphMap -> Svg msg
boundingRect graphMap =
    S.rect
        [ x (toString graphMap.targetRect.corner.x)
        , y (toString graphMap.targetRect.corner.y)
        , width (toString graphMap.targetRect.size.width)
        , height (toString graphMap.targetRect.size.height)
        , fill (rgba graphMap.targetRect.fillColor)
        , stroke (rgba graphMap.targetRect.strokeColor)
        ]
        []


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
affineTransformData : GraphMap -> AffineTransformData
affineTransformData graphMap =
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


{-| affineTransformPoints affineTransformData is a function
  that applies an affine transformation to a list of points,
  returning a new list of points.
-}
affineTransformPoints : AffineTransformData -> Points -> Points
affineTransformPoints affineTransformData points =
    List.map (affineTransformPoint affineTransformData) points


{-| zip [a, b, c] [1, 2, 3] = [(a,1), (b,2), (c,3)]
  The (,) expression is a shortcut to create 2-tuples, so
  evaluating ((,) 3 4) results in (3,4)
-}



-- zip1 : List a -> List b -> List Point
-- zip1 =
--     List.map2 (,)


zip : List Float -> List Float -> Points
zip =
    List.map2 Point


{-| timeSeries [0.4, 1.3, 2.9] = [(0, 0.4), (1, 1.3), (2, 2.9)]
-}
timeSeries : List Float -> Points
timeSeries data =
    let
        n =
            List.length data

        timeSequence =
            List.range 0 (n - 1) |> List.map toFloat
    in
        zip timeSequence data


{-| point2String (1.2, 2.7) == "1.2, 2.7"
-}
point2String : Point -> String
point2String point =
    (toString point.x) ++ ", " ++ (toString point.y)


{-| data2SVG GraphData [(0, 2), (1,4), (2,3)]
  => "0,2  1,4  2,3"
  data2SVG : GraphData -> Svg Msg
-}
data2SVG : GraphMap -> Points -> String
data2SVG graphMap points =
    let
        affData =
            affineTransformData graphMap

        aff =
            affineTransformPoints affData
    in
        points
            |> aff
            |> List.map point2String
            |> String.join " "


{-| drawPointList graphData "yellow" [(0.0, 0.0), (100.0, 20.0), (200.0, 0.0)]
  produces an SVG representation of the given polygonal path.
-}
drawPoints : GraphMap -> XColor -> Points -> S.Svg msg
drawPoints graphMap color data =
    -- polyline [ fill "none", stroke "red", points (data2SVG data) ] []
    polyline [ fill "none", stroke (rgba color), points (data2SVG graphMap data) ] []


drawPolygon : GraphMap -> String -> String -> Float -> Points -> S.Svg msg
drawPolygon graphMap strokeColor fillColor opacityValue data =
    polygon [ fill fillColor, stroke strokeColor, opacity (toString opacityValue), points (data2SVG graphMap data) ] []


drawRect : GraphMap -> Rect -> S.Svg msg
drawRect graphMap rect =
    let
        affData =
            affineTransformData graphMap

        affp =
            affineTransformPoint affData

        affs =
            affineTransformSize affData

        corner2 =
            affp rect.corner

        size2 =
            affs rect.size
    in
        S.rect [ fill (rgba rect.fillColor), stroke (rgba rect.fillColor), x (toString corner2.x), y (toString corner2.y), width (toString size2.width), height (toString size2.height) ] []


drawCircle : GraphMap -> Circle -> S.Svg msg
drawCircle graphMap circle =
    let
        affData =
            affineTransformData graphMap

        affp =
            affineTransformPoint affData

        center2 =
            affp circle.center

        affs =
            affineTransformSize affData

        radii =
            Size circle.radius circle.radius

        radii2 =
            affs radii
    in
        ellipse
            [ fill (rgba circle.fillColor)
            , stroke (rgba circle.fillColor)
            , SA.cx (toString center2.x)
            , SA.cy (toString center2.y)
            , SA.rx (toString (radii2.width))
              --, SA.rx "20.0"
              -- , SA.ry "20.0"
            , SA.ry (toString (radii2.height))
            ]
            []


renderHistory : GraphMap -> List Circle -> List (S.Svg msg)
renderHistory graphMap history =
    List.map (drawCircle graphMap) history


drawLine : GraphMap -> XColor -> Point -> Point -> S.Svg msg
drawLine graphMap color p q =
    drawPoints graphMap color [ p, q ]


{-| drawTimeSeries "yellow" graphData [1.0, 1.2, 3.1, 2.2, ..)]
  produces an SVG representation the polgonal path
  [(0, 1.0), (1, 1.2), (2, 3.1), (3, 2.2), ..)]
-}
drawTimeSeries : GraphMap -> XColor -> List Float -> S.Svg msg
drawTimeSeries graphMap color data =
    data |> timeSeries |> drawPoints graphMap color


{-| drawIntegerTimeSeries "yellow" graphData [1, 2, 3, 2, ..)]
  produces an SVG representation the polgonal path
  [(0, 1), (1, 2), (2, 3), (3, 2), ..)]
-}
drawIntegerTimeSeries : GraphMap -> XColor -> List Int -> S.Svg msg
drawIntegerTimeSeries graphMap color data =
    data |> List.map toFloat |> timeSeries |> drawPoints graphMap color
