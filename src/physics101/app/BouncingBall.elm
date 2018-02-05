module Main exposing (..)

-- On commandshttps://www.elm-tutorial.org/en/03-subs-cmds/02-commands.html

import BouncingBallModel exposing (trajectory, viewModel)
import BouncingBallTypes exposing (Model, Msg(..), SimulatorState(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Style exposing (..)
import Svg exposing (Svg, svg)
import Svg.Attributes as SA
import Time exposing (Time, second)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


start : SimulatorState -> ( Model, Cmd Msg )
start simulatorState =
    let
        maxSteps =
            350
    in
    ( { simulatorState = simulatorState
      , count = 0
      , maxSteps = maxSteps
      , trajectory = trajectory maxSteps
      , message = "Starting engines"
      , info = "Hi there"
      }
    , Cmd.none
    )


init =
    start Paused


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            reset model

        Pause ->
            ( { model | simulatorState = Paused }, Cmd.none )

        Run ->
            ( { model | simulatorState = Running }, Cmd.none )

        Step ->
            step model

        Plot ->
            plotModel model

        Tick newTime ->
            tick model


step : Model -> ( Model, Cmd Msg )
step model =
    let
        newCount =
            model.count + 1

        newMessage =
            toString newCount
    in
    ( { model | count = newCount, message = newMessage }, Cmd.none )


plotModel : Model -> ( Model, Cmd Msg )
plotModel model =
    let
        newCount =
            model.maxSteps

        newMessage =
            toString newCount
    in
    ( { model | count = newCount, message = newMessage, simulatorState = Paused }, Cmd.none )


reset : Model -> ( Model, Cmd Msg )
reset model =
    let
        newCount =
            0

        newMessage =
            "t = " ++ toString newCount
    in
    ( { model | count = newCount, message = newMessage, simulatorState = Paused }, Cmd.none )


tick : Model -> ( Model, Cmd Msg )
tick model =
    let
        newCount =
            if model.simulatorState == Running && model.count < model.maxSteps then
                model.count + 1
            else
                model.count
    in
    ( { model | count = newCount, message = "t = " ++ toString newCount }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (20 * Time.millisecond) Tick


view : Model -> Html Msg
view model =
    div
        [ mainStyle ]
        [ h1 [] [ text "Simulator: Bouncing Ball" ]
        , svg [ width 500, height 500 ] [ viewModel model ]
        , br [] []
        , br [] []
        , button [ onClick Step, id "run", buttonStyle ] [ text "Step" ]
        , button [ onClick Run, id "run", buttonStyle ] [ text "Run" ]
        , button [ onClick Pause, id "pause", buttonStyle ] [ text "Pause" ]
        , button [ onClick Reset, id "reset", buttonStyle ] [ text "Reset" ]
        , button [ onClick Plot, id "plot", buttonStyle ] [ text "Plot" ]
        , span [ id "message", labelStyle ] [ text model.message ]
        , br [] []
        , br [] []
        ]
