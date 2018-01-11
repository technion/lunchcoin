import * as React from "react";
import * as ReactDOM from "react-dom";

interface LunchFormProps {
  onOrderSubmit: (data: string) => void;
}


class LunchForm extends React.Component<LunchFormProps, {}> {
  constructor(props: LunchFormProps) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(e: any) {
    e.preventDefault();
    this.props.onOrderSubmit("new order");
  }

  public render() {
    return (
    <form className="ui large form" method="post" action="/api/new" onSubmit={this.handleSubmit}>
      <div className="ui stacked segment">
        <div className="field">
          <div className="ui left icon input">
            <i className="user icon"></i>
            <input type="text" name="name" placeholder="Your Name" />
          </div>
        </div>
        <div className="field">
          <div className="ui left icon input">
            <i className="lock icon"></i>
            <input type="text" name="order" placeholder="Password" />
          </div>
        </div>
        <input type="submit" className="ui fluid large teal submit button" value="Order" />
      </div>
    </form>
    );
  }

}

interface MainComponentState {
  showData: "form" | "mining";
}

class MainContent extends React.Component<{}, MainComponentState> {
  constructor(props: {}) {
    super(props);
    this.submitOrder = this.submitOrder.bind(this);
    this.state = {
      showData: "form"
    };
  }

  submitOrder(data: string) {
    this.setState({...this.state, showData: "mining" });
  }

  public render() {
    let renderdata;
    switch(this.state.showData) {
      case "form":
      renderdata = <LunchForm onOrderSubmit={this.submitOrder} />;
      break;
      case "mining":
      renderdata = <Mining>
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
