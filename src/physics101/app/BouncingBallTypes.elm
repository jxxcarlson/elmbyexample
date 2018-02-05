module BouncingBallTypes exposing (..)

import Time exposing (Time, second)


type SimulatorState
    = Running
    | Paused
    | Start


type Msg
    = Reset
    | Pause
    | Run
    | Step
    | Tick Time


type alias Model =
    { simulatorState : SimulatorState
    , count : Int
    , maxSteps : Int
    , message : String
    , info : String
    }
