module App exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Task exposing (Task)
import Platform.Cmd exposing (Cmd)

import Debug

import WithWebSocket as WS
import WithPorts as PS


type ViewType
    = ElmBased
    | PortsBased

type alias Model =
    { viewType : ViewType
    , websocket : WS.Model
    , portsModel : PS.Model
    }

init : (Model, Cmd Msg)
init =
    ( Model ElmBased (fst WS.init) (fst PS.init)
    , Cmd.none
    )

type Msg
    = Switch
    | WSMsg WS.Msg
    | PSMsg PS.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Switch ->
            ( { model | viewType = if model.viewType == ElmBased then PortsBased else ElmBased }
            , Cmd.none
            )
        WSMsg msg' ->
            let (m, e) = WS.update msg' model.websocket
            in
            ( { model | websocket = m }
            , Cmd.map WSMsg e
            )
        PSMsg msg' ->
            let (m, e) = PS.update msg' model.portsModel
            in
            ( { model | portsModel = m }
            , Cmd.map PSMsg e
            )

view : Model -> Html Msg
view model =
    div []
    [ button
        [ onClick Switch ]
        [ text "Switch"]
    , case model.viewType of
        ElmBased ->
            WS.view model.websocket |> Html.map WSMsg
        PortsBased ->
            PS.view model.portsModel |> Html.map PSMsg
    ]
