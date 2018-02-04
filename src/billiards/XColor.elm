module XColor exposing (..)


type alias XColor =
    { r : Int, g : Int, b : Int, a : Float }


whiteColor =
    XColor 255 255 255 1.0


blackColor =
    XColor 0 0 0 1.0


redColor =
    XColor 255 0 0 1.0


yellowColor =
    XColor 255 255 0 0.4


greenColor =
    XColor 0 255 0 1.0


blueColor =
    XColor 0 0 255 1.0


transparentColor =
    XColor 0 0 0 0.0


rgba : XColor -> String
rgba color =
    "rgba(" ++ (toString color.r) ++ "," ++ (toString color.g) ++ "," ++ (toString color.b) ++ "," ++ (toString color.a) ++ ")"
