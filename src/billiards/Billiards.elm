module Main exposing (..)

-- On commandshttps://www.elm-tutorial.org/en/03-subs-cmds/02-commands.html

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Time exposing (Time, second)
import Svg as S exposing (svg, circle)
import Svg.Attributes as SA exposing (cx, cy, fill, width, height, r)
import Random
import Graph exposing (..)
import XColor exposing (..)
import Geometry exposing (..)
import Physics exposing (..)


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


rgb : XColor -> String
rgb color =
    "red"


type alias Particles =
    { a : Particle, b : Particle }



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


color1 =
    XColor 255 0 0 0.8


color2 =
    XColor 0 0 255 0.8


circle1 =
    Circle (Point 20.0 10.0) 2.0 color1 color1


circle2 =
    Circle (Point 10.0 20.0) 2.0 color2 color2


velocity1 =
    Vector 1.0 2.11


particle1 =
    Particle circle1 velocity1 0.0


velocity2 =
    Vector 2.0 1.222


particle2 =
    Particle circle2 velocity2 0.0



-- start : RunMode -> ( Model, Cmd Msg )


start : SimulatorState -> ( Model, Cmd Msg )
start simulatorState =
    let
        x_max =
            100.0

        y_max =
            100.0

        source =
            Geometry.Rect (Point 0.0 0.0) (Size x_max y_max) transparentColor transparentColor

        target =
            Geometry.Rect (Point 0.0 0.0) (Size 450.0 450.0) blackColor transparentColor

        graphMap =
            Graph.GraphMap source target

        distance =
            round (Physics.distance particle1 particle2)

        message =
            "n: 0, distance: " ++ (toString distance)
    in
        ( Model simulatorState
            0
            x_max
            y_max
            (Particles particle1 particle2)
            graphMap
            message
            ""
        , Cmd.none
        )


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
            start Start

        Pause ->
            handlePause model

        Run ->
            ( { model | simulatorState = Running }, Cmd.none )

        Tick newTime ->
            do_update_model model


handlePause : Model -> ( Model, Cmd Msg )
handlePause model =
    let
        newSimulatorState =
            if model.simulatorState == Paused then
                Running
            else
                Paused
    in
        ( { model | simulatorState = newSimulatorState }, Cmd.none )


do_update_model : Model -> ( Model, Cmd Msg )
do_update_model model =
    if model.simulatorState == Running then
        update_model model
    else
        ( model, Cmd.none )


update_model : Model -> ( Model, Cmd Msg )
update_model model =
    let
        new_particles =
            updateParticles model

        new_count =
            model.count + 1

        distance =
            round (Physics.distance model.particles.a model.particles.b)

        bgColor =
            if distance < 5 then
                yellowColor
            else
                blackColor

        oldGraphMap =
            model.graphMap

        oldTargetRect =
            oldGraphMap.targetRect

        newTargetRect =
            { oldTargetRect | fillColor = bgColor }

        newGraphMap =
            { oldGraphMap | targetRect = newTargetRect }

        new_message =
            "n: " ++ (toString new_count) ++ ", distance: " ++ (toString distance)
    in
        ( { model
            | particles = new_particles
            , count = new_count
            , message = new_message
            , graphMap = newGraphMap
          }
        , Cmd.none
        )


updateParticle : Model -> Particle -> Particle
updateParticle model particle =
    let
        circle =
            particle.circle

        center =
            circle.center

        new_x =
            center.x + particle.velocity.x

        new_y =
            center.y + particle.velocity.y

        new_center =
            Point new_x new_y

        new_circle =
            { circle | center = new_center }

        new_vx =
            if (new_x > model.x_max) || (new_x < 0) then
                -particle.velocity.x
            else
                particle.velocity.x

        new_vy =
            if (new_y > model.y_max) || (new_y < 0) then
                -particle.velocity.y
            else
                particle.velocity.y

        new_velocity =
            Vector new_vx new_vy
    in
        { particle | circle = new_circle, velocity = new_velocity }


updateParticles : Model -> Particles
updateParticles model =
    let
        particles =
            model.particles

        a =
            (updateParticle model) particles.a

        b =
            (updateParticle model) particles.b
    in
        Particles a b



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
            [ SA.width "450", SA.height "450" ]
            ([ (Graph.boundingRect model.graphMap)

             --, (Graph.drawRect model.graphMap (Rect (Point 50.0 50.0) (Size 4.0 4.0) color1 color1))
             --, (Graph.drawCircle model.graphMap (Circle (Point 20.0 20.0) 4.0 color2 color2))
             ]
                ++ (renderParticles model)
            )
        , br [] []
        , button [ onClick Run, id "run", buttonStyle ] [ text "Run" ]
        , button [ onClick Pause, id "pause", buttonStyle ] [ text "Pause" ]
        , button [ onClick Reset, id "reset", buttonStyle ] [ text "Reset" ]
        , span [ id "message", labelStyle ] [ text model.message ]
        , br [] []
        , br [] []
        ]


buttonStyle =
    style
        [ ( "height", "25px" )
        , ( "background-color", "black" )
        , ( "color", "white" )
        , ( "margin-right", "10px" )
        , ( "font-size", "12pt" )
        ]


labelStyle =
    style
        [ ( "height", "35px" )
        , ( "background-color", "black" )
        , ( "color", "white" )
        , ( "margin-right", "15px" )
        , ( "padding", "3px 8px 3px 8px" )
        ]
