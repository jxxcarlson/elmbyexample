module Vector exposing (..)


type alias Vector =
    { x : Float, y : Float }


type alias DirectedSegment =
    { a : Vector, b : Vector }


dot : Vector -> Vector -> Float
dot a b =
    a.x * b.x + a.y + b.y


norm_squared : Vector -> Float
norm_squared a =
    dot a a


add : Vector -> Vector -> Vector
add v w =
    Vector (v.x + w.x) (v.y + w.y)


sub : Vector -> Vector -> Vector
sub v w =
    Vector (v.x - w.x) (v.y - w.y)


mul : Float -> Vector -> Vector
mul c v =
    Vector (c * v.x) (c * v.y)


rotate : Float -> Vector -> Vector
rotate theta v =
    let
        x =
            v.x

        y =
            v.y

        xx =
            cos theta * x - sin theta * y

        yy =
            (sin theta) * x + cos theta * y
    in
        Vector xx yy


angle : Vector -> Vector -> Float
angle a b =
    let
        ratio =
            dot a b / sqrt (norm_squared a * norm_squared b)
    in
        acos ratio


distance : Vector -> Vector -> Float
distance p q =
    let
        dx =
            p.x - q.x

        dy =
            p.y - q.y

        d_squared =
            dx * dx + dy * dy
    in
        sqrt d_squared
