module App exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Task exposing (Task)
import Platform.Cmd exposing (Cmd)

import Debug

import Chat


type alias Model =
  Chat.Model

init : List String -> (Model, Cmd Chat.Msg)
init flags =
  Chat.init flags


type Msg
    = ChatMsg Chat.Msg

update : Chat.Msg -> Model -> (Model, Cmd Chat.Msg)
update msg model =
  Chat.update msg model


view : Model -> Html Chat.Msg
view model =
    Chat.view model

