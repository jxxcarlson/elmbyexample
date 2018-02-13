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


transparentRedColor : ColorRecord
transparentRedColor =
    ColorRecord 255 0 0 0.1


transparentBlueColor : ColorRecord
transparentBlueColor =
    ColorRecord 0 0 255 0.15


lightRedColor : ColorRecord
lightRedColor =
    ColorRecord 255 0 0 0.4


mutedRedColor : ColorRecord
mutedRedColor =
    ColorRecord 204 0 0 1.0


yellowColor : ColorRecord
yellowColor =
    ColorRecord 255 255 0 0.4


greenColor : ColorRecord
greenColor =
    ColorRecord 0 255 0 1.0


blueColor : ColorRecord
blueColor =
    ColorRecord 0 0 255 1.0


lightBlueColor : ColorRecord
lightBlueColor =
    ColorRecord 110 110 255 1.0


mutedBlueColor : ColorRecord
mutedBlueColor =
    ColorRecord 80 80 204 1.0


mutedCyanColor : ColorRecord
mutedCyanColor =
    ColorRecord 0 204 204 1.0


transparentColor : ColorRecord
transparentColor =
    ColorRecord 0 0 0 0.0
