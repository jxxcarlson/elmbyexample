module View exposing (view)

import Html exposing (Html, button, div, input, table, td, text, tr, a)
import Html.Attributes exposing (placeholder, style, type_, href, target)
import Html.Events exposing (onClick, onInput)
import Http
import Types exposing (Model, Msg(..), TemperatureScale(..), Weather, Status(..))


{- Main view function -}


view : Model -> Html Msg
view model =
    div [ mainStyle ]
        [ div [ innerStyle ]
            [ weatherTable model.weather model.temperatureScale
            , setLocationInput model
            , getWeatherButton model
            , setTemperatureControl model
            , messageLine model
            , showIf (not <| List.member model.status [ Authenticated, Starting ]) (setApiKeyInput model)
            , showIf (not <| List.member model.status [ Authenticated, Starting ]) getApiKeyLink
            ]
        ]


showIf condition element =
    if condition then
        element
    else
        text ""



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



{- Inputs -}


setLocationInput model =
    div [ style [ ( "margin-bottom", "10px" ) ] ]
        [ input [ type_ "text", placeholder "Location", onInput SetLocation ] [] ]


setApiKeyInput model =
    div [ style [ ( "margin-top", "20px" ) ] ]
        [ input [ type_ "password", placeholder "Api key", onInput SetApiKey ] [] ]



{- Controls -}


getWeatherButton model =
    div [ style [ ( "margin-bottom", "0px" ) ] ]
        [ button [ onClick GetWeather ] [ text "Get weather" ] ]


setTemperatureControl model =
    div []
        [ setToCentigrade model
        , setToFahrenheit model
        ]


centigradeStyle model =
    case model.temperatureScale of
        Centigrade ->
            style [ ( "background-color", "black" ), ( "color", "white" ) ]

        Fahrenheit ->
            style [ ( "background-color", "#888" ), ( "color", "white" ) ]


fahrenheitStyle model =
    case model.temperatureScale of
        Centigrade ->
            style [ ( "background-color", "#888" ), ( "color", "white" ) ]

        Fahrenheit ->
            style [ ( "background-color", "black" ), ( "color", "white" ) ]


setToCentigrade model =
    button [ onClick SetToCentigrade, centigradeStyle model ] [ text "C" ]


setToFahrenheit model =
    button [ onClick SetToFahrenheit, fahrenheitStyle model ] [ text "F" ]



{- Links and text -}


getApiKeyLink =
    div
        [ style [ ( "margin-top", "8px" ) ] ]
        [ a
            [ href "https://openweathermap.org/price", target "_blank" ]
            [ text "get Api key" ]
        ]


messageLine model =
    div [ style [ ( "margin-bottom", "10px" ), ( "margin-top", "10px" ) ] ] [ text model.message ]



{- Weather display -}


{-| Dispatch: if there is valid weather data, display it,
otherwise display a messaget saying that there is none.
-}
weatherTable : Maybe Weather -> TemperatureScale -> Html msg
weatherTable maybeWeather temperatureScale =
    case maybeWeather of
        Just weather ->
            realWeatherTable weather temperatureScale

        Nothing ->
            noWeatherTable


noWeatherTable : Html msg
noWeatherTable =
    div [ style [ ( "margin-bottom", "20px" ) ] ]
        [ text "No weather data" ]


realWeatherTable : Weather -> TemperatureScale -> Html msg
realWeatherTable weather temperatureScale =
    table [ style [ ( "margin-bottom", "20px" ) ] ]
        [ locationRow weather
        , temperatureRow weather temperatureScale
        , humidityRow weather
        , indoorRHRow weather
        , pressureRow weather
        ]



{- Rows for the weather display -}


locationRow : Weather -> Html msg
locationRow weather =
    tr []
        [ td [] [ text "Location" ]
        , td [ style [ ( "padding-left", "20px" ) ] ]
            [ text <| weather.name ]
        ]


temperatureRow : Weather -> TemperatureScale -> Html msg
temperatureRow weather temperatureScale =
    tr []
        [ td [] [ text "Temp" ]
        , td [ style [ ( "padding-left", "20px" ) ] ]
            [ text <| temperatureString weather temperatureScale ]
        ]


temperatureString weather temperatureScale =
    case temperatureScale of
        Centigrade ->
            addSuffix "C" <| toString <| toCentigrade <| weather.main.temp

        Fahrenheit ->
            addSuffix "F" <| toString <| toFahrenheit <| weather.main.temp


humidityRow : Weather -> Html msg
humidityRow weather =
    tr []
        [ td [] [ text "Humidity" ]
        , td [ style [ ( "padding-left", "20px" ) ] ]
            [ text <| addSuffix "%" <| toString <| weather.main.humidity ]
        ]


pressureRow : Weather -> Html msg
pressureRow weather =
    tr []
        [ td [] [ text "Pressure" ]
        , td [ style [ ( "padding-left", "20px" ) ] ]
            [ text <| addSuffix "mb" <| toString <| weather.main.pressure ]
        ]


{-| Computed indoor relative humidity at 22 C
-}
indoorRHRow : Weather -> Html msg
indoorRHRow weather =
    tr []
        [ td [] [ text "Indoor RH" ]
        , td [ style [ ( "padding-left", "20px" ) ] ]
            [ text <| addSuffix "%" <| toString <| toFloat <| round <| (rhIndoor 22.2 weather) * 100 ]
        ]


{-| Helper function.

    addSufix "C" "12.3"

yields the string "12.3 C"

-}
addSuffix : String -> String -> String
addSuffix suffix str =
    str ++ " " ++ suffix



{- Conversions -}


toCentigrade : Float -> Float
toCentigrade kelvin =
    kelvin - 273.15 |> round |> toFloat


toFahrenheit : Float -> Float
toFahrenheit kelvin =
    1.8 * (kelvin - 273.15) + 32 |> round |> toFloat



{- Relative humidity -}


exp x =
    Basics.e ^ x


{-| Equilibrium vapor pressure:
<https://en.wikipedia.org/wiki/Relative_humidity>
<http://ww2010.atmos.uiuc.edu/(Gh)/guides/mtr/cld/dvlp/rh.rxml>
<https://en.wikipedia.org/wiki/Vapor_pressure>
<https://chem.libretexts.org/Textbook_Maps/General_Chemistry_Textbook_Maps/Map%3A_Chemistry%3A_The_Central_Science_(Brown_et_al.)/11%3A_Liquids_and_Intermolecular_Forces/11.5%3A_Vapor_Pressure>
-}
evp temperature pressure =
    let
        temp =
            temperature - 273.15
    in
        (1.0007 + 0.00000346 * pressure) * 6.1121 * exp (17.502 * temp / (240.9 + temp))


{-| Actual vapor pressuure
-}
avp temperature pressure humidity =
    (evp temperature pressure) * humidity / 100


{-| Computed indoor relative humidity at 22 C based on
assumption that when outdoor air is heated/cooled,
water is neither added nor subtracted.
-}
rhIndoor indoorCentigradeTemperature weather =
    let
        indoorTemperature =
            indoorCentigradeTemperature + 273.15

        numerator =
            avp weather.main.temp weather.main.pressure weather.main.humidity

        denominator =
            evp indoorTemperature weather.main.pressure
    in
        numerator / denominator
