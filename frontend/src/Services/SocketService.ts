import { io, Socket } from "socket.io-client";

export class SocketService {
  socket: Socket;

  constructor() {
    this.socket = io("127.0.0.1:8081");
    this.socket.on("connect", () => {
      console.log("connect", this.socket.id);
    });
  }

  async send(message: string, body: any): Promise<any> {
    return new Promise((res, rej) => {
      this.socket.emit(message, body, (payload: any) => {
        res(payload);
      });
    });
  }

  on(event: string, listener: (status: string, payload: any) => void) {
    this.socket.on(event, listener);
  }
}

const socketService = new SocketService();

export default socketService;
