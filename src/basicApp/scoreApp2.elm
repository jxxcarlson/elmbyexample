module ScoreApp2 exposing (..)

import Html exposing (Html, button, div, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { counter : Int }


model : Model
model =
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
    div [ mainStyle ]
        [ div [ displayStyle ] [ text (toString model.counter) ]
        , button [ onClick Increment, buttonStyle ] [ text "+" ]
        ]



--- STYLE


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


mainStyle : Html.Attribute msg
mainStyle =
    style [ ( "margin", "30px" ) ]
