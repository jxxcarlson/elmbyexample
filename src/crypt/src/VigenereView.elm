module VigenereView exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import VigenereStyle exposing (..)
import VigenereTypes exposing (Msg(..))


heading =
    h1
        headingStyle
        [ text "Vigenère cipher" ]


textInput model =
    div []
        [ input
            ([ type_ "text"
             , placeholder "Input text"
             , onInput InputText
             ]
                ++ inputStyle
            )
            []
        , span numberDisplayStyle [ text (String.fromInt (String.length model.inputText)) ]
        ]


keyInput model =
    div []
        [ input
            ([ type_ "text"
             , placeholder "key"
             , onInput Key
             ]
                ++ keyInputStyle
            )
            []
        , span numberDisplayStyle [ text (String.fromInt (String.length model.key)) ]
        ]


cipherTextDisplay model =
    div [ style "margin-top" "15px" ]
        [ span
            cipherTextStyle
            [ text model.cipherText ]
        , span numberDisplayStyle [ text (String.fromInt (String.length model.cipherText)) ]
        ]


decipheredTextDisplay model =
    div [ style "margin-top" "15px" ]
        [ span
            cipherTextStyle
            [ text model.decipheredText ]
        , span numberDisplayStyle [ text (String.fromInt (String.length model.decipheredText)) ]
        ]


legend =
    p
        legendStyle
        [ text "Enter text in 'Input text' and a string in 'key'. Use ALL CAPS, no spaces, numbers, or punctuation marks." ]
