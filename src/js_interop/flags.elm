module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Attribute, Html, div, h3, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Json.Decode as Decode
import Time



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { content : String
    , time : Time.Posix
    }


init : Decode.Value -> ( Model, Cmd Msg )
init initialDate =
    ( { content = ""
      , time = Decode.decodeValue Decode.int initialDate |> Result.withDefault 0 |> Time.millisToPosix
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Change String
    | NewDateTime Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newContent ->
            ( { model | content = newContent }, Cmd.none )

        NewDateTime dateTime ->
            ( { model | time = dateTime }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 NewDateTime



-- VIEW


view : Model -> Html Msg
view model =
    let
        hour =
            Time.toHour Time.utc model.time |> String.fromInt

        minute =
            Time.toMinute Time.utc model.time |> String.fromInt

        second =
            Time.toSecond Time.utc model.time |> String.fromInt
    in
    div []
        [ h3 [] [ text <| String.join ":" [ hour, minute, second ] ]
        , input [ placeholder "Text to reverse", value model.content, onInput Change ] []
        , div [] [ text (String.reverse model.content) ]
        ]
