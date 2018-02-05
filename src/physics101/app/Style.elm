module Style exposing (..)

import Html.Attributes exposing (style)


-- ( "margin-left", "35px" )
--             , ( "margin-top", "25px" )
--             , ( "padding", "25px 35px 35px 55px" )
--             , ( "width", "480px" )
--             , ( "background-color", "#eee" )


mainStyle =
    style
        [ ( "margin-left", "35px" )
        , ( "margin-top", "25px" )
        , ( "padding", "25px 35px 35px 55px" )
        , ( "width", "500px" )
        , ( "height", "600px" )
        , ( "background-color", "#ddd" )
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
