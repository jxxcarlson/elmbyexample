module StyleForRandomNumbers  exposing(..)

import Html.Attributes exposing (style)

mainStyle =
    style
        [ ( "width", "130px" )
        , ( "height", "180px" )
        , ( "background-color", "#ddd" )
        , ( "padding", "20px" )
        , ( "margin", "20px" )
        ]


messageStyle =
    style
        [ ( "width", "100px" )
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
