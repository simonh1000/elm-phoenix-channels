port module Ports exposing (..)

import Json.Encode as E
import Helpers exposing (SendMsg)

-- port channelSend : SendMsg -> Cmd msg
port channelSend : String -> Cmd msg

port channelRec : (String -> msg) -> Sub msg
