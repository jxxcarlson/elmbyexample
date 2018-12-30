port module Main exposing (main)

{- This is a starter app which presents a text label, text field, and a button.
   What you enter in the text field is echoed in the label.  When you press the
   button, the text in the label is reverse.

   This version uses `mdgriffith/elm-ui` for the view functions.
-}

import Browser
import Html exposing (Html)
import Json.Encode as E
import Json.Decode as D
import Task
import Time
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Http
import Message exposing (Message)


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { input : String
    , output : String
    , zone : Time.Zone
    , time : Time.Posix
    , thisAppId : String
    , otherAppId : String
    }


type Msg
    = NoOp
    | Tick Time.Posix
    | NewTime Time.Posix
    | AdjustTimeZone Time.Zone
    | InputText String
    | SendMessage
    | ReceivedMessage E.Value
    | GetMessage


type alias Flags =
    { thisAppId : String
    , otherAppId : String
    }


port sendMessage : E.Value -> Cmd msg


port receiveMessage : (E.Value -> msg) -> Sub msg


port getMessage : E.Value -> Cmd msg


port getAndDeleteMessage : E.Value -> Cmd msg


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { input = ""
      , output = "App started"
      , zone = Time.utc
      , time = Time.millisToPosix 0
      , thisAppId = flags.thisAppId
      , otherAppId = flags.otherAppId
      }
    , Task.perform AdjustTimeZone Time.here
    )


subscriptions model =
    Sub.batch
        [ Time.every 1000 Tick
        , receiveMessage ReceivedMessage
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Tick newTime ->
            ( model, getNewTime )

        NewTime newTime ->
            ( { model | time = newTime }, Cmd.none )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )

        InputText str ->
            ( { model | input = str }, Cmd.none )

        SendMessage ->
            let
                message =
                    Message.encode model.zone
                        { sender = model.thisAppId
                        , recipient = model.otherAppId
                        , key = "message"
                        , value = model.input
                        , time = model.time
                        }
            in
                ( { model | output = "Sent message" }, sendMessage message )

        ReceivedMessage value ->
            -- case D.decodeValue D.string value of
            case Message.decode model.zone value of
                Ok message ->
                    ( { model | output = "Message: " ++ message.value }, Cmd.none )

                Err err ->
                    ( { model | output = D.errorToString err }, Cmd.none )

        GetMessage ->
            ( model, getAndDeleteMessage (E.string "getMessage") )


getNewTime : Cmd Msg
getNewTime =
    Task.perform NewTime Time.now



--
-- VIEW
--


view : Model -> Html Msg
view model =
    Element.layout [ Background.color (rgb255 40 40 40) ] (mainColumn model)


mainColumn : Model -> Element Msg
mainColumn model =
    column mainColumnStyle
        [ column [ centerX, spacing 20 ]
            [ title <| "App " ++ model.thisAppId
            , inputText model
            , sendMessageButton
            , getMessageButton
            , outputDisplay model
            ]
        ]


title : String -> Element msg
title str =
    row [ centerX, Font.bold ] [ text str ]


outputDisplay : Model -> Element msg
outputDisplay model =
    row [ centerX ]
        [ text model.output ]


inputText : Model -> Element Msg
inputText model =
    Input.text []
        { onChange = InputText
        , text = model.input
        , placeholder = Nothing
        , label = Input.labelLeft [] <| el [] (text "")
        }


sendMessageButton : Element Msg
sendMessageButton =
    row [ centerX ]
        [ Input.button buttonStyle
            { onPress = Just SendMessage
            , label = el [ centerX, centerY, width (px 140) ] (text "Send message")
            }
        ]


getMessageButton : Element Msg
getMessageButton =
    row [ centerX ]
        [ Input.button buttonStyle
            { onPress = Just GetMessage
            , label = el [ centerX, centerY, width (px 140) ] (text "Get message")
            }
        ]



--
-- STYLE
--


mainColumnStyle =
    [ centerX
    , centerY
    , Background.color (rgb255 240 240 240)
    , paddingXY 20 20
    ]


buttonStyle =
    [ Background.color (rgb255 40 40 40)
    , Font.color (rgb255 255 255 255)
    , paddingXY 15 8
    ]



--
