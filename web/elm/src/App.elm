module App exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Task exposing (Task)
import Platform.Cmd exposing (Cmd)

import Debug

import WithWebSocket as WS
-- import WithPorts as PS


type ViewType
    = ElmBased
    | PortsBased

type alias Model =
    { viewType : ViewType
    , websocket : WS.Model
    -- , ports : PS.Model
    }

init =
    ( Model ElmBased (fst WS.init) -- (fst PS.init)
    , Cmd.none
    )

type Msg
    = Switch
    | WSMsg WS.Msg
    -- | PSMsg PS.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Switch ->
            ( { model | viewType = if model.viewType == ElmBased then PortsBased else ElmBased }
            , Cmd.none
            )
        WSMsg act ->
            let (m, e) = WS.update act model.websocket
            in
            ( { model | websocket = m }
            , Cmd.map WSMsg e
            )
        -- PSMsg act ->
        --     let (m, e) = PS.update act model.ports
        --     in
        --     ( { model | ports = m }
        --     , Cmd.map PSMsg e
        --     )

view model =
    div []
    [ button
        [ onClick Switch ]
        [ text "Switch"]
    , case model.viewType of
        ElmBased -> WS.view model.websocket |> Html.map WSMsg
        PortsBased ->
            text ""
            -- PS.view model.ports |> Html.map PSMsg
    ]
