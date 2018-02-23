module TimeSeries exposing (..)

{- This app retrieves random numbers from www.random.org -}

import Json.Decode as Decode exposing (Decoder, list, float)
import Html exposing (div, p, span, text, button, input)
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
    , url : String
    , command : String
    , message : String
    }


initialModel =
    { data = []
    , displayType = Bar
    , url = "http://localhost:8000"
    , command = "data=100"
    , message = "Starting up with data source localhost:8000 ..."
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel
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
    | GetUrl String
    | GetCommand String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewData (Ok data) ->
            ( { model
                | data = data
                , message = "Success for " ++ dataUrl model ++ ", data points: " ++ (toString <| List.length data)
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

        GetUrl urlString ->
            ( { model | url = urlString }, Cmd.none )

        GetCommand commandString ->
            ( { model | command = commandString }, Cmd.none )


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
        , span [ labelStyle "50px" ] [ text "Command" ]
        , commandInput "355px" model
        , p [] [ text "Data server url: ", urlInput "520px" model ]
        , messageLine "12px" model.message
        , messageLine "" (displayResult model.data)
        ]


commandInput width model =
    input
        [ type_ "text"
        , inputStyle width
        , placeholder model.command
        , onInput GetCommand
        ]
        []


urlInput width model =
    input
        [ type_ "text"
        , inputStyle width
        , placeholder model.url
        , onInput GetUrl
        ]
        []


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
            (dataUrl model)

        request =
            Http.get url dataDecoder
    in
        Http.send NewData request


dataUrl : Model -> String
dataUrl model =
    model.url ++ "/" ++ model.command


dataDecoder : Decoder (List Float)
dataDecoder =
    (list float)
