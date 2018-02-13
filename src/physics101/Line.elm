module Line exposing (..)

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


type alias Line =
    { a : Vector
    , b : Vector
    , width : Float
    , strokeColor : ColorRecord
    , fillColor : ColorRecord
    }


transform : Affine.Coefficients -> Line -> Line
transform coefficients line =
    let
        newA =
            Affine.transform coefficients line.a

        newB =
            Affine.transform coefficients line.b
    in
        { line | a = newA, b = newB }


draw : Line -> S.Svg msg
draw line =
    S.line (lineAttributes line) []


moveTo : Vector -> Line -> Line
moveTo position line =
    let
        displacement =
            Vector.sub line.b line.a

        newB =
            Vector.add displacement position
    in
        { line | a = position, b = newB }


moveBy : Vector -> Line -> Line
moveBy displacement line =
    let
        newA =
            Vector.add displacement line.a

        newB =
            Vector.add displacement line.b
    in
        { line | a = newA, b = newB }


scaleBy : Float -> Line -> Line
scaleBy factor line =
    let
        newA =
            Vector.mul factor line.a

        newB =
            Vector.mul factor line.b
    in
        { line | a = newA, b = newB }


lineAttributes : Line -> List (Attribute msg)
lineAttributes line =
    [ fill (rgba line.fillColor)
    , stroke (rgba line.fillColor)
    , x1 (toString line.a.x)
    , y1 (toString line.a.y)
    , x2 (toString line.b.x)
    , y2 (toString line.b.y)
    , strokeWidth (toString line.width)
    ]
