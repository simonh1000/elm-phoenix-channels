module Channels.Channels exposing (..)

import WebSocket as WS
import Task
import Platform.Cmd exposing (Cmd)
import Json.Decode exposing (..)

import Channels.Model as CM exposing (..)

type alias Model = CM.Model
init socketUrl =
    Model socketUrl "1" Closed

type Msg
    = Join
    | Send String
    | Raw String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Join ->
            let joinMsg = SendMsg "rooms:lobby" "phx_join" "rooms:lobby" "rooms:lobby"
            in
            ( model
            , WS.send model.socketUrl (encoder joinMsg)
            )
        Send m ->
            let myMsg = SendMsg "rooms:lobby" "new_msg" m "1"
            in
            ( model
            , sendChannel model myMsg
            )
        Raw s ->
            case processRaw (Debug.log "Raw" s) of
                Result.Ok conf ->
                    if conf.event == "phx_reply" && conf.payload == "ok"
                    then
                        ( { model | state = Open }, Cmd.none )
                    else (model, Cmd.none)
                Result.Err err ->
                    ( model, Cmd.none)

joinChannel : Model -> SendMsg -> Cmd msg
joinChannel {socketUrl} joinMsg =
    WS.send socketUrl (Debug.log "joinChannel" <| encoder joinMsg)
    -- |> Cmd.map JoinConfirmation

sendChannel : Model -> SendMsg -> Cmd msg
sendChannel {socketUrl} msg =
    WS.send socketUrl (Debug.log "sendChannel" <| encoder msg)
    -- |> Cmd.map JoinConfirmation

isOpen model =
    model.state == Open

getNewMessage : String -> Maybe String
getNewMessage s =
    s
    |> decodeString newMsgDecoder
    |> Result.map .payload
    |> Result.toMaybe
