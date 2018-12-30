module Message exposing (Message, encode, decode)

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
    messageEncoder zone message


messageEncoder : Time.Zone -> Message -> E.Value
messageEncoder zone message =
    E.object
        [ ( "sender", E.string message.sender )
        , ( "recipient", E.string message.recipient )
        , ( "key", E.string message.key )
        , ( "value", E.string message.value )
        , ( "time", E.int (Time.toMillis zone message.time) )
        ]


decode : Time.Zone -> E.Value -> Result D.Error Message
decode zone value =
    D.decodeValue (messageDecoder zone) value


messageDecoder : Time.Zone -> D.Decoder Message
messageDecoder zone =
    D.map5 Message
        (D.field "sender" D.string)
        (D.field "recipient" D.string)
        (D.field "key" D.string)
        (D.field "value" D.string)
        ((D.field "time" D.int) |> D.map Time.millisToPosix)
