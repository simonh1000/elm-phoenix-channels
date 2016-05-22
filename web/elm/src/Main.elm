module Main exposing (..)

import Html.App as Html
import PChannel

import Ports exposing (..)
import Helpers exposing (channelUrl)

import App exposing (init, update, view, Msg, Model)
import WithWebSocket as WS
import WithPorts as PS

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
    [ PChannel.listen channelUrl (App.WSMsg << WS.NewMessage)
    , channelRec (App.PSMsg << PS.NewMessage)
    ]
