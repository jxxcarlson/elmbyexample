-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/random.html


module Dice2App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (..)
import Random


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { dieFace : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model 1, Cmd.none )



-- UPDATE


type Msg
    = Roll
    | NewFace Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model, Random.generate NewFace (Random.int 1 6) )

        NewFace newFace ->
            ( Model newFace, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ basicStyle ]
        [ bigLabel (toString model.dieFace)
        , basicButton Roll "Roll" buttonStyle
        ]


bigLabel str =
    h1 [ style [ ( "text-align", "center" ) ] ]
        [ text str ]



-- STYLE


basicStyle =
    style
        [ ( "height", "120px" )
        , ( "width", "80px" )
        , ( "background-color", "#ddd" )
        , ( "margin-top", "30px" )
        , ( "margin-left", "20px" )
        , ( "padding", "20px" )
        ]


basicButton action label style =
    button [ onClick action, style ] [ text "Roll" ]


buttonStyle =
    style
        [ ( "height", "40px" )
        , ( "width", "80px" )
        , ( "background-color", "#444" )
        , ( "font-size", "12pt" )
        , ( "color", "#fff" )
        , ( "padding", "8px" )
        ]
