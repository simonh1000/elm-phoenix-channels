module Main exposing (..)

import Html.App as Html
-- import PChannel
import WebSocket

import App exposing (..)
import WithWebSocket as WS
-- import Helpers exposing (channelUrl)
-- import Ports exposing (..)
-- import WithPorts as PS

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
  Sub.batch
    [ WebSocket.listen WS.channelUrl (App.WSMsg << WS.SocketMessage)
    -- , channelRec (App.PSMsg << PS.NewMessage)
    ]
