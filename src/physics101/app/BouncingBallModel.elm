module BouncingBallModel exposing (..)

import Affine
import BouncingBallTypes exposing (Model)
import ColorRecord exposing (..)
import Particle exposing (Particle)
import Shape exposing (..)
import Svg exposing (Svg, svg)
import Vector exposing (Vector)


viewModel : Model -> List (Svg msg)
viewModel model =
    (List.drop (model.maxSteps - model.count) model.trajectory
        |> List.map Particle.draw
    )
        ++ [ floor |> Shape.transform coefficients |> Shape.draw ]


sourceRect =
    { corner = Vector 0 0, size = Vector 100 100 }


targetRect =
    { corner = Vector 0 0, size = Vector 500 500 }


coefficients =
    Affine.make sourceRect targetRect


circle : Shape
circle =
    Ellipse
        { center = Vector 0 0
        , dimensions = Vector 1 1
        , strokeColor = redColor
        , fillColor = lightRedColor
        }


floor : Shape
floor =
    Rect
        { center = Vector 250 0
        , dimensions = Vector 500 1
        , strokeColor = blackColor
        , fillColor = blackColor
        }


field r =
    let
        range =
            5

        strength =
            200

        u =
            -((r.y + 3) / range)
    in
    Vector 0 (-5 + strength * e ^ u)


ball : Particle
ball =
    Particle.make 10.0 (Vector 5 80) (Vector 0.5 3) circle


trajectory : Int -> List Particle
trajectory maxSteps =
    Particle.orbit maxSteps (Particle.update 0.6 field) ball
        |> List.map (Particle.transform coefficients)


svgTrajectory : List Particle -> List (Svg msg)
svgTrajectory particleList =
    (particleList
        |> List.map Particle.draw
    )
        ++ [ floor |> Shape.transform coefficients |> Shape.draw ]
