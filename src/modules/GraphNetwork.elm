module GraphNetwork exposing (..)

import Vector exposing (Vector)
import List.Extra
import Shape exposing (..)
import ColorRecord exposing (..)
import Line exposing(..)


-- Ellie: https://ellie-app.com/nP53PWDPya1/0


type State
    = On
    | Off


type alias Node =
    { id : Int, label : String, state : State, friends : Friends }


type alias Friends =
    List Int


type alias Network =
    List Node


n1 =
    Node 1 "A" On [ 2, 3 ]


n2 =
    Node 2 "B" On [ 3, 2, 1 ]


n3 =
    Node 3 "C" On [ 4 ]


n4 =
    Node 4 "D" On [ 1 ]

n5 =
    Node 5 "E" On [ 4, 3 ]



net1 =
    [ n1, n2, n3, n4, n5 ]


printNetwork : Network -> String
printNetwork network =
    let
        printNetworkNode =
            printNode network
    in
        List.foldl (\node acc -> acc ++ printNetworkNode node) "" network


printNode : Network -> Node -> String
printNode network node =
    String.join ": " [ node.label, printFriends node network ]
        |> (\str -> str ++ "\n")


printFriends : Node -> Network -> String
printFriends node network =
    node.friends
        |> List.sort
        |> List.map (idToNode network)
        |> List.filterMap identity
        |> List.map .label
        |> String.join ", "


idToNode : Network -> Int -> Maybe Node
idToNode network k =
    network
        |> List.filter (\node -> node.id == k)
        |> List.head


networkVertices : Network -> List Vector
networkVertices network =
    let
        vertices =
            []

        n =
            List.length network

        theta =
            2 * 3.14159265 / (toFloat n)

        vertex =
            rotate (Vector 1 0) theta
    in
        List.range 0 (n - 1)
            |> List.foldl (\k acc -> (acc ++ [ vertex k ])) []


rotate : Vector -> Float -> Int -> Vector
rotate vector angle k =
    Vector.rotate ((toFloat k) * angle) vector


indexedNetworkVertices : Network -> List ( Int, Vector )
indexedNetworkVertices network =
    let
        vertices =
            networkVertices network

        ids =
            network |> List.map .id
    in
        List.Extra.zip ids vertices


getVertexFromId : List ( Int, Vector ) -> Int -> Maybe Vector
getVertexFromId indexedNetworkVertices id =
    indexedNetworkVertices
        |> List.filter (\item -> (Tuple.first item) == id)
        |> List.head
        |> Maybe.map Tuple.second


getVertex : List ( Int, Vector ) -> Node -> Maybe Vector
getVertex indexedNetworkVertices node =
    getVertexFromId indexedNetworkVertices node.id


getEdges : Network -> List ( Int, Vector ) -> Node -> List Vector.DirectedSegment
getEdges network indexedNetworkVertices node =
    let
        maybeStartVertex =
            getVertex indexedNetworkVertices node

        endVertices =
            node.friends
                |> List.map (getVertexFromId indexedNetworkVertices)
                |> List.filterMap identity
    in
        case maybeStartVertex of
            Just startVertex ->
                List.map (\vertex -> Vector.DirectedSegment startVertex vertex) endVertices

            Nothing ->
                []


renderVertices : List Vector -> List Shape
renderVertices centers =
    let
      size = 0.5/(toFloat (List.length centers))
    in
    centers |> List.map (\center -> makeCircle size center)

renderEdges : List Vector.DirectedSegment -> List Line
renderEdges edges =
    edges |> List.map (\edge -> makeLine edge)




makeCircle : Float -> Vector -> Shape
makeCircle size center  =
    let
        shapeData =
            ShapeData center (Vector size size) ColorRecord.lightBlueColor ColorRecord.lightBlueColor
    in
        Ellipse shapeData

makeLine : Vector.DirectedSegment -> Line
makeLine segment  =
    Line segment.a segment.b 2.5 ColorRecord.blackColor ColorRecord.blackColor


{- Example -}


exVertices =
    networkVertices net1


exIndexedVertices =
    indexedNetworkVertices net1


exEdges =
    List.map (getEdges net1 exIndexedVertices) net1
