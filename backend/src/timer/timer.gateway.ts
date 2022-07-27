import { SubscribeMessage, WebSocketGateway } from '@nestjs/websockets';
import { TimerDto } from './dto/timer.dto';
import { TimerService } from './timer.service';

@WebSocketGateway(8081, { cors: true })
export class TimerGateway {
  constructor(private timerService: TimerService) {}

  @SubscribeMessage('timer/get-client-active-timer-id')
  async getClientActiveTimerId(
    client: any,
    payload: { userId: number },
  ): Promise<number> {
    return await this.timerService.getClientFirstActiveTimerId(payload.userId);
  }

  @SubscribeMessage('timer/get-timer')
  async getTimer(client: any, payload: { timerId: number }): Promise<TimerDto> {
    return await this.timerService.getTimer(payload.timerId);
  }
}
