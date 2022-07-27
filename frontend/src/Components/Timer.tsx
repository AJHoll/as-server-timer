import React from "react";
import timerService, { TimerDto } from "./TimerService";

export type TimerProps = {
  timerId: number;
};

export interface TimerState {
  intervalId: number | undefined;
  timer: TimerDto | undefined;
}

export default class Timer extends React.Component<TimerProps> {
  state: TimerState = {
    intervalId: undefined,
    timer: undefined,
  };

  timerHandler = () => {
    if (!!this.state.timer && this.state.timer.timer_amount > 0) {
      this.setState({
        timer: {
          ...this.state.timer,
          timer_amount: --this.state.timer.timer_amount,
        },
      });
    }
  };

  get timerString() {
    var date = new Date(0);
    date.setSeconds(this.state.timer?.timer_amount || 0);
    return date.toISOString().substring(11, 19);
  }

  async syncTimerWithServer() {
    const timer: TimerDto = await timerService.getTimer(this.props.timerId);
    console.log(this.props.timerId, timer);
    this.setState({ timer });
  }

  async componentDidMount() {
    await this.syncTimerWithServer();
    timerService.subscribeOnServer(this.props.timerId);
    this.setState({
      intervalId: setInterval(this.timerHandler, 1000),
    });
  }

  componentWillUnmount() {
    if (!!this.state.intervalId) clearInterval(this.state.intervalId);
  }

  async componentDidUpdate(props: any) {
    if (!this.state.timer) {
      await this.syncTimerWithServer();
    }
  }

  render(): React.ReactNode {
    return (
      <>
        <h2>{this.state.timer?.caption}</h2>
        <h1>{this.timerString}</h1>
      </>
    );
  }
}
