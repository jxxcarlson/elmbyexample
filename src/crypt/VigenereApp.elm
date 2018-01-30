module VigenereApp exposing (..)

import Html exposing (..)
import VigenereCipher exposing (longKeyEncrypt, longKeyDecrypt)
import VigenereStyle exposing(mainStyle)
import VigenereTypes exposing(Msg(..))
import VigenereView exposing(..)


main =
    Html.beginnerProgram { model = model, view = view, update = update }

type alias Model =
    { inputText : String
    , cipherText : String
    , decipheredText : String
    , key : String
    }

model : Model
model =
    Model "" "" "" ""


update : Msg -> Model -> Model
update msg model =
    case msg of
        InputText inputText ->
            { model | inputText = inputText,
                      cipherText = longKeyEncrypt model.key inputText,
                      decipheredText = longKeyDecrypt model.key inputText }

        Key key ->
            { model | cipherText = longKeyEncrypt key model.inputText,
                      decipheredText = longKeyDecrypt key model.inputText ,
                      key = key }


view : Model -> Html Msg
view model =
    div
        [ mainStyle ]
        [ heading
        , textInput model
        , keyInput model
        , cipherTextDisplay model
        , decipheredTextDisplay model
        , VigenereView.legend ]
