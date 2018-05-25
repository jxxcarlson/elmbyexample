-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/random.html


module Dice2App exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (..)
import Random


main =
    Browser.embed
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { dieFace : Int
    }


type alias Flags =
    {}


init : Flags -> ( Model, Cmd Msg )
init flags =
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
    div basicStyle
        [ bigLabel (String.fromInt model.dieFace)
        , basicButton Roll "Roll" buttonStyle
        ]


bigLabel str =
    h1 [ style "text-align" "center" ]
        [ text str ]



-- STYLE


basicStyle =
    [ style "height" "120px"
    , style "width" "80px"
    , style "background-color" "#ddd"
    , style "margin-top" "30px"
    , style "margin-left" "20px"
    , style "padding" "20px"
    ]


basicButton action label style =
    button ([ onClick action ] ++ style) [ text "Roll" ]


buttonStyle =
    [ style "height" "40px"
    , style "width" "80px"
    , style "background-color" "#444"
    , style "font-size" "12pt"
    , style "color" "#fff"
    , style "padding" "8px"
    ]
