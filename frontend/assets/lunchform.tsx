import * as React from "react";
import * as ReactDOM from "react-dom";

interface LunchFormProps {
  onOrderSubmit: (data: string) => void;
}


export class LunchForm extends React.Component<LunchFormProps, {}> {
  constructor(props: LunchFormProps) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(e: any) {
    e.preventDefault();
    this.props.onOrderSubmit(JSON.stringify({name: e.target.name.value.trim(), order: "order"}));
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

