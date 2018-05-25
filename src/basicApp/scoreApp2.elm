module ScoreApp2 exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


main =
    Browser.sandbox { init = init, view = view, update = update }



-- MODEL


type alias Model =
    { counter : Int }


init : Model
init =
    { counter = 0 }



-- UPDATE


type Msg
    = Increment


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | counter = model.counter + 1 }



-- VIEW


view : Model -> Html Msg
view model =
    div mainStyle
        [ div displayStyle [ text (String.fromInt model.counter) ]
        , button ([ onClick Increment ] ++ buttonStyle) [ text "+" ]
        ]



--- STYLE


buttonStyle : List (Html.Attribute msg)
buttonStyle =
    [ style "backgroundColor" "rgb(100,100,100)"
    , style "color" "white"
    , style "width" "50px"
    , style "height" "50px"
    , style "padding-bottom" "8px"
    , style "font-size" "28pt"
    , style "text-align" "center"
    , style "border" "none"
    ]


displayStyle : List (Html.Attribute msg)
displayStyle =
    [ style "backgroundColor" "rgb(50,50,50)"
    , style "color" "red"
    , style "width" "50px"
    , style "height" "42px"
    , style "padding-top" "8px"
    , style "text-align" "center"
    , style "font-size" "32pt"
    , style "border" "none"
    ]


mainStyle : List (Html.Attribute msg)
mainStyle =
    [ style "margin" "30px" ]
