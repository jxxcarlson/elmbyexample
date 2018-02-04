module Particle exposing (Particle, update, draw, orbit, make, transform, constantField)

{- A `Particle` has mass, position, velocity, and shape.

   - Construct a particle using `make mass position velociy shape`.

   - Use `draw particle` to obtain an Svg representation of a particle.

   - Use `update t force particle` to return an updated version of the
     particle under the influence of the given force acting for time t.

   - Use `orbit n stepper initiaValue` to obtain the "orbit" of a particle
     consisting of n updates using the `stepper` function.

   A `stepper` function is of type `Particle -> Particle`. As an example,
   consider the function

      ss = Particle.update 0.75 force,

   where `force` is force vector and 0.75 is an interval of time.  Then
   `ss`, which is a partial application of `Particle.update`, is a stepper
   function.
-}

import Shape exposing (Shape(..), moveTo)
import Vector exposing (Vector, add, mul)
import Svg
import Affine


type alias Particle =
    { position : Vector
    , velocity : Vector
    , mass : Float
    , shape : Shape
    }

type alias Field = Vector -> Vector

type alias Stepper = Particle ->  Particle

constantField : Vector -> Field
constantField f =
  \v -> f

make : Float -> Vector -> Vector -> Shape -> Particle
make mass position velocity shape =
    let
        shape_ =
            Shape.moveTo position shape
    in
        { position = position, velocity = velocity, mass = mass, shape = shape_ }


orbit : Int -> Stepper -> Particle -> List Particle
orbit n stepper initiaValue =
    orbitAux n stepper [ initiaValue ]


orbitAux : Int -> Stepper -> List Particle -> List Particle
orbitAux n stepper acc =
    if n == 0 then
        acc
    else
        orbitAux (n - 1) stepper ((step stepper acc) ++ acc)


step : Stepper -> List Particle -> List Particle
step stepper list =
    List.map stepper (List.take 1 list)


draw : Particle -> Svg.Svg msg
draw particle =
    Shape.draw particle.shape


update : Float -> Field -> Particle -> Particle
update t field particle =
    let
        displacement =
            mul t particle.velocity

        newPosition =
            add particle.position displacement

        acceleration =
            mul (1 / particle.mass) (field newPosition)

        newVelocity =
            add (mul t acceleration) particle.velocity

        newShape =
            Shape.moveTo newPosition particle.shape
    in
        { particle | position = newPosition, velocity = newVelocity, shape = newShape }


transform : Affine.Coefficients -> Particle -> Particle
transform coefficients particle =
    let
        newShape =
            Shape.transform coefficients particle.shape
    in
        { particle | shape = newShape }
