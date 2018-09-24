port module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode



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
    { js_message : String
    , logMessage : String
    }


init : Decode.Value -> ( Model, Cmd Msg )
init js_message =
    ( { js_message = Decode.decodeValue Decode.string js_message |> Result.withDefault ""
      , logMessage = ""
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SendMessage
    | UpdateMessage String



-- | RecieveMessage String


port log : Encode.Value -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SendMessage ->
            ( model, log (model.logMessage |> Encode.string) )

        UpdateMessage text ->
            ( { model | logMessage = text }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text <|
            "from js:"
                ++ model.js_message
        , div
            []
            [ input [ onInput UpdateMessage ]
                []
            , button
                [ onClick SendMessage ]
                [ text "Send to js" ]
            ]
        ]
