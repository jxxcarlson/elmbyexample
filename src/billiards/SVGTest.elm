module SVGTest exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Shape exposing (..)
import XColor exposing (..)
import Physics exposing (..)
import Vector exposing (Vector)


main =
    svg
        [ viewBox "0 0 400 400" ]
        [ background, object, draw rr, draw e ]


background =
    rect
        [ fill "#ddf", x "0", y "0", width "200", height "200" ]
        []


object =
    circle
        [ cx "100", cy "100", r "30", fill "#f00" ]
        []


data1 =
    { cx = 100, cy = 100, width = 40, height = 40, strokeColor = redColor, fillColor = blueColor }


data2 =
    { cx = 100, cy = 100, width = 20, height = 10, strokeColor = redColor, fillColor = blackColor }


rr =
    Rect data1


e =
    Ellipse data2


position =
    Vector 100 100


velocity =
    Vector 10 0


force =
    Vector 1 0


body =
    Particle position velocity 10 e
