import { Module } from '@nestjs/common';
import { ConfigModule } from './config/config.module';
import { TimerModule } from './timer/timer.module';
import { AuthModule } from './auth/auth.module';
import { DatabaseModule } from './database/database.module';

@Module({
  imports: [DatabaseModule, AuthModule, ConfigModule, TimerModule],
  providers: [],
})
export class AppModule {}
