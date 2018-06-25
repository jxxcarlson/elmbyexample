module CaesarApp exposing (..)

{- A very basic app that demonstrates the Caesar Cipher. -}

import Browser
import CaesarCipher exposing (encryptWithCaesar)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main =
    Browser.sandbox { init = init, view = view, update = update }



-- MODEL


type alias Model =
    { plainText : String
    , cipherText : String
    , key : Int
    }


init : Model
init =
    { plainText = "", cipherText = "", key = 0 }



-- UPDATE


type Msg
    = PlainText String
    | CipherText String
    | Key String


update : Msg -> Model -> Model
update msg model =
    case msg of
        PlainText plainText ->
            let
                cipherText =
                    encryptWithCaesar model.key plainText
            in
                { model | plainText = plainText, cipherText = cipherText }

        CipherText cipherText ->
            { model | cipherText = cipherText }

        Key keyString ->
            let
                key =
                    String.toInt keyString |> Maybe.withDefault 0

                cipherText =
                    encryptWithCaesar key model.plainText
            in
                { model | key = key, cipherText = cipherText }



-- VIEW


view : Model -> Html Msg
view model =
    div
        mainStyle
        [ heading
        , textInput
        , keyInput
        , cipherTextDisplay model
        , message
        ]


heading =
    h1
        headingStyle
        [ text "Caesar cipher" ]


textInput =
    input
        ([ type_ "text"
         , placeholder "Plain text"
         , onInput PlainText
         ]
            ++ plainTextInputStyle
        )
        []


cipherTextDisplay model =
    div
        encryptedTextStyle
        [ text model.cipherText ]


keyInput =
    input
        ([ type_ "text"
         , placeholder "key"
         , onInput Key
         ]
            ++ keyInputStyle
        )
        []


message =
    div
        labeStyle
        [ text "Enter a word in 'Plain text' and an integer in 'key'" ]



{- STYLE -}


mainStyle =
    [ style "width" "300px"
    , style "height" "300px"
    , style "padding" "15px"
    , style "margin" "40px"
    , style "background-color" "rgb(140,140,140"
    ]


headingStyle =
    [ style "color" "white"
    , style "padding-bottom" "20px"
    ]


plainTextInputStyle =
    [ style "width" "150x", style "font-size" "14pt" ]


keyInputStyle =
    [ style "width" "65px", style "margin-top" "15px", style "font-size" "14pt" ]


encryptedTextStyle =
    [ style "width" "210px"
    , style "height" "32px"
    , style "font-size" "18pt"
    , style "padding" "4px"
    , style "margin-top" "15px"
    , style "background-color" "rgb(160, 110, 110)"
    , style "color" "white"
    ]


labeStyle =
    [ style "width" "210px"
    , style "height" "32px"
    , style "font-size" "12pt"
    , style "padding" "4px"
    , style "padding-top" "40px"
    , style "color" "white"
    ]
