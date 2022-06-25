import { Controller, Get, Ip, Post, Req } from '@nestjs/common';
import { DatabaseService, TimerClient } from 'src/database.service';
import { v4 } from 'uuid';

@Controller('auth')
export class AuthController {
  constructor(private databaseService: DatabaseService) {}

  @Get('token')
  async getToken(@Ip() ip): Promise<string> {
    const clients = await this.databaseService.getData<TimerClient>('clients');
    return clients.filter((item) => item.id == ip).map((item) => item.token)[0];
  }

  @Post('token')
  async registerToken(@Ip() ip) {
    const clients = await this.databaseService.getData<TimerClient>('clients');
    let clientData = clients.filter((item) => item.id == ip)[0];
    console.log(clientData);
    if (!clientData.token) {
      clientData = {
        id: ip,
        token: v4(),
      };
      await this.databaseService.setData('clients', `${ip}.json`, clientData);
    }
    return clientData;
  }
}
