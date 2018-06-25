module Types exposing (..)

import Http exposing (get, send)
import Http


type alias Model =
    { message : String
    }


type Msg
    = NoOp
    | Input String
    | ReverseText
