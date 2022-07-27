import { Injectable } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { ICallbackMessageStatus, Request } from 'src/interfaces';
import { TimerDto } from './dto/timer.dto';

@Injectable()
export class TimerService {
  constructor(private databaseService: DatabaseService) {}
  async getClientFirstActiveTimerId(userId: number): Promise<number> {
    const data = await this.databaseService.query([
      new Request({
        query: `select uat.id_timer 
                from user_access_timer uat
                where uat.id_user = $(userId) limit 1`,
        bindingParams: { userId },
      }),
    ]);
    if (data.status === ICallbackMessageStatus.Done) {
      console.log(data.data[0]?.id_timer);
      return data.data[0]?.id_timer;
    } else {
      throw new Error(data.error);
    }
  }

  async getTimer(timerId: number): Promise<TimerDto> {
    console.log(timerId);
    const data = await this.databaseService.query([
      new Request({
        query: `select timer.* 
                from v_timer timer 
                where timer.id = $(timerId)`,
        bindingParams: { timerId },
      }),
    ]);
    if (data.status === ICallbackMessageStatus.Done) {
      return data.data[0];
    } else {
      throw new Error(data.error);
    }
  }
}
