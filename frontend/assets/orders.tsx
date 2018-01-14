import * as React from "react";
import * as ReactDOM from "react-dom";

interface OrdersState {
  data: string[];
}

export class Orders extends React.Component<{}, OrdersState>  {
  constructor(props: {}) {
    super(props);
    this.state = {
      data: ["initial"],
    };
  }

  public componentDidMount() {
    fetch(
      "https://lunchcoin.lolware.net/api/orders",
    ).then((response) => {
      if (!response.ok) {
        throw new Error("Network response returned "
            + response.status);
      }
      return response.text() as any;
    }).then((data) => {
      // The server return doesn't understand an array. It sends a list of items
      // If the return is empty, calling split will create an empty string incorrectly
      if (data.length === 0) {
        return this.setState({...this.state, data: []});
      }
      this.setState({...this.state, data: data.split("\n")});
    }).catch((err) => {
      console.error(err.message);
    });
  }

  public render() {
    if (this.state.data.length === 1 && this.state.data[0] === "initial") {
      return "Polling blockchain";
    }

    // Turn JSON strings into objects
    let ordernodes = this.state.data.map(
      (node: string, index: number) => {
        try {
          const nodeparsed = JSON.parse(node);
          if (!nodeparsed.name) {
            // Sanity check on returned JSON
            throw new Error("Failed JSON parse");
          }
          return (
            <div key={index}> {nodeparsed.name}</div>
            );
        } catch (e) {
          console.error("Failed to parse " + node);
          return null;
        }
      });
    // Filter out any parse failures
    ordernodes = ordernodes.filter( (x) => { return x; });
    if (ordernodes.length === 0) {
      return "No orders yet";
    }

    return ordernodes;
  }
}
