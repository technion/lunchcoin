import * as React from "react";
import * as ReactDOM from "react-dom";

import { LunchForm } from "./lunchform.tsx";

interface MiningProps {
  data: string;
}

interface MiningState {
  show: "mining" | "mined" | "error";
}

class Mining extends React.Component<MiningProps, MiningState> {
  constructor(props: MiningProps) {
    super(props);
    this.state = {
      show: "mining",
    }
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
    switch(this.state.show) {
      case "mining":
      return (
        "mining"
      )
      case "mined":
      return (
        "mined"
      )
      default: // Default is always an error case
      return (
        "Error mining coin"
      )
    }
  }
}

class Mined extends React.Component<{}, {}> {
  public render() {
    return (
      "mined"
    )
  }
}

interface MainComponentState {
  show: "form" | "mining";
  data: string;
}

class MainContent extends React.Component<{}, MainComponentState> {
  constructor(props: {}) {
    super(props);
    this.submitOrder = this.submitOrder.bind(this);
    this.state = {
      show: "form",
      data: "undefined"
    };
  }

  public submitOrder(data: string) {
    this.setState({...this.state, show: "mining", data: data});
  }

  public render() {
    let renderdata;
    switch(this.state.show) {
      case "form":
      renderdata = <LunchForm onOrderSubmit={this.submitOrder} />;
      break;
      case "mining":
      renderdata = <Mining data={this.state.data} />
      break;
      default:
      console.error("Major failure");
    }

    return (
      <div> { renderdata } </div>
    )
  }
}

export class App extends React.Component<{}, {}> {
  public render() {
    return (
      <div className="column">
    <h2 className="ui teal image header">
      <img src="assets/images/logo.png" className="image" />
      <div className="content">
        Enter your order details
      </div>
    </h2>
    <MainContent />
    <div className="ui message">
      <a href="/api/orders">Looking for today's orders? Click Here</a>
    </div>
    <div className="ui message">
      <a href="/api/blockchain">Dump the whole blockchain</a>
    </div>
  </div>
      );
  }
}

ReactDOM.render(
  <App />,
  document.getElementById("content"),
);
