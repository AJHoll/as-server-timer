import { Module } from '@nestjs/common';
import { DatabaseService } from 'src/database.service';
import { TimerController } from './timer.controller';
import { TimerService } from './timer.service';

@Module({
  controllers: [TimerController],
  providers: [TimerService, DatabaseService],
  exports: [TimerModule],
})
export class TimerModule {}
