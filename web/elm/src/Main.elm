module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Task exposing (Task)
import Platform.Cmd exposing (Cmd)

-- import WebSocket
import WebSocket.LowLevel as Low
import Debug

import Ports exposing (..)
import PChannel

channelUrl = "ws://localhost:4000/socket/websocket"
-- channelUrl = "/socket"
-- never : Never -> a
-- never n =
--     never n
--
-- taskNever : Never ()
-- taskNever =
--     Task.succeed ()

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { input : String
  , messages : List String
  }


init : (Model, Cmd Msg)
init =
  -- (Model "" [], conn)
  (Model "" [], Cmd.none)

-- conn : Cmd Msg
-- conn =
--     Low.open channelUrl
--         { onMessage = \_ _ -> Task.succeed () `Task.mapError` never
--         , onClose = \_ -> Task.succeed () `Task.mapError` never
--         }
--     |> Task.perform never NoOp
-- UPDATE

type Msg
  = Input String
  | Send
  | NewMessage String
  -- | NoOp ()


update : Msg -> Model -> (Model, Cmd Msg)
update msg {input, messages} =
  case msg of
    Input newInput ->
      (Model newInput messages, Cmd.none)

    Send ->
    --   (Model "" messages, PChannel.send channelUrl ("rooms:" ++ input) )
      (Model "" messages, channelSend <| ChannelMsg "lobby" input)

    NewMessage str ->
      (Model input ((Debug.log "***NewMessage" str) :: messages), Cmd.none)


-- SUBSCRIPTIONS

-- subscriptions : Model -> Sub Msg
-- subscriptions model =
--   PChannel.listen channelUrl NewMessage
  -- Sub.none

subscriptions : Model -> Sub Msg
subscriptions model =
    channelRec NewMessage

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ div [] (List.map viewMessage model.messages)
    , input [onInput Input, value model.input] []
    , button [onClick Send] [text "Send"]
    ]


viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]
