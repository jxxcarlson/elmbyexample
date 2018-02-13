module GraphDemo exposing (main)

import Html exposing (Html, div)
import Html.Attributes exposing (..)
import Svg exposing (svg)
import Svg.Attributes as SA
import DisplayGraph exposing (Graph, Vertex, graphDisplay)
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
            (graphDisplay coefficients testGraph)
        ]


sourceRect =
    { corner = Vector -1 -1, size = Vector 2 2 }


targetRect =
    { corner = Vector 150 0, size = Vector 200 200 }


coefficients =
    Affine.make sourceRect targetRect


vertices =
    [ Vertex 1 "A", Vertex 2 "B", Vertex 3 "C", Vertex 4 "D", Vertex 5 "E" ]


edges =
    [ ( 1, 2 ), ( 1, 3 ), ( 1, 4 ), ( 2, 3 ), ( 3, 4 ), ( 3, 5 ) ]


testGraph =
    Graph vertices edges


mainStyle =
    style
        [ ( "margin-left", "35px" )
        , ( "margin-top", "25px" )
        , ( "padding", "25px 35px 35px 55px" )
        , ( "width", "500px" )
        , ( "height", "500px" )
        , ( "background-color", "#ddd" )
        ]
