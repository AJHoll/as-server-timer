import socketService from "../../Services/SocketService";

export default class AuthPageService {
  async signIn(
    username: string,
    password: string
  ): Promise<{ status: string; message: string }> {
    const data: { id: string; status: string; secret: string } =
      await socketService.send("auth-sign-in", {
        username,
        password,
      });
    if (data.status !== "error") {
      window.localStorage.setItem("userId", data.id);
      window.localStorage.setItem("userAccessKey", data.secret);
      return { status: "done", message: "all ok" };
    } else {
      return { status: "error", message: "all ok" };
    }
  }
}
