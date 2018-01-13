import * as React from "react";
import * as ReactDOM from "react-dom";

import { LunchForm } from "./lunchform.tsx";

interface MiningProps {
  data: string;
}

interface MiningState {
  show: "mining" | "mined" | "error";
}

export class Mining extends React.Component<MiningProps, MiningState> {
  constructor(props: MiningProps) {
    super(props);
    this.state = {
      show: "mining",
    };
  }

  public componentDidMount() {
    fetch(
      "https://lunchcoin.lolware.net/api/new", {
      body: JSON.stringify(this.props.data),
      method: "POST",
    }).then((response) => {
      if (!response.ok) {
        throw new Error("Network response returned "
        + response.status);
      }
      console.log("Logged coin");
      this.setState({...this.state, show: "mined" });
    }).catch((err) => {
      this.setState({...this.state, show: "error" });
      console.error(err.message);
    });
  }

  public render() {
    switch (this.state.show) {
      case "mining":
      return (
        <div className="ui icon message teal">
        <i className="notched circle loading icon"></i>
          <div className="content">
            <div className="header">
              Mining a coin
            </div>
           <p>Your order is being processed as a transaction on the blockchain</p>
          </div>
        </div>
      );
      case "mined":
      return (
        <Mined />
      );
      default: // Default is always an error case
      return (
        <div className="ui message red">Error communicating with blockchain</div>
      );
    }
  }
}

class Mined extends React.Component<{}, {}> {
  public render() {
    return (
      "mined successfully"
    );
  }
}
