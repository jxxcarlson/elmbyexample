module Message exposing (Message, encode)

import Json.Encode as E
import Json.Decode as D
import Time


type alias Message =
    { sender : String
    , recipient : String
    , key : String
    , value : String
    , time : Time.Posix
    }


encode : Time.Zone -> Message -> E.Value
encode zone message =
    encoder zone message


encoder : Time.Zone -> Message -> E.Value
encoder zone message =
    E.object
        [ ( "sender", E.string message.sender )
        , ( "recipient", E.string message.recipient )
        , ( "key", E.string message.key )
        , ( "value", E.string message.value )
        , ( "time", E.int (Time.toMillis zone message.time) )
        ]


messageDecoder : Time.Zone -> D.Decoder Message
messageDecoder zone =
    D.map5 Message
        (D.field "sender" D.string)
        (D.field "recipient" D.string)
        (D.field "key" D.string)
        (D.field "value" D.string)
        ((D.field "time" D.string) |> D.map (String.toInt >> Maybe.withDefault 0 >> Time.millisToPosix))
