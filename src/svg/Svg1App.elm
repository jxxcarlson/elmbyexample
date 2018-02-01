module Svg1App exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)


main =
    svg
        [ viewBox "0 0 600 600" ]
        [ background, object ]


background =
    rect
        [ fill "#ddf", x "0", y "0", width "200", height "200" ]
        []


object =
    circle
        [ cx "100", cy "100", r "30", fill color, opacity "0.9" ]
        []


color =
    "rgb(200,0, 0)"
