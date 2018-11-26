module ScoreApp2 exposing (..)

{-| Simple counter app using mdgriffith/elm-ui

-}

import Browser
import Html exposing (Html)

import Element exposing(..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input



main =
    Browser.sandbox { init = init, view = view, update = update }



-- MODEL


type alias Model =
    { counter : Int }


init : Model
init =
    { counter = 0 }



-- UPDATE


type Msg
    = Increment


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | counter = model.counter + 1 }



-- VIEW


view : Model -> Html Msg
view model = 
  Element.layout  [] ( mainColumn model )
   

mainColumn model = 
  column mainColumnStyle
     [column [centerX]
        [ 
            indicator model
          , incrementButton
        ]
     ]

indicator : Model -> Element msg 
indicator model = 
   row indicatorStyle [
       el [centerX, centerY] (text (String.fromInt model.counter))
       ]

incrementButton :  Element Msg 
incrementButton = 
  row buttonStyle [
    Input.button buttonStyle {
        onPress = Just Increment
        , label = el [centerX, centerY] (text "+")
    }
  ]

-- STYLE

indicatorStyle = [
   width <| px 80
   , height <| px 80
   , Background.color (rgb255 40 40 40)
   , Font.color (rgb255 255 0 0) 
   , Font.size 50
  ]

buttonStyle = [
   width <| px 80
   , height <| px 80
   , Background.color (rgb255 220 220 220)
   , Font.color (rgb255 0 0 0) 
   , Font.size 50
  ]

mainColumnStyle = [ 
   centerX
  , centerY
  ]