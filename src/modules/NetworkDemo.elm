module Bars2App exposing (main)

import Html exposing (Html, div, table, td, text, tr)
import Html.Attributes exposing (..)
import Svg exposing (Svg, rect, svg)
import Svg.Attributes as SA
import GraphNetwork exposing (..)
import Shape exposing (..)
import ColorRecord exposing (..)
import Vector exposing (Vector)
import Affine


main : Html msg
main =
    div [] [ display ]


display : Html msg
display =
    div [ mainStyle ]
        [ svg
            [ SA.viewBox "0 0 500 500" ]
            trajectoryDisplay
        ]


trajectoryDisplay : List (Svg msg)
trajectoryDisplay =
    renderVertices exVertices
        |> List.map
        |> List.map Shape.draw


sourceRect =
    { corner = Vector -1 -1, size = Vector 2 2 }


targetRect =
    { corner = Vector 0 0, size = Vector 500 500 }


coefficients =
    Affine.make sourceRect targetRect


rv =
    renderVertices exVertices


mainStyle =
    style
        [ ( "margin-left", "35px" )
        , ( "margin-top", "25px" )
        , ( "padding", "25px 35px 35px 55px" )
        , ( "width", "500px" )
        , ( "height", "600px" )
        , ( "background-color", "#ddd" )
        ]
