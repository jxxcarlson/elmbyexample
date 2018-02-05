module ColorRecord exposing (..)


type alias ColorRecord =
    { r : Int, g : Int, b : Int, a : Float }


rgba : ColorRecord -> String
rgba color =
    "rgba(" ++ toString color.r ++ "," ++ toString color.g ++ "," ++ toString color.b ++ "," ++ toString color.a ++ ")"



{- Some standard colors -}


whiteColor : ColorRecord
whiteColor =
    ColorRecord 255 255 255 1.0


blackColor : ColorRecord
blackColor =
    ColorRecord 0 0 0 1.0


redColor : ColorRecord
redColor =
    ColorRecord 255 0 0 1.0


lightRedColor : ColorRecord
lightRedColor =
    ColorRecord 255 0 0 0.4


yellowColor : ColorRecord
yellowColor =
    ColorRecord 255 255 0 0.4


greenColor : ColorRecord
greenColor =
    ColorRecord 0 255 0 1.0


blueColor : ColorRecord
blueColor =
    ColorRecord 0 0 255 1.0


transparentColor : ColorRecord
transparentColor =
    ColorRecord 0 0 0 0.0
