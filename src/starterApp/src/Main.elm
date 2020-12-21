module Main exposing (main)

{- This is a starter app which presents a text label, text field, and a button.
   What you enter in the text field is echoed in the label.  When you press the
   button, the text in the label is reverse. This is the Html version.
-}

import Browser
import Html
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (placeholder, style, type_)
import Html.Events exposing (onClick, onInput)
import Http


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { message : String
    }


type Msg
    = NoOp
    | Input String
    | ReverseText


type alias Flags =
    {}


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { message = "App started"
      }
    , Cmd.none
    )


subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Input str ->
            ( { model | message = str }, Cmd.none )

        ReverseText ->
            ( { model | message = model.message |> String.reverse |> String.toLower }, Cmd.none )



--
-- VIEW
--


view : Model -> Html Msg
view model =
    div mainStyle
        [ div innerStyle
            [ label "Skeleton App"
            , messageDisplay model
            , sampleInput model
            , sampleButton model
            ]
        ]


showIf condition element =
    if condition then
        element
    else
        text ""



{- Outputs -}


label str =
    div [ style "margin-bottom" "10px", style "font-weight" "bold" ]
        [ (text str) ]


messageDisplay model =
    div [ style "margin-bottom" "10px" ]
        [ (text model.message) ]



{- Inputs -}


sampleInput model =
    div [ style "margin-bottom" "10px" ]
        [ input [ type_ "text", placeholder "Enter text here", onInput Input ] [] ]



{- Controls -}


sampleButton model =
    div [ style "margin-bottom" "0px" ]
        [ button [ onClick ReverseText ] [ text "Reverse" ] ]



{- Style -}


mainStyle =
    [ style "margin" "15px"
    , style "margin-top" "20px"
    , style "background-color" "#eee"
    , style "width" "240px"
    ]


innerStyle =
    [ style "padding" "15px" ]
