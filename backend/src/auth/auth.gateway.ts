import {
  MessageBody,
  SubscribeMessage,
  WebSocketGateway,
} from '@nestjs/websockets';
import { AuthService } from './auth.service';
import { AuthDto } from './dto/AuthDto';

@WebSocketGateway(8081, { cors: true })
export class AuthGateway {
  constructor(private authService: AuthService) {}

  @SubscribeMessage('auth-sign-in')
  handleMessage(
    @MessageBody('username') username: string,
    @MessageBody('password') password: string,
  ): any {
    console.log(username, password);
    return this.authService.signIn(username, password);
  }
}
