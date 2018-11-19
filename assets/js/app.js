import css from "../css/app.scss"

// Import dependencies
import "phoenix_html"
import jQuery from 'jquery';
window.jQuery = window.$ = jQuery;
import "bootstrap";
import socket from "./socket";
import game_init from "./party-room.jsx";

function start() {
  let root = document.getElementById('root');
  if (root) {
    socket.connect();
    // TODO come up with a param to pass into token to help authorize the connnection.
    let channel = socket.channel("Welcome! Party Room:" + window.gameName, {token: true});
    game_init(root, channel);
  }
}

$(start);
