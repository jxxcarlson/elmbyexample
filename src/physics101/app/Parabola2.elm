module Parabola2 exposing (..)

{- Parabola shows how to use the Physics module to simulate the motion
   of a particle -- a "ball" -- with given mass, initial position
   and velocity, and an applied force.  Is this example, we use screen
   coordinates, with (0,0) in the upper left corner, so that the vector

       force = Vector 0 100

   is directed downwards.  The initial velocity is

        Vector 20 -15

   and so points upward and to the right.  The motion of the ball,
   of course,  is a parabola.

   NOTE: The Physics module depends upon

      - Shape
      - Vector

-}

import Affine
import ColorRecord exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Particle exposing (Particle)
import Shape exposing (..)
import Style exposing (..)
import Svg exposing (Svg, svg)
import Svg.Attributes as SA
import Vector exposing (Vector)


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


sourceRect =
    { corner = Vector 0 0, size = Vector 100 100 }


targetRect =
    { corner = Vector 0 0, size = Vector 500 500 }


coefficients =
    Affine.make sourceRect targetRect


{-| This is the shape that we shall use to make the particle.
-}
circle : Shape
circle =
    Ellipse
        { center = Vector 0 0
        , dimensions = Vector 2 2
        , strokeColor = redColor
        , fillColor = lightRedColor
        }


{-| Note that we are using screen coordinates,
so the force is directed downwards,
-}
field =
    Particle.constantField (Vector 0 -5)


{-| Particle.make mass position velocity shape
-}
ball : Particle
ball =
    Particle.make 10.0 (Vector 5 80) (Vector 3 3) circle


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
    Particle.orbit 24 (Particle.update 1.1 field) ball


{-| Map the trajectory to a list of Svg msg's to
obtain a structure that can be displayed.
-}
trajectoryDisplay : List (Svg msg)
trajectoryDisplay =
    trajectory
        |> List.map (Particle.transform coefficients)
        |> List.map Particle.draw
