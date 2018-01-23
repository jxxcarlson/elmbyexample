module ScoreAppWithIndicator exposing (..)

import Html exposing (Html, button, div, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Svg exposing (rect, svg)
import Svg.Attributes as SA


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    Int


model : Model
model =
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
    div [ mainStyle ]
        [ basicButton Decrement "-" buttonStyle
        , div [ displayStyle ] [ text (toString model) ]
        , basicButton Increment "+" buttonStyle
        , indicatorWithLegend 150 20 "blue" (fraction model 10) "Score mod 10"
        , indicatorWithLegend 150 20 "red" (fraction model 100) "Score"
        ]


fraction model denom =
    let
        num =
            toFloat (model % denom)

        ratio =
            num / toFloat denom
    in
        Basics.min ratio 1.0



---- Button component


basicButton message label style =
    button [ onClick message, style ] [ text label ]



--- Indicator code


indicator barWidth barHeight color fraction =
    svg
        [ SA.height <| toString barHeight, indicatorStyle ]
        [ horizontalBar barWidth barHeight "black" 1.0
        , horizontalBar barWidth barHeight color fraction
        ]


indicatorWithLegend barWidth barHeight color fraction legend =
    div []
        [ indicator barWidth barHeight color fraction
        , p [ legendStyle ] [ text legend ]
        ]


indicatorStyle =
    style [ ( "margin-top", "15px" ) ]


legendStyle =
    style [ ( "margin", "0" ), ( "color", "#ccc" ) ]


hRect barWidth barHeight color fraction =
    rect
        [ SA.width <| toString <| fraction * barWidth
        , SA.height <| toString barHeight
        , SA.fill color
        ]
        []


horizontalBar barWidth barHeight color fraction =
    svg
        [ SA.height <| toString (barHeight + 2) ]
        [ hRect barWidth barHeight color fraction ]



--- STYLE


mainStyle =
    style
        [ ( "width", "220px" )
        , ( "height", "250px" )
        , ( "background-color", "#444" )
        , ( "padding", "20px" )
        ]


buttonStyle : Html.Attribute msg
buttonStyle =
    style
        [ ( "backgroundColor", "rgb(100,100,100)" )
        , ( "color", "white" )
        , ( "width", "50px" )
        , ( "height", "50px" )
        , ( "font-size", "28pt" )
        , ( "text-align", "center" )
        , ( "border", "none" )
        ]


displayStyle : Html.Attribute msg
displayStyle =
    style
        [ ( "backgroundColor", "rgb(50,50,50)" )
        , ( "color", "red" )
        , ( "width", "50px" )
        , ( "height", "50px" )
        , ( "text-align", "center" )
        , ( "font-size", "32pt" )
        , ( "border", "none" )
        ]
