import socketService from "../../Services/SocketService";
import ClientTimerPage from "./ClientTimerPage";

export default class ClientTimerPageService {
  constructor(private clientTimerPage: ClientTimerPage) {}

  async getActiveTimer(): Promise<number> {
    const timerId = await socketService.send(
      "timer/get-client-active-timer-id",
      {
        userId: window.localStorage.getItem("userId"),
      }
    );
    console.log(timerId);
    return timerId;
  }
}
