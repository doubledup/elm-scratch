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
    { jsMessages : List String
    , logMessage : String
    }


init : Decode.Value -> ( Model, Cmd Msg )
init jsMessages =
    ( { jsMessages = [ Decode.decodeValue Decode.string jsMessages |> Result.withDefault "" ]
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
        [ h3 [] [ text "from js:\n" ]
        , p [] [ text <| String.join "\n" model.jsMessages ]
        , div
            []
            [ input [ onInput UpdateMessage ]
                []
            , button
                [ onClick SendMessage ]
                [ text "Send to js" ]
            ]
        ]
