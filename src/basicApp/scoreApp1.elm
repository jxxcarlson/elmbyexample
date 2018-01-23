module ScoreApp1 exposing (..)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)


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
    div []
        [ div [] [ text (toString model.counter) ]
        , button [ onClick Increment ] [ text "+" ]
        ]
