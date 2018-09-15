module Main exposing (main)

import Browser
import Html
import Html.Events as Event


main =
    Browser.sandbox
        { init = emptyModel
        , update = update
        , view = view
        }



-- Model


type alias Model =
    { count : Int
    , notification : Maybe String
    }


emptyModel : Model
emptyModel =
    { count = 0
    , notification = Nothing
    }


type DecrementStatus
    = SuccessfullDecrement Model
    | Underflow

type IncrementStatus
  = SuccessfullIncrement Model
  | MaximumReached

increment : Model -> IncrementStatus
increment model =
    if model.count < 80 then
      SuccessfullIncrement { model | count = model.count + 1 }

    else
      MaximumReached

decrement : Model -> DecrementStatus
decrement model =
    if model.count > 0 then
        SuccessfullDecrement { model | count = model.count - 1 }

    else
        Underflow

-- Update

type Message
    = PersonEntered
    | PersonLeft


update : Message -> Model -> Model
update message model =
    case message of
        PersonEntered ->
            case increment model of
              SuccessfullIncrement m ->
                { m | notification = Just "" }

              MaximumReached ->
                { model | notification = Just "Maximum amount of people reached." }

        PersonLeft ->
            case decrement model of
                SuccessfullDecrement m ->
                    { m | notification = Just "" }

                Underflow ->
                    { model | notification = Just "A person left an empty area." }



-- View


view : Model -> Html.Html Message
view model =
    let
        notification =
            Maybe.withDefault "" model.notification
    in
    Html.div []
        [ Html.div [] [ Html.span [] [ Html.text notification ] ]
        , Html.div []
            [ Html.button [ Event.onClick PersonLeft ] [ Html.text "-" ]
            , Html.span [] [ Html.text (String.fromInt model.count) ]
            , Html.button [ Event.onClick PersonEntered ] [ Html.text "+" ]
            ]
        ]
