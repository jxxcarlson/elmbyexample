module Types exposing (..)

import Http exposing (get, send)
import Http


type alias Model =
    { weather : Maybe Weather
    , message : String
    , location : String
    , apiKey : String
    , temperatureScale : TemperatureScale
    , status : Status
    }


type Msg
    = GetWeather
    | NewWeather (Result Http.Error Weather)
    | SetLocation String
    | SetApiKey String
    | SetToCentigrade
    | SetToFahrenheit
    | RestoreApiKey String


type Status
    = Start
    | Starting
    | Authenticated
    | Error


type TemperatureScale
    = Centigrade
    | Fahrenheit


type alias Weather =
    { id : Int
    , name : String
    , main : Main
    }


type alias Main =
    { temp : Float
    , humidity : Float
    , pressure : Float
    , temp_min : Float
    , temp_max : Float
    }
