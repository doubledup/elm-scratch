module ElmArch.TextFieldsCustom exposing (..)

import Browser
import Html exposing (Html, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { text : String }


init : Model
init =
    { text = "" }



-- UPDATE


type Msg
    = Change String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newContent ->
            { model | text = newContent }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Text to reverse", value model.text, onInput Change ] []
        , div [] [ text (String.reverse model.text) ]
        , div [] [ text ("Length: " ++ (model.text |> String.length |> String.fromInt)) ]
        ]
