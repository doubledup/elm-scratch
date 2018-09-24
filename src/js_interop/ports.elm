module Main exposing (main)

import Browser
import Html exposing (..)
import Json.Decode as Decode



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
    { js_message : String }


init : Decode.Value -> ( Model, Cmd Msg )
init js_message =
    ( { js_message = Decode.decodeValue Decode.string js_message |> Result.withDefault "" }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SendMessage String



-- | RecieveMessage String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendMessage text ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text <| "from js:" ++ model.js_message
        ]
