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
    return (
      <div>
        <p>
          User Entered the Party Room!!!
        </p>
      </div>
    )};
  }
