# Elm Architecture Demonstration
A demonstration of the [Elm Architecture][elm-architecture].

## Elm
We assume a passing familiarity with [Elm][elm]. See the [guide][] or an [Elm demonstration][demo].

## Architecture
The Elm architecture is

> a simple pattern for architecting webapps. It is great for modularity, code reuse, and testing. Ultimately, it makes it easy to create complex web apps that stay healthy as you refactor and add features.

It provides a structure and guideline how to develop a web application. This reduces surprises and enables developers to make decisions on their own.

### Structure
The basic structure of an Elm Architure revolves around the following components.

1. Model
2. Update
3. View

#### Model
Model contains the state of you application. It describes what is important for your particular application.

#### Update
A way to change the model. It determines the how to model goes through various transformations.

#### View
A way to visualize the model. Usually this is some form of HTML, but other options are available as well.

### Demonstration
Our customer is interested in keeping track of how many people enter a certain area. For this they want a simple counter.

#### Setup
Initialize a project with `elm init` accepting to create the `elm.json`. Create a `src` directory and open a file `Main.elm`. The contents is a jumping off point and is used to check if our code still works

```elm
module Main exposing (main)

import Html


main =
    Html.text "Hello, World"
```

#### Model
In order to keep track of the number of people we keep track of how many people are currently in the area. We do this by introducing a _record_ keeping track of a count.

```elm
type alias Model =
    { count : Int
    }
```

We want some abstractions to work with this model. We will introduce an empty start model.

```elm
emptyModel : Model
emptyModel =
    { count = 0
    }
```

A way to register that a person enters the area.

```elm
increment : Model -> Model
increment model =
    { model | count = model.count + 1 }
```

And a way to register that a person leaves the area. As an extra check we will provide a _tagged_ model. We will tag a model whether it successfully could register the leave, or that according to our model the area was empty.

```
type DecrementStatus
    = Successfull Model
    | Underflow


decrement : Model -> DecrementStatus
decrement model =
    if model.count > 0 then
        Successfull { model | count = model.count - 1 }

    else
        Underflow
```

We now have modeled our problem. Notice that this can be done without a visual representation. In a sense it is independent.

#### Update
The `update` function accepts a _message_ and a model. The function will return the new model. The message should indicate how the model is to be changed. For us that will be either an person entered or person left.

```elm
type Message
    = PersonEntered
    | PersonLeft
```

No we need to respond correctly to these messages.

```elm
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
                    model
```

Note that we could test this method without any dependency on running the application.

#### View
With our model and view in place it is time to create a view. A view accepts a model and returns `Html`. When a user interacts with our app, intent is the change the model. Because this is done with `Message` the return type is `Html.Html Message`.

As a first shot we try, leaving out the interaction.

```elm
view : Model -> Html.Html Message
view model =
    Html.div []
        [ Html.button [] [ Html.text "-" ]
        , Html.span [] [ Html.text (String.fromInt model.count) ]
        , Html.button [] [ Html.text "+" ]
        ]
```

#### Wire everything together
In order to see our changes we need to create a [`sandbox`][sandbox]. For this we need to import `Browser`.


```elm
import Browser
```

and change our main to

```elm
main =
    Browser.sandbox
        { init = emptyModel
        , update = update
        , view = view
        }
```

`Browser.sandbox` accepts a record contain an initial model, an update function and a view function which we provide. If you open the reactor you should be created with some buttons and a count. Notice that the buttons do not update the model.

#### Interaction
Let's change that. In order to add interactivity we need to tell the view function when to send a message. For this we need `Html.Events`

```elm
import Html.Events as Event
```

Now our update function changes into

```elm
view : Model -> Html.Html Message
view model =
    Html.div []
        [ Html.button [ Event.onClick PersonLeft ] [ Html.text "-" ]
        , Html.span [] [ Html.text (String.fromInt model.count) ]
        , Html.button [ Event.onClick PersonEntered ] [ Html.text "+" ]
        ]
```

this will make the buttons respond to our intended changes. Note that we can't decrement passed zero.

### Change
Seeing our solution our customer is very happy. She praises us all around. After a few weeks she has a new request. She would like to be notified when a person leaves while the area is empty. So we set out to fulfill the request.

#### Model
We update our model with a notification. Because it should not always be there, we give it the type `Maybe String`

```elm
type alias Model =
    { count : Int
    , notification : Maybe String
    }
```

this will break our application, but the compiler helps us in telling where it breaks. We work hard to resolve that issue.

```elm
emptyModel : Model
emptyModel =
    { count = 0
    , notification = Nothing
    }
```

#### Update
We will need to change the `update` function. Specifically, when a decrement fails we need to notify the user.

```elm
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
```

This will change the model to notify the user. Note that we haven't shown the notification yet.

#### View
We should show the notification when there is one.

```elm
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
```

This will notify the user when something odd is going on.

## Summary
A basic Elm Architecture uses

1. a model
2. an update function
3. a view function

The compiler aids a developer when changes need to be made. She is signaled where changes break existing code. With effort a developer can minimize the places this happens.

## Enhancements
How can this demonstrations be improved?

[elm-architecture]: https://guide.elm-lang.org/architecture/
[elm]: http://elm-lang.org/
[guide]: https://guide.elm-lang.org/
[demo]: https://github.com/HAN-ASD-DT/elm-demonstration
[sandbox]: https://package.elm-lang.org/packages/elm/browser/latest/Browser#sandbox
