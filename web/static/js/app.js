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
import "deps/phoenix_html/web/static/js/phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import "./conversation"
import "./post"


import { Socket } from "deps/phoenix/web/static/js/phoenix"

class App {
  static init() {
    var message = $("#message_content")


    let token = $("meta[name=channel_token]").attr("content")
    let conversationToken = $("meta[name=conversation_token]").attr("content")

    console.log(token)

    let socket = new Socket("/socket", {params: {
      token: token,
      conversation: conversationToken
    }})

    socket.connect()
    socket.onClose( e => console.log("Closed connection") )

    var channel = socket.channel("conversations:general", {})
    channel.join()
      .receive( "error", () => console.log("Connection error") )
      .receive( "ok", () => console.log("Connected") )

     message.off("keypress")
      .on("keypress", e => {
        if (e.keyCode == 13) {
          e.preventDefault()
          console.log(`${message.val()}`)

          channel.push("new:message", {
            content: message.val()
          })

          message.val("")
        }
      })
    console.log("init")

    channel.on( "new:message", msg => this.renderMessage(msg) )
  }

  static renderMessage(msg) {
    $(".messages")
      .prepend(`<li><span>${msg.user}: </span>${msg.content}</li>`)
  }
}


$( () => App.init() )

export default App
