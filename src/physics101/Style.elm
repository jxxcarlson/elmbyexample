module Style exposing (..)

import Html.Attributes exposing (style)


mainStyle =
    style
        [ ( "margin-left", "35px" )
        , ( "margin-top", "25px" )
        , ( "padding", "25px 35px 35px 55px" )
        , ( "width", "500px" )
        , ( "height", "500px" )
        , ( "background-color", "#eee" )
        ]


buttonStyle =
    style
        [ ( "height", "25px" )
        , ( "background-color", "black" )
        , ( "color", "white" )
        , ( "margin-right", "10px" )
        , ( "font-size", "12pt" )
        ]


labelStyle =
    style
        [ ( "height", "35px" )
        , ( "background-color", "black" )
        , ( "color", "white" )
        , ( "margin-right", "15px" )
        , ( "padding", "3px 8px 3px 8px" )
        ]
