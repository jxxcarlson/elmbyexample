module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Vigenere exposing (longKeyEncrypt, longKeyDecrypt)
import Style exposing (..)


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { plainText : String
    , cipherText : String
    , key : String
    }


model : Model
model =
    Model "" "" ""



-- UPDATE


type Msg
    = PlainText String
    | Key String


update : Msg -> Model -> Model
update msg model =
    case msg of
        PlainText plainText ->
            { model | plainText = plainText, cipherText = longKeyEncrypt model.key plainText }

        Key key ->
            { model | cipherText = longKeyEncrypt key model.plainText, key = key }



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ mainStyle ]
        [ h1
            [ headingStyle ]
            [ text "Vigenère cipher" ]
        , div []
            [ input
                [ type_ "text"
                , inputStyle
                , placeholder "Plain text"
                , onInput PlainText
                ]
                []
            , span [ numberDisplayStyle ] [ text (toString (String.length model.plainText)) ]
            ]
        , div []
            [ input
                [ keyInputStyle
                , type_ "text"
                , placeholder "key"
                , onInput Key
                ]
                []
            , span [ numberDisplayStyle ] [ text (toString (String.length model.key)) ]
            ]
        , div [ style [ ( "margin-top", "15px" ) ] ]
            [ span
                [ cipherTextStyle ]
                [ text model.cipherText ]
            , span [ numberDisplayStyle ] [ text (toString (String.length model.cipherText)) ]
            ]
        , p
            [ legendStyle ]
            [ text "Enter text in 'Plain text' and a string in 'key'. Use ALL CAPS plus spaces and punctuation for plain text. Use all caps for key" ]
        ]
