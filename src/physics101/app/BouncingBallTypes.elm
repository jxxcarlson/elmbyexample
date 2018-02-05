module BouncingBallTypes exposing (..)

import Particle exposing (Particle)
import Svg exposing (Svg)
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
    | Plot
    | Tick Time


type alias Model =
    { simulatorState : SimulatorState
    , count : Int
    , maxSteps : Int
    , trajectory : List Particle
    , message : String
    , info : String
    }
