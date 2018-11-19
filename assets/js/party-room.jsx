import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function game_init(root, channel) {
  ReactDOM.render(<Party channel={channel} />, root);
}


class Party extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
    this.state = {
    }

    this.channel.join()
      .receive("ok", console.log("succesfully joined"))
      .receive("error", resp => { console.log("Unable to join", resp)});
  }
  render() {
    console.log("here1");
    window.onSpotifyWebPlaybackSDKReady = () => {
      // You can now initialize Spotify.Player and use the SDK
      console.log("here2");
      const token = window.token;
      const player = new Spotify.Player({
        name: 'LAS Spotify Player',
        getOAuthToken: cb => { cb(token); }
      });
    
      // Error handling
      player.addListener('initialization_error', ({ message }) => { console.error(message); });
      player.addListener('authentication_error', ({ message }) => { console.error(message); });
      player.addListener('account_error', ({ message }) => { console.error(message); });
      player.addListener('playback_error', ({ message }) => { console.error(message); });
    
      // Playback status updates
      player.addListener('player_state_changed', state => { console.log(state); });
    
      // Ready
      player.addListener('ready', ({ device_id }) => {
        console.log('Ready with Device ID', device_id);
      });
    
      // Not Ready
      player.addListener('not_ready', ({ device_id }) => {
        console.log('Device ID has gone offline', device_id);
      });
    
      // Connect to the player!
      player.connect();
      // var player = new Spotify.Player({
      //   name: 'Spotify Player',
      //   getOAuthToken: callback => {
      //     // Run code to get a fresh access token
      //     callback(window.userToken);
      //   },
      //   volume: 0.5
      //   });
      // // player.addListener('ready', ({ device_id }) => {
      // //   console.log('Connected with Device ID', device_id);
      // // });
      // player.connect().then(success => {
      //   if (success) {
      //     console.log('The Web Playback SDK successfully connected to Spotify!');
      //   }
      // });
    };
    return (
      <div>
        <p>
          User Entered the Party Room!!!
        </p>
      </div>
    )};
  }
