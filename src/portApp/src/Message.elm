module Message exposing (Message)

import Json.Encode as E
import Json.Decode as D
import Time


type alias Message =
    { recipient : String
    , key : String
    , value : String
    , time : Time.Posix
    }


messageEncoder : Time.Zone -> Message -> E.Value
messageEncoder zone message =
    E.object
        [ ( "recipient", E.string message.recipient )
        , ( "key", E.string message.key )
        , ( "value", E.string message.value )
        , ( "time", E.int (Time.toMillis zone message.time) )
        ]


messageDecoder : Time.Zone -> D.Decoder Message
messageDecoder zone =
    D.map4 Message
        (D.field "recipient" D.string)
        (D.field "key" D.string)
        (D.field "value" D.string)
        ((D.field "time" D.string) |> D.map (String.toInt >> Maybe.withDefault 0 >> Time.millisToPosix))
