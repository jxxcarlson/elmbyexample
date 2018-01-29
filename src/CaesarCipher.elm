module CaesarCipher exposing (..)

{- A very basic app that demonstrates the Caesar Cipher. -}

import Char
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
    Model "" "" 0



-- UPDATE


type Msg
    = PlainText String
    | CipherText String
    | Key String


update : Msg -> Model -> Model
update msg model =
    case msg of
        PlainText plainText ->
            { model | plainText = plainText }

        CipherText cipherText ->
            { model | cipherText = cipherText }

        Key key ->
            { model | key = String.toInt key |> Result.withDefault 0 }



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ mainStyle
        ]
        [ h1
            [ headingStyle ]
            [ text "Caesar cipher" ]
        , input
            [ type_ "text"
            , plainTextInputStyle
            , placeholder "Plain text"
            , onInput PlainText
            ]
            []
        , input
            [ keyInputStyle
            , type_ "text"
            , placeholder "key"
            , onInput Key
            ]
            []
        , p
            [ encryptedTextStyle ]
            [ text (encrypt model.key model.plainText) ]
        , p
            [ labeStyle ]
            [ text "Enter a word in 'Plain text' and an integer in 'key'" ]
        ]



-- ENCRYPTION
{- One should really use modular arithmetic for the below. -}


string2ascii : String -> List Char.KeyCode
string2ascii message =
    message
        |> String.toList
        |> List.map Char.toCode


ascii2string : List Char.KeyCode -> String
ascii2string nums =
    nums
        |> List.map Char.fromCode
        |> String.fromList


add : Int -> Int -> Int
add x y =
    x + y


encrypt : Int -> String -> String
encrypt k str =
    str |> string2ascii |> List.map (add k) |> ascii2string


decrypt : Int -> String -> String
decrypt k str =
    encrypt -k str



{- STYLE -}


mainStyle =
    style
        [ ( "width", "300px" )
        , ( "height", "300px" )
        , ( "padding", "15px" )
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
    style [ ( "width", "65px" ), ( "margin-left", "15px" ), ( "font-size", "14pt" ) ]


encryptedTextStyle =
    style
        [ ( "width", "210px" )
        , ( "height", "32px" )
        , ( "font-size", "18pt" )
        , ( "padding", "4px" )
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
