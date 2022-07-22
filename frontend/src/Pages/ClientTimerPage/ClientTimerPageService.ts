import socketService from "../../Services/SocketService";
import ClientTimerPage from "./ClientTimerPage";

export default class ClientTimerPageService {
  constructor(private clientTimerPage: ClientTimerPage) {}

  async getActiveTimer(): Promise<number> {
    const timerAmount = await socketService.send(
      "timer/get-client-active-timer",
      {
        userId: window.localStorage.getItem("userId"),
      }
    );
    return timerAmount || 0;
  }

  subscribeOnServer() {
    socketService.on("timer/client-timer-update", async (status, payload) => {
      const timerAmount = await this.getActiveTimer();
      this.clientTimerPage.setState({ timerAmount });
    });
  }
}
