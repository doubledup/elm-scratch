module ElmArch.ButtonsCustom exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (value)
import Html.Events exposing (onClick, onInput)


main : Platform.Program () Model Msg
main =
    Browser.sandbox { init = init, view = view, update = update }



-- MODEL


type alias Model =
    { displayNumber : Int
    , typedNumber : String
    }


init : Model
init =
    { displayNumber = 0
    , typedNumber = ""
    }



-- UPDATE


type Msg
    = Increment
    | IncrementBy Int
    | Decrement
    | Reset
    | Set42
    | SetNumber { dn : Int, tn : String }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | displayNumber = model.displayNumber + 1 }

        IncrementBy increment ->
            { model | displayNumber = model.displayNumber + increment }

        Decrement ->
            { model | displayNumber = model.displayNumber - 1 }

        Reset ->
            { model | displayNumber = 0 }

        Set42 ->
            { model | displayNumber = 42 }

        SetNumber r ->
            { model | displayNumber = r.dn, typedNumber = r.tn }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ incrementButton 10
            , button [ onClick Increment ] [ text "+" ]
            , div [] [ text (String.fromInt model.displayNumber) ]
            , button [ onClick Decrement ] [ text "-" ]
            ]
        , div []
            [ button [ onClick Reset ] [ text "Back to 0" ]
            , button [ onClick Set42 ] [ text "42" ]
            ]
        , div []
            [ input
                [ onInput (\str -> SetNumber { dn = str |> String.toInt |> Maybe.withDefault 0, tn = str })
                , value model.typedNumber
                ]
                []
            ]
        ]


incrementButton : Int -> Html Msg
incrementButton n =
    button [ onClick (IncrementBy n) ] [ text <| "Add " ++ String.fromInt n ]
