module Message exposing (Message, encode, decode, decodeMessageList)

import Json.Encode as E
import Json.Decode as D
import Time


type alias Message =
    { to : String
    , from : String
    , subject : String
    , body : String
    , time : Time.Posix
    }


encode : Time.Zone -> Message -> E.Value
encode zone message =
    messageEncoder zone message


messageEncoder : Time.Zone -> Message -> E.Value
messageEncoder zone message =
    E.object
        [ ( "to", E.string message.to )
        , ( "from", E.string message.from )
        , ( "subject", E.string message.subject )
        , ( "body", E.string message.body )
        , ( "time", E.int (Time.toMillis zone message.time) )
        ]


decode : Time.Zone -> E.Value -> Result D.Error Message
decode zone value =
    D.decodeValue (messageDecoder zone) value


decodeMessageList : Time.Zone -> E.Value -> Result D.Error (List Message)
decodeMessageList zone value =
    D.decodeValue (messageListDecoder zone) value


messageListDecoder : Time.Zone -> D.Decoder (List Message)
messageListDecoder zone =
    D.list (messageDecoder zone)


messageDecoder : Time.Zone -> D.Decoder Message
messageDecoder zone =
    D.map5 Message
        (D.field "to" D.string)
        (D.field "from" D.string)
        (D.field "subject" D.string)
        (D.field "body" D.string)
        ((D.field "time" D.int) |> D.map Time.millisToPosix)
