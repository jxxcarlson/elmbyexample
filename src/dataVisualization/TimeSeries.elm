module TimeSeries exposing (main)

{- This app retrieves random numbers from www.random.org -}

import Json.Decode as Decode exposing (Decoder, list, float)
import Html exposing (div, text, button)
import Html.Events exposing (onClick)
import Http
import StyleForTimeSeries exposing (..)
import Svg exposing (rect, svg)
import Svg.Attributes as SA


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { data : List Float, message : String }


init : ( Model, Cmd Msg )
init =
    ( { data = []
      , message = "Starting up ..."
      }
    , Cmd.none
    )


subscriptions model =
    Sub.none


type Msg
    = NewData (Result Http.Error (List Float))
    | GetData


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewData (Ok data) ->
            ( { model
                | data = data
                , message = "Success"
              }
            , Cmd.none
            )

        NewData (Err error) ->
            ( { model
                | data = []
                , message = (toString error)
              }
            , Cmd.none
            )

        GetData ->
            ( { model | message = "Request" }, getData )



-- VIEW


view model =
    div [ mainStyle ]
        [ div [ displayStyle ] (barGraph (barWidth model) 100 "red" (scaleData model.data))
        , messageLine (displayResult model.data)
        , messageLine model.message
        , button
            [ onClick GetData, buttonStyle ]
            [ text "Get data" ]
        ]


barWidth model =
    450.0 / (toFloat (List.length model.data))


scale : Float -> List Float -> List Float
scale k data =
    List.map (\datum -> k * datum) data


scaleData : List Float -> List Float
scaleData data =
    let
        m =
            data |> List.map abs |> List.maximum |> Maybe.withDefault 1.0
    in
        scale (1.0 / m) data


displayResult : List Float -> String
displayResult data =
    data |> List.map (roundTo 3) |> toString


roundTo : Int -> Float -> Float
roundTo digits value =
    let
        factor =
            10 ^ digits |> toFloat
    in
        value
            |> (\x -> x * factor)
            |> round
            |> toFloat
            |> (\x -> x / factor)


messageLine message =
    div [ legendStyle ] [ text message ]



-- RANDOM NUMBER STUFF


getData : Cmd Msg
getData =
    let
        url =
            dataUrl 100

        request =
            Http.get url dataDecoder
    in
        Http.send NewData request


dataUrl : Int -> String
dataUrl dataSize =
    "http://localhost:8000/data=" ++ (toString dataSize)


dataDecoder : Decoder (List Float)
dataDecoder =
    (list float)


barGraph : Float -> Float -> String -> List Float -> List (Html.Html msg)
barGraph barWidth barHeight color scaledData =
    List.map (verticalBar barWidth barHeight color) scaledData


vRect : Float -> Float -> String -> Float -> Svg.Svg msg
vRect barWidth barHeight color fraction =
    if fraction > 0 then
        vRectPlus barWidth barHeight color fraction
    else
        vRectMinus barWidth barHeight color fraction


vRectPlus : Float -> Float -> String -> Float -> Svg.Svg msg
vRectPlus barWidth barHeight color fraction =
    rect
        [ SA.y <| toString <| (1 - fraction) * barHeight
        , SA.height <| toString <| fraction * barHeight
        , SA.width <| toString barWidth
        , SA.fill color
        ]
        []


vRectMinus : Float -> Float -> String -> Float -> Svg.Svg msg
vRectMinus barWidth barHeight color fraction =
    rect
        [ SA.y <| toString <| barHeight
        , SA.height <| toString <| -1 * fraction * barHeight
        , SA.width <| toString barWidth
        , SA.fill color
        ]
        []


verticalBar : Float -> Float -> String -> Float -> Html.Html msg
verticalBar barWidth barHeight color fraction =
    svg
        [ SA.width <| toString (1.3 * barWidth), SA.height <| toString <| 2 * barHeight ]
        [ vRect barWidth barHeight color fraction ]
