port module Ports exposing (..)

port channelSend : String -> Cmd msg

port channelRec : (String -> msg) -> Sub msg
