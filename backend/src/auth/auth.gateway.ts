import { SubscribeMessage, WebSocketGateway } from '@nestjs/websockets';
import { AuthService } from './auth.service';
import { AuthDto } from './dto/AuthDto';

@WebSocketGateway(8081, { cors: true })
export class AuthGateway {
  constructor(private authService: AuthService) {}

  @SubscribeMessage('auth-sign-in')
  handleMessage(client, payload: AuthDto): any {
    console.log(payload);
    return this.authService.signIn(payload.username, payload.password);
  }
}
