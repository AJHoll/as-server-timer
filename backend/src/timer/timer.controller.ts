import { Controller, Get } from '@nestjs/common';

@Controller('timer')
export class TimerController {
  constructor() {}
  @Get('all')
  getAllTimers(): any {
    return [];
  }
}
