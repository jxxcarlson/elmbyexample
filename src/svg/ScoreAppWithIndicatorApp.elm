module ScoreAppWithIndicatorApp exposing (..)

import Browser
import Html exposing (Html, button, div, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Svg exposing (rect, svg)
import Svg.Attributes as SA


main =
    Browser.sandbox { init = init, view = view, update = update }



-- MODEL


type alias Model =
    Int


init : Model
init =
    0



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1



-- VIEW


view : Model -> Html Msg
view model =
    div mainStyle
        [ basicButton Decrement "-" buttonStyle
        , div displayStyle [ text (String.fromInt model) ]
        , basicButton Increment "+" buttonStyle
        , indicatorWithLegend 150 20 "blue" (fraction model 10) "Score mod 10"
        , indicatorWithLegend 150 20 "red" (fraction model 100) "Score"
        ]


fraction model denom =
    let
        num =
            toFloat <| remainderBy denom model

        ratio =
            num / toFloat denom
    in
        Basics.min ratio 1.0



---- Button component


basicButton message label style =
    button ([ onClick message ] ++ style) [ text label ]



--- Indicator code


indicator barWidth barHeight color fraction_ =
    svg
        ([ SA.height <| String.fromInt barHeight ] ++ indicatorStyle)
        [ horizontalBar barWidth barHeight "black" 1.0
        , horizontalBar barWidth barHeight color fraction_
        ]


indicatorWithLegend barWidth barHeight color fraction_ legend =
    div []
        [ indicator barWidth barHeight color fraction_
        , p legendStyle [ text legend ]
        ]


indicatorStyle =
    [ style "margin-top" "15px" ]


legendStyle =
    [ style "margin" "0", style "color" "#ccc" ]


hRect barWidth barHeight color fraction_ =
    rect
        [ SA.width <| String.fromFloat <| fraction_ * barWidth
        , SA.height <| String.fromFloat barHeight
        , SA.fill color
        ]
        []


horizontalBar barWidth barHeight color fraction_ =
    svg
        [ SA.height <| String.fromInt (barHeight + 2) ]
        [ hRect (toFloat barWidth) (toFloat barHeight) color fraction_ ]



--- STYLE


mainStyle =
    [ style "width" "220px"
    , style "height" "250px"
    , style "background-color" "#444"
    , style "padding" "20px"
    ]


buttonStyle : List (Html.Attribute msg)
buttonStyle =
    [ style "backgroundColor" "rgb(100,100,100)"
    , style "color" "white"
    , style "width" "50px"
    , style "height" "50px"
    , style "font-size" "28pt"
    , style "text-align" "center"
    , style "border" "none"
    ]


displayStyle : List (Html.Attribute msg)
displayStyle =
    [ style "backgroundColor" "rgb(50,50,50)"
    , style "color" "red"
    , style "width" "50px"
    , style "height" "50px"
    , style "text-align" "center"
    , style "font-size" "32pt"
    , style "border" "none"
    ]
