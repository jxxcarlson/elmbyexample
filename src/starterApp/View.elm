module View exposing (view)

import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (placeholder, style, type_)
import Html.Events exposing (onClick, onInput)
import Http
import Types exposing (Model, Msg(..))


{- Main view function -}


view : Model -> Html Msg
view model =
    div [ mainStyle ]
        [ div [ innerStyle ]
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
    div [ style [ ( "margin-bottom", "10px" ), ( "font-weight", "bold" ) ] ]
        [ (text str) ]


messageDisplay model =
    div [ style [ ( "margin-bottom", "10px" ) ] ]
        [ (text model.message) ]



{- Inputs -}


sampleInput model =
    div [ style [ ( "margin-bottom", "10px" ) ] ]
        [ input [ type_ "text", placeholder "Enter text here", onInput Input ] [] ]



{- Controls -}


sampleButton model =
    div [ style [ ( "margin-bottom", "0px" ) ] ]
        [ button [ onClick ReverseText ] [ text "Reverse" ] ]



{- Style -}


mainStyle =
    style
        [ ( "margin", "15px" )
        , ( "margin-top", "20px" )
        , ( "background-color", "#eee" )
        , ( "width", "240px" )
        ]


innerStyle =
    style [ ( "padding", "15px" ) ]
