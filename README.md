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


[elm-architecture]: https://guide.elm-lang.org/architecture/
[elm]: http://elm-lang.org/
[guide]: https://guide.elm-lang.org/
[demo]: https://github.com/HAN-ASD-DT/elm-demonstration
