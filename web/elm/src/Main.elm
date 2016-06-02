module Main exposing (..)

import Html.App as Html

import Phoenix.Socket

import Chat
import App exposing (..)

main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = Chat.subscriptions
    }

