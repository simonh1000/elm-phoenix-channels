module Channels.Model exposing (..)

import Json.Encode as E
import Json.Decode exposing (..)

import String

type SOCKET_STATES
    = Connecting
    | Open
    | Closing
    | Closed

-- type CHANNEL_STATES
--     = Closed
--     | Errored
--     | Joined
--     | Joining
--
-- state2String : CHANNEL_STATES -> String
-- state2String =
--     String.toLower << toString
--
-- type CHANNEL_EVENTS
--     = Close
--     | Error
--     | Join
--     | Reply
--     | Leave
--
-- toString : CHANNEL_EVENTS -> String
-- toString s =
--     "phx_" ++ (String.toLower <| toString s)


type alias Model =
    { socketUrl : String
    , ref : String
    , state : SOCKET_STATES
    }

type alias SendMsg =
    { topic : String
    , event: String
    , payload : String
    , ref : String
    }

type alias ChannelMsg =
    { topic : String
    , event: String
    , payload : String
    , ref : String
    }

type alias Payload =
    { status: String
    , response : String
    }

processRaw =
    decodeString decoder

decoder =
    oneOf [ joinConfDecoder, newMsgDecoder ]

joinConfDecoder : Decoder ChannelMsg
joinConfDecoder =
    object4 ChannelMsg
        ("topic" := string)
        ("event" := string)
        ("payload" := payloadDecoder)
        ("ref" := string)

newMsgDecoder =
    object4 ChannelMsg
        ("topic" := string)
        ("event" := string)
        ("payload" := payloadDecoder2)
        ("ref" := null "null ref")

-- Catches join confirmations
payloadDecoder : Decoder String
payloadDecoder =
    at ["status"] string
    -- object2 Payload
    --     ("status" := string)
    --     ("response" := oneOf [ string, succeed "empty" ])

payloadDecoder2 : Decoder String
payloadDecoder2 =
    at ["body"] string
        -- object2 Payload
        -- ("status" := string)
        -- ("response" := oneOf [ string, succeed "empty" ])
-- decodeMessage : String -> msg
-- decodeMessage s =
--     case decodeString s decoder of
--         Result.Ok


encoder : SendMsg -> String
encoder m =
    E.object
        [ ("topic", E.string m.topic)
        , ("event", E.string m.event)
        , ("payload", payloadEncoder m.payload)
        , ("ref", E.string m.ref)
        ]
    |> E.encode 0

payloadEncoder : String -> E.Value
payloadEncoder p = E.object [("body", E.string p)]
--     E.object
--         [ ("status", E.string p.status)
--         , ("response", E.string p.response)
--         ]

-- type alias Push =
--     { channel : Channel
--     , event : CHANNEL_EVENTS
--     , payload : String
--     , receivedResp : String
--     , timeout : Int
--     , timeoutTimer : Maybe Int
--     , recHooks : List Int
--     , sent : Bool
--     }
-- initPush channel event payload timeout =
--     Push channel event payload "" timeout Nothing [] False
--
-- type alias Socket =
--     { endPoint : String
--     , connection :  }
--
-- connect
