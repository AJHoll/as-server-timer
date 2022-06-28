import { Controller, Get, Ip, Post, Req } from '@nestjs/common';
import { DatabaseService, TimerClient } from 'src/database.service';
import { v4 } from 'uuid';

@Controller('auth')
export class AuthController {
  constructor(private databaseService: DatabaseService) {}

  @Get('token')
  async getToken(@Ip() ip): Promise<string> {
    return 'asdasd';
  }

  @Post('token')
  async registerToken(@Ip() ip) {
    return 'clientData';
  }
}
