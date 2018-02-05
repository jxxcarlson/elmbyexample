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
import Style exposing(..)


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

type Msg
    = Reset
    | Pause
    | Run
    | Step
    | Tick Time

-- MODEL


type alias Model =
    { simulatorState : SimulatorState
    , count : Int
    -- , trajectoryDisplay : List (Svg msg)
    , maxSteps : Int
    , message : String
    , info : String
    }




-- start : RunMode -> ( Model, Cmd Msg )


start : SimulatorState -> ( Model, Cmd Msg )
start simulatorState =
    let
       maxSteps = 350
    in
        ( {simulatorState = simulatorState
          , count = 0
          , maxSteps = maxSteps
          -- , trajectoryDisplay = trajectoryDisplay maxSteps
          , message = "Starting engines"
          , info = "Hi there"}
          , Cmd.none
        )


init = start Paused

viewModel : Model -> List (Svg msg)
viewModel model =
  List.drop (model.maxSteps - model.count) (trajectoryDisplay model.maxSteps)

-- UPDATE



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            reset model

        Pause ->
            ( {model | simulatorState =  Paused}, Cmd.none )

        Run ->
            ( {model | simulatorState =  Running}, Cmd.none )

        Step ->
            step model

        Tick newTime ->
            tick model


step : Model -> (Model, Cmd Msg)
step model =
  let
    newCount = model.count + 1
    newMessage = (toString newCount)
  in
    ({model | count = newCount, message = newMessage}, Cmd.none)


reset :  Model -> (Model, Cmd Msg)
reset model =
  let
    newCount = 0
    newMessage = "t = " ++ (toString newCount)
  in
    ({model | count = newCount, message = newMessage, simulatorState = Paused}, Cmd.none)


tick : Model -> (Model, Cmd Msg)
tick model =
  let
    newCount = if model.simulatorState == Running && model.count < model.maxSteps then
      model.count + 1
    else
      model.count
  in
    ({ model | count = newCount, message = "t = " ++ (toString newCount)}, Cmd.none )
-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (20 * Time.millisecond) Tick



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
        [ h1 [] [ text "Simulator" ]
        , svg
            [ SA.viewBox "0 0 500 500" ]
            (viewModel model)
        , br [] []
        , button [ onClick Step, id "run", buttonStyle ] [ text "Step" ]
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
trajectory : Int -> List Particle
trajectory maxSteps =
    Particle.orbit maxSteps (Particle.update 0.6 field) ball


{-| Map the trajectory to a list of Svg msg's to
obtain a structure that can be displayed.
-}
trajectoryDisplay : Int -> List (Svg msg)
trajectoryDisplay maxSteps =
    trajectory maxSteps
        |> List.map (Particle.transform coefficients)
        |> List.map Particle.draw
