module Main exposing (..)

import Browser
import Html exposing (..)
import Task
import Time


-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc (Time.millisToPosix 0)
    , Task.perform AdjustTimeZone Time.here
    )



-- UPDATE


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick



-- VIEW


view : Model -> Html Msg
view model =
    let
        hour =
            (Time.toHour model.zone model.time)
                |> String.fromInt
                |> String.padLeft 2 '0'

        minute =
            (Time.toMinute model.zone model.time)
                |> String.fromInt
                |> String.padLeft 2 '0'

        second =
            (Time.toSecond model.zone model.time)
                |> String.fromInt
                |> String.padLeft 2 '0'
    in
        h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
