// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

// Connect to channel
let channel = socket.channel("rooms:lobby", {});
channel.join()
.receive("ok", resp => { console.log("Joined successfully", resp) })
.receive("error", resp => { console.log("Unable to join", resp) })

// Insert Elm component
var elmDiv = document.getElementById('elm-main')
  , elmApp = Elm.Main.embed(elmDiv);

elmApp.ports.channelSend.subscribe( payload => {
    console.log(payload);
    channel.push("new_msg", {body: payload.message})
});

channel.on("new_msg", payload => {
  elmApp.ports.channelRec.send(payload.body)
})
