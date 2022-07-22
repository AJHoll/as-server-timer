import { Module } from '@nestjs/common';
import { TimerGateway } from './timer.gateway';
import { TimerService } from './timer.service';

@Module({
  controllers: [],
  providers: [TimerService, TimerGateway],
  exports: [TimerModule],
})
export class TimerModule {}
