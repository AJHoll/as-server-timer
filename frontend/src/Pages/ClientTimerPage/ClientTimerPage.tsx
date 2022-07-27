import React from "react";
import { ReactNode } from "react";
import Timer from "../../Components/Timer";
import "./ClientTimerPage.css";
import ClientTimerPageService from "./ClientTimerPageService";

export interface ClientTimerPageState {
  timerId: number;
}

export default class ClientTimerPage extends React.Component<any> {
  clientTimerPageService: ClientTimerPageService = new ClientTimerPageService(
    this
  );

  state: ClientTimerPageState = {
    timerId: 0,
  };

  async componentDidMount() {
    const timerId = await this.clientTimerPageService.getActiveTimer();
    this.setState({ timerId: timerId });
  }

  render(): ReactNode {
    return (
      <div className="app-layout-center">
        <div className="app-client-timer-page-container">
          <div className="app-client-timer-page-container__timer">
            <Timer timerId={this.state.timerId} />
          </div>
        </div>
      </div>
    );
  }
}
