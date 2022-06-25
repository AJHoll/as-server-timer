import { Module } from '@nestjs/common';
import { ConfigModule } from './config/config.module';
import { TimerModule } from './timer/timer.module';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [ConfigModule, TimerModule, AuthModule],
  providers: [],
})
export class AppModule {}
