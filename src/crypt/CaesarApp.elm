module CaesarApp exposing (..)

{- A very basic app that demonstrates the Caesar Cipher. -}

import CaesarCipher exposing (encryptWithCaesar)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { plainText : String
    , cipherText : String
    , key : Int
    }


model : Model
model =
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
                    String.toInt keyString |> Result.withDefault 0

                cipherText =
                    encryptWithCaesar key model.plainText
            in
                { model | key = key, cipherText = cipherText }



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ mainStyle ]
        [ heading
        , textInput
        , keyInput
        , cipherTextDisplay model
        , message
        ]


heading =
    h1
        [ headingStyle ]
        [ text "Caesar cipher" ]


textInput =
    input
        [ type_ "text"
        , plainTextInputStyle
        , placeholder "Plain text"
        , onInput PlainText
        ]
        []


cipherTextDisplay model =
    div
        [ encryptedTextStyle ]
        [ text model.cipherText ]


keyInput =
    input
        [ keyInputStyle
        , type_ "text"
        , placeholder "key"
        , onInput Key
        ]
        []


message =
    div
        [ labeStyle ]
        [ text "Enter a word in 'Plain text' and an integer in 'key'" ]



{- STYLE -}


mainStyle =
    style
        [ ( "width", "300px" )
        , ( "height", "300px" )
        , ( "padding", "15px" )
        , ( "margin", "40px" )
        , ( "background-color", "rgb(140,140,140" )
        ]


headingStyle =
    style
        [ ( "color", "white" )
        , ( "padding-bottom", "20px" )
        ]


plainTextInputStyle =
    style [ ( "width", "150x" ), ( "font-size", "14pt" ) ]


keyInputStyle =
    style [ ( "width", "65px" ), ( "margin-top", "15px" ), ( "font-size", "14pt" ) ]


encryptedTextStyle =
    style
        [ ( "width", "210px" )
        , ( "height", "32px" )
        , ( "font-size", "18pt" )
        , ( "padding", "4px" )
        , ( "margin-top", "15px" )
        , ( "background-color", "rgb(160, 110, 110)" )
        , ( "color", "white" )
        ]


labeStyle =
    style
        [ ( "width", "210px" )
        , ( "height", "32px" )
        , ( "font-size", "12pt" )
        , ( "padding", "4px" )
        , ( "padding-top", "40px" )
        , ( "color", "white" )
        ]
