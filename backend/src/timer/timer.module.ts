import { Module } from '@nestjs/common';
import { TimerController } from './timer.controller';
import { TimerService } from './timer.service';

@Module({
  controllers: [TimerController],
  providers: [TimerService],
  exports: [TimerModule],
})
export class TimerModule {}
