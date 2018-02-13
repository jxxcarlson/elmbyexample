module GraphDemo exposing (..)

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
            [ SA.viewBox "-40 -50 300 300" ]
            (graphDisplay 100 testGraph)
        ]


testGraph =
    Graph vertices edges


vertices =
    [ Vertex 1 "A", Vertex 2 "B", Vertex 3 "C", Vertex 4 "D", Vertex 5 "E" ]


edges =
    [ ( 1, 2 ), ( 2, 3 ), ( 3, 4 ), ( 4, 5 ), ( 5, 1 ) ]


mainStyle =
    style
        [ ( "margin-left", "30px" )
        , ( "margin-top", "30px" )
        , ( "width", "400px" )
        , ( "height", "400px" )
        , ( "background-color", "#ddd" )
        ]
