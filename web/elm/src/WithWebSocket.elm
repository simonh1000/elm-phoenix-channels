module WithWebSocket exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Task exposing (Task)
import Platform.Cmd exposing (Cmd)

import Json.Decode as Json

import Channels.Channels as C

import Debug

socketUrl = "ws://localhost:4000/socket/websocket"

-- MODEL

type alias Model =
  { input : String
  , messages : List String
  , channel : C.Model
  }


init : (Model, Cmd Msg)
init =
  (Model "" [] (C.init socketUrl), Cmd.none)

-- UPDATE

type Msg
  = Input String
  | Join
  | Send
  | SocketMessage String
  | ChannelsMsg C.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update msg ({input, messages} as model) =
  case msg of
    Input newInput ->
      ( { model | input = newInput }
      , Cmd.none
      )
    Join ->
        update (ChannelsMsg C.Join) model
    Send ->
        { model | input = "" }
        |> update (ChannelsMsg <| C.Send model.input)
    SocketMessage msg' ->
        case C.getNewMessage msg' of
            Just m ->
                ( { model | messages = m :: messages }
                , Cmd.none
                )
            Nothing ->
                update (ChannelsMsg <| C.Raw msg') model
    ChannelsMsg msg ->
        let (m, e) = C.update (Debug.log "ChannelsMsg" msg) model.channel
        in
        ( { model | channel = m }
        , Cmd.map ChannelsMsg e
        )

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text "WebSocket" ]
    , if C.isOpen model.channel
        then text "open!!"
        else button [onClick Join] [text "Join"]
    , div [] (List.map viewMessage model.messages)
    , input [onInput Input, value model.input] []
    , button [onClick Send] [text "Send"]
    ]


viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]
