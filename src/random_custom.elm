module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Random
import Task
import Process


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
    { dieFace : Int
    , weightedDieFace : Int
    , rollCounter : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { dieFace = 1
      , weightedDieFace = 1
      , rollCounter = 0
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Roll
    | StartRoll
    | NewFace Int
    | WeightedFace Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            if model.rollCounter > 0 then
                ( { model | rollCounter = model.rollCounter - 1 }
                , Cmd.batch [ (Task.perform (\_ -> Roll) (Process.sleep 100.0)), rollDice ]
                )
            else
                ( model, Cmd.none )

        StartRoll ->
            ( { model | rollCounter = 10 }, Task.perform (\_ -> Roll) (Process.sleep 1.0) )

        NewFace newFace ->
            ( { model | dieFace = newFace }
            , Cmd.none
            )

        WeightedFace newFace ->
            ( { model | weightedDieFace = newFace }
            , Cmd.none
            )


rollDice =
    Cmd.batch
        [ Random.generate NewFace (Random.int 1 6)
        , Random.generate WeightedFace
            (Random.weighted ( 1, 1 )
                [ ( 1, 2 )
                , ( 2, 3 )
                , ( 3, 4 )
                , ( 5, 5 )
                , ( 8, 6 )
                ]
            )
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text (String.fromInt model.dieFace) ]
        , button [ onClick StartRoll ] [ text "Roll" ]
        , div []
            [ h3 [] [ text "Fair die" ]
            , img
                [ src ("https://wpclipart.com/recreation/games/dice/die_face_" ++ (String.fromInt model.dieFace) ++ ".png"), height 100, width 130 ]
                []
            ]
        , div []
            [ h3 [] [ text "Weighted die" ]
            , img
                [ src ("https://wpclipart.com/recreation/games/dice/die_face_" ++ (String.fromInt model.weightedDieFace) ++ ".png"), height 100, width 130 ]
                []
            ]
        ]
