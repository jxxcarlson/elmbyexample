module Decoder exposing (weatherDecoder)

{- Decode data returned from openweathermap.org as Weather value. -}

import Json.Decode exposing (Decoder, decodeString, field, float, int, map2, map3, map4, map5, string)
import Types exposing (Weather, Main)


weatherDecoder : Decoder Weather
weatherDecoder =
    map3 Weather
        (field "id" int)
        (field "name" string)
        (field "main" mainDecoder)


mainDecoder : Decoder Main
mainDecoder =
    map5 Main
        (field "temp" float)
        (field "humidity" float)
        (field "pressure" float)
        (field "temp_max" float)
        (field "temp_min" float)


{-| Below is an example of the data structure returned by
openweathermap.org. It is not used in the app,
but is useful as a reference.
-}
data =
    """{"coord":{"lon":139,"lat":35},
"sys":{"country":"JP","sunrise":1369769524,"sunset":1369821049},
"weather":[{"id":804,"main":"clouds","description":"overcast clouds","icon":"04n"}],
"main":{"temp":289.5,"humidity":89,"pressure":1013,"temp_min":287.04,"temp_max":292.04},
"wind":{"speed":7.31,"deg":187.002},
"rain":{"3h":0},
"clouds":{"all":92},
"dt":1369824698,
"id":1851632,
"name":"Shuzenji",
"cod":200}"""
