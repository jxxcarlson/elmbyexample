module Main exposing (main)

{- This app retrieves random numbers from www.random.org -}

import Json.Decode as Decode exposing (Decoder, int)
import Html exposing (div, text, button)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { maybeRandomNumber : Maybe Int, message : String }


init : ( Model, Cmd Msg )
init =
    ( { maybeRandomNumber = Nothing
      , message = "Starting up ..."
      }
    , Cmd.none
    )


subscriptions model =
    Sub.none


type Msg
    = NewNumber (Result Http.Error Int)
    | GetNumber


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewNumber (Ok newNumber) ->
            ( { model
                | maybeRandomNumber = Just newNumber
                , message = "Success"
              }
            , Cmd.none
            )

        NewNumber (Err error) ->
            ( { model
                | maybeRandomNumber = Nothing
                , message = "Error"
              }
            , Cmd.none
            )

        GetNumber ->
            ( { model | message = "Request" }, getRandomNumber )



-- VIEW


view model =
    div [ mainStyle ]
        [ messageLine (displayResult model.maybeRandomNumber)
        , messageLine model.message
        , button
            [ onClick GetNumber, buttonStyle ]
            [ text "Get number" ]
        ]


displayResult : Maybe Int -> String
displayResult maybeNumber =
    case maybeNumber of
        Just n ->
            (toString n)

        Nothing ->
            "****"


messageLine message =
    div [ messageStyle ] [ text message ]



-- RANDOM NUMBER STUFF


getRandomNumber : Cmd Msg
getRandomNumber =
    let
        url =
            randomNumberUrl 9

        request =
            Http.get url randomNumberDecoder
    in
        Http.send NewNumber request


{-| maxDigits < 10
-}
randomNumberUrl : Int -> String
randomNumberUrl maxDigits =
    let
        maxNumber =
            10 ^ maxDigits

        prefix =
            "https://www.random.org/integers/?num=1&min=1&max="

        suffix =
            "&col=1&base=10&format=plain&rnd=new"
    in
        prefix ++ (toString maxNumber) ++ suffix


randomNumberDecoder : Decoder Int
randomNumberDecoder =
    int



-- STYLE


mainStyle =
    style
        [ ( "width", "130px" )
        , ( "height", "180px" )
        , ( "background-color", "#ddd" )
        , ( "padding", "20px" )
        , ( "margin", "20px" )
        ]


messageStyle =
    style
        [ ( "width", "100px" )
        , ( "height", "16px" )
        , ( "background-color", "#444" )
        , ( "color", "#fff" )
        , ( "padding", "12px" )
        , ( "font-size", "16px" )
        , ( "margin-top", "15px" )
        ]


buttonStyle =
    style
        [ ( "background-color", "#66b" )
        , ( "color", "#fff" )
        , ( "padding", "12px" )
        , ( "margin-top", "15px" )
        ]
