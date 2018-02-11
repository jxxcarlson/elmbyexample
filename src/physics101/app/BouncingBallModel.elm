module BouncingBallModel exposing (..)

import Affine
import BouncingBallTypes exposing (Model)
import ColorRecord exposing (..)
import Particle exposing (Particle)
import Shape exposing (..)
import Svg exposing (Svg, svg)
import Svg.Attributes as SA
import Svg.Lazy
import Vector exposing (Vector)


viewModel : Model -> Svg msg
viewModel model =
    List.drop (model.maxSteps - model.count) model.trajectory
        |> svgTrajectory


viewModel1 : Model -> Svg msg
viewModel1 model =
    let
        particleList =
            List.drop (model.maxSteps - model.count) model.trajectory
    in
    Svg.Lazy.lazy svgTrajectory particleList


viewModel2 : Model -> Svg msg
viewModel2 model =
    let
        particleList =
            List.drop (model.maxSteps - model.count) model.trajectory
    in
    Svg.Lazy.lazy svgTrajectory particleList


svgTrajectory : List Particle -> Svg msg
svgTrajectory particleList =
    (particleList
        |> List.map Particle.draw
    )
        ++ [ floor |> Shape.transform coefficients |> Shape.draw ]
        |> Svg.g [ SA.viewBox "0 0 500 500" ]



-- ilias [12:56 PM]
-- Yeah, that's a different `particleList` at every step. It works quite smoothly
-- on my end, even with `lazy` here making it potentially slower. One option
-- is to do "batches". Say you round the entries in the lazily rendered
-- list down to a multiple of 50, then "live" render the the rest. That _might_ be reasonably efficient.
-- so you'd have something like
-- `svg [ viewBox "0 0 500 500"  [ lazy svgTrajectory (do maths here and list.drop stuff), g [] (List.map Particle.draw (more maths and List.take), floor-and-transform-it ]`


trajectory : Int -> List Particle
trajectory maxSteps =
    Particle.orbit maxSteps (Particle.update 0.6 field) ball
        |> List.map (Particle.transform coefficients)


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
