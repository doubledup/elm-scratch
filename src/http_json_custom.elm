module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Url.Builder as Url


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
    { topic : String
    , url : String
    , errorMessage : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { topic = "cats"
      , url = "waiting.gif"
      , errorMessage = ""
      }
    , getRandomGif "cat"
    )



-- UPDATE


type Msg
    = MorePlease
    | NewGif (Result Http.Error String)
    | SetTopic String
    | PresetTopic String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( model
            , getRandomGif model.topic
            )

        NewGif result ->
            case result of
                Ok newUrl ->
                    ( { model | url = newUrl, errorMessage = "" }
                    , Cmd.none
                    )

                Err message ->
                    ( { model | errorMessage = humanMessage message }
                    , Cmd.none
                    )

        SetTopic newTopic ->
            ( { model | topic = newTopic }, Cmd.none )

        PresetTopic newTopic ->
            ( { model | topic = newTopic }, getRandomGif newTopic )


humanMessage : Http.Error -> String
humanMessage err =
    case err of
        Http.BadUrl url ->
            "Got a bad URL: " ++ url

        Http.Timeout ->
            "Took too long to find the next gif"

        Http.NetworkError ->
            "Something's up with the network :'("

        Http.BadStatus response ->
            "Server sent a bad status: "
                ++ (response.status.code |> String.fromInt)
                ++ response.status.message

        Http.BadPayload message _ ->
            "Data from the server made no sense. " ++ message



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text ("GIF finder for: " ++ model.topic) ]
        , br [] []
        , label [] [ text "Topic" ]
        , input [ onInput SetTopic, value model.topic ] []
        , select []
            [ option [ onClick (PresetTopic "cats") ] [ text "cats" ]
            , option [ onClick (PresetTopic "memes") ] [ text "memes" ]
            ]
        , button [ onClick MorePlease ] [ text "More Please!" ]
        , br [] []
        , img [ src model.url ] []
        , br [] []
        , label [] [ text model.errorMessage ]
        ]



-- HTTP


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    Http.send NewGif (Http.get (toGiphyUrl topic) gifDecoder)


toGiphyUrl : String -> String
toGiphyUrl topic =
    Url.crossOrigin "https://api.giphy.com"
        [ "v1", "gifs", "random" ]
        [ Url.string "api_key" "dc6zaTOxFJmzC"
        , Url.string "tag" topic
        ]


gifDecoder : Decode.Decoder String
gifDecoder =
    Decode.field "data" (Decode.field "image_url" Decode.string)
