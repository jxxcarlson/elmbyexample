module TimeSeries exposing (..)

{- This app retrieves random numbers from www.random.org -}

import Json.Decode as Decode exposing (Decoder, list, float)
import Html exposing (div, span, text, button, input)
import Html.Attributes exposing (type_, placeholder)
import Html.Events exposing (onClick, onInput)
import Http
import StyleForTimeSeries exposing (..)
import LineGraph exposing (makeLineGraph)
import BarGraph exposing (makeBarGraph)
import Data


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { data : List Float
    , displayType : DisplayType
    , parameter : Int
    , message : String
    }


init : ( Model, Cmd Msg )
init =
    ( { data = []
      , displayType = Bar
      , parameter = 100
      , message = "Starting up ..."
      }
    , Cmd.none
    )


subscriptions model =
    Sub.none


type DisplayType
    = Bar
    | Line


type Msg
    = NewData (Result Http.Error (List Float))
    | GetData
    | ToggleDisplay
    | GetParameter String


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
            ( { model | message = "Request" }, getData model )

        ToggleDisplay ->
            ( { model | displayType = toggleDisplay model }, Cmd.none )

        GetParameter parameterString ->
            ( { model | parameter = String.toInt parameterString |> Result.withDefault 0 }, Cmd.none )


toggleDisplay model =
    case model.displayType of
        Line ->
            Bar

        Bar ->
            Line



{- VIEW -}


view model =
    div [ mainStyle ]
        [ div [ displayStyle ] [ showGraph model ]
        , basicButton GetData "Get data"
        , basicButton ToggleDisplay "Toggle display"
        , span [ labelStyle ] [ text "Number of data points" ]
        , parameterInput model
        , messageLine "14   0px" (displayResult model.data)
        , messageLine "12px" model.message
        ]


parameterInput model =
    input
        [ type_ "text"
        , inputStyle
        , placeholder "???"
        , onInput GetParameter
        ]
        [ text (toString model.parameter) ]


basicButton action message =
    button
        [ onClick action, buttonStyle ]
        [ text message ]


showGraph model =
    case model.displayType of
        Bar ->
            makeBarGraph 600 200 model.data

        Line ->
            makeLineGraph 600 200 1 model.data


displayResult : List Float -> String
displayResult data =
    data
        |> List.map (Data.roundTo 3)
        |> List.map toString
        |> String.join ", "


messageLine height message =
    div [ legendStyle height ] [ text message ]



{- DATA -}


getData : Model -> Cmd Msg
getData model =
    let
        url =
            dataUrl model.parameter

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
