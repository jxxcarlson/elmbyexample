Parabola
========

*To run the app:* Use `elm make src/parabola/Parabola.elm` from the root 
of the `elmbyexample` folder, the open `index.html`
using a browser.

The Parabola app shows how to use the Physics module to simulate the motion
of a particle  with given mass, initial position
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