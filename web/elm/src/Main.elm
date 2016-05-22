module Main exposing (..)

import Html.App as Html
import WebSocket

import Ports exposing (..)

import WithWebSocket as WWS
import WithPorts as PS

import App exposing (..)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    -- Sub.none
    -- WebSocket.listen WWS.socketUrl (App.WSMsg << WWS.SocketMessage)
  Sub.batch
    [ WebSocket.listen WWS.socketUrl (App.WSMsg << WWS.SocketMessage)
    , channelRec (App.PSMsg << PS.NewMessage)
    ]
