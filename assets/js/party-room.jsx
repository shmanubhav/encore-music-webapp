import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function game_init(root, channel) {
  alert("got here")
  ReactDOM.render(<Party channel={channel} />, root);
}

class Party extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
    this.state = {
    }
  }
  render() {
    return (
      <div>
        <h3>
          Party Room.
        </h3>
      </div>
}
