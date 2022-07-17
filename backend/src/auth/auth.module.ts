import { Module } from '@nestjs/common';
import { AuthGateway } from './auth.gateway';
import { AuthService } from './auth.service';

@Module({
  controllers: [],
  providers: [AuthService, AuthGateway],
  exports: [AuthModule],
})
export class AuthModule {}
