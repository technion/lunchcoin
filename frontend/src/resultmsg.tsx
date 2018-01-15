import * as React from "react";
import * as ReactDOM from "react-dom";

interface MsgProps {
  data: string;
}

export class ResultMsg extends React.Component<MsgProps, {}> {
  public render() {
    return (
      <div className="ui olive segment">{this.props.data}</div>
    );
  }
}
