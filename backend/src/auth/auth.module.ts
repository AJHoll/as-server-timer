import { Module } from '@nestjs/common';
import { DatabaseService } from 'src/database.service';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';

@Module({
  controllers: [AuthController],
  providers: [AuthService, DatabaseService],
  exports: [AuthModule],
})
export class AuthModule {}
