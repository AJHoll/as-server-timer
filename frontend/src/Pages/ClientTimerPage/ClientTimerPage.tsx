import React from "react";
import { ReactNode } from "react";
import "./ClientTimerPage.css";
import ClientTimerPageService from "./ClientTimerPageService";

export interface ClientTimerPageState {
  intervalId: number | undefined;
  timerAmount: number;
}

export default class ClientTimerPage extends React.Component<any> {
  clientTimerPageService: ClientTimerPageService = new ClientTimerPageService(
    this
  );
  webSocket = this.props.webSocket;

  state: ClientTimerPageState = {
    intervalId: undefined,
    timerAmount: 0,
  };

  timerHandler = () => {
    if (this.state.timerAmount > 0) {
      this.setState({
        timerAmount: --this.state.timerAmount,
      });
    }
  };

  get timerString() {
    var date = new Date(0);
    date.setSeconds(this.state.timerAmount);
    return date.toISOString().substring(11, 19);
  }

  async syncTimerWithServer() {
    const timerAmount = await this.clientTimerPageService.getActiveTimer();
    this.setState({ timerAmount });
  }

  async componentDidMount() {
    await this.syncTimerWithServer();
    this.clientTimerPageService.subscribeOnServer();
    this.setState({
      intervalId: setInterval(this.timerHandler, 1000),
    });
  }

  componentWillUnmount() {
    if (!!this.state.intervalId) clearInterval(this.state.intervalId);
  }

  render(): ReactNode {
    return (
      <div className="app-layout-center">
        <div className="app-client-timer-page-container">
          <div className="app-client-timer-page-container__timer">
            <h1 style={this.state.timerAmount <= 0 ? { color: "#990000" } : {}}>
              {this.timerString}
            </h1>
          </div>
        </div>
      </div>
    );
  }
}
