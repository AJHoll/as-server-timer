import { SubscribeMessage, WebSocketGateway } from '@nestjs/websockets';

@WebSocketGateway(8081, { cors: true })
export class TimerGateway {
  @SubscribeMessage('timer/get-client-active-timer')
  handleMessage(client: any, payload: { userId: number }): number {
    console.log(+payload.userId);
    return 150;
  }
}
