import { Injectable } from '@nestjs/common';
import { DatabaseService } from 'src/database/database.service';
import { ICallbackMessageStatus, Request } from 'src/interfaces';
import { UserDto } from './dto/UserDto';
import { createHash } from 'crypto';

@Injectable()
export class AuthService {
  constructor(private databaseService: DatabaseService) {}

  async signIn(username: string, password: string) {
    const requests = [];
    requests.push(
      new Request({
        query: `select usr.* from "user" usr where usr.username = $(username)`,
        bindingParams: { username },
      }).Pre((req) => console.log(req)),
    );
    const response = await this.databaseService.query(requests);
    if (response.status === ICallbackMessageStatus.Done) {
      const user: UserDto = {
        ...response.data[0],
      };
      if (user.secret === createHash('sha256').update(password).digest('hex')) {
        return user;
      } else {
        return { status: 'error', data: 'Логин или пароль не верен!' };
      }
    } else {
      console.log(response.error);
      return { status: 'error', data: response.error };
    }
  }
}
