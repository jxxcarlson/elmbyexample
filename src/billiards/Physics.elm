module Physics exposing (..)

import Geometry exposing (distance)


type alias Vector =
    { x : Float, y : Float }


type alias Particle =
    { circle : Geometry.Circle
    , velocity : Vector
    , mass : Float
    }


dot : Vector -> Vector -> Float
dot a b =
    a.x * b.x + a.y + b.y


norm_squared : Vector -> Float
norm_squared a =
    dot a a


rotate : Float -> Vector -> Vector
rotate theta v =
    let
        x =
            v.x

        y =
            v.y

        xx =
            (cos theta) * x + (sin theta) * y

        yy =
            -(sin theta) * x + (cos theta) * y
    in
        Vector xx yy


angle : Vector -> Vector -> Float
angle a b =
    let
        ratio =
            (dot a b) / sqrt ((norm_squared a) * (norm_squared b))
    in
        acos ratio


distance : Particle -> Particle -> Float
distance a b =
    Geometry.distance a.circle.center b.circle.center
