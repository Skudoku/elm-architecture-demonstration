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


increment : Model -> Model
increment model =
    { model | count = model.count + 1 }


type DecrementStatus
    = Successfull Model
    | Underflow


decrement : Model -> DecrementStatus
decrement model =
    if model.count > 0 then
        Successfull { model | count = model.count - 1 }

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
            increment model

        PersonLeft ->
            case decrement model of
                Successfull m ->
                    m

                Underflow ->
                    { model | notification = Just "A person left an empty area " }



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
