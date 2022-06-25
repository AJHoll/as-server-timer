import { Controller, Get } from '@nestjs/common';
import { DatabaseService } from 'src/database.service';

@Controller('timer')
export class TimerController {
  constructor(private databaseService: DatabaseService) {}
  @Get('all')
  getAllTimers(): any {
    return this.databaseService.getData('timers');
  }
}
