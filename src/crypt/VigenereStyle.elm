module VigenereStyle exposing (..)

import Html.Attributes exposing (style)


mainStyle =
    [ style "width" "400px"
    , style "height" "360px"
    , style "padding" "15px"
    , style "margin" "40px"
    , style "background-color" "rgb(140,140,140"
    ]


headingStyle =
    [ style "color" "white"
    , style "padding-bottom" "20px"
    ]


inputStyle =
    [ style "width" "350px"
    , style "font-family" "monospace"
    , style "font-size" "14pt"
    ]


cipherTextStyle =
    [ style "width" "350px"
    , style "height" "30px"
    , style "font-size" "14pt"
    , style "font-family" "monospace"
    , style "padding" "4px"
    , style "background-color" "rgb(160, 110, 110)"
    , style "color" "white"
    ]


keyInputStyle =
    [ style "width" "350px"
    , style "font-family" "monospace"
    , style "margin-top" "15px"
    , style "font-size" "14pt"
    ]


numberDisplayStyle =
    [ style "margin-left" "10px", style "color" "white" ]


legendStyle =
    [ style "width" "350px"
    , style "height" "32px"
    , style "font-size" "12pt"
    , style "padding" "4px"
    , style "padding-top" "20px"
    , style "color" "white"
    ]
