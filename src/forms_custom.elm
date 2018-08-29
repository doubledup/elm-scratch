module Main exposing (..)

import Browser
import Html exposing (Html, div, input, label, text, button)
import Html.Attributes exposing (value, type_, style, pattern, placeholder)
import Html.Events exposing (onInput, onClick)
import List
import Regex exposing (fromString, contains)


-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , confirmation : String
    , age : Int
    , validationRecord : { valid : Bool, message : String }
    }


init : Model
init =
    { name = ""
    , password = ""
    , confirmation = ""
    , age = 0
    , validationRecord = { valid = False, message = "" }
    }



-- UPDATE


type Msg
    = Name String
    | Password String
    | Confirmation String
    | Age String
    | Validate


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name newName ->
            { model | name = newName }

        Password newPassword ->
            { model | password = newPassword }

        Confirmation newConfirmation ->
            { model | confirmation = newConfirmation }

        Age newAge ->
            { model | age = (String.toInt newAge |> Maybe.withDefault 0) }

        Validate ->
            { model | validationRecord = (validate model) }


view : Model -> Html Msg
view model =
    div []
        [ labelledInput "Name" Name "" model.name
        , labelledInput "Password" Password "password" model.password
        , labelledInput "Password confirmation" Confirmation "password" model.confirmation
        , labelledInput "Age" Age "number" <| String.fromInt model.age
        , viewValidation model.validationRecord
        , button [ onClick Validate ] [ text "Submit" ]
        ]


labelledInput labelText inputHandler inputType inputValue =
    div []
        [ label [] [ text labelText ]
        , input [ onInput inputHandler, type_ inputType, value inputValue, placeholder labelText ] []
        ]


viewValidation validationRecord =
    div
        [ style "color"
            (if validationRecord.valid then
                "green"
             else
                "red"
            )
        ]
        [ label []
            [ text
                (validationRecord.message)
            ]
        ]


validate model =
    let
        validations =
            [ { valid = model.password == model.confirmation, validText = "matches", invalidText = "doesn't match" }
            , { valid = model.password /= "", validText = "isn't empty", invalidText = "is empty" }
            , { valid = String.length model.password > 8, validText = "is long enough", invalidText = "is too short" }
            , { valid = String.any Char.isDigit model.password, validText = "has a number", invalidText = "has no numbers" }
            , { valid = String.any Char.isLower model.password, validText = "has a lower case character", invalidText = "has no lower case characters" }
            , { valid = String.any Char.isUpper model.password, validText = "has a upper case character", invalidText = "has no upper case characters" }
            ]

        validationText =
            "Password "
                ++ (validations
                        |> (List.foldr
                                (\check ->
                                    (\messages ->
                                        (if check.valid then
                                            check.validText
                                         else
                                            check.invalidText
                                        )
                                            :: messages
                                    )
                                )
                                []
                           )
                        |> (List.intersperse " and ")
                        |> (List.foldr (++) "")
                   )
                ++ (if allValid then
                        " :)"
                    else
                        "! :'("
                   )

        allValid =
            validations |> (List.map (\record -> record.valid)) |> (List.all (\x -> x))
    in
        { valid = allValid, message = validationText }
