module Style exposing (..)

import Html.Attributes exposing (style)


mainStyle =
    [ style "margin" "20px"
    ]


mainStyle2 =
    [ style "width" "600px"
    , style "height" "180px"
    , style "background-color" "#ddd"
    , style "padding" "20px"
    , style "margin" "20px"
    ]


displayStyle =
    [ style "width" "600px"
    , style "height" "190px"
    , style "background-color" "#ddd"
    , style "padding" "20px"
    ]


legendStyle height =
    [ style "width" "615px"
    , style "height" height
    , style "background-color" "#444"
    , style "color" "#fff"
    , style "padding" "12px"
    , style "font-size" "16px"
    , style "margin-top" "15px"
    ]


inputStyle width =
    [ style "width" width, style "font-size" "12pt" ]


messageStyle =
    [ style "width" "58  0px"
    , style "height" "16px"
    , style "background-color" "#444"
    , style "color" "#fff"
    , style "padding" "12px"
    , style "font-size" "16px"
    , style "margin-top" "15px"
    ]


buttonStyle =
    [ style "background-color" "#66b"
    , style "color" "#fff"
    , style "padding" "12px"
    , style "margin-top" "15px"
    ]


labelStyle width =
    [ style "margin-left" "20px"
    , style "margin-right" "8px"
    ]
