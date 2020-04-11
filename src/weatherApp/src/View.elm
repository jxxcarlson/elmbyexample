module View exposing (view)

import Html exposing (Html, a, button, div, input, table, td, text, tr)
import Html.Attributes exposing (href, placeholder, style, target, type_)
import Html.Events exposing (onClick, onInput)
import Http
import Types exposing (Model, Msg(..), Status(..), TemperatureScale(..), Weather)



{- Main view function -}


view : Model -> Html Msg
view model =
    div mainStyle
        [ div innerStyle
            [ weatherTable model.weather model.temperatureScale
            , setLocationInput model
            , getWeatherButton model
            , setTemperatureControl model
            , messageLine model
            , showIf (not <| List.member model.status [ Authenticated, Starting ]) (setApiKeyInput model)
            , showIf (not <| List.member model.status [ Authenticated, Starting ]) getApiKeyLink
            , apiLine
            ]
        ]


showIf condition element =
    if condition then
        element

    else
        text ""



{- Style -}


mainStyle =
    [ style "margin" "15px"
    , style "margin-top" "20px"
    , style "width" "240px"
    ]


innerStyle =
    [ style "padding" "15px" ]



{- Inputs -}


setLocationInput model =
    div [ style "margin-bottom" "10px" ]
        [ input [ type_ "text", placeholder "Location", onInput SetLocation ] [] ]


setApiKeyInput model =
    div [ style "margin-top" "20px" ]
        [ input [ type_ "password", placeholder "Api key", onInput SetApiKey ] [] ]



{- Controls -}


getWeatherButton model =
    div [ style "margin-bottom" "0px" ]
        [ button [ onClick GetWeather ] [ text "Get weather" ] ]


setTemperatureControl model =
    div []
        [ setToCentigrade model
        , setToFahrenheit model
        ]


dark =
    "#1b508c"


light =
    "#7490b0"


centigradeStyle model attr =
    case model.temperatureScale of
        Centigrade ->
            [ style "background-color" dark, style "color" "white" ] ++ attr

        Fahrenheit ->
            [ style "background-color" light, style "color" "white" ] ++ attr


fahrenheitStyle model attr =
    case model.temperatureScale of
        Centigrade ->
            [ style "background-color" light, style "color" "white" ] ++ attr

        Fahrenheit ->
            [ style "background-color" dark, style "color" "white" ] ++ attr


setToCentigrade model =
    button (centigradeStyle model [ onClick SetToCentigrade ]) [ text "C" ]


setToFahrenheit model =
    button (fahrenheitStyle model [ onClick SetToFahrenheit ]) [ text "F" ]



{- Links and text -}


getApiKeyLink =
    div
        [ style "margin-top" "8px" ]
        [ a
            [ href "https://openweathermap.org/price", target "_blank" ]
            [ text "get Api key" ]
        ]


messageLine model =
    div [ style "margin-bottom" "10px", style "margin-top" "10px" ] [ text model.message ]


apiLine =
    div [ style "margin-bottom" "10px", style "margin-top" "10px" ]
        [ text "You can paste in b0dadd61e9751e297ed9519af39ec7bc, but only temporarily (please!)" ]



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
    div [ style "margin-bottom" "20px" ]
        [ text "No weather data" ]


realWeatherTable : Weather -> TemperatureScale -> Html msg
realWeatherTable weather temperatureScale =
    table [ style "margin-bottom" "20px" ]
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
        , td [ style "padding-left" "20px" ]
            [ text <| weather.name ]
        ]


temperatureRow : Weather -> TemperatureScale -> Html msg
temperatureRow weather temperatureScale =
    tr []
        [ td [] [ text "Temp" ]
        , td [ style "padding-left" "20px" ]
            [ text <| temperatureString weather temperatureScale ]
        ]


temperatureString weather temperatureScale =
    case temperatureScale of
        Centigrade ->
            addSuffix "C" <| String.fromFloat <| toCentigrade <| weather.main.temp

        Fahrenheit ->
            addSuffix "F" <| String.fromFloat <| toFahrenheit <| weather.main.temp


humidityRow : Weather -> Html msg
humidityRow weather =
    tr []
        [ td [] [ text "Humidity" ]
        , td [ style "padding-left" "20px" ]
            [ text <| addSuffix "%" <| String.fromFloat <| weather.main.humidity ]
        ]


pressureRow : Weather -> Html msg
pressureRow weather =
    tr []
        [ td [] [ text "Pressure" ]
        , td [ style "padding-left" "20px" ]
            [ text <| addSuffix "mb" <| String.fromFloat <| weather.main.pressure ]
        ]


{-| Computed indoor relative humidity at 22 C
-}
indoorRHRow : Weather -> Html msg
indoorRHRow weather =
    tr []
        [ td [] [ text "Indoor RH" ]
        , td [ style "padding-left" "20px" ]
            [ text <| addSuffix "%" <| String.fromFloat <| toFloat <| round <| rhIndoor 22.2 weather * 100 ]
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
    evp temperature pressure * humidity / 100


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
