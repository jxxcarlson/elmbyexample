module Parabola exposing (..)

import Svg exposing (Svg, svg)
import Svg.Attributes as SA
import Shape exposing (..)
import XColor exposing (..)
import Particle exposing (Particle)
import Vector exposing (Vector)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Style exposing (..)


main : Html msg
main =
    div [] [ display ]


display : Html msg
display =
    div [ mainStyle ]
        [ svg
            [ SA.viewBox "0 0 500 500" ]
            trajectoryDisplay
        ]


{-| This is the shape that we shall use to make the particle.
-}
circle : Shape
circle =
    Ellipse { cx = 0, cy = 0, width = 15, height = 15, strokeColor = redColor, fillColor = lightRedColor }


{-| Note that we are using screen coordinates,
so the force is directed downwards,
-}
force =
    Vector 0 100


{-| Particle.make mass position velocity shape
-}
ball : Particle
ball =
    Particle.make 10.0 (Vector 20 50) (Vector 20 -15) circle


{-| The trajector is a sist of particles where the nth
particle is the (n-1)-st particle after 0.75 seconds,
where the motion is that defined by the given force vector.

Note that

    Particle.update 0.75 force

is the result of partial application. It has type signature

    Particle -> Particle

-}
trajectory : List Particle
trajectory =
    Particle.orbit 30 (Particle.update 0.75 force) ball


{-| Map the trajectory to a list of Svg msg's to
obtain a structure that can be displayed.
-}
trajectoryDisplay : List (Svg msg)
trajectoryDisplay =
    List.map Particle.draw trajectory
