Physics101
==========

Physics101 is a physics simulation package.  There there are two parts:
the library and the demos.  Noteworthy in the Particle module is that
the dynamics of particles is determined by a field, which has
type signature

    Field : Vector -> Vector

That is, to each position vector is assigned a force vector.

  * Parabola: a demo of throwing a ball into the air and letting it fall
    under the influence of gravity.  Uses screen coordinates and a
    constant field:

      field = Particle.constantField (Vector 0 100)

  * Parabola2: the same, but uses Cartesian coordinates, with

      field = Particle.constantField (Vector 0 -5)

  * Parabola3: the field is as above, plus a "repulsive" force directed
    upwards that increases in linearly in magnitude as one approaches
    the "floor" at y = 0.  The result is simple harmonic motion in
    the y-direction.  One can view this as a "soft bounce" of the ball
    off the floor.  The field is

      field r = Vector 0 (-5 + (100 - r.y)/10)

  * Parabola4: As above, but now the repulsive field decays very rapidly
    as one gets out of range of the source of the field, which is the floor.
    The field is

      field r =
        let
          range = 15
          strength = 40
          u = -(r.y/range)
        in
        Vector 0 (-5 + strength*e^u)

    In this case, one observes a "hard bounce" with angle of reflection
    equal to angle of incidence.


*To run the Parabola app:* Use `elm make src/physics101/Parabola.elm` from the root
of the `elmbyexample` folder, the open `index.html`
using a browser.
