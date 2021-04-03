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


type alias Model = String


init : Model
init = ""



-- UPDATE


type Msg
    = Change String


update : Msg -> Model -> Model
update msg _ =
    case msg of
        Change newContent -> newContent



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Text to reverse", value model, onInput Change ] []
        , div [] [ text (String.reverse model) ]
        , div [] [ text ("Length: " ++ (model |> String.length |> String.fromInt)) ]
        ]
