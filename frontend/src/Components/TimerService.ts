import socketService from "../Services/SocketService";

export type TimerDto = {
  id: number;
  caption: string;
  state: string;
  sec_count: number;
  timer_start: number;
  timer_end: number;
  timer_amount: number;
};

export class TimerService {
  async getTimer(timerId: number): Promise<TimerDto> {
    const timer: TimerDto = await socketService.send(`timer/get-timer`, {
      timerId,
    });
    return timer;
  }

  subscribeOnServer(timerId: number) {
    socketService.on(`timer/${timerId}/changes`, (status, payload) => {
      console.log(`timer/${timerId}/changes`, status, payload);
    });
  }
}

const timerService = new TimerService();
export default timerService;
