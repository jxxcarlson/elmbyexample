module Message exposing (Message, MessageForm, encode, decode, decodeMessageList)

import Json.Encode as E
import Json.Decode as D
import Time


type alias Message =
    { to : String
    , from : String
    , subject : String
    , body : String
    , timeSent : Time.Posix
    }


type alias MessageForm =
    { to : String
    , from : String
    , subject : String
    , body : String
    , expiration : Int
    }


messageFromForm : Time.Posix -> MessageForm -> Message
messageFromForm time messageForm =
    { to = messageForm.to
    , from = messageForm.from
    , subject = messageForm.subject
    , body = messageForm.body
    , timeSent = time
    }


encode : Time.Posix -> MessageForm -> E.Value
encode time messageForm =
    messageEncoder (messageFromForm time messageForm)


messageEncoder : Message -> E.Value
messageEncoder message =
    E.object
        [ ( "to", E.string message.to )
        , ( "from", E.string message.from )
        , ( "subject", E.string message.subject )
        , ( "body", E.string message.body )
        , ( "timeSent", E.int (Time.posixToMillis message.timeSent) )
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
        ((D.field "timeSent" D.int) |> D.map Time.millisToPosix)
