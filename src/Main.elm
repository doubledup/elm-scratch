module Main exposing (Image, Model, Msg(..), getRandomGif, gifDecoder, humanMessage, init, main, onKeyUp, subscriptions, toGiphyUrl, update, view)

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
    , errorMessage : String
    , image : Image
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { topic = "cats"
      , errorMessage = ""
      , image = { url = "waiting.gif", title = "Le title", caption = "Ze caption" }
      }
    , getRandomGif "cat"
    )


type alias Image =
    { url : String, title : String, caption : String }



-- UPDATE


type Msg
    = MorePlease
    | NewGif (Result Http.Error Image)
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
                Ok image ->
                    ( { model
                        | image =
                            { url = image.url
                            , caption = image.caption
                            , title = image.title
                            }
                        , errorMessage = ""
                      }
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
        [ h1 [] [ text ("GIF finder for: " ++ model.topic) ]
        , makePresetButton "cats"
        , makePresetButton "memes"
        , br [] []
        , label [] [ text model.errorMessage ]
        , br [] []
        , label [] [ text "Topic" ]
        , input
            [ onKeyUp
                (\key ->
                    if key == 13 then
                        MorePlease

                    else
                        SetTopic model.topic
                )
            , onInput SetTopic
            , value model.topic
            ]
            []
        , button [ onClick MorePlease ] [ text "More Please!" ]
        , br [] []
        , h3 [] [ text model.image.title ]
        , br [] []
        , img [ height 200, src model.image.url ] []
        , br [] []
        , label [] [ text model.image.caption ]
        ]


makePresetButton str =
    button [ onClick (PresetTopic str) ] [ text str ]



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


gifDecoder : Decode.Decoder Image
gifDecoder =
    Decode.map3 Image
        (Decode.at [ "data", "image_url" ] Decode.string)
        (Decode.at [ "data", "title" ] Decode.string)
        (Decode.at [ "data", "caption" ] Decode.string)


onKeyUp : (Int -> Msg) -> Attribute Msg
onKeyUp tagger =
    on "keyup" (Decode.map tagger keyCode)
