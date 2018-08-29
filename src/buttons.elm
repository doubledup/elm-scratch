module Main exposing (..)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


main : Platform.Program Basics.Never Model Msg
main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    Int


model : Model
model =
    0



-- UPDATE


type Msg
    = Increment
    | Decrement
    | Reset


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1

        Reset ->
            0



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ button [ onClick Increment ] [ text "+" ]
            , div [] [ text (toString model) ]
            , button [ onClick Decrement ] [ text "-" ]
            ]
        , div []
            [ button [ onClick Reset ] [ text "Back to 0" ] ]
        ]
