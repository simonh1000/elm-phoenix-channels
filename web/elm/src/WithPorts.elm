module WithPorts exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Task exposing (Task)
import Platform.Cmd exposing (Cmd)

import Json.Decode as Json

import Ports exposing (..)

-- MODEL

type alias Model =
  { input : String
  , messages : List String
  }


init : (Model, Cmd Msg)
init =
  (Model "" [], Cmd.none)

-- UPDATE

type Msg
  = Input String
  | Send
  | NewMessage String


update : Msg -> Model -> (Model, Cmd Msg)
update msg {input, messages} =
  case msg of
    Input newInput ->
      (Model newInput messages, Cmd.none)

    Send ->
        (Model "" messages, channelSend input)

    NewMessage incomingMsg ->
        (Model input (incomingMsg :: messages), Cmd.none)

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text "Ports" ]
    , div [] (List.map viewMessage model.messages)
    , input [onInput Input, value model.input] []
    , button [onClick Send] [text "Send"]
    ]


viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]
