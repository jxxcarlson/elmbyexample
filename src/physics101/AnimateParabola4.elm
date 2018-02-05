module Main exposing (..)

-- On commandshttps://www.elm-tutorial.org/en/03-subs-cmds/02-commands.html

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Svg exposing (Svg, svg)
import Svg.Attributes as SA
import Time exposing (Time, second)
import Random
import Shape exposing (..)
import ColorRecord exposing (..)
import Particle exposing (Particle)
import Vector exposing (Vector)
import Affine


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type SimulatorState
    = Running
    | Paused
    | Start


type DisplayMode
    = HistoryOn
    | HistoryOff



-- MODEL


type alias Model =
    { simulatorState : SimulatorState
    , count : Int
    , x_max : Float
    , y_max : Float
    , particles : Particles
    , graphMap : Graph.GraphMap
    , message : String
    , info : String
    }



-- start : RunMode -> ( Model, Cmd Msg )


start : SimulatorState -> ( Model, Cmd Msg )
start simulatorState =
    ( model, Cmd.none )


init =
    start Paused



-- UPDATE


type Msg
    = Reset
    | Pause
    | Run
    | Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            ( model, Cmd.none )

        Pause ->
            ( model, Cmd.none )

        Run ->
            ( model, Cmd.none )

        Tick newTime ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (20 * Time.millisecond) Tick


renderParticle : Model -> Particle -> S.Svg msg
renderParticle model particle =
    Graph.drawCircle model.graphMap particle.circle


renderParticles : Model -> List (S.Svg msg)
renderParticles model =
    let
        render =
            (renderParticle model)

        p =
            model.particles
    in
        [ (render p.a), (render p.b) ]


view : Model -> Html Msg
view model =
    div
        [ id "graphics_area"
        , style
            [ ( "margin-left", "35px" )
            , ( "margin-top", "25px" )
            , ( "padding", "25px 35px 35px 55px" )
            , ( "width", "480px" )
            , ( "background-color", "#eee" )
            ]
        ]
        [ h1 [] [ text "Billiard simulator" ]
        , svg
            [ SA.viewBox "0 0 500 500" ]
            trajectoryDisplay
        , br [] []
        , button [ onClick Run, id "run", buttonStyle ] [ text "Run" ]
        , button [ onClick Pause, id "pause", buttonStyle ] [ text "Pause" ]
        , button [ onClick Reset, id "reset", buttonStyle ] [ text "Reset" ]
        , span [ id "message", labelStyle ] [ text model.message ]
        , br [] []
        , br [] []
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
        , dimensions = Vector 1 1
        , strokeColor = redColor
        , fillColor = lightRedColor
        }


{-| Note that we are using screen coordinates,
so the force is directed downwards,
-}
field r =
    let
        range =
            10

        strength =
            60

        u =
            -(r.y / range)
    in
        Vector 0 (-5 + strength * e ^ u)


{-| Particle.make mass position velocity shape
-}
ball : Particle
ball =
    Particle.make 10.0 (Vector 5 80) (Vector 0.5 3) circle


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
    Particle.orbit 350 (Particle.update 0.6 field) ball


{-| Map the trajectory to a list of Svg msg's to
obtain a structure that can be displayed.
-}
trajectoryDisplay : List (Svg msg)
trajectoryDisplay =
    trajectory
        |> List.map (Particle.transform coefficients)
        |> List.map Particle.draw
