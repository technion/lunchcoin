import * as React from "react";
import * as ReactDOM from "react-dom";

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
    <form className="ui large form" method="post" action="/api/new">
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
