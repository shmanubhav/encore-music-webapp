import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function game_init(root, channel) {
  ReactDOM.render(<Party channel={channel} />, root);
  // If there is no token, redirect to Spotify authorization to authorize the APP with SDK
  if (!_token) {
   window.location = `${authEndpoint}?client_id=${clientId}&redirect_uri=${redirectUri}&scope=${scopes.join('%20')}&response_type=token&show_dialog=true`;
  }
}

// Get the hash of the url
const hash = window.location.hash
.substring(1)
.split('&')
.reduce(function (initial, item) {
  if (item) {
    var parts = item.split('=');
    initial[parts[0]] = decodeURIComponent(parts[1]);
  }
  return initial;
}, {});
window.location.hash = '';

// Set token
let _token = hash.access_token;

const authEndpoint = 'https://accounts.spotify.com/authorize';

// Replace with your app's client ID, redirect URI and desired scopes
const clientId = '597e9f9fad654c41b818b7ab1bc7f0b4';
const redirectUri = 'http://localhost:4000/auth/spotify/callback/';
const scopes = [
  'streaming',
  'user-read-birthdate',
  'user-read-private',
  'user-modify-playback-state'
];

class Party extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
    this.state = {
      authorized: false,
      users: [],
      song_queue: [],
      currently_playing: [],
      playing: true, // is the current song playing
      party_name: ""
    }

    this.channel.join()
      .receive("ok", this.gotView.bind(this))
      .receive("error", resp => { console.log("Unable to join", resp) });

    this.channel.on("change_view", (state) => {
       if (state !== undefined) {
           console.log(state)
           this.setState(state);
       }
    });
  }

  gotView(view) {
    console.log(view.view)
    this.setState(view.view);
  }

play(device_id) {
  var uris = this.state.song_queue.map(function(song) {
    return song.uri
  });
  const uri_object = {"uris": uris}
  console.log("here");
  $.ajax({
   url: "https://api.spotify.com/v1/me/player/play?device_id=" + device_id,
   type: "PUT",
   data: JSON.stringify(uri_object),
   beforeSend: function(xhr){xhr.setRequestHeader('Authorization', 'Bearer ' + _token );},
   success: function(data) {
     console.log(data)
   }
  });
}

onPauseClick() {
  this.channel.push("toggle", {})
    .receive("ok", this.gotView.bind(this));
  this.player.togglePlay();
}

onBackClick() {
  if (!this.state.playing) {
    this.channel.push("toggle", {})
      .receive("ok", this.gotView.bind(this));
  }
  this.player.previousTrack();
}

onNextClick() {
  if (!this.state.playing) {
    this.channel.push("toggle", {})
      .receive("ok", this.gotView.bind(this));
  }
  this.player.nextTrack();
}

  render() {
    window.onSpotifyPlayerAPIReady = () => {
      console.log("intialize");
      this.player = new Spotify.Player({
        name: 'LAS Spotify Player',
        getOAuthToken: cb => { cb(_token); }
      });

      // Error handling
      this.player.on('initialization_error', e => console.error(e));
      this.player.on('authentication_error', e => console.error(e));
      this.player.on('account_error', e => console.error(e));
      this.player.on('playback_error', e => console.error(e));

      // Playback status updates
      this.player.on('player_state_changed', state => {
        console.log(state)
        this.channel.push("current_song", { track: state.track_window.current_track.name,
        image: state.track_window.current_track.album.images[0].url})
          .receive("ok", this.gotView.bind(this));
        $('#current-track').attr('src',     state.track_window.current_track.album.images[0].url);
        $('#current-track-name').text(state.track_window.current_track.name);
      });
      this.player.connect();
      this.player.addListener('ready', ({ device_id }) => {
        console.log('The Web Playback SDK is ready to play music!');
        console.log('Device ID', device_id);
      });
      // Connect to the player!
      console.log(this.player);
      // Ready
      this.player.on('ready', data => {
        console.log('Ready with Device ID', data.device_id);
        // Play a track using our new device ID
        this.play(data.device_id);
      });
    }  
    console.log("length",this.state.users.length);
    console.log("user_id and list", window.user_id, this.state.users);
    if ((this.state.users.length < 2) && ((this.state.users)[0] == window.user_id.toString())) {
      let count=0;
      if (this.state.authorized) {
        return (
          <div className="row">
            <div className="col-1"></div>
            <div className="col-4">
              <h4 className="mt-3">Song Queue</h4>
              <div className="queue">
                <div>
                  {this.state.song_queue.map((s) => <div className="card song-background" key={s.title+(count++).toString()}><strong className="party-song">{s.title}</strong></div>)}
                </div>
              </div>
            </div>
            <div className="col-1"></div>
            <div className="col-6">
              <p className="mt-3" id="current-song">
                <strong>Currently Playing: </strong>{this.state.currently_playing[0]}
              </p>
              <img className="card login-page" src={this.state.currently_playing[1]}/>
              <div className="mt-3" id="all-controls">
                <div id="controls">
                  <button className="mx-2" onClick={() => this.onBackClick()}><i className="fa fa-backward"/></button>
                  <button className="mx-2" onClick={() => this.onPauseClick()}>{this.state.playing ? <i className="fa fa-pause"/> : <i className="fa fa-play"/>}</button>
                  <button className="mx-2" onClick={() => this.onNextClick()}><i className="fa fa-forward"/></button>
                </div>
              </div>
            </div>
          </div>
        )
      }
      else {
        return (
          <div></div>
        )
      };
    } 
    else {
      let count=0;
      if (this.state.authorized) {
        return (
          <div className="row">
            <div className="col-1"></div>
            <div className="col-4">
              <h4 className="mt-3">Song Queue</h4>
              <div className="queue">
                <div>
                  {this.state.song_queue.map((s) => <div className="card song-background" key={s.title+(count++).toString()}><strong className="party-song">{s.title}</strong></div>)}
                </div>
              </div>
            </div>
            <div className="col-1"></div>
            <div className="col-6">
              <p className="mt-3" id="current-song">
                <strong>Currently Playing: </strong>{this.state.currently_playing[0]}
              </p>
              <img className="card login-page" src={this.state.currently_playing[1]}/>
            </div>
          </div>
        )
      }
      else {
        return (
          <div></div>
        )
      };
    }
  }
}
