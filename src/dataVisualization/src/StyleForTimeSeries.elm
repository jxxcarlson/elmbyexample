module StyleForTimeSeries exposing (..)

import Html.Attributes exposing (style)


mainStyle =
    style
        [ ( "margin", "20px" )
        ]


mainStyle2 =
    style
        [ ( "width", "600px" )
        , ( "height", "180px" )
        , ( "background-color", "#ddd" )
        , ( "padding", "20px" )
        , ( "margin", "20px" )
        ]


displayStyle =
    style
        [ ( "width", "600px" )
        , ( "height", "190px" )
        , ( "background-color", "#ddd" )
        , ( "padding", "20px" )
        ]


legendStyle height =
    style
        [ ( "width", "615px" )
        , ( "height", height )
        , ( "background-color", "#444" )
        , ( "color", "#fff" )
        , ( "padding", "12px" )
        , ( "font-size", "16px" )
        , ( "margin-top", "15px" )
        ]


messageStyle =
    style
        [ ( "width", "58  0px" )
        , ( "height", "16px" )
        , ( "background-color", "#444" )
        , ( "color", "#fff" )
        , ( "padding", "12px" )
        , ( "font-size", "16px" )
        , ( "margin-top", "15px" )
        ]


buttonStyle =
    style
        [ ( "background-color", "#66b" )
        , ( "color", "#fff" )
        , ( "padding", "12px" )
        , ( "margin-top", "15px" )
        ]
