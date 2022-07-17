import SocketService from "../../Services/SocketService";

export default class AuthPageService {
  socketService = new SocketService();

  async signIn(
    username: string,
    password: string
  ): Promise<{ status: string; message: string }> {
    const data = await this.socketService.send("auth-sign-in", {
      username,
      password,
    });
    console.log("dd", data);
    return { status: "error", message: "all ok" };
  }
}
