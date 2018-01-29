module Style exposing (..)

import Html.Attributes exposing (style)


mainStyle =
    style
        [ ( "width", "400px" )
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


inputStyle =
    style
        [ ( "width", "350px" )
        , ( "font-family", "monospace" )
        , ( "font-size", "14pt" )
        ]


cipherTextStyle =
    style
        [ ( "width", "350px" )
        , ( "height", "30px" )
        , ( "font-size", "14pt" )
        , ( "font-family", "monospace" )
        , ( "padding", "4px" )
        , ( "background-color", "rgb(160, 110, 110)" )
        , ( "color", "white" )
        ]


keyInputStyle =
    style
        [ ( "width", "350px" )
        , ( "font-family", "monospace" )
        , ( "margin-top", "15px" )
        , ( "font-size", "14pt" )
        ]


numberDisplayStyle =
    style [ ( "margin-left", "10px" ), ( "color", "white" ) ]


legendStyle =
    style
        [ ( "width", "350px" )
        , ( "height", "32px" )
        , ( "font-size", "12pt" )
        , ( "padding", "4px" )
        , ( "padding-top", "20px" )
        , ( "color", "white" )
        ]
