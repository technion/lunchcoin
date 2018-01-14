import * as React from "react";
import * as ReactDOM from "react-dom";

import { LunchForm } from "./lunchform.tsx";
import { Mining } from "./mining.tsx";
import { Orders } from "./orders.tsx";

interface MainComponentState {
  show: "form" | "mining" | "orders";
  data: string;
}

class MainContent extends React.Component<{}, MainComponentState> {
  constructor(props: {}) {
    super(props);
    this.submitOrder = this.submitOrder.bind(this);
    this.showOrders = this.showOrders.bind(this);
    this.state = {
      show: "form",
      data: "undefined",
    };
  }

  public submitOrder(data: string) {
    this.setState({...this.state, show: "mining", data});
  }

  public showOrders(e: any) {
    e.preventDefault();
    this.setState({...this.state, show: "orders"});
  }

  public render() {
    let renderdata;
    switch (this.state.show) {
      case "form":
      renderdata = <LunchForm onOrderSubmit={this.submitOrder} />;
      break;
      case "mining":
      renderdata = <Mining data={this.state.data} />;
      break;
      case "orders":
      renderdata = <Orders />;
      break;
      default:
      console.error("Major failure");
    }

    return (
      <div> { renderdata }
        <div className="ui message">
          <a href="#" onClick={this.showOrders}>Looking for today's orders? Click Here</a>
        </div>
      </div>
    );
  }
}

export class App extends React.Component<{}, {}> {
  public render() {
    return (
      <div className="column">
      <h2 className="ui teal image header">
        <img src="assets/images/logo.png" className="image" />
        <div className="content">
           Blockchain Lunch and Coffee Ordering
        </div>
      </h2>
      <MainContent />
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
