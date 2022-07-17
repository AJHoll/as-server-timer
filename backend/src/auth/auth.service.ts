import { Injectable } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { Request } from 'src/interfaces';

@Injectable()
export class AuthService {
  constructor(private databaseService: DatabaseService) {}

  async signIn(user: string, password: string) {
    const data = await this.databaseService.query([
      new Request({ query: `select * from timer`, bindingParams: {} }),
    ]);
    console.log(data);
  }
}
